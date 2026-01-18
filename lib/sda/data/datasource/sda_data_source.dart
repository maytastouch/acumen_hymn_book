import 'dart:convert';

import 'package:acumen_hymn_book/core/services/hymn_storage_service.dart';

import '../models/sda_hymn_model.dart';

class SDALocalMethods {
  static Future<List<SDAHymnModel>> fromJsonFile(String assetPath) async {
    var jsonString = await HymnStorageService.loadHymnContent(assetPath);
    var json = jsonDecode(jsonString);

    List<SDAHymnModel> hymns = [];
    if (json['songs'] is! Map) {
      // If 'songs' is not a Map, return an empty hymns list
      return hymns;
    }

    Map<String, dynamic> songs = Map.from(json['songs']);

    songs.forEach((key, dynamic value) {
      if (key == 'titles' || value is! Map) {
        return; // Skip if the key is 'titles' or if the value is not a Map
      }

      Map<String, dynamic> songMap = Map<String, dynamic>.from(value);

      String number = songMap['id']?.toString() ?? 'Unknown';
      String title = songMap['title'] ?? 'Untitled';
      List<String> verses = [];
      if (songMap['stanzas'] != null) {
        Map<String, dynamic> stanzas =
            Map<String, dynamic>.from(songMap['stanzas']);
        stanzas.forEach((stanzaKey, stanzaValue) {
          verses.add(stanzaValue.toString());
        });
      }

      String? chorus;
      if (songMap['choruses'] != null && songMap['choruses'].isNotEmpty) {
        Map<String, dynamic> choruses =
            Map<String, dynamic>.from(songMap['choruses']);
        chorus = choruses.values.first?.toString();
      }

      hymns.add(SDAHymnModel(
        chorus: chorus,
        number: number,
        title: title,
        verses: verses,
      ));
    });

    return hymns;
  }
}
