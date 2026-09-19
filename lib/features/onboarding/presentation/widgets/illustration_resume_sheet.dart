import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class IllustrationResumeSheet extends StatelessWidget {
  const IllustrationResumeSheet({super.key});

  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: .045,
    child: Container(
      width: 215,
      height: 280,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: .12),
            blurRadius: 28,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primary,
                  size: 29,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aziza Karimova',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'UX / UI dizayner',
                        style: TextStyle(fontSize: 7, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: 14),
          _section('MEN HAQIMDA'),
          _line(160),
          _line(145),
          _line(110),
          const SizedBox(height: 11),
          _section('ISH TAJRIBASI'),
          _line(125, dark: true),
          _line(160),
          _line(140),
          const SizedBox(height: 11),
          _section('KO‘NIKMALAR'),
          Row(
            children: ['Figma', 'Dizayn', 'UX']
                .map(
                  (label) => Container(
                    margin: const EdgeInsets.only(right: 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF3E9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 7,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    ),
  );
  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 7,
        letterSpacing: 1,
        fontWeight: FontWeight.w800,
        color: AppColors.primary,
      ),
    ),
  );

  Widget _line(double width, {bool dark = false}) => Container(
    width: width,
    height: 4,
    margin: const EdgeInsets.only(bottom: 5),
    decoration: BoxDecoration(
      color: dark ? const Color(0xFF91A39A) : AppColors.line,
      borderRadius: BorderRadius.circular(3),
    ),
  );
}
