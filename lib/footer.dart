import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  @override
  _Footer createState() => _Footer();
}

class _Footer extends State {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('ホーム'),
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text('検索'),
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          title: Text('通知'),
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.mail),
          title: Text('メッセージ'),
        ),
      ],
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.black45,
    );
  }
}