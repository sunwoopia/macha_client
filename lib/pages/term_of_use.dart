import 'package:flutter/material.dart';
import 'package:macha_client/common/components/back_header.dart';

class TermOfUse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BackHeader(),
      body: Center(
        child: Text("이용약관"),
      ),
    );
  }
}