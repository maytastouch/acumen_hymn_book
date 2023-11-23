import 'dart:convert';
import 'dart:io';
import 'package:acumen_hymn_book/Keresete%20Mo%20Kopelong/data/models/tn_hymn_model.dart';

import 'package:flutter/services.dart' show rootBundle;

import '../../../christ_in_song/domain/entity/hymn_entity.dart';

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

  static Future<List<HymnModel>> fromDirectory(String directoryPath) async {
    var dir = Directory(directoryPath);
    List<HymnModel> hymns = [];

    if (await dir.exists()) {
      await for (var entity in dir.list()) {
        if (entity is File && entity.path.endsWith('.md')) {
          var hymn = await HymnModel.fromMarkdownFile(entity.path);
          hymns.add(hymn!);
        }
      }
    }

    return hymns;
  }
}
