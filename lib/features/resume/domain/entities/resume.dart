class Resume {
  Resume({
    Map<String, String>? details,
    Set<String>? skills,
    Map<String, List<Map<String, String>>>? entries,
  }) : details = details ?? {},
       skills = skills ?? {},
       entries = entries ?? {};

  final Map<String, String> details;
  final Set<String> skills;
  final Map<String, List<Map<String, String>>> entries;

  factory Resume.fromJson(Map<String, dynamic> json) => Resume(
    details: Map<String, String>.from(json['details'] as Map? ?? {}),
    skills: Set<String>.from(json['skills'] as List? ?? []),
    entries: (json['entries'] as Map? ?? {}).map(
      (key, rows) => MapEntry(
        key as String,
        (rows as List)
            .map((row) => Map<String, String>.from(row as Map))
            .toList(),
      ),
    ),
  );

  Map<String, dynamic> toJson() => {
    'details': Map<String, String>.of(details),
    'skills': skills.toList(),
    'entries': entries.map(
      (key, rows) => MapEntry(key, rows.map((row) => Map.of(row)).toList()),
    ),
  };

  Resume copy() => Resume(
    details: Map.of(details),
    skills: Set.of(skills),
    entries: entries.map(
      (key, rows) => MapEntry(
        key,
        rows.map((row) => Map<String, String>.of(row)).toList(),
      ),
    ),
  );
}
