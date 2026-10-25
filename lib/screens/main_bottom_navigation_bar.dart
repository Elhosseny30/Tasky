import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:try_shared_preferences/screens/completed_screen.dart';
import 'package:try_shared_preferences/screens/home_screen.dart';
import 'package:try_shared_preferences/screens/profile_screen.dart';
import 'package:try_shared_preferences/screens/to_do_screen.dart';

class MainBottomNavigationBar extends StatefulWidget {
  const MainBottomNavigationBar({super.key});

  @override
  State<MainBottomNavigationBar> createState() =>
      _MainBottomNavigationBarState();
}

class _MainBottomNavigationBarState extends State<MainBottomNavigationBar> {
  final List<Widget> _screens = [
    HomeScreen(),
    ToDoScreen(),
    CompletedScreen(),
    ProfileScreen(),
  ];
  int _screenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _screenIndex,
        onTap: (value) {
          setState(() {
            _screenIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: _buildSvg("assets/images/home.svg",0),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: _buildSvg("assets/images/to_do.svg",1),
            
           
            label: "To Do",
          ),
          BottomNavigationBarItem(
            icon:  _buildSvg("assets/images/completed.svg",2),
            
           
            label: "Completed",
          ),
          BottomNavigationBarItem(
            icon: _buildSvg("assets/images/profile.svg",3),
            label: "Profile",
          ),
        ],
      ),

      body:_screens[_screenIndex],
    );
  }

  SvgPicture _buildSvg(String path,int index) {
    return SvgPicture.asset(
            path,
            colorFilter: ColorFilter.mode(_screenIndex == index? Color(0xff15B86C):Color(0xffC6C6C6), BlendMode.srcIn),
          );
  }
}
