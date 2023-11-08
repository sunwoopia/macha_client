import 'package:flutter/material.dart';
import 'dart:async';
import './common/components/header.dart';
import './common/components/footer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      highlightColor: Colors.transparent, // 선택된 아이템의 강조 효과 비활성화
      // 나머지 테마 설정
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Header(),
      body: SingleChildScrollView(
        // child: NaverMap(
          // onMapCreated: (controller) {
          // },
          // markers: [
          //   Marker(
          //     markerId: 'markerId',
          //     position: LatLng(37.5665, 126.9780),
          //     infoWindow: '서울',
          //   ),
          // ],
        // ),
      ),
      bottomNavigationBar: Footer(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 일정 시간이 지난 후에 MyHomePage로 이동
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/images/splash.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}