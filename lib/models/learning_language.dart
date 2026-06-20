enum LearningLanguage {
  vietnamese('越南语', 'vi', '🇻🇳', 'vietnamese.json'),
  uyghur('维吾尔语', 'ug', '🇨🇳', 'uyghur.json'),
  russian('俄语', 'ru', '🇷🇺', 'russian.json'),
  javanese('爪哇语', 'jv', '🇮🇩', 'javanese.json'),
  muong('芒语', 'mtq', '🌿', 'muong.json');

  final String label;
  final String code;
  final String flag;
  final String fileName;

  const LearningLanguage(this.label, this.code, this.flag, this.fileName);
}