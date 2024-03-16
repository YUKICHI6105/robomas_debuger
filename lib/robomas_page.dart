// import 'package:flutter/services.dart';
//import 'package:usbcan_plugins/usbcan.dart';
import 'package:flutter/material.dart';
//import 'package:usbcan_plugins/frames.dart';
// import 'package:robomas_debuger/change_datatype.dart';
import 'package:robomas_debuger/robomas_views.dart';
// import 'package:usbcan_plugins/frames.dart';

class RobomasControlPage extends StatelessWidget {
  const RobomasControlPage({
    Key? key,
    /*required this.number*/
  }) : super(key: key);
  // final int number;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FrameSendButton(
                    number: 1,
                  ),
                  TargetResetButton(),
                ],
              )
            ] +
            [for (var i = 0; i < 8; i++) TargetWidget(number: i + 1)],
      ),
    );
  }
}

class RobomasSettingPage extends StatelessWidget {
  const RobomasSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 8, // PIDTextField の数をカウント
        itemBuilder: (context, index) {
          return PIDTextField(
              number: index + 1); // 生成した番号を引数にして PIDTextField を生成
        },
      ),
    );
  }
}

class RobomasPages extends StatefulWidget {
  const RobomasPages({super.key});

  @override
  State<RobomasPages> createState() => _RobomasPagesState();
}

class _RobomasPagesState extends State<RobomasPages> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Robomas_Debuger"),
      ),
      body: const [
        RobomasControlPage(),
        RobomasSettingPage(),
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}
