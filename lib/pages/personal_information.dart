import 'package:flutter/material.dart';
import 'package:macha_client/common/components/back_header.dart';

class PersonalInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BackHeader(),
      body: Center(
        child: Text("개인정보처리방침"),
      ),
    );
  }
}