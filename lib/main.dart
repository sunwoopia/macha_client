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


// class MyHomePage2 extends StatefulWidget {
//   @override
//   State<MyHomePage2> createState() => _MyHomePageState2();
// }
// class _MyHomePageState2 extends State<MyHomePage2> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: Header(),
//       body: Center(
//         child:Container(
//           child:Column(
//               children[
//                 Text(
//                   '우리집',
//                   style: TextStyle(fontSize: 20, color: Colors.black),
//                   // decoration: BoxDecoration(
//                   //   border: Border.all(
//                   //     color: Colors.black,
//                   //     width: 1.0,
//                   //   ),
//                   // ),
//                 ),
//                 Text(
//                 '서울 성북구 삼양로27길 19',
//                 style: TextStyle(fontSize: 20, color: Colors.black),
//                 // decoration: BoxDecoration(
//                 //   border: Border.all(
//                 //     color: Colors.black,
//                 //     width: 1.0,
//                 //     ),
//                 //   ),
//                 ),
//               ],
//           )
//         ),
//       ),
//       floatingActionButton: ElevatedButton(
//         onPressed: () {},
//         style: ElevatedButton.styleFrom(
//           primary: Color(0xFF141D5B),
//           onPrimary: Colors.white,
//           fixedSize: Size(148, 48),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(50),
//           ),
//         ),
//         child: Text('+    장소추가하기'),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       bottomNavigationBar: Footer(),
//     );
//   }
// }




class MyHomePage3 extends StatefulWidget {
  @override
  State<MyHomePage3> createState() => _MyHomePageState3();
}
class _MyHomePageState3 extends State<MyHomePage3> {
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
                  width:295,
                  height:102,
                decoration: BoxDecoration(
                  border:Border.all(
                  color:Colors.black,
                  width:1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children:[
                        Text(
                        '우리집',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Spacer(), // Add a spacer to push the checkbox to the right
                        Checkbox(
                          value: true,
                          onChanged: (value) {},
                          shape: CircleBorder(),
                          activeColor: Color(0xFF601CB7),
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
              SizedBox(height: 20), // Add margin between container and button
                ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                primary: Color(0xFFB2B2B2),
                onPrimary: Colors.white,
                fixedSize: Size(96, 49),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text('막차보기'),
              ),
            ],
          ),
        ),
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






class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 일정 시간이 지난 후에 MyHomePage로 이동
    Timer(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage3()),
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