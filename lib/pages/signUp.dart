import 'package:flutter/material.dart';
import 'dart:async';
import './signIn.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(children: [
                Text("손쉽게 막차 시간을 알려주는"),
                SizedBox(height: 20),
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
                      primary: Color(0xFF141D5B),
                      onPrimary: Colors.white,
                      fixedSize: Size(295, 60),
                    ),
                    child: Text('회원가입', style: TextStyle(color: Colors.white))),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("이미 회원이신가요?",
                        style: TextStyle(color: Color(0xFF7A7A7A))),
                    GestureDetector(
                      onTap: () {
                        // Handle login action
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
                      child: Text("로그인",
                          style: TextStyle(color: Color(0xFF141D5B))),
                    )
                  ],
                )
              ]))),
    );
  }
}

class SignUp2 extends StatefulWidget {
  @override
  _SignUp2State createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(children: [
                Image.asset('assets/images/splash2.png',
                    width: 200, height: 200, color: Colors.black),
                buildInputField('이름'),
                buildInputField('이메일'),
                buildInputField('비밀번호'),
                buildInputField('비밀번호 확인'),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        }),
                    Text(
                      '동의하시겠습니까?',
                      style: TextStyle(color: Color(0xFF7A7A7A)),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF141D5B),
                      onPrimary: Colors.white,
                      fixedSize: Size(295, 60),
                    ),
                    child:
                        Text('회원가입완료', style: TextStyle(color: Colors.white))),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("이미 회원이신가요?",
                        style: TextStyle(color: Color(0xFF7A7A7A))),
                    GestureDetector(
                      onTap: () {
                        // Handle login action
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
                      child: Text("로그인",
                          style: TextStyle(color: Color(0xFF141D5B))),
                    )
                  ],
                )
              ]))),
    );
  }
}

Widget buildInputField(String labelText, {bool isPassword = false}) {
  return TextField(
    obscureText: isPassword,
    style: TextStyle(fontSize: 13),
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Color(0xFF9C9C9C)),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF9C9C9C)),
      ),
    ),
  );
}
