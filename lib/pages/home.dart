import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../common/components/containerlist.dart';

class MyHomePage extends StatefulWidget {
  final Function() onAddCallback;
  MyHomePage({required this.onAddCallback});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DateTime defaultDateTime;

  @override
  void initState() {
    super.initState();
    defaultDateTime = DateTime.now();
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
            return ContainerList(dataList: snapshot.data!);
          }
        },
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
        child: Text('+  장소추가하기', style: TextStyle(color: Colors.white)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}