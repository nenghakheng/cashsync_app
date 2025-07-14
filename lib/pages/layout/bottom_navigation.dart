import 'package:cashsyncapp/commons/widgets/custom_bar.dart';
import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/pages/dca/dca_screen.dart';
import 'package:cashsyncapp/pages/home/home_screen.dart';
import 'package:cashsyncapp/pages/layout/side_bar.dart';
import 'package:cashsyncapp/pages/setting/setting_screen.dart';
import 'package:cashsyncapp/pages/strategy/strategy_screen.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(),
    StrategyScreen(),
    DcaScreen(),
    SettingScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: SideBar(),
      appBar: CustomAppBar(),
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    // Calculate screen width and item positions
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 40) / 4; // 40 is total horizontal margin

    return Container(
      height: 70,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              red: 0,
              green: 0,
              blue: 0,
              alpha: 0.1,
            ),
            blurRadius: 25,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(0, Icons.home_rounded, itemWidth),
                  _buildNavItem(1, Icons.checklist_rounded, itemWidth),
                  _buildNavItem(2, Icons.access_time, itemWidth),
                  _buildNavItem(3, Icons.settings_rounded, itemWidth),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, double width) {
    return SizedBox(
      width: width,
      child: Center(
        child: IconButton(
          highlightColor: Colors.transparent,
          icon:
              _currentIndex == index
                  ? _buildActiveIcon(icon)
                  : Icon(
                    icon,
                    size: ConfigConstant.iconSize3,
                    color: const Color(0xFF8AD6E8),
                  ),
          onPressed: () => setState(() => _currentIndex = index),
        ),
      ),
    );
  }

  Widget _buildActiveIcon(IconData icon) {
    return Container(
      // Make sure width is consistent
      alignment: Alignment.center, // Center the icon
      decoration: BoxDecoration(
        color: const Color(0xFF5164BF),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Icon(icon, color: Colors.white, size: ConfigConstant.iconSize3),
    );
  }
}
