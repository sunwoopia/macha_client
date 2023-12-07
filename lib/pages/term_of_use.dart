import 'package:flutter/material.dart';
import 'package:macha_client/common/components/back_header.dart';

class TermOfUse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackHeader(),
      body: ListView(
        children: [
          SizedBox(height: 40,),
          Center(
            child: Text("이용약관", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
          ),
          SizedBox(height: 40,),
          Container(
            width: double.infinity, // 가로로 확장
            padding: EdgeInsets.symmetric(horizontal: 20), // 가로 내부 간격 조절
            child: Text(
              """
              서비스 이용약관의 목적

              1.1. 본 서비스 이용약관(이하 "약관")은 서비스
              이용자와 서비스 제공자 간의 권리, 의무 및 책임사항,
              서비스 이용 조건 등을 규정함을 목적으로 합니다.

              서비스 이용자의 의무

              2.1. 이용자는 본 약관 및 관련 법령을 준수하여 서비스를
              이용해야 합니다.

              서비스 제공자의 책임 제한

              3.1. 서비스 제공자는 천재지변, 기술적 결함 등 불가항력적인
              사유로 인한 서비스 중단에 대해 책임을 지지 않습니다.

              이용약관의 변경과 고지 의무

              4.1. 서비스 제공자는 필요한 경우 약관을 변경할 수 있으며,
              변경 사항은 서비스 내에 공지함으로써 이용자에게 통지합니다.

              분쟁 해결 및 관할 법원

              5.1. 본 약관으로 인한 분쟁은 대한민국 법률에 따라
              해결되며, 관할 법원은 서비스 제공자의 본사 소재지를
              관할하는 법원으로 합니다.

              서비스 제공자의 연락처

              6.1. 서비스 제공자의 연락처는 [이메일 주소]입니다.
              """,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ), 
    );
  }
}
