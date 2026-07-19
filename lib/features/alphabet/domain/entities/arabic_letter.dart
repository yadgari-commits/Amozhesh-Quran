class ArabicLetter {
  final String char;
  final String name;
  final String transliteration;
  final String audioPath;
  final String description;

  const ArabicLetter({
    required this.char,
    required this.name,
    required this.transliteration,
    required this.audioPath,
    this.description = '',
  });
}

const List<ArabicLetter> arabicAlphabet = [
  ArabicLetter(char: 'ا', name: 'Alif', transliteration: 'a', audioPath: 'alif.mp3'),
  ArabicLetter(char: 'ب', name: 'Ba', transliteration: 'b', audioPath: 'ba.mp3'),
  ArabicLetter(char: 'ت', name: 'Ta', transliteration: 't', audioPath: 'ta.mp3'),
  ArabicLetter(char: 'ث', name: 'Tha', transliteration: 'th', audioPath: 'tha.mp3'),
  ArabicLetter(char: 'ج', name: 'Jim', transliteration: 'j', audioPath: 'jim.mp3'),
  ArabicLetter(char: 'ح', name: 'Ha', transliteration: 'h', audioPath: 'ha.mp3'),
  ArabicLetter(char: 'خ', name: 'Kha', transliteration: 'kh', audioPath: 'kha.mp3'),
  ArabicLetter(char: 'د', name: 'Dal', transliteration: 'd', audioPath: 'dal.mp3'),
  ArabicLetter(char: 'ذ', name: 'Thal', transliteration: 'dh', audioPath: 'thal.mp3'),
  ArabicLetter(char: 'ر', name: 'Ra', transliteration: 'r', audioPath: 'ra.mp3'),
  ArabicLetter(char: 'ز', name: 'Zay', transliteration: 'z', audioPath: 'zay.mp3'),
  ArabicLetter(char: 'س', name: 'Sin', transliteration: 's', audioPath: 'sin.mp3'),
  ArabicLetter(char: 'ش', name: 'Shin', transliteration: 'sh', audioPath: 'shin.mp3'),
  ArabicLetter(char: 'ص', name: 'Sad', transliteration: 's', audioPath: 'sad.mp3'),
  ArabicLetter(char: 'ض', name: 'Dad', transliteration: 'd', audioPath: 'dad.mp3'),
  ArabicLetter(char: 'ط', name: 'Ta', transliteration: 't', audioPath: 'ta_heavy.mp3'),
  ArabicLetter(char: 'ظ', name: 'Za', transliteration: 'z', audioPath: 'za_heavy.mp3'),
  ArabicLetter(char: 'ع', name: 'Ayn', transliteration: '‘a', audioPath: 'ayn.mp3'),
  ArabicLetter(char: 'غ', name: 'Ghayn', transliteration: 'gh', audioPath: 'ghayn.mp3'),
  ArabicLetter(char: 'ف', name: 'Fa', transliteration: 'f', audioPath: 'fa.mp3'),
  ArabicLetter(char: 'ق', name: 'Qaf', transliteration: 'q', audioPath: 'qaf.mp3'),
  ArabicLetter(char: 'ك', name: 'Kaf', transliteration: 'k', audioPath: 'kaf.mp3'),
  ArabicLetter(char: 'ل', name: 'Lam', transliteration: 'l', audioPath: 'lam.mp3'),
  ArabicLetter(char: 'م', name: 'Mim', transliteration: 'm', audioPath: 'mim.mp3'),
  ArabicLetter(char: 'ن', name: 'Nun', transliteration: 'n', audioPath: 'nun.mp3'),
  ArabicLetter(char: 'ه', name: 'Ha', transliteration: 'h', audioPath: 'ha_soft.mp3'),
  ArabicLetter(char: 'و', name: 'Waw', transliteration: 'w', audioPath: 'waw.mp3'),
  ArabicLetter(char: 'ي', name: 'Ya', transliteration: 'y', audioPath: 'ya.mp3'),
  ArabicLetter(char: 'ء', name: 'Hamza', transliteration: '\'', audioPath: 'hamza.mp3'),
];
