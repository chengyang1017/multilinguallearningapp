import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildCategoryChip('🌐 全部', null),
          ...categories.map((cat) {
            final emoji = _getCategoryEmoji(cat);
            return _buildCategoryChip('$emoji $cat', cat);
          }),
        ],
      ),
    );
  }

  String _getCategoryEmoji(String category) {
    switch (category) {
      case '问候礼貌': return '👋';
      case '人称代词': return '👥';
      case '饮食': return '🍜';
      case '交通出行': return '🏍️';
      case '购物': return '🛒';
      case '数字': return '🔢';
      case '感情表达': return '❤️';
      case '常用动词': return '🏃';
      case '时间日期': return '📅';
      case '天气自然': return '🌤️';
      case '身体部位': return '🦵';
      case '颜色': return '🎨';
      case '职业': return '👨‍💼';
      case '地点方向': return '📍';
      case '家庭关系': return '👨‍👩‍👧';
      case '紧急情况': return '🆘';
      case '商务用语': return '💼';
      case '网络科技': return '📱';
      case '俗语感叹': return '💬';
      case '抽象概念': return '💡';
      default: return '📌';
    }
  }

  Widget _buildCategoryChip(String label, String? value) {
    final isSelected = selectedCategory == value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () => onCategorySelected(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2D5F4C) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF2D5F4C).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.white : const Color(0xFF555555),
            ),
          ),
        ),
      ),
    );
  }
}