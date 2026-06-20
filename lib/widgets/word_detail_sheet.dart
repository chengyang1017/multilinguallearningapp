import 'package:flutter/material.dart';
import '../models/word_model.dart';
import '../services/tts_service.dart';

class WordDetailSheet extends StatelessWidget {
  final WordModel word;
  final bool isNorthern;
  final bool isVietnamese;
  final TtsService ttsService;

  const WordDetailSheet({
    super.key,
    required this.word,
    required this.isNorthern,
    required this.isVietnamese,
    required this.ttsService,
  });

  @override
  Widget build(BuildContext context) {
    final hasVariants = word.variants.isNotEmpty;
    final groupedVariants = _groupVariants();

    return Container(
      height: hasVariants ? MediaQuery.of(context).size.height * 0.7 : MediaQuery.of(context).size.height * 0.45,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            // 词根
            Text(word.word, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
            const SizedBox(height: 4),
            Text(word.meaningCN, style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            const SizedBox(height: 2),
            Text('发音: ${word.pronunciation}', style: TextStyle(fontSize: 14, color: Colors.grey[400], fontStyle: FontStyle.italic)),
            const SizedBox(height: 12),
            // 发音按钮
            if (isVietnamese)
              Row(children: [
                _buildSpeakerBtn('河内音', isNorthern, () => ttsService.speakNorthern(word.word)),
                const SizedBox(width: 10),
                _buildSpeakerBtn('西贡音', !isNorthern, () => ttsService.speakSouthern(word.word)),
              ])
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => ttsService.speakNorthern(word.word),
                  icon: const Icon(Icons.volume_up, size: 18),
                  label: const Text('播放发音'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D5F4C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            // 例句
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF8F8F5), borderRadius: BorderRadius.circular(10)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(word.example, style: const TextStyle(fontSize: 14, color: Color(0xFF2D2D2D), fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(word.exampleMeaning, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ]),
            ),
            // 变体（按组显示）
            if (hasVariants) ...[
              const SizedBox(height: 14),
              Row(children: [
                const Icon(Icons.account_tree_rounded, size: 16, color: Color(0xFF2D5F4C)),
                const SizedBox(width: 6),
                const Text('词形变化', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2D5F4C))),
              ]),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: groupedVariants.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 分组标题
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, top: 4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D5F4C).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(entry.key,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2D5F4C))),
                          ),
                        ),
                        // 变体列表
                        ...entry.value.map((v) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFE8E8E8)),
                            ),
                            child: Row(children: [
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(v.form, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                                  const SizedBox(height: 2),
                                  Text(v.meaning, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                                ]),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F0EB),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(v.suffix, style: const TextStyle(fontSize: 10, color: Color(0xFF888888))),
                              ),
                            ]),
                          ),
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 按 group 分组
  Map<String, List<WordVariant>> _groupVariants() {
    final map = <String, List<WordVariant>>{};
    for (var v in word.variants) {
      map.putIfAbsent(v.group, () => []);
      map[v.group]!.add(v);
    }
    return map;
  }

  Widget _buildSpeakerBtn(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF2D5F4C).withOpacity(0.1) : const Color(0xFFF0F0EB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: active ? const Color(0xFF2D5F4C).withOpacity(0.3) : Colors.transparent),
          ),
          child: Text('🔊 $label', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
        ),
      ),
    );
  }
}