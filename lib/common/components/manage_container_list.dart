import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageContainerList extends StatefulWidget {
  final List<dynamic> dataList;
  final VoidCallback reloadDataList; // 추가된 부분

  ManageContainerList({required this.dataList, required this.reloadDataList}); // 수정된 부분

  @override
  _ManageContainerListState createState() => _ManageContainerListState();
}

class _ManageContainerListState extends State<ManageContainerList> {
  int selectedContainerIndex = -1;

  @override
  void initState() {
    super.initState();
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
    return Container();
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
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selectedContainerIndex == index
                ? Color(0xFF6200EE)
                : Color(0xFFD8D8D8),
          ),
        ),
        child: Stack(
          children: [
            Column(
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
              ],
            ),
            if (selectedContainerIndex == index)
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    debugPrint('${widget.dataList[index]}');
                    _showDeleteConfirmationDialog(index, widget.dataList[index]['id']);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 15,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(int index, String placeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('장소 삭제'),
          content: Text('이 장소를 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                _deletePlace(placeId);
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePlace(String placeId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://15.164.170.6:5000/api/data/places/$placeId'),
      );
      debugPrint(response.body);
      if (response.statusCode == 200) {
        debugPrint('장소 삭제 성공. placeId: $placeId');
        widget.reloadDataList(); // 추가된 부분
      } else {
        debugPrint('장소 삭제 실패. statusCode: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('장소 삭제 중 오류 발생: $error');
    }
  }
}
