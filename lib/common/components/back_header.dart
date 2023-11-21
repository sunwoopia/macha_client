import 'package:flutter/material.dart';

class BackHeader extends StatelessWidget implements PreferredSizeWidget {
  const BackHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.only(left: 13.0),
        child: BackButton(
          color: Colors.black, // 아이콘 색상을 검정색으로 설정
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.of(context,rootNavigator:true).pop(context);
            }
          },
        ),
      ),
    );
  }
}
