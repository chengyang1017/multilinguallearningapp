import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/word_model.dart';
import '../models/learning_language.dart';

class WordLoader {
  static Future<List<WordModel>> loadWords(LearningLanguage language) async {
    final path = 'assets/languages/${language.fileName}';
    final jsonString = await rootBundle.loadString(path);
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map((json) => WordModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}