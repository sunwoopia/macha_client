import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import './common/components/header.dart';
import './common/components/footer.dart';
import './pages/signIn.dart';
import './pages/signUp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: '9z6ezmsit2',
      onAuthFailed: (error) {
        debugPrint('Auth failed: $error');
      });


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      highlightColor: Colors.transparent,
      ),
      home: NaverMapPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage1 extends StatefulWidget {
  @override
  State<MainPage1> createState() => _MainPage1State();
}

class _MainPage1State extends State<MainPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  '장소를 추가해주세요',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                child: Image.asset(
                  'assets/images/location.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 34),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage2()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF141D5B),
                onPrimary: Colors.white,
                fixedSize: Size(148, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text('+    장소추가하기'),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Footer(),
    );
  }
}


class MainPage2 extends StatefulWidget {
  @override
  State<MainPage2> createState() => _MainPage2State();
}
class _MainPage2State extends State<MainPage2> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Container(
                width: 295,
                height: 102,
                decoration: BoxDecoration(
                  color: isChecked ? Color(0xFFBB86FC).withOpacity(0.1) : Colors.transparent, // Updated line
                  border: Border.all(
                    color: isChecked ? Color(0xFF601CB7) : Colors.black.withOpacity(0.12),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '우리집',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Spacer(),
                        Checkbox(
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                          shape: CircleBorder(),
                          activeColor: isChecked ? Color(0xFF601CB7) : Colors.transparent,
                        ),
                      ],
                    ),
                    Text(
                      '서울 성북구 삼양로27길 19',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: isChecked ? Color(0xFF601CB7) : Color(0xFFB2B2B2),
                      onPrimary: Colors.white,
                      fixedSize: Size(96, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text('막차보기'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 34),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage1()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF141D5B),
                onPrimary: Colors.white,
                fixedSize: Size(148, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text('+    장소추가하기'),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Footer(),
    );
  }
}

class NaverMapPage extends StatefulWidget {
  @override
  _NaverMapPageState createState() => _NaverMapPageState();
}
class _NaverMapPageState extends State<NaverMapPage> {
  @override
  void initState() {
    super.initState();
  }
  Widget build(BuildContext context) {
    final Completer<NaverMapController> mapControllerCompleter = Completer();

    return Scaffold(
      appBar: Header(),
      body: NaverMap(
        options: const NaverMapViewOptions(
            indoorEnable: true,             // 실내 맵 사용 가능 여부 설정
            locationButtonEnable: true,    // 위치 버튼 표시 여부 설정
            consumeSymbolTapEvents: false,  // 심볼 탭 이벤트 소비 여부 설정
          ),
          onMapReady: (controller) async {                // 지도 준비 완료 시 호출되는 콜백 함수
            mapControllerCompleter.complete(controller);  // Completer에 지도 컨트롤러 완료 신호 전송
            debugPrint('네이버 맵 로딩 완료');
          },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF141D5B),
          onPrimary: Colors.white,
          fixedSize: Size(148, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text('+    장소추가하기'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Footer(),
    );
  }
}

class ProfilePage extends StatelessWidget {
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
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(
                          //       builder: (context) => appSettings()),
                          // );
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

class personalInforamtion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("개인정보처리방침"),
    );
  }
}

class termOfUse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("이용약관"),
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
    Timer(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainPage1()),

    // Timer(Duration(seconds: 2), () {
     // Navigator.of(context).pushReplacement(
      //  MaterialPageRoute(builder: (context) => SignIn()),
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
