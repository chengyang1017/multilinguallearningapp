class WordModel {
  final String id;
  final String word;
  final String meaningCN;
  final String pronunciation;
  final String example;
  final String exampleMeaning;
  final String category;
  final String difficulty;
  final List<int> tonePattern;
  final List<WordVariant> variants;

  const WordModel({
    required this.id,
    required this.word,
    required this.meaningCN,
    required this.pronunciation,
    required this.example,
    required this.exampleMeaning,
    required this.category,
    required this.difficulty,
    required this.tonePattern,
    this.variants = const [],
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id'] as String,
      word: json['word'] as String,
      meaningCN: json['meaningCN'] as String,
      pronunciation: json['pronunciation'] as String,
      example: json['example'] as String,
      exampleMeaning: json['exampleMeaning'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      tonePattern: List<int>.from(json['tonePattern'] as List),
      variants: (json['variants'] as List)
          .map((v) => WordVariant.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WordVariant {
  final String form;
  final String meaning;
  final String suffix;
  final String group;

  const WordVariant({
    required this.form,
    required this.meaning,
    required this.suffix,
    this.group = '其他',
  });

  factory WordVariant.fromJson(Map<String, dynamic> json) {
    return WordVariant(
      form: json['form'] as String,
      meaning: json['meaning'] as String,
      suffix: json['suffix'] as String,
      group: json['group'] as String? ?? '其他',
    );
  }
}