import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../common/components/searchbar.dart';

class LocationInfo extends StatelessWidget {
  final String locationText;
  final VoidCallback onAddLocationPressed;

  LocationInfo(
      {required this.locationText, required this.onAddLocationPressed}
  );

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
            style: TextStyle(fontSize: 6.0, color: Colors.black),
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
  Completer<NaverMapController> mapControllerCompleter = Completer();
  late NaverMapController mapController;
  String _token = '';
  bool _isLoading = true;
  late Position _currentPosition = Position(
    latitude: 37.6098496,
    longitude: 126.9970267,
    speed: 0.0,
    accuracy: 0.0,
    altitude: 0.0,
    altitudeAccuracy: 0.0,
    heading: 0.0,
    headingAccuracy: 0.0,
    speedAccuracy: 0.0,
    timestamp: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<Map<String, dynamic>> fetchLocationInfo(
    double latitude, double longitude) async {
    final apiUrl = 'http://15.164.170.6:5000/api/data/naver/coordinate';
    final String queryParams =
        'x=${longitude.toString()}&y=${latitude.toString()}';

    final response = await http.get(
      Uri.parse('$apiUrl?$queryParams'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to load location info');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _placeNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: SearchBarComponent(
          onSearchCallback: (x, y, address) {
            moveToLocation(x, y, address);
          },
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(
                    _currentPosition.latitude, _currentPosition.longitude),
                zoom: 14,
              ),
              indoorEnable: true,
              scaleBarEnable: true,
              locationButtonEnable: true,
              consumeSymbolTapEvents: true,
            ),
            onMapReady: (controller) async {
              mapController = controller;
              mapControllerCompleter.complete(controller);
              setState(() {
                _isLoading = false;
              });
              debugPrint('네이버 맵 로딩 완료');
            },
            onMapTapped: (NPoint point, NLatLng latLng) async {
              final cameraUpdate = NCameraUpdate.withParams(
                target: NLatLng(latLng.latitude, latLng.longitude),
                zoom: 14,
              );
              mapController.updateCamera(cameraUpdate);
              final returnValue =
                  await fetchLocationInfo(latLng.latitude, latLng.longitude);
              final addressValue = returnValue['address'];

              String infoWindowText;
              if (addressValue != null) {
                infoWindowText = addressValue;
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.0)),
                  ),
                  builder: (context) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom:
                            MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              controller: _placeNameController,
                              decoration: InputDecoration(labelText: '장소 이름'),
                              textInputAction: TextInputAction.none,
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Color(0xFF141D5B)),
                              ),
                              onPressed: () async {
                                final requestBody = {
                                  'name': _placeNameController.text,
                                  'address': infoWindowText,
                                  'x': latLng.longitude,
                                  'y': latLng.latitude,
                                  'userId': _token,
                                };
                                const placeUrl =
                                    'http://15.164.170.6:5000/api/data/places';
                                final response = await http.post(
                                  Uri.parse(placeUrl),
                                  headers: {
                                    'Content-Type': 'application/json'
                                  },
                                  body: jsonEncode(requestBody),
                                );
                                final responseData = json.decode(response.body);
                                if (responseData['success'] == true) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('장소가 추가되었습니다.'),
                                      duration: Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Color(0xFF141D5B),
                                      margin: EdgeInsets.all(8.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  );
                                }
                                Navigator.pop(context);
                              },
                              child: Text('추가하기', style: TextStyle(color: Colors.white)),
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
                position:
                    NLatLng(latLng.latitude, latLng.longitude),
                text: infoWindowText,
              );
              mapController.addOverlay(infoWindow);
            },
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  void moveToLocation(String x, String y, String address) {
    TextEditingController _placeNameController = TextEditingController();
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
                  controller: _placeNameController,
                  decoration: InputDecoration(labelText: '장소 이름'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF141D5B)),
                  ),
                  onPressed: () async {
                    final requestBody = {
                      'name': _placeNameController.text,
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
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color(0xFF141D5B),
                          margin: EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: Text('추가하기', style: TextStyle(color: Colors.white)),
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

  Future<void> _getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var status = await Permission.location.status;
    debugPrint('!');
    if (token != null) {
      _token = token;
    }
    debugPrint('!!');
    if (status == PermissionStatus.denied) {
      var permissionStatus = await Permission.location.request();
      if (permissionStatus == PermissionStatus.granted) {
        try {
          debugPrint('!!!');
          Position positiondata = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          setState(() {
            _currentPosition = positiondata; 
          });
          debugPrint('!!!!');
        } catch (e) {
          debugPrint('error: $e');
        }
      } else {
        debugPrint('위치 권한이 거부되었습니다.');
      }
    } else if (status.isGranted) {
      debugPrint('!!!!!');
      try {
        Position positiondata = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        debugPrint('${positiondata}');
        setState(() {
            _currentPosition = positiondata; 
          });    
        debugPrint('!!!!!!');
      } catch (e) {
        debugPrint('error: $e');
      }
    }
    if (_currentPosition == null) {
      debugPrint('_currentPosition이 null입니다.');
    } else {
      // _currentPosition이 null이 아닌 경우에만 setState 호출
      setState(() {
        _isLoading = false;
      });
    }
  }
}
