import 'dart:convert';
import 'dart:io';

import 'package:acumen_hymn_book/core/services/hymn_storage_service.dart';

import '../models/lozi_hymn_model.dart';

class LocalMethods {
  static Future<List<LzHymnModel>> fromJsonFile(String assetPath) async {
    var contents = await HymnStorageService.loadHymnContent(assetPath);
    var jsonData = json.decode(contents);

    List<LzHymnModel> hymns = [];
    if (jsonData['songs'] != null) {
      jsonData['songs'].forEach((key, value) {
        hymns.add(LzHymnModel(
            hymnNumber: int.parse(key),
            hymnTitle: value.toString(),
            verses: const []));
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
