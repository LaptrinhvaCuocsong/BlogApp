import 'package:blog_app/ui/home/blog/blog_page.dart';
import 'package:blog_app/ui/home/setting/setting_page.dart';
import 'package:blog_app/utils/strings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _pages = [BlogPage(), SettingPage()];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: Strings.blogPageTitle,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: Strings.settingPageTitle
          )
        ],
        backgroundColor: Colors.deepPurple,
        selectedIconTheme: IconThemeData(color: Colors.white),
        unselectedIconTheme: IconThemeData(color: Colors.black),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _barItemOnTap,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [..._pages],
      ),
    );
  }

  void _barItemOnTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}