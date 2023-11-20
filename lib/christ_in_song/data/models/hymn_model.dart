import 'package:flutter/services.dart' show rootBundle;

class HymnModel {
  final int hymnNumber;
  final String hymnTitle;
  final List<Verse> verses;

  HymnModel({
    required this.hymnNumber,
    required this.hymnTitle,
    required this.verses,
  });

  // Parse Markdown file to create a Hymn object
  static Future<HymnModel?> fromMarkdownFile(String filePath) async {
    try {
      String contents = await rootBundle.loadString(filePath);

      var filename = filePath.split('/').last;
      var hymnNumberString = filename.split('.').first;
      var hymnNumber = int.tryParse(hymnNumberString);
      if (hymnNumber == null) {
        throw FormatException(
            'Unable to parse hymn number from file name: $filename');
      }

      var lines = contents.split('\n');
      var titleLine =
          lines.firstWhere((line) => line.startsWith('##'), orElse: () => '');
      var hymnTitle = titleLine.replaceFirst('##', '').trim();

      List<Verse> verses = [];
      StringBuffer verseBuffer = StringBuffer();
      int verseNumber = 1;
      bool isChorus = false;

      for (var line in lines.skip(1)) {
        if (line.startsWith('Chorus')) {
          if (verseBuffer.isNotEmpty) {
            verses.add(Verse(
                number: verseNumber++, text: verseBuffer.toString().trim()));
            verseBuffer.clear();
          }
          isChorus = true;
          continue;
        }

        if (line.trim().isEmpty) {
          if (verseBuffer.isNotEmpty) {
            if (isChorus) {
              // Add chorus text without verse number
              verses.add(Verse(text: verseBuffer.toString().trim()));
              isChorus = false; // Reset chorus flag
            } else {
              verses.add(Verse(
                  number: verseNumber++, text: verseBuffer.toString().trim()));
            }
            verseBuffer.clear();
          }
        } else {
          verseBuffer.writeln(line);
        }
      }

      // Add the last verse or chorus if there's remaining text
      if (verseBuffer.isNotEmpty) {
        if (isChorus) {
          verses.add(Verse(text: verseBuffer.toString().trim()));
        } else {
          verses.add(
              Verse(number: verseNumber, text: verseBuffer.toString().trim()));
        }
      }

      return HymnModel(
        hymnNumber: hymnNumber,
        hymnTitle: hymnTitle,
        verses: verses,
      );
    } catch (e) {
      print('Error loading hymn from file: $e');
      return null;
    }
  }
}

class Verse {
  final int? number; // Make number nullable
  final String text;

  Verse({this.number, required this.text});
}

class Chorus {
  String subtitle;

  Chorus({required this.subtitle});
}
