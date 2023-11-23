import 'dart:convert';
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
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
          MyHomePage(onAddCallback: addClick),
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
  void addClick() {
    setState(() {
      _currentIndex = 1;
      _pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
    });
  }
}

class MyHomePage extends StatefulWidget {
  final Function() onAddCallback;
  MyHomePage({required this.onAddCallback});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> places = []; 
  late DateTime defaultDateTime;

  @override
  void initState() {
    super.initState();
    defaultDateTime = DateTime.now();
    fetchData();
  }
  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    debugPrint('$token');
    if (token != null) {
      final url = 'http://15.164.170.6:5000/api/data/places/$token';
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['place'] is List) {
            setState(() {
              places = (data['place'] as List).cast<Map<String, dynamic>>();
            });
          } else {
            debugPrint('Invalid data type for places');
          } 
        } else {
          debugPrint('Failed to load data: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Error: $e');
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: places.isNotEmpty
            ? ContainerList(dataList: places)
            : Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text(
                        '도착지를 추가해주세요',
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
        onPressed: () {
          widget.onAddCallback();
        },
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
class SearchBar extends StatefulWidget {
  final Function(String, String, String) onSearchCallback;
  SearchBar({required this.onSearchCallback});
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _textEditingController = TextEditingController();

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
          SizedBox(width: 20),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              onChanged: (value) {
                // Call your onSearch method here with the updated value
                setState(() {
                  _textEditingController.text = value;
                });
              },
              decoration: InputDecoration(
                hintText: '장소를 검색하세요',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.black,),
            onPressed: () {
              // Call onSearch with the current value when the search icon is pressed
              onSearch(_textEditingController.text);
            },
          ),
        ],
      ),
    );
  }

  void onSearch(String inputValue) async {
    // 기존의 onSearch 메서드
    final String apiUrl = 'http://15.164.170.6:5000/api/data/naver/address';
    try {
      final Map<String, String> data = {
        "address": "$inputValue",
      };
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );
      if (response.statusCode == 201) {
        debugPrint('API 응답: ${response.body}');

        // 응답 본문에서 x와 y 값을 파싱합니다.
        final responseData = json.decode(response.body);
        String x = responseData['x'];
        String y = responseData['y'];
        widget.onSearchCallback(x, y, inputValue);
      } else {
        debugPrint('API 호출 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _textEditingController.dispose();
    super.dispose();
  }
}



class NaverMapPage extends StatefulWidget {
  @override
  _NaverMapPageState createState() => _NaverMapPageState();
}
class _NaverMapPageState extends State<NaverMapPage> {
  Completer<NaverMapController> mapControllerCompleter = Completer();
  late NaverMapController mapController;
  String _token = '';
  @override
  void initState() {
    super.initState();
    _getLocation();
  }
  Future<Map<String, dynamic>> fetchLocationInfo(double latitude, double longitude) async {
    final apiUrl = 'http://15.164.170.6:5000/api/data/naver/coordinate';
    final String queryParams = 'x=${longitude.toString()}&y=${latitude.toString()}';

    final response = await http.get(
      Uri.parse('$apiUrl?$queryParams'),
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint('$response');
    if (response.statusCode == 201) {
      final responsedata = json.decode(response.body);
      return responsedata;
    } else {
      throw Exception('Failed to load location info');
    }
  }
  Widget build(BuildContext context) {
    Position? currentPosition =
        Provider.of<LocationProvider>(context).currentPosition;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SearchBar(
          onSearchCallback: (x, y, address) {
            moveToLocation(x, y, address); // 예시로 넣은데 실제 동작에 맞게 수정 필요
          },
        ),
        elevation: 0,
      ),
      body: NaverMap(
        options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(
              target: NLatLng(currentPosition!.latitude, currentPosition.longitude),
              zoom: 14
              ),
            indoorEnable: true,             // 실내 맵 사용 가능 여부 설정
            scaleBarEnable: true,
            locationButtonEnable: true,    // 위치 버튼 표시 여부 설정
            consumeSymbolTapEvents: true,  // 심볼 탭 이벤트 소비 여부 설정
          ),
          onMapReady: (controller) async {
             mapController = controller;
             mapControllerCompleter.complete(controller);
             debugPrint('네이버 맵 로딩 완료');
          },
          onMapTapped: (NPoint point, NLatLng latLng) async {
            final cameraUpdate = NCameraUpdate.withParams(
              target: NLatLng(latLng.latitude, latLng.longitude),
              zoom: 14,
            );
            mapController.updateCamera(cameraUpdate);
            final returnValue = await fetchLocationInfo(latLng.latitude, latLng.longitude);
            final addressValue = returnValue['address'];

            String infoWindowText;
            if (addressValue != null) {
              infoWindowText = addressValue;
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                builder: (context) {
                  String placeName = '';
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(labelText: '장소 이름'),
                            onChanged: (value) {
                              placeName = value;
                            },
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF141D5B)), // 원하는 색상으로 변경
                              ),
                              onPressed: () async {
                              // 서버에 요청 보내기
                              final requestBody = {
                                'name': placeName,
                                'address': infoWindowText,
                                'x': latLng.longitude,
                                'y': latLng.latitude,
                                'userId': _token,
                              };
                              const placeUrl = 'http://15.164.170.6:5000/api/data/places';
                              final response = await http.post(
                                Uri.parse(placeUrl),
                                headers: {'Content-Type': 'application/json'},
                                body: jsonEncode(requestBody),
                              );
                              final responseData = json.decode(response.body);
                              if (responseData['success'] == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('장소가 추가되었습니다.'),
                                    duration: Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating, // 또는 SnackBarBehavior.fixed
                                    backgroundColor: Color(0xFF141D5B),
                                    margin: EdgeInsets.all(8.0), // SnackBar의 외부 여백 설정
                                    shape: RoundedRectangleBorder( // SnackBar 모양 설정
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                );
                              }
                              Navigator.pop(context);
                            },
                            child: Text('추가하기'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              infoWindowText = '잘못된 장소입니다. 다시 클릭하여 주세요';
            }
            final infoWindow = NInfoWindow.onMap(
              id: "location",
              position: NLatLng(latLng.latitude, latLng.longitude),
              text: infoWindowText,
            );
            mapController.addOverlay(infoWindow);
          },
      ),
    );
  }
  void moveToLocation(String x, String y, String address) {
    final cameraUpdate = NCameraUpdate.withParams(
      target: NLatLng(double.parse(y), double.parse(x)),
      zoom: 14,
    );
    mapController.updateCamera(cameraUpdate);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        String placeName = '';
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: '장소 이름'),
                  onChanged: (value) {
                    placeName = value;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF141D5B)), // 원하는 색상으로 변경
                    ),
                    onPressed: () async {
                    // 서버에 요청 보내기
                    final requestBody = {
                      'name': placeName,
                      'address': address,
                      'x': x,
                      'y': y,
                      'userId': _token,
                    };
                    const placeUrl = 'http://15.164.170.6:5000/api/data/places';
                    final response = await http.post(
                      Uri.parse(placeUrl),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode(requestBody),
                    );
                    final responseData = json.decode(response.body);
                    if (responseData['success'] == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('장소가 추가되었습니다.'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating, // 또는 SnackBarBehavior.fixed
                          backgroundColor: Color(0xFF141D5B),
                          margin: EdgeInsets.all(8.0), // SnackBar의 외부 여백 설정
                          shape: RoundedRectangleBorder( // SnackBar 모양 설정
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: Text('추가하기'),
                ),
              ],
            ),
          ),
        );
      },
    );
    String infoWindowText;
    infoWindowText = address;
    final infoWindow = NInfoWindow.onMap(
      id: "location",
      position: NLatLng(double.parse(y), double.parse(x)),
      text: infoWindowText,
    );
    mapController.addOverlay(infoWindow);
  }
  void _getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      _token = token;
    }
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
class LocationInfo extends StatelessWidget {
  final String locationText;
  final VoidCallback onAddLocationPressed;

  LocationInfo({required this.locationText, required this.onAddLocationPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(6.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            locationText,
            style: TextStyle(fontSize: 6.0, color: Colors.black), // 조절 가능한 폰트 크기
          ),
        ],
      ),
    );
  }
}

class ContainerList extends StatefulWidget {
  final List<dynamic> dataList;

  ContainerList({required this.dataList});

  @override
  _ContainerListState createState() => _ContainerListState();
}

class _ContainerListState extends State<ContainerList> {
  int selectedContainerIndex = -1;
  late DateTime selectedDateTime;
  late DateTime defaultDateTime;

  @override
  void initState() {
    super.initState();
    defaultDateTime = DateTime.now();
    selectedDateTime = defaultDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(40.0),
      itemCount: widget.dataList.length + 1, // +1 for the date and time section
      itemBuilder: (context, index) {
        if (index == 0) {
          // Display date and time section
          return buildDateTimeSection(context);
        } else {
          // Display container list
          return buildContainerItem(index - 1);
        }
      },
    );
  }

  Widget buildDateTimeSection(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDateTime,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null) {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(selectedDateTime),
          );

          if (pickedTime != null) {
            setState(() {
              selectedDateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
            });
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        alignment: Alignment.center,
        color: Colors.grey[200],
        child: Column(
          children: [
            Text(
              '선택된 날짜와 시간:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat('yyyy-MM-dd hh:mm a').format(selectedDateTime),
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContainerItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedContainerIndex = index;
        });
      },
      child: Container(
        height: 150,
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: selectedContainerIndex == index
              ? Color(0xBB86FC).withOpacity(0.12)
              : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: selectedContainerIndex == index
                ? Color(0xFF6200EE)
                : Color(0xFFD8D8D8),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.dataList[index]['name']!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 20,),
            Text(
              widget.dataList[index]['address']!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (selectedContainerIndex == index)
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 96,
                  height: 36,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF601CB7),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: Text(
                      '막차보기',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
