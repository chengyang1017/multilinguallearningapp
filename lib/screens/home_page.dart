import 'package:flutter/material.dart';
import '../models/learning_language.dart';
import '../models/word_model.dart';
import '../services/tts_service.dart';
import '../services/word_loader.dart';
import '../widgets/search_bar.dart' as app_search;
import '../widgets/category_filter.dart';
import '../widgets/word_detail_sheet.dart';

const int buildNumber = 3;

enum SortMode { defaultOrder, alphabetical, difficulty, category }

class HomePage extends StatefulWidget {
  final LearningLanguage initialLanguage;
  const HomePage({super.key, required this.initialLanguage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isNorthern = true;
  bool _isGridView = true;
  late LearningLanguage _currentLanguage;
  List<WordModel> _allWords = [];
  List<WordModel> _filteredWords = [];
  String _searchQuery = '';
  String? _selectedCategory;
  SortMode _sortMode = SortMode.defaultOrder;
  final TtsService _ttsService = TtsService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentLanguage = widget.initialLanguage;
    _loadWords();
  }

  Future<void> _loadWords() async {
    setState(() => _isLoading = true);
    try {
      _allWords = await WordLoader.loadWords(_currentLanguage);
    } catch (e) {
      _allWords = [];
    }
    _filteredWords = List.from(_allWords);
    _applyFilters();
    setState(() => _isLoading = false);
  }

  void _switchLanguage(LearningLanguage lang) async {
    if (lang == _currentLanguage) return;
    setState(() {
      _currentLanguage = lang;
      _selectedCategory = null;
      _searchQuery = '';
    });
    await _loadWords();
  }

  void _toggleAccent() => setState(() => _isNorthern = !_isNorthern);
  void _toggleLayout() => setState(() => _isGridView = !_isGridView);

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = (_selectedCategory == category) ? null : category;
      _applyFilters();
    });
  }

  void _setSortMode(SortMode mode) {
    setState(() {
      _sortMode = mode;
      _applyFilters();
    });
  }

  void _applyFilters() {
    _filteredWords = _allWords.where((word) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!word.word.toLowerCase().contains(query) &&
            !word.meaningCN.contains(query) &&
            !word.pronunciation.toLowerCase().contains(query)) return false;
      }
      if (_selectedCategory != null && word.category != _selectedCategory) return false;
      return true;
    }).toList();

    switch (_sortMode) {
      case SortMode.defaultOrder:
        _filteredWords.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
        break;
      case SortMode.alphabetical:
        _filteredWords.sort((a, b) => a.word.toLowerCase().compareTo(b.word.toLowerCase()));
        break;
      case SortMode.difficulty:
        final order = {'easy': 0, 'medium': 1, 'hard': 2};
        _filteredWords.sort((a, b) {
          final dc = order[a.difficulty]!.compareTo(order[b.difficulty]!);
          return dc != 0 ? dc : a.word.compareTo(b.word);
        });
        break;
      case SortMode.category:
        _filteredWords.sort((a, b) {
          final cc = a.category.compareTo(b.category);
          return cc != 0 ? cc : int.parse(a.id).compareTo(int.parse(b.id));
        });
        break;
    }
  }

  List<String> _getAllCategories() {
    final cats = <String>{};
    for (var w in _allWords) cats.add(w.category);
    return cats.toList();
  }

  void _showWordDetail(WordModel word) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WordDetailSheet(
        word: word,
        isNorthern: _isNorthern,
        isVietnamese: _currentLanguage == LearningLanguage.vietnamese,
        ttsService: _ttsService,
      ),
    );
  }

  void _speak(WordModel word) {
  if (_currentLanguage == LearningLanguage.vietnamese) {
    _ttsService.speakVietnamese(word.word);
  } else if (_currentLanguage == LearningLanguage.russian) {
    _ttsService.speakRussian(word.word);
  } else {
    _ttsService.speakUyghur(word.word);
  }
}

  Color _toneColor(int t) {
    switch (t) {
      case 1: return const Color(0xFF4A90D9);
      case 2: return const Color(0xFF66BB6A);
      case 3: return const Color(0xFFFFA726);
      case 4: return const Color(0xFFEF5350);
      case 5: return const Color(0xFFAB47BC);
      case 6: return const Color(0xFFFF7043);
      default: return Colors.grey;
    }
  }

  Color _diffColor(String d) {
    switch (d) {
      case 'easy': return const Color(0xFF4CAF50);
      case 'medium': return const Color(0xFFFF9800);
      case 'hard': return const Color(0xFFE53935);
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _getAllCategories();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF2D5F4C)))
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                    color: const Color(0xFFF5F5F0),
                    child: Row(
                      children: [
                        Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF2D5F4C).withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.arrow_back_rounded, size: 18, color: Color(0xFF2D5F4C)),
      ),
    ),
    const SizedBox(width: 8),
    _buildLanguageSwitcher(),
  ],
),
                        const SizedBox(width: 8),
                        if (_currentLanguage == LearningLanguage.vietnamese)
                          GestureDetector(
                            onTap: _toggleAccent,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: _isNorthern ? const Color(0xFF2D5F4C).withOpacity(0.1) : const Color(0xFFE07A3D).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: _isNorthern ? const Color(0xFF2D5F4C).withOpacity(0.3) : const Color(0xFFE07A3D).withOpacity(0.3)),
                              ),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Text(_isNorthern ? '🌾' : '🌴', style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: 4),
                                Text(_isNorthern ? '河内' : '西贡', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _isNorthern ? const Color(0xFF2D5F4C) : const Color(0xFFE07A3D))),
                              ]),
                            ),
                          ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFF2D5F4C).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                          child: Text('#$buildNumber', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2D5F4C))),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)]),
                          child: const Row(mainAxisSize: MainAxisSize.min, children: [
                            Text('🔥', style: TextStyle(fontSize: 14)), SizedBox(width: 2),
                            Text('7天', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2D2D2D))),
                          ]),
                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: app_search.SearchBar(onSearch: _onSearch, query: _searchQuery),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: Row(children: [
                      _buildStatChip('📚', '${_allWords.length}'),
                      const Spacer(),
                      _buildSortDropdown(),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _toggleLayout,
                        child: Container(
                          height: 32, padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)]),
                          child: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded, size: 18, color: const Color(0xFF555555)),
                        ),
                      ),
                    ]),
                  ),
                  CategoryFilter(categories: categories, selectedCategory: _selectedCategory, onCategorySelected: _onCategorySelected),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(_selectedCategory ?? '全部单词', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
                      Text('${_filteredWords.length} 个', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ]),
                  ),
                  Expanded(
                    child: _filteredWords.isEmpty
                        ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 12),
                            Text('没有找到相关单词', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                          ]))
                        : _isGridView ? _buildGridView() : _buildListView(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLanguageSwitcher() {
    return PopupMenuButton<LearningLanguage>(
      onSelected: _switchLanguage,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF2D5F4C), Color(0xFF3D6F5C)]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: const Color(0xFF2D5F4C).withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(_currentLanguage.flag, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(_currentLanguage.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(width: 4),
          const Icon(Icons.swap_horiz, size: 16, color: Colors.white70),
        ]),
      ),
      itemBuilder: (context) => LearningLanguage.values.map((lang) {
        final isSelected = _currentLanguage == lang;
        return PopupMenuItem<LearningLanguage>(
          value: lang,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(lang.flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Text(lang.label, style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400, color: isSelected ? const Color(0xFF2D5F4C) : const Color(0xFF333333))),
            const SizedBox(width: 8),
            if (isSelected) const Icon(Icons.check, size: 18, color: Color(0xFF2D5F4C)),
          ]),
        );
      }).toList(),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.95, mainAxisSpacing: 10, crossAxisSpacing: 10),
      itemCount: _filteredWords.length,
      itemBuilder: (context, index) => _buildCard(_filteredWords[index]),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredWords.length,
      itemBuilder: (context, index) => _buildListItem(_filteredWords[index]),
    );
  }

  Widget _buildCard(WordModel word) {
    final dc = _diffColor(word.difficulty);
    return GestureDetector(
      onTap: () => _showWordDetail(word),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: dc.withOpacity(0.2)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]),
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(mainAxisSize: MainAxisSize.min, children: word.tonePattern.map((t) => Container(width: 6, height: 6, margin: const EdgeInsets.symmetric(horizontal: 1.5), decoration: BoxDecoration(shape: BoxShape.circle, color: _toneColor(t)))).toList()),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: dc.withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Text(word.difficulty == 'easy' ? '初级' : word.difficulty == 'medium' ? '中级' : '高级', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: dc))),
          ]),
          const Spacer(),
          Text(word.word, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(word.meaningCN, style: TextStyle(fontSize: 12, color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(word.pronunciation, style: TextStyle(fontSize: 11, color: Colors.grey[400], fontStyle: FontStyle.italic), maxLines: 1, overflow: TextOverflow.ellipsis),
          const Spacer(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(onTap: () => _speak(word), child: Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: dc.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.volume_up_rounded, size: 16, color: dc))),
            Text(word.category, style: TextStyle(fontSize: 10, color: Colors.grey[400])),
          ]),
        ]),
      ),
    );
  }

  Widget _buildListItem(WordModel word) {
    final dc = _diffColor(word.difficulty);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _showWordDetail(word),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: dc.withOpacity(0.2)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))]),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Row(mainAxisSize: MainAxisSize.min, children: word.tonePattern.map((t) => Container(width: 6, height: 6, margin: const EdgeInsets.symmetric(horizontal: 1.5), decoration: BoxDecoration(shape: BoxShape.circle, color: _toneColor(t)))).toList()),
                const SizedBox(width: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: dc.withOpacity(0.12), borderRadius: BorderRadius.circular(6)), child: Text(word.difficulty == 'easy' ? '初级' : word.difficulty == 'medium' ? '中级' : '高级', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: dc))),
              ]),
              const SizedBox(height: 6),
              Text(word.word, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
              const SizedBox(height: 2),
              Row(children: [
                Text(word.meaningCN, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                const SizedBox(width: 8),
                Text(word.pronunciation, style: TextStyle(fontSize: 12, color: Colors.grey[400], fontStyle: FontStyle.italic)),
                const Spacer(),
                Text(word.category, style: TextStyle(fontSize: 11, color: Colors.grey[400])),
              ]),
            ])),
            const SizedBox(width: 12),
            GestureDetector(onTap: () => _speak(word), child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: dc.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.volume_up_rounded, size: 22, color: dc))),
          ]),
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    final names = {SortMode.defaultOrder: '默认', SortMode.alphabetical: 'A-Z', SortMode.difficulty: '难度', SortMode.category: '分类'};
    return PopupMenuButton<SortMode>(
      onSelected: _setSortMode,
      offset: const Offset(0, 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 32, padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)]),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.sort_rounded, size: 16, color: Color(0xFF555555)),
          const SizedBox(width: 4),
          Text(names[_sortMode]!, style: const TextStyle(fontSize: 12, color: Color(0xFF555555))),
          const Icon(Icons.arrow_drop_down, size: 16, color: Color(0xFF555555)),
        ]),
      ),
      itemBuilder: (context) => SortMode.values.map((mode) {
        final sel = _sortMode == mode;
        return PopupMenuItem<SortMode>(value: mode, child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(sel ? Icons.radio_button_checked : Icons.radio_button_unchecked, size: 16, color: sel ? const Color(0xFF2D5F4C) : Colors.grey),
          const SizedBox(width: 8),
          Text(names[mode]!, style: TextStyle(fontSize: 14, fontWeight: sel ? FontWeight.w600 : FontWeight.w400, color: sel ? const Color(0xFF2D5F4C) : const Color(0xFF555555))),
        ]));
      }).toList(),
    );
  }

  Widget _buildStatChip(String emoji, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)]),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
      ]),
    );
  }
}