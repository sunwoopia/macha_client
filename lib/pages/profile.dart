import 'package:flutter/material.dart';
import './personal_information.dart';
import './term_of_use.dart';
import './sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'sunwoopia@naver.com',
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 60),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // 내 장소로 이동 아직 미구현(클래스명 X)
                    Navigator.pushNamed(context, '/my-places');
                  },
                  child: const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      '내 장소 관리',
                      style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 40,
                // ),
                // GestureDetector(
                //   onTap: () {
                //     // 앱 설정 페이지로 이동(아직 덜 구현)
                //     // Navigator.of(context).pushReplacement(
                //     //   MaterialPageRoute(
                //     //       builder: (context) => appSettings()),
                //     // );
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: const Text(
                //       '앱 설정',
                //       style: TextStyle(
                //           fontFamily: 'Roboto',
                //           fontSize: 16,
                //           fontWeight: FontWeight.w600,
                //           color: Colors.black),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    // 개인정보처리방침으로 이동
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => PersonalInformation()),
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => TermOfUse()),
                    );
                  },
                  child: const Padding(
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
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () async {
                    // 확인 및 취소 창 띄우기
                    bool logoutConfirmed = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Logout',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          content: Text('로그아웃 하시겠습니까?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false); // 취소 버튼
                              },
                              child: Text('취소'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true); // 확인 버튼
                              },
                              child: Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                    // 사용자가 확인을 선택했을 때 로그아웃 수행
                    if (logoutConfirmed == true) {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.remove('token');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
                        ),
                      );
                    }
                  },
                  child: const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '로그아웃',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

