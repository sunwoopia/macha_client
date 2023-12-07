import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:macha_client/common/components/back_header.dart';
import 'package:macha_client/common/components/manage_container_list.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../common/components/containerlist.dart';

class ManagePlacePage extends StatefulWidget {
  @override
  State<ManagePlacePage> createState() => _ManagePlacePageState();
}

class _ManagePlacePageState extends State<ManagePlacePage> {
  List<dynamic> dataList = []; // 추가된 부분

  @override
  void initState() {
    super.initState();
    _loadDataList(); // 수정된 부분
  }

  Future<void> _loadDataList() async {
    // 데이터를 불러와 dataList에 저장
    dataList = await fetchData();
    debugPrint('${dataList}');
  }

  void _reloadDataList() {
    setState(() {
      _loadDataList(); // 데이터를 다시 불러옴
    });
  }

  Future<List<dynamic>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    debugPrint('token: $token');
    if (token != null) {
      final url = 'http://15.164.170.6:5000/api/data/places/$token';
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['place'] is List) {
            return (data['place'] as List).cast<Map<String, dynamic>>();
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
    return [];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackHeader(),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
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
            );
          } else {
            return ManageContainerList(dataList: dataList, reloadDataList: _reloadDataList); // 수정된 부분
          }
        },
      ),
    );
  }
}
