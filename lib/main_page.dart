import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer_app/app/app_colors.dart';
import 'package:personal_trainer_app/pages/statistic_page.dart';
import 'package:personal_trainer_app/pages/settings_page.dart';
import 'package:personal_trainer_app/pages/workout_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainPage> {
  int _currentIndex = 0;
  late final PageController _controller = PageController();

  final _pages = const [
    WorkoutPage(),
    StatisticPage(),
    SettingsPage(),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (ctx, index) {
                return _pages[index];
              },
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: CustomNavigationBar(
                  isFloating: true,
                  borderRadius: const Radius.circular(42),
                  backgroundColor: AppColors.navBar,
                  unSelectedColor: AppColors.yellow,
                  selectedColor: AppColors.blue,
                  elevation: 5,
                  currentIndex: _currentIndex,
                  items: [
                    CustomNavigationBarItem(
                      icon: const Icon(Icons.sports_baseball_rounded),
                    ),
                    CustomNavigationBarItem(
                      icon: const Icon(Icons.auto_graph_rounded),
                    ),
                    CustomNavigationBarItem(
                      icon: const Icon(Icons.settings),
                    )
                  ],
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                      _controller.animateToPage(index,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.linear);
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
