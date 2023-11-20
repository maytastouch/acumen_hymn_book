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

      // Extract the hymn number from the file path
      var filename = filePath.split('/').last;
      var hymnNumberString = filename.split('.').first;
      var hymnNumber = int.tryParse(hymnNumberString);
      if (hymnNumber == null) {
        throw FormatException(
            'Unable to parse hymn number from file name: $filename');
      }

      // Extract hymn title from the contents
      var lines = contents.split('\n');
      var titleLine =
          lines.firstWhere((line) => line.startsWith('##'), orElse: () => '');
      var hymnTitle = titleLine.replaceFirst('##', '').trim();

      List<Verse> verses = [];
      StringBuffer verseBuffer = StringBuffer();
      int verseNumber = 1;

      for (var line in lines.skip(1)) {
        // Skip the title line
        if (line.trim().isEmpty) {
          if (verseBuffer.isNotEmpty) {
            verses.add(Verse(
                number: verseNumber, text: verseBuffer.toString().trim()));
            verseNumber++;
            verseBuffer.clear();
          }
        } else {
          verseBuffer.writeln(line);
        }
      }

      // Add the last verse if there's remaining text
      if (verseBuffer.isNotEmpty) {
        verses.add(
            Verse(number: verseNumber, text: verseBuffer.toString().trim()));
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
  final int number;
  final String text;

  Verse({required this.number, required this.text});
}

class Chorus {
  String subtitle;

  Chorus({required this.subtitle});
}
