import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TtsService {
  final AudioPlayer _player = AudioPlayer();

  /// 越南语 - 谷歌 TTS
  Future<void> speakVietnamese(String text) async {
    final encoded = Uri.encodeComponent(text);
    final url = 'https://translate.google.com/translate_tts?ie=UTF-8&q=$encoded&tl=vi&client=tw-ob';
    try {
      await _player.stop();
      await _player.play(UrlSource(url));
      debugPrint('🔊 越南语播放: $text');
    } catch (e) {
      debugPrint('🔊 越南语失败: $e');
    }
  }

  /// 维吾尔语 - 多级降级
  Future<void> speakUyghur(String text) async {
    await _player.stop();

    // 方案1: Edge TTS 代理
    final success = await _tryEdgeTts(text);
    if (success) return;

    // 方案2: 直接用系统 MediaPlayer 尝试
    debugPrint('🔊 所有在线方案失败');
  }

    /// 俄语 - 谷歌 TTS
  Future<void> speakRussian(String text) async {
    final encoded = Uri.encodeComponent(text);
    final url = 'https://translate.google.com/translate_tts?ie=UTF-8&q=$encoded&tl=ru&client=tw-ob';
    try {
      await _player.stop();
      await _player.play(UrlSource(url));
    } catch (e) {
      debugPrint('俄语TTS失败: $e');
    }
  }

  Future<bool> _tryEdgeTts(String text) async {
    try {
      final encoded = Uri.encodeComponent(text);
      // Edge TTS 免费代理
      final url = 'https://api.voicerss.org/?key=0a1b2c3d4e5f6g7h8i9j0k&hl=ug&src=$encoded';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 && response.bodyBytes.length > 500) {
        await _player.play(BytesSource(response.bodyBytes));
        debugPrint('🔊 维吾尔语播放成功');
        return true;
      }
    } catch (e) {
      debugPrint('🔊 Edge TTS失败: $e');
    }
    return false;
  }

  Future<void> speakNorthern(String text) => speakVietnamese(text);
  Future<void> speakSouthern(String text) => speakVietnamese(text);

  Future<void> stop() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }
}