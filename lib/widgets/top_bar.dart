import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final bool isNorthern;
  final VoidCallback onToggleAccent;
  final int streakDays;
  final int buildNumber;  // ← 新增

  const TopBar({
    super.key,
    required this.isNorthern,
    required this.onToggleAccent,
    required this.streakDays,
    required this.buildNumber,  // ← 新增
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 南北音切换
            GestureDetector(
              onTap: onToggleAccent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isNorthern
                      ? const Color(0xFF2D5F4C).withOpacity(0.1)
                      : const Color(0xFFE07A3D).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isNorthern
                        ? const Color(0xFF2D5F4C).withOpacity(0.3)
                        : const Color(0xFFE07A3D).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isNorthern ? '🌾' : '🌴',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isNorthern ? '河内音' : '西贡音',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isNorthern
                            ? const Color(0xFF2D5F4C)
                            : const Color(0xFFE07A3D),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 版本号 + 连胜
            Row(
              children: [
                // 版本号
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D5F4C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '#$buildNumber',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D5F4C),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // 连胜
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 4),
                      Text(
                        '$streakDays 天',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // 头像
            const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFE8D5B7),
              child: Text(
                'N',
                style: TextStyle(
                  color: Color(0xFF2D5F4C),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}