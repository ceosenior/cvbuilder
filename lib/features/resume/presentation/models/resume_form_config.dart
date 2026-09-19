const resumeSpecialties = <String, List<String>>{
  'Flutter dasturchi': [
    'Flutter',
    'Dart',
    'BLoC',
    'Firebase',
    'REST API',
    'Git',
  ],
  'Frontend dasturchi': [
    'HTML',
    'CSS',
    'JavaScript',
    'TypeScript',
    'React',
    'Git',
  ],
  'Backend dasturchi': [
    'Python',
    'Java',
    'Node.js',
    'SQL',
    'REST API',
    'Docker',
  ],
  'UI/UX dizayner': [
    'Figma',
    'Prototiplash',
    'UI dizayn',
    'UX tadqiqot',
    'Design system',
  ],
  'Loyiha menejeri': [
    'Agile',
    'Scrum',
    'Jira',
    'Rejalashtirish',
    'Jamoa boshqaruvi',
  ],
  'Marketing mutaxassisi': [
    'SEO',
    'SMM',
    'Copywriting',
    'Google Ads',
    'Analitika',
  ],
  'Boshqa': [],
};

const resumeStepTitles = [
  'Ism-familiya',
  'Mutaxassislik',
  'Aloqa ma’lumotlari',
  'Yashash manzili',
  'Ko‘nikmalar',
  'Tillar',
  'Sertifikatlar',
  'Tarjimai hol',
  'Ish tajribasi',
  'Loyihalar',
  'Ta’lim',
  'Tekshirish',
];
const resumeEntryFields = <int, Map<String, String>>{
  5: {'language': 'Til', 'level': 'Daraja (masalan, B2 yoki ona tili)'},
  6: {
    'name': 'Sertifikat nomi',
    'issuer': 'Bergan tashkilot',
    'date': 'Olingan sana',
  },
  8: {
    'company': 'Tashkilot',
    'role': 'Lavozim',
    'period': 'Muddat (masalan, 2022–hozir)',
    'description': 'Bajargan ishlaringiz va natijalar',
  },
  9: {
    'name': 'Loyiha nomi',
    'period': 'Qachon / muddat',
    'role': 'Rol (masalan, lead yoki assistent)',
    'description': 'Loyiha haqida va qo‘shgan hissangiz',
  },
  10: {
    'school': 'Ta’lim muassasasi',
    'degree': 'Daraja va yo‘nalish',
    'period': 'O‘qish muddati',
  },
};
