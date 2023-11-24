import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

import '../../domain/lz_hymn_entity.dart';
import '../models/lozi_hymn_model.dart';

class LzLocalMethods {
  // Method to read JSON file from assets and return a list of Hymns
  static Future<List<LzHymnEntity>> readHymnsFromFile(String assetPath) async {
    var contents = await rootBundle.loadString(assetPath);
    var jsonData = json.decode(contents);

    List<LzHymnEntity> hymns = [];
    if (jsonData['songs'] != null) {
      jsonData['songs'].forEach((key, value) {
        hymns.add(LzHymnEntity(number: key, title: value.toString()));
      });
    }

    return hymns;
  }

  static Future<List<LzHymnModel>> fromDirectory(String directoryPath) async {
    var dir = Directory(directoryPath);
    List<LzHymnModel> hymns = [];

    if (await dir.exists()) {
      await for (var entity in dir.list()) {
        if (entity is File && entity.path.endsWith('.md')) {
          var hymn = await LzHymnModel.fromMarkdownFile(entity.path);
          hymns.add(hymn!);
        }
      }
    }

    return hymns;
  }
}
