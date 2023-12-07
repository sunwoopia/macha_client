import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SearchBarComponent extends StatefulWidget {
  final Function(String, String, String) onSearchCallback;
  SearchBarComponent({required this.onSearchCallback});
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBarComponent> {
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
              decoration: InputDecoration(
                hintText: '장소를 검색하세요',
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.none,
            ),
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.black,),
            onPressed: () {
              onSearch(_textEditingController.text);
            },
          ),
        ],
      ),
    );
  }

  void onSearch(String inputValue) async {
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
        final responseData = json.decode(response.body);
        String x = responseData['x'];
        String y = responseData['y'];
        widget.onSearchCallback(x, y, inputValue);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('장소가 없습니다! 정확한 주소를 입력해주세요.'),
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('문제가 있습니다.'),
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
  }
}