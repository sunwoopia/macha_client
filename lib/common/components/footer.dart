import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Footer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Footer({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 0,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset('assets/images/active_home.svg'),
          icon: SvgPicture.asset('assets/images/home.svg'),
          label: '',
        ),
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset('assets/images/active_location.svg'),
          icon: SvgPicture.asset('assets/images/location.svg'),
          label: '',
        ),
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset('assets/images/active_setting.svg'),
          icon: SvgPicture.asset('assets/images/setting.svg'),
          label: '',
        ),
      ],
      onTap: onTap,
    );
  }
}