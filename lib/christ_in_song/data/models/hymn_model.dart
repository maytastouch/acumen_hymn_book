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
        // Skip the title line
        if (line.trim().isEmpty && verseBuffer.isNotEmpty) {
          if (isChorus) {
            verses.add(
                Verse(text: verseBuffer.toString().trim(), isChorus: true));
          } else {
            verses.add(Verse(
                text: verseBuffer.toString().trim(),
                number: verseNumber++,
                isChorus: false));
          }
          verseBuffer.clear();
          isChorus = false;
        } else if (line.startsWith(RegExp(r'Chorus', caseSensitive: false))) {
          isChorus = true;
        } else {
          verseBuffer.writeln(line);
        }
      }

      // Add the last verse or chorus if there's remaining text
      if (verseBuffer.isNotEmpty) {
        if (isChorus) {
          verses
              .add(Verse(text: verseBuffer.toString().trim(), isChorus: true));
        } else {
          verses.add(Verse(
              text: verseBuffer.toString().trim(),
              number: verseNumber,
              isChorus: false));
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
  final int? number;
  final String text;
  final bool isChorus;

  Verse({this.number = 1, required this.text, this.isChorus = false});

  @override
  String toString() {
    if (isChorus) {
      // If it's a chorus, label it as "Chorus"
      return 'Chorus:\n$text';
    } else {
      // If it's a verse, label it with its number
      return 'Verse $number:\n$text';
    }
  }
}

class Chorus {
  String subtitle;

  Chorus({required this.subtitle});
}
