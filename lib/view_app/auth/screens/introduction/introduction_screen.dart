import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../data_app/model/jarvis/intro.dart';
import '../../../../core/navigation/routes.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _pageController = PageController();
  final List<Intro> list = [
    Intro(
      title: 'Ask me anything',
      subtitle:
          'I can be your best friend and you can ask me anything, I will help you with my best',
      lottie: 'animation2',
    ),
    Intro(
      title: 'Imagination to Reality',
      subtitle:
          'Just imagine anything, I will create something wonderful for you',
      lottie: 'animation1',
    ),
  ];

  Future<void> _completeIntroduction() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenIntroduction', true);

    if (!mounted) return;

    context.go(AppRoutes.login); // Điều hướng sang trang đăng nhập
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final isLast = index == list.length - 1;
          return Column(
            children: [
              const SizedBox(height: 60),
              Align(
                alignment: Alignment.topCenter,
                child: Lottie.asset(
                  'animations/${list[index].lottie}.json',
                  width: 280,
                  height: 280,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                list[index].title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: .5,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  list[index].subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13.5,
                    letterSpacing: .5,
                  ),
                ),
              ),
              const Spacer(),
              Wrap(
                spacing: 10,
                children: List.generate(
                  list.length,
                  (i) => Container(
                    width: i == index ? 15 : 10,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == index ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  elevation: 0,
                  backgroundColor: Colors.blue,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.4, 50),
                ),
                onPressed: () {
                  if (isLast) {
                    _completeIntroduction();
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.ease,
                    );
                  }
                },
                child: Text(
                  isLast ? "Let's go" : "Next",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const Spacer(),
            ],
          );
        },
      ),
    );
  }
}
