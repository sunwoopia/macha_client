import 'package:flutter/material.dart';
import 'dart:async';
import '../common/components/header.dart';
import '../common/components/footer.dart';

class appSettings extends StatefulWidget {
  @override
  _AppsettingsState createState() => _AppsettingsState();
}

class _AppsettingsState extends State<appSettings> {
  bool _pushNotificationEnabled = true;
  bool _sleepModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text('앱 푸시 알림'),
            trailing: Switch(
              value: _pushNotificationEnabled,
              onChanged: (value) {
                setState(() {
                  _pushNotificationEnabled = value;
                });
              },
            ),
          ),
          SizedBox(height: 23),
          ListTile(
            title: Text('수면 모드 활성화'),
            trailing: Switch(
              value: _sleepModeEnabled,
              onChanged: (value) {
                setState(() {
                  _sleepModeEnabled = value;
                });
              },
            ),
          ),
          SizedBox(height: 25),
          Text("수면모드를 활성화 하면 23시부터 09시까지 알림이 오지 않아요.")
        ],
      ),
    );
  }
}
