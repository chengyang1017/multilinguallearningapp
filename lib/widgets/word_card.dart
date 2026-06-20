import 'package:flutter/material.dart';
import '../models/word_model.dart';
import '../services/tts_service.dart';

class WordCard extends StatelessWidget {
  final WordModel word;
  final bool isNorthern;
  final VoidCallback onTap;
  final TtsService ttsService;

  const WordCard({
    super.key,
    required this.word,
    required this.isNorthern,
    required this.onTap,
    required this.ttsService,
  });

  Color _getDifficultyColor() {
    switch (word.difficulty) {
      case 'easy':
        return const Color(0xFF4CAF50);
      case 'medium':
        return const Color(0xFFFF9800);
      case 'hard':
        return const Color(0xFFE53935);
      default:
        return Colors.grey;
    }
  }

  LinearGradient _getCardGradient() {
    switch (word.difficulty) {
      case 'easy':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF1F8F2)],
        );
      case 'medium':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFFFF8F0)],
        );
      case 'hard':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFFFF1F1)],
        );
      default:
        return const LinearGradient(colors: [Colors.white, Colors.white]);
    }
  }

  void _speak() {
    if (isNorthern) {
      ttsService.speakNorthern(word.word);
    } else {
      ttsService.speakSouthern(word.word);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: _getDifficultyColor().withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: _getDifficultyColor().withOpacity(0.15), width: 1),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: _getDifficultyColor().withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            gradient: _getCardGradient(),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ToneIndicator(tonePattern: word.tonePattern),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor().withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      word.difficulty == 'easy' ? '初级' : word.difficulty == 'medium' ? '中级' : '高级',
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: _getDifficultyColor()),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                word.word,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                word.meaningCN,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                word.pronunciation,
                style: TextStyle(fontSize: 11, color: Colors.grey[400], fontStyle: FontStyle.italic),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: _speak,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor().withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.volume_up_rounded, size: 16, color: _getDifficultyColor()),
                    ),
                  ),
                  Text(
                    word.category,
                    style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToneIndicator extends StatelessWidget {
  final List<int> tonePattern;
  const _ToneIndicator({required this.tonePattern});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: tonePattern.map((tone) {
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getToneColor(tone),
            boxShadow: [
              BoxShadow(color: _getToneColor(tone).withOpacity(0.4), blurRadius: 3),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getToneColor(int tone) {
    switch (tone) {
      case 1: return const Color(0xFF4A90D9);
      case 2: return const Color(0xFF66BB6A);
      case 3: return const Color(0xFFFFA726);
      case 4: return const Color(0xFFEF5350);
      case 5: return const Color(0xFFAB47BC);
      case 6: return const Color(0xFFFF7043);
      default: return Colors.grey;
    }
  }
}