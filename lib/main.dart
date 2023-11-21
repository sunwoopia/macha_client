import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:macha_client/pages/profile.dart';
import 'package:provider/provider.dart';
import './common/components/header.dart';
import './common/components/footer.dart';
import 'pages/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: '9z6ezmsit2',
      onAuthFailed: (error) {
        debugPrint('Auth failed: $error');
      });

  runApp(
    ChangeNotifierProvider(
      create: (context) => LocationProvider(), // LocationProvider 인스턴스 생성
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      highlightColor: Colors.transparent,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 스플래시 스크린
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      // 토큰이 저장되어 있으면 로그인 상태이므로 MyHome 으로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      // 토큰이 없으면 로그인되지 않은 상태이므로 SignUp 으로 이동
      Timer(Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignUp()),
        );
      });
    }
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
class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          MyHomePage(),
          NaverMapPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: Footer(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: const Text(
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
          backgroundColor: Color(0xFF141D5B),
          fixedSize: const Size(148, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text('+    장소추가하기'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(178, 178, 178, 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.black,),
          SizedBox(width: 4),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '장소를 검색하세요',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NaverMapPage extends StatefulWidget {
  @override
  _NaverMapPageState createState() => _NaverMapPageState();
}
class _NaverMapPageState extends State<NaverMapPage> {
  Position? _currentPosition;
  Completer<NaverMapController> mapControllerCompleter = Completer();
  
  @override
  void initState() {
    super.initState();
    _getLocation();
  }
  Widget build(BuildContext context) {
    Position? currentPosition =
        Provider.of<LocationProvider>(context).currentPosition;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SearchBar(),
        elevation: 0,
      ),
      body: NaverMap(
        options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(
              target: NLatLng(currentPosition!.latitude, currentPosition.longitude),
              zoom: 14
              ),
            indoorEnable: true,             // 실내 맵 사용 가능 여부 설정
            locationButtonEnable: true,    // 위치 버튼 표시 여부 설정
            consumeSymbolTapEvents: false,  // 심볼 탭 이벤트 소비 여부 설정
          ),
          onMapReady: (controller) async {                // 지도 준비 완료 시 호출되는 콜백 함수
            mapControllerCompleter.complete(controller);  // Completer에 지도 컨트롤러 완료 신호 전송
            debugPrint('네이버 맵 로딩 완료');
            
          },
          onMapTapped: (NPoint point, NLatLng latLng)async {
            debugPrint('Tapped Point: $point');
            debugPrint('Tapped Point: $latLng');   
            final lati = currentPosition.latitude;  
            final longi = currentPosition.longitude;
            debugPrint('lati Point: $currentPosition');     
            debugPrint('longi Point: $latLng');     
          },
      ),
    );
  }
  void _getLocation() async {
    var status = await Permission.location.status;
    debugPrint('status: $status');

    if (status == PermissionStatus.denied) {
      await Permission.locationWhenInUse.request();
      status = await Permission.location.status;
    }

    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        debugPrint('위치 정보 가져왔어염: $position');
        // 위치 정보를 LocationProvider에 저장
        Provider.of<LocationProvider>(context, listen: false)
            .setCurrentPosition(position);
      } catch (e) {
        debugPrint('error: $e');
      }
    } else {
      debugPrint('위치 권한이 거부되었습니다.');
    }
  }
}

class LocationProvider with ChangeNotifier {
  // 위치 정보를 저장할 변수
  Position? _currentPosition;

  // 위치 정보 가져오기
  Position? get currentPosition => _currentPosition;

  // 위치 정보 설정
  void setCurrentPosition(Position position) {
    _currentPosition = position;
    notifyListeners();
  }
}