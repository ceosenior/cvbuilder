# Proyekt uchun ko'rsatmalar

 /// Arxitektura

lib/
├── app/
│   ├── app.dart
│   ├── router/
│   │   └── app_router.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │   └── app_text_styles.dart
│   └── di/
│       └── injection.dart
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── utils/
│   ├── services/
│   │   ├── pdf_service.dart
│   │   ├── storage_service.dart
│   │   └── file_service.dart
│   └── widgets/
│
├── features/
│   ├── onboarding/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── home/
│   │   └── presentation/
│   │
│   ├── resume/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   │
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   ├── templates/
│   ├── preview/
│   ├── export/
│   └── settings/
│
└── main.dart



- qandaydir packagelar kerak bo'lsa, bemalol o'rnataver


 # rezyume quyidagi feauturelarga asosan tayyorlansin va shular userdan so'ralsin

 - ism-familiya
 - mutaxassislik
 - contact uchun email, phone-number, github, linkedin
 - yashash manzili
 - skills (mutaxassislik tanlangandan so'ng, shu mutaxassislikka oid skills chip shaklida multiple tanlanadigan bo'lib chiqsin)
 - languages
 - certificates
 - tarjimai hol
 - ish tajriba (qayerda, qaysi muddatda va nimalar qilgani, role)
 - projects (qanday, qachon, qaysi rol(lead, assistent), nima qilgani)
 - education