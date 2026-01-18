import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class HymnStorageService {
  static Future<String> loadHymnContent(String assetPath) async {
    try {
      final localFile = await _getLocalFile(assetPath);
      if (await localFile.exists()) {
        if (kDebugMode) {
          print('Loading hymn from local storage: ${localFile.path}');
        }
        return await localFile.readAsString();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading local hymn file: $e');
      }
    }
    return await rootBundle.loadString(assetPath);
  }

  static Future<void> saveHymnContent(String assetPath, String content) async {
    try {
      final localFile = await _getLocalFile(assetPath);
      if (!await localFile.parent.exists()) {
        await localFile.parent.create(recursive: true);
      }
      await localFile.writeAsString(content);
      if (kDebugMode) {
        print('Saved hymn to local storage: ${localFile.path}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving hymn file: $e');
      }
      rethrow;
    }
  }

  static Future<File> _getLocalFile(String assetPath) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$assetPath');
  }
}
