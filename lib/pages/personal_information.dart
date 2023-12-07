import 'package:flutter/material.dart';
import 'package:macha_client/common/components/back_header.dart';

class PersonalInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackHeader(),
      body: ListView(
        children: [
          SizedBox(height: 40,),
          Center(
            child: Text("개인정보처리방침", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
          ),
          SizedBox(height: 40,),
          Container(
            width: double.infinity, // 가로로 확장
            padding: EdgeInsets.symmetric(horizontal: 20), // 가로 내부 간격 조절
            child: Text("""
            수집하는 개인정보 항목 및 수집 방법

            1.1. 수집하는 개인정보 항목

            이메일 주소
            1.2. 수집 방법

            사용자로부터 직접 제공받은 정보
            개인정보의 수집 및 이용 목적

            2.1. 이메일 주소

            서비스 제공, 안내, 문의사항 처리 등 사용자와의
            원활한 소통 경로로 사용 개인정보의 보유 및 이용 기간

            3.1. 수집한 개인정보는 사용자가 서비스 이용을
            요청한 기간 동안에만 보유하며, 서비스 제공 
            목적이 달성되면 지체 없이 파기됩니다.

            개인정보의 제3자 제공 및 공유

            4.1. 본 정보는 어떠한 경우에도 제3자에게 제공되지 않습니다.

            개인정보의 파기 절차 및 방법

            5.1. 사용자의 개인정보는 목적이 달성된 후 즉시 파기됩니다.

            개인정보의 안전성 확보 조치

            6.1. 개인정보 보호를 위해 관련 법령에 따른 안전성
            확보를 위한 조치를 취하고 있습니다.

            이용자의 권리와 의무

            7.1. 이용자는 언제든지 자신의 개인정보를 열람,
            수정 또는 삭제 요청할 수 있습니다.
        """, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
          )
        ],
      ), 
    );
  }
}