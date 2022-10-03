import 'package:flutter/material.dart';
import 'package:flutter_trip/pages/home_page.dart';
import 'package:flutter_trip/pages/my_page.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/pages/travel_page.dart';

class TabNavigator extends StatefulWidget {
  const TabNavigator({Key? key}) : super(key: key);

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomePage(),
            SearchPage(
              hideLeft: true,
            ),
            TravelPage(),
            MyPage(),
          ],
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(
              brightness: Brightness.light,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent),
          child: BottomNavigationBar(
            unselectedItemColor: _defaultColor,
            selectedItemColor: _activeColor,
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              _controller.jumpToPage(index);
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              _bottomItem('首页', Icons.home, 0),
              _bottomItem('搜索', Icons.search, 1),
              _bottomItem('旅拍', Icons.camera_alt, 2),
              _bottomItem('我的', Icons.account_circle, 3),
            ],
          ),
        ));
  }

  _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _defaultColor,
        ),
        activeIcon: Icon(
          icon,
          color: _activeColor,
        ),
        label: title);
  }
}
