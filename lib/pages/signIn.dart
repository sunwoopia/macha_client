import 'package:flutter/material.dart';
import 'dart:async';
import './signUp.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(children: [
                Image.asset('assets/images/splash2.png',
                    width: 200, height: 200, color: Colors.black),
                buildInputField('이메일'),
                buildInputField('비밀번호'),
                SizedBox(height: 20),
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
                    child: Text('로그인', style: TextStyle(color: Colors.white))),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("회원이 아니신가요?",
                        style: TextStyle(color: Color(0xFF7A7A7A))),
                    GestureDetector(
                      onTap: () {
                        // Handle login action
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp2()),
                        );
                      },
                      child: Text("회원가입",
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
