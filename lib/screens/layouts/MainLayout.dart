
import 'package:flutter/material.dart';
import 'package:schoolappfinal/screens/pages/main/HSLibraryPage.dart';
import 'package:schoolappfinal/util/FirebaseAuthUtil.dart';
import 'package:schoolappfinal/util/MonitorUtil.dart';

import '../pages/main/AccountPage.dart';
import '../pages/main/CravePage.dart';
import '../pages/main/CravePage2.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  MonitorUtil? monitorUtil;
  late List<Widget> mainPageList;
  int selectedBottomIndex = 1;
  final pageController = PageController(
    initialPage:  1,
  );

  @override
  void initState() {
    super.initState();
    monitorUtil ??= MonitorUtil();
    mainPageList = [
      AccountPage(monitorUtil),
      HSLibraryPage(monitorUtil),
      CravePage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(children: mainPageList, controller: pageController),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedBottomIndex,
        onTap: (nextSelectedBottomIndex){
          selectedBottomIndex = nextSelectedBottomIndex;
          pageController.animateToPage(selectedBottomIndex, curve: Curves.ease, duration: const Duration(milliseconds: 500));
          setState((){});
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: "Account",
          ),BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: "Library",
          ),BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: "Crave",
          ),
        ],
      ),
    );

  }
}
