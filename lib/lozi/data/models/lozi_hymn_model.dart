import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:html/parser.dart' as html;
import 'package:path/path.dart' as path; // Import the 'path' package

class LoziHymnModel extends Equatable {
  final int hymnNumber;
  final String hymnTitle;
  final List<Verse> verses;

  const LoziHymnModel({
    required this.hymnNumber,
    required this.hymnTitle,
    required this.verses,
  });

  factory LoziHymnModel.fromHtml(String htmlData, int fallbackHymnNumber) {
    final document = html.parse(htmlData);

    // Extract hymn title
    final hymnTitleElement = document.querySelector('.c1');
    if (hymnTitleElement == null) {
      throw const FormatException('Hymn title not found in HTML data.');
    }
    final hymnTitleText = hymnTitleElement.text.trim();

    // Attempt to extract hymn number from the title
    int hymnNumber;
    final hymnNumberMatch = RegExp(r'^(\d+)').firstMatch(hymnTitleText);
    if (hymnNumberMatch != null) {
      hymnNumber =
          int.tryParse(hymnNumberMatch.group(1)!) ?? fallbackHymnNumber;
    } else {
      hymnNumber = fallbackHymnNumber;
    }

    // Extract the rest of the title after the hymn number, if present
    final hymnTitle = hymnNumberMatch != null
        ? hymnTitleText.substring(hymnNumberMatch.group(0)!.length).trim()
        : hymnTitleText;

    // Extract verses and choruses
    // Extract verses and choruses
    //TODO: BREAD AND BUTTER
    final elements = document.querySelectorAll('.ListParagraph');
    final List<Verse> verses = [];
    String currentVerseText = '';
    bool isChorus = false;

    for (var element in elements) {
      if (element.text.trim() == 'MAKUTELO:') {
        // Add the previous verse to the list if it's not empty
        if (currentVerseText.isNotEmpty) {
          verses.add(Verse(
            text: currentVerseText.trim(),
            isChorus: isChorus,
          ));
        }
        // Reset for the next verse/chorus
        currentVerseText = '';
        isChorus = true; // Next verse is a chorus
        continue;
      }

      // Concatenate the lines of the verse/chorus
      currentVerseText +=
          (currentVerseText.isNotEmpty ? '\n' : '') + element.text.trim();
    }

    // Add the last verse/chorus if it's not empty
    if (currentVerseText.isNotEmpty) {
      verses.add(Verse(
        text: currentVerseText.trim(),
        isChorus: isChorus,
      ));
    }

    return LoziHymnModel(
      hymnTitle: hymnTitle,
      hymnNumber: hymnNumber,
      verses: verses,
    );
  }

  // Parse HTML file to create a LoziHymnModel object
  static Future<LoziHymnModel?> fromHtmlFile(String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString();

      final document = html.parse(content);

      // Extract hymn number from the filename
      final filename = path.basenameWithoutExtension(filePath);
      final hymnNumber = int.tryParse(filename);

      if (hymnNumber == null) {
        throw FormatException(
            'Unable to parse hymn number from file name: $filename');
      }

      // Extract hymn title from the HTML content (assuming it's in an <h1> element)
      final titleElement = document.querySelector('h1');
      final hymnTitle = titleElement?.text.trim() ?? '';

      // Extract chorus and verses from the HTML content
      final chorusElement = document.querySelector('p:contains("MAKUTELO:")');
      final chorusText = chorusElement?.text.trim() ?? '';

      final verseElements =
          document.querySelectorAll('p:not(:contains("MAKUTELO:"))');
      final verses = verseElements
          .map((element) => Verse(
                number: null, // You can assign verse numbers if available
                text: element.text.trim(),
                isChorus: false,
              ))
          .toList();

      // Create the LoziHymnModel object
      return LoziHymnModel(
        hymnNumber: hymnNumber,
        hymnTitle: hymnTitle,
        verses: verses,
      );
    } catch (e) {
      print('Error loading hymn from file: $e');
      return null;
    }
  }

  @override
  List<Object?> get props => [hymnNumber, hymnTitle, verses];
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
