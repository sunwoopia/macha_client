import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 0,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: _buildFooterButton('assets/images/home.svg'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildFooterButton('assets/images/location.svg'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildFooterButton('assets/images/setting.svg'),
          label: '',
        ),
      ],
    );
  }

  Widget _buildFooterButton(String imagePath) {
    return IconButton(
      icon: SvgPicture.asset(
        imagePath,
        width: 24,
        height: 24,
      ),
      onPressed: () {
        // 각 버튼이 눌렸을 때의 동작 추가
      },
    );
  }
}
