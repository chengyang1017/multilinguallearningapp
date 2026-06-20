import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import '../models/word_model.dart';
import '../models/learning_language.dart';

class WordLoader {
  static const _baseUrl = 'https://raw.githubusercontent.com/chengyang1017/multilinguallearningapp/main/assets/languages';

  static Future<List<WordModel>> loadWords(LearningLanguage language) async {
    // 先从 GitHub 加载（最新数据）
    try {
      final url = '$_baseUrl/${language.fileName}';
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => WordModel.fromJson(json as Map<String, dynamic>)).toList();
      }
    } catch (_) {}

    // 网络失败降级到本地
    final path = 'assets/languages/${language.fileName}';
    final jsonString = await rootBundle.loadString(path);
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => WordModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}