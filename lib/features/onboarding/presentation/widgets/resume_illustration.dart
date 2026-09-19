import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import 'illustration_badge.dart';
import 'illustration_resume_sheet.dart';

/// Code-drawn artwork stays crisp at every screen size and works offline.
class ResumeIllustration extends StatelessWidget {
  const ResumeIllustration({required this.step, super.key});

  final int step;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: MediaQuery.withNoTextScaling(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 340,
            height: 350,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAF0E4),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  top: 25,
                  right: 23,
                  child: Icon(
                    Icons.auto_awesome,
                    color: AppColors.primary.withValues(alpha: .65),
                    size: 28,
                  ),
                ),
                Positioned(
                  bottom: 45,
                  left: 18,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: -.10,
                  child: Container(
                    width: 215,
                    height: 275,
                    margin: const EdgeInsets.only(right: 20, top: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4DDCE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const IllustrationResumeSheet(),
                Positioned(
                  left: 4,
                  top: 77,
                  child: IllustrationBadge(
                    icon: [
                      Icons.dashboard_customize_outlined,
                      Icons.edit_outlined,
                      Icons.picture_as_pdf_outlined,
                    ][step],
                    title: [
                      'Sizga mos uslub',
                      'Sizning hikoyangiz',
                      'PDF formatida',
                    ][step],
                    subtitle: [
                      'Professional shablonlar',
                      'Har bir yutuq muhim',
                      'Ulashishga tayyor',
                    ][step],
                    dark: false,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 24,
                  child: IllustrationBadge(
                    icon: [
                      Icons.check_rounded,
                      Icons.add_task_rounded,
                      Icons.file_download_outlined,
                    ][step],
                    title: [
                      'Birinchi taassurot',
                      'Qadam-baqadam',
                      'Keyingi manzil — ish!',
                    ][step],
                    subtitle: [
                      'Ishonchli. Tartibli. Sizga xos.',
                      'Oson va tushunarli',
                      'Yangi imkoniyatlar sari',
                    ][step],
                    dark: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
