import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      leading: Padding(
        padding: const EdgeInsets.only(left: 13.0), // 왼쪽 패딩 값으로 수정
        child: SvgPicture.asset(
          'assets/images/logo.svg',
        ),
      ),
      actions: [
        // IconButton(
        //   icon: SvgPicture.asset(
        //     'assets/images/like.svg',
        //     width: 36,
        //     height: 36,
        //   ),
        //   onPressed: () {
        //     // 좋아요 버튼이 눌렸을 때의 동작 추가
        //   },
        // ),
        IconButton(
          icon: SvgPicture.asset(
            'assets/images/search.svg',
            width: 36,
            height: 36,
          ),
          onPressed: () {
            // 돋보기 버튼이 눌렸을 때의 동작 추가
          },
        ),
      ],
    );
  }
}
