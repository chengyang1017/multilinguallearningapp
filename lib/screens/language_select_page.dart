import 'package:flutter/material.dart';
import '../models/learning_language.dart';
import 'home_page.dart';

class LanguageSelectPage extends StatelessWidget {
  const LanguageSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Logo / 标题
            const Icon(Icons.language_rounded, size: 72, color: Color(0xFF2D5F4C)),
            const SizedBox(height: 16),
            const Text(
              '选择学习语言',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D)),
            ),
            const SizedBox(height: 8),
            Text(
              '选择一个你想要学习的语言',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 40),
            // 语言卡片列表
            Expanded(
              flex: 5,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: LearningLanguage.values.length,
                itemBuilder: (context, index) {
                  final lang = LearningLanguage.values[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomePage(initialLanguage: lang),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2D5F4C).withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: const Color(0xFFE8E8E8)),
                        ),
                        child: Row(
                          children: [
                            // 国旗
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2D5F4C).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(lang.flag, style: const TextStyle(fontSize: 32)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // 语言名称
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang.label,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _getDescription(lang),
                                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            ),
                            // 箭头
                            Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey[400]),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDescription(LearningLanguage lang) {
  switch (lang) {
    case LearningLanguage.vietnamese:
      return '南部音、北部音自由切换';
    case LearningLanguage.uyghur:
      return '词根 + 人称/时态/格变化';
    case LearningLanguage.russian:
      return '名词变格、动词变位';
      case LearningLanguage.javanese:
  return '敬语系统：普通/敬语/高敬语三级';
  }
}
}