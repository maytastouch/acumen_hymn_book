import 'dart:io';

class Hymn {
  int hymnNumber;
  String hymnTitle;
  List<Verse> verses;

  Hymn({
    required this.hymnNumber,
    required this.hymnTitle,
    required this.verses,
  });

  // Parse Markdown file to create a Hymn object
  static Future<Hymn> fromMarkdownFile(String filePath) async {
    var file = File(filePath);
    var contents = await file.readAsString();

    // Extract hymn number, title, verses from the contents
    var lines = contents.split('\n');
    var titleLine = lines.firstWhere((line) => line.startsWith('##'));
    var titleParts = titleLine.split(' ');
    var hymnNumber = int.parse(titleParts[1]);
    var hymnTitle = titleParts.sublist(2).join(' ');

    List<Verse> verses = [];
    Chorus? chorus;
    bool isChorus = false;

    for (var line in lines) {
      if (line.startsWith('CHORUS')) {
        isChorus = true;
        chorus =
            Chorus(subtitle: ''); // Initialize chorus with an empty subtitle
        continue;
      }

      if (isChorus) {
        chorus!.subtitle = line; // Set the chorus subtitle
        isChorus = false;
      } else if (line.trim().isNotEmpty) {
        verses.add(Verse(number: verses.length + 1, text: line));
        if (chorus != null) {
          // Add chorus after each verse
          verses.add(Verse(number: verses.length + 1, text: chorus.subtitle));
        }
      }
    }

    return Hymn(
      hymnNumber: hymnNumber,
      hymnTitle: hymnTitle,
      verses: verses,
    );
  }
}

class Verse {
  int number;
  String text;

  Verse({required this.number, required this.text});
}

class Chorus {
  String subtitle;

  Chorus({required this.subtitle});
}
