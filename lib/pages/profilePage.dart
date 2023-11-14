import 'package:flutter/material.dart';
import 'package:macha_client/pages/appSettings.dart';
import 'dart:async';
import '../main.dart';
import '../common/components/header.dart';
import '../common/components/footer.dart';

class ProfilePage extends StatelessWidget {
  //설정 제일 초기화면
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 23,
                        backgroundImage: AssetImage('assets/images/splash.png'),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '김선우',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'sunwoopia@naver.com',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // 내 장소로 이동 아직 미구현(클래스명 X)
                          Navigator.pushNamed(context, '/my-places');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            '내 장소 관리',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          // 앱 설정 페이지로 이동(아직 덜 구현)
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => appSettings()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            '앱 설정',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          // 개인정보처리방침으로 이동
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => personalInforamtion()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            '개인정보 처리방침',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () {
                          // Navigate to '이용약관' page
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => termOfUse()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            '이용약관',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ))),
    );
  }
}
