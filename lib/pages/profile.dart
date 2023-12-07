import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:macha_client/pages/manage_place.dart';
import './personal_information.dart';
import './term_of_use.dart';
import './sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String user_name = '';
  late String user_email = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    debugPrint('token: $token');

    if (token != null) {
      final url = 'http://15.164.170.6:5000/api/user/$token';
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 201) {
          final data = jsonDecode(response.body);
          if (data['data'] != null) {
            final userData = data['data'];
            setState(() {
              user_name = userData['name'];
              user_email = userData['email'];
              isLoading = false;
            });
          } else {
            debugPrint('장소 데이터 형식이 잘못되었습니다.');
            isLoading = false;
          }
        } else {
          debugPrint('데이터 로드 실패: ${response.statusCode}');
          isLoading = false;
        }
      } catch (e) {
        debugPrint('에러: $e');
        isLoading = false;
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 23,
                        child: Icon(
                          Icons.account_circle,
                          size: 46,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user_name ?? '',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user_email ?? '',
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ManagePlacePage()),
                          );
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
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () {
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
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text('취소'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text('확인'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (logoutConfirmed == true) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
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
