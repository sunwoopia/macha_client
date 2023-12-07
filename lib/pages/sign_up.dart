import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'sign_in.dart';
import 'package:email_validator/email_validator.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("손쉽게 막차 시간을 알려주는"),
              Image.asset('assets/images/splash2.png',
                  width: 200, height: 200, color: Colors.black),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp2()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF141D5B),
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: const Text('회원가입', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text("이미 회원이신가요?",
                      style: TextStyle(color: Color(0xFF7A7A7A))),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      // Handle login action
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                    },
                    child: const Text("로그인",
                        style: TextStyle(color: Color(0xFF141D5B))),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SignUp2 extends StatefulWidget {
  @override
  _SignUp2State createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  bool isChecked = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/splash2.png',
                  width: 200, height: 200, color: Colors.black),
              buildInputField('이름', controller: nameController),
              buildInputField('이메일', controller: emailController),
              buildInputField('비밀번호', isPassword: true, controller: passwordController),
              buildInputField('비밀번호 확인', isPassword: true, controller: confirmPasswordController),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  const Text(
                    '개인정보 이용에 동의하시겠습니까?',
                    style: TextStyle(color: Color(0xFF7A7A7A)),
                  ),
                ],
              ),
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
                  if (validateFields()) {
                    await registerUser();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF141D5B),
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: const Text('회원가입완료', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    "이미 회원이신가요?",
                    style: TextStyle(color: Color(0xFF7A7A7A)),
                  ),
                  const SizedBox(width: 5,),
                  GestureDetector(
                    onTap: () {
                      // Handle login action
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                    },
                    child: const Text("로그인",
                        style: TextStyle(color: Color(0xFF141D5B))),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String labelText,
      {bool isPassword = false, TextEditingController? controller}) {
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

  bool validateFields() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      setState(() {
        errorMessage = '모든 필드를 입력해주세요';
      });
      return false;
    }

    if (!EmailValidator.validate(emailController.text)) {
      setState(() {
        errorMessage = '올바른 이메일 주소를 입력해주세요';
      });
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = '비밀번호와 비밀번호 확인이 일치하지 않습니다';
      });
      return false;
    }

    if (!isChecked) {
      setState(() {
        errorMessage = '약관에 동의해주세요';
      });
      return false;
    }

    return true;
  }

  Future<void> registerUser() async {
    const url = 'http://15.164.170.6:5000/api/user/';
    final Map<String, String> data = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
    };

    final response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('회원가입에 성공하였습니다.'),
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
          MaterialPageRoute(builder: (context) => SignIn()),
        );
      } else {
        debugPrint('회원가입 실패');
      }
    } else {
      // HTTP 요청 실패
      debugPrint('회원가입 실패. Status code: ${response.statusCode}');
    }
  }
}
