import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class ContainerList extends StatefulWidget {
  final List<dynamic> dataList;

  ContainerList({required this.dataList});

  @override
  _ContainerListState createState() => _ContainerListState();
}

class _ContainerListState extends State<ContainerList> {
  bool isLoading = false;
  int selectedContainerIndex = -1;
  late DateTime selectedDateTime;
  late DateTime defaultDateTime;
  double? startX = 0.0;
  double? startY = 0.0;
  double? endX = 127.08550930023235;
  double? endY = 37.5956338923703;
  late String busRoute = '';
  late String subwayRoute = '';

  @override
  void initState() {
    super.initState();
    defaultDateTime = DateTime.now();
    selectedDateTime = defaultDateTime;
    debugPrint('${widget.dataList}');
  }

  Future<void> makeApiCall() async {
    try {
      setState(() {
        busRoute = '';
        subwayRoute = '';
      });
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      startX = position.longitude;
      startY = position.latitude;

      String formattedTime =
          DateFormat('yyyyMMddHHmm').format(selectedDateTime);

      String apiUrl = 'http://15.164.170.6:5000/api/data/makcha?startX=$startX&startY=$startY&endX=$endX&endY=$endY&time=$formattedTime';

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);

        int busCount = responseData['metaData']['requestParameters']['busCount'];
        int subwayCount = responseData['metaData']['requestParameters']['subwayCount'];
        if (busCount > 0) {
          setState(() {
            busRoute = responseData['metaData']['plan']['itineraries'][0]['legs'][1]['route'];
            subwayRoute = '';
          });
        } else if (subwayCount > 0) {
          setState(() {
            subwayRoute = responseData['metaData']['plan']['itineraries'][0]['legs'][1]['route'];
            busRoute = '';
          });
        } else {
          setState(() {
            busRoute = '';
            subwayRoute = '';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('너무 가까운 거리에요!'),
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating, // 또는 SnackBarBehavior.fixed
              backgroundColor: Color(0xFF141D5B),
              margin: EdgeInsets.all(8.0), // SnackBar의 외부 여백 설정
              shape: RoundedRectangleBorder( // SnackBar 모양 설정
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('막차가 없습니다..ㅠㅠ'),
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating, // 또는 SnackBarBehavior.fixed
              backgroundColor: Color(0xFF141D5B),
              margin: EdgeInsets.all(8.0), // SnackBar의 외부 여백 설정
              shape: RoundedRectangleBorder( // SnackBar 모양 설정
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
        debugPrint('에러: ${response.statusCode}');
        debugPrint('내용: ${response.body}');
      }
      if (busRoute.isNotEmpty) {
        _showRouteModal(context, '$busRoute');
      } else if (subwayRoute.isNotEmpty) {
        _showRouteModal(context, '$subwayRoute');
      }
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('막차가 없습니다..ㅠㅠ'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating, // 또는 SnackBarBehavior.fixed
          backgroundColor: Color(0xFF141D5B),
          margin: EdgeInsets.all(8.0), // SnackBar의 외부 여백 설정
          shape: RoundedRectangleBorder( // SnackBar 모양 설정
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
      debugPrint('에러: $error');
    }
  }

  void _showRouteModal(BuildContext context, String route) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('막차 조회'),
          content: Text('''
        막차가 있습니다!
        $route 를 탑승하세요
                  '''),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(40.0),
      itemCount: widget.dataList.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return buildDateTimeSection(context);
        } else {
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
          cancelText: '취소',
          confirmText: '확인',
          helpText: '시간을 선택하세요',
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: Color(0xFF141D5B),
                colorScheme: ColorScheme.light(primary: Color(0xFF141D5B)),
                buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child!,
            );
          },
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
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xFFD8D8D8),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '조회 시간',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Text(
                DateFormat('yy-MM-dd hh:mm a').format(selectedDateTime),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Icon(
                Icons.event,
                color: Color(0xFF141D5B),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContainerItem(int index) {
    double? selectedX = double.tryParse(widget.dataList[index]['x'].toString()) ?? 0.0;
    double? selectedY = double.tryParse(widget.dataList[index]['y'].toString()) ?? 0.0;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedContainerIndex = index;
          endX = selectedX;
          endY = selectedY;
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
          borderRadius: BorderRadius.circular(10),
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  makeApiCall();
                },
                child: Align(
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
                      child: isLoading
                      ? CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white), 
                      ) // Show loading spinner
                      : Text(
                          '막차보기',
                          style: TextStyle(
                            color: Colors.white,
                          ),
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
