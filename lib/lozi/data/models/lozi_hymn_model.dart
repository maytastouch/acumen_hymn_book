import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:html/dom.dart';
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
// Extract verses and choruses
// Extract verses and choruses
    List<Verse> verses = [];
    int verseNumber = 1;

// Find and store the chorus
    String chorus = "";
    var makuteloElement = document
        .querySelector('MAKUTELO:'); // Locate the element with "MAKUTELO:"
    if (makuteloElement != null) {
      Element? nextElement = makuteloElement.nextElementSibling;
      while (nextElement != null && nextElement.localName != 'li') {
        chorus += "${nextElement.text.trim()}\n";
        nextElement = nextElement.nextElementSibling;
      }
    }

    var verseElements = document.querySelectorAll('ol > li');
    for (var i = 0; i < verseElements.length; i++) {
      String verseText = verseElements[i].text.trim();
      Element? nextElement = verseElements[i].nextElementSibling;

      while (nextElement != null && nextElement.localName == 'p') {
        verseText += "\n${nextElement.text.trim()}";
        nextElement = nextElement.nextElementSibling;
        if (nextElement?.localName == 'li') break;
      }

      if (verseText.isNotEmpty) {
        verses
            .add(Verse(number: verseNumber, text: verseText, isChorus: false));
        verseNumber++;
      }

      // Add chorus after each verse
      if (chorus.isNotEmpty) {
        verses.add(Verse(text: chorus, isChorus: true));
      }
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
