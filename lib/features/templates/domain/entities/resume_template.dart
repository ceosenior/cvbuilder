enum ResumeLayout { standard, graphite, timeline, beam }

class ResumeTemplate {
  const ResumeTemplate(
    this.id,
    this.name,
    this.description,
    this.color, {
    this.centered = false,
    this.banner = false,
    this.boxed = false,
    this.compact = false,
    this.skillsFirst = false,
    this.layout = ResumeLayout.standard,
  });

  final String id;
  final String name;
  final String description;
  final int color;
  final bool centered, banner, boxed, compact, skillsFirst;
  final ResumeLayout layout;

  static const all = [
    ResumeTemplate(
      'graphite_green', 'Graphite Green',
      'Yashil bezaklar va o‘ng ma’lumotlar ustuni', 0xFF408D79,
      layout: ResumeLayout.graphite,
    ),
    ResumeTemplate(
      'blank_timeline', 'Blank Timeline',
      'Kulrang aloqa tasmasi va sanalar ustuni', 0xFF383838,
      layout: ResumeLayout.timeline,
    ),
    ResumeTemplate(
      'beam', 'Beam',
      'Pushti chap panel va keng tajriba bo‘limi', 0xFFFF575D,
      layout: ResumeLayout.beam,
    ),
    ResumeTemplate('classic', 'Klassik', 'Sodda va rasmiy', 0xFF263238),
    ResumeTemplate(
      'modern',
      'Zamonaviy',
      'Ko‘k sarlavha va aniq bo‘limlar',
      0xFF1565C0,
      banner: true,
    ),
    ResumeTemplate(
      'minimal',
      'Minimal',
      'Ixcham va ortiqcha bezaksiz',
      0xFF455A64,
      compact: true,
    ),
    ResumeTemplate(
      'executive',
      'Rahbar',
      'Markaziy sarlavha, to‘q ko‘k uslub',
      0xFF1A237E,
      centered: true,
    ),
    ResumeTemplate(
      'creative',
      'Kreativ',
      'Binafsha blokli bo‘limlar',
      0xFF6A1B9A,
      boxed: true,
      centered: true,
    ),
    ResumeTemplate(
      'tech',
      'Texnologik',
      'Ko‘nikmalar birinchi o‘rinda',
      0xFF00695C,
      banner: true,
      skillsFirst: true,
    ),
    ResumeTemplate(
      'academic',
      'Akademik',
      'Ta’lim va tajriba uchun keng format',
      0xFF5D4037,
      boxed: true,
    ),
    ResumeTemplate(
      'elegant',
      'Nafis',
      'Markaziy sarlavha va iliq ranglar',
      0xFF9A6700,
      centered: true,
      compact: true,
    ),
    ResumeTemplate(
      'fresh',
      'Yangi avlod',
      'Yashil sarlavha va ko‘nikmalar',
      0xFF2E7D32,
      banner: true,
      boxed: true,
      skillsFirst: true,
    ),
    ResumeTemplate(
      'bold',
      'Dadillik',
      'To‘q qizil, ixcham bloklar',
      0xFFAD2340,
      banner: true,
      centered: true,
      compact: true,
    ),
  ];
}
