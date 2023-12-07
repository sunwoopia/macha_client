import 'package:flutter/material.dart';
import 'package:macha_client/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_up.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/splash2.png',
                  width: 200, height: 200, color: Colors.black),
              buildInputField('이메일', controller: emailController),
              buildInputField('비밀번호', isPassword: true, controller: passwordController),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.left,
                )
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await loginUser(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF141D5B),
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: const Text('로그인', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text("회원이 아니신가요?", style: TextStyle(color: Color(0xFF7A7A7A))),
                  const SizedBox(width: 4,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp2()),
                      );
                    },
                    child: const Text("회원가입", style: TextStyle(color: Color(0xFF141D5B))),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveTokenToSharedPreferences(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> loginUser(BuildContext context) async {
    const url = 'http://15.164.170.6:5000/api/user/login';
    final Map<String, String> data = {
      'email': emailController.text,
      'password': passwordController.text,
    };
    debugPrint('${data}');
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint('${response.statusCode}');
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == true && responseData['token'] != null) {
        saveTokenToSharedPreferences(responseData['token']);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('로그인 성공!'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating, // 또는 SnackBarBehavior.fixed
              backgroundColor: Color(0xFF141D5B),
              margin: EdgeInsets.all(8.0), // SnackBar의 외부 여백 설정
              shape: RoundedRectangleBorder( // SnackBar 모양 설정
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {
        setState(() {
          errorMessage = '아이디와 비밀번호를 확인해주세요';
        });
      }
    } else {
      setState(() {
        errorMessage = '아이디와 비밀번호를 확인해주세요';
      });    
    }
  }

  Widget buildInputField(String labelText, {bool isPassword = false, TextEditingController? controller}) {
    return TextField(
      obscureText: isPassword,
      controller: controller,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Color(0xFF9C9C9C)),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF9C9C9C)),
        ),
      ),
    );
  }
}
