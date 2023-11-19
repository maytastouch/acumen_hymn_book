import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../../domain/entity/hymn_entity.dart';

class LocalMethods {
  // Method to read JSON file from assets and return a list of Hymns
  static Future<List<HymnEntity>> readHymnsFromFile(String assetPath) async {
    var contents = await rootBundle.loadString(assetPath);
    var jsonData = json.decode(contents);

    List<HymnEntity> hymns = [];
    if (jsonData['songs'] != null) {
      jsonData['songs'].forEach((key, value) {
        hymns.add(HymnEntity(number: key, title: value.toString()));
      });
    }

    return hymns;
  }
}
