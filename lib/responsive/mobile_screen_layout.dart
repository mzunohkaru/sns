import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_e_shop/utils/global_variable.dart';
import 'package:lottie/lottie.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  int _page = 0;
  late PageController pageController; // for tabs animation
  bool isLoading = true;

  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 2;

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        controller.reset();
      }
    });

    timer();
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  void timer() {
    setState(() {
      isLoading = true;
    });
    Timer(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: Lottie.network(
                'https://assets9.lottiefiles.com/private_files/lf30_wbszjekz.json',
                animate: true,
              ),
            ),
          )
        : Scaffold(
            body: PageView(
              children: homeScreenItems,
              controller: pageController,
              onPageChanged: onPageChanged,
            ),
            bottomNavigationBar: CurvedNavigationBar(
                key: navigationKey,
                //Bar Color
                // color: Colors.white,
                //Icon Color
                buttonBackgroundColor: Colors.white,
                //背景色と合わせる
                backgroundColor: Colors.transparent,
                height: 60,
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 700),
                index: _page,
                items: const [
                  Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 30,
                  ),
                  Icon(
                    Icons.person,
                    color: Colors.black,
                  )
                ],
                onTap: navigationTapped),
          );
  }
}
