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
      String chorusText = '';
      bool isChorus = false;
      int verseNumber = 1;

      for (var line in lines.skip(1)) {
        if (line.startsWith('Chorus')) {
          if (verseBuffer.isNotEmpty) {
            // Add previous verse
            verses.add(Verse(
                text: verseBuffer.toString().trim(),
                number: verseNumber++,
                isChorus: false));
            verseBuffer.clear();
          }
          isChorus = true;
          continue;
        }

        if (line.trim().isEmpty) {
          if (verseBuffer.isNotEmpty) {
            if (isChorus) {
              // Capture the chorus text
              chorusText = verseBuffer.toString().trim();
              isChorus = false;
            } else {
              // Add verse
              verses.add(Verse(
                  text: verseBuffer.toString().trim(),
                  number: verseNumber++,
                  isChorus: false));
            }
            verseBuffer.clear();
          }
          // Add chorus after each verse
          if (!isChorus && chorusText.isNotEmpty) {
            verses.add(Verse(text: chorusText, isChorus: true));
          }
        } else {
          verseBuffer.writeln(line);
        }
      }

      // Handle the final verse or chorus
      if (verseBuffer.isNotEmpty) {
        if (isChorus) {
          chorusText = verseBuffer.toString().trim();
        } else {
          verses.add(Verse(
              text: verseBuffer.toString().trim(),
              number: verseNumber,
              isChorus: false));
        }
      }

      // Add chorus at the end if it was not added
      if (!isChorus && chorusText.isNotEmpty) {
        verses.add(Verse(text: chorusText, isChorus: true));
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

  Verse({this.number, required this.text, this.isChorus = false});

  @override
  String toString() {
    if (isChorus) {
      return 'Chorus:\n$text';
    } else {
      return 'Verse $number:\n$text';
    }
  }
}
