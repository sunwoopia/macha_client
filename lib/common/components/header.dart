import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      leading: Padding(
        padding: const EdgeInsets.only(left: 13.0), // 왼쪽 패딩 값으로 수정
        child: SvgPicture.asset(
          'assets/images/logo.svg',
        ),
      ),
    );
  }
}
