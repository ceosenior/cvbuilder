import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_footer.dart';
import '../widgets/onboarding_slide.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  static const _slides = [
    (
      label: 'SIZNING YANGI BOSHLANISHINGIZ',
      title: 'Katta imkoniyatlar,\nmukammal CV dan.',
      description:
          'O‘zingizga mos shablonni tanlang. Tajribangizni chiroyli va tartibli ko‘rsatadigan CV yarating.',
    ),
    (
      label: 'HAR BIR TAJRIBANGIZ QADRLI',
      title: 'Siz haqingizda.\nEng yaxshi tarzda.',
      description:
          'Ta’lim, tajriba va ko‘nikmalaringizni bosqichma-bosqich kiriting. Har bir yutug‘ingiz o‘z o‘rnini topsin.',
    ),
    (
      label: 'KEYINGI QADAMGA TAYYOR',
      title: 'Tayyor CV.\nYangi imkoniyatlar.',
      description:
          'CV ni PDF formatida saqlang. Ish beruvchiga yuborish yoki chop etish uchun qulay hujjat oling.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() => Navigator.of(context).pushReplacementNamed(AppRouter.home);

  void _next() {
    if (_index == _slides.length - 1) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Column(
              children: [
                OnboardingHeader(onSkip: _finish),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _slides.length,
                    onPageChanged: (value) => setState(() => _index = value),
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return OnboardingSlide(
                        index: index,
                        label: slide.label,
                        title: slide.title,
                        description: slide.description,
                      );
                    },
                  ),
                ),
                OnboardingFooter(
                  index: _index,
                  count: _slides.length,
                  onNext: _next,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
