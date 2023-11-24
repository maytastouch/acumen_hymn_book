import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

import '../../../christ_in_song/domain/entity/hymn_entity.dart';
import '../models/lozi_hymn_model.dart';

class LoziLocalMethods {
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

  static Future<List<LoziHymnModel>> fromDirectory(String directoryPath) async {
    var dir = Directory(directoryPath);
    List<LoziHymnModel> hymns = [];

    if (await dir.exists()) {
      await for (var entity in dir.list()) {
        if (entity is File && entity.path.endsWith('.htm')) {
          var hymn = await LoziHymnModel.fromHtmlFile(entity.path);
          if (hymn != null) {
            hymns.add(hymn);
          }
        }
      }
    }

    return hymns;
  }
}
