import 'package:flutter/material.dart';
import 'package:robomas_debuger/robomas_views.dart';

class RobomasControlPage extends StatelessWidget {
  const RobomasControlPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FrameSendButton(),
                  TargetResetButton(),
                ],
              )
            ] +
            [for (var i = 0; i < 8; i++) TargetWidget(motorIndex: i )],
      ),
    );
  }
}

class RobomasSettingPage extends StatelessWidget {
  const RobomasSettingPage({Key? key}) : super(key: key);
  final int numberOfMotors = 8;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: numberOfMotors, // PIDTextField の数をカウント
        itemBuilder: (context, index) {
          return PIDTextField(
              motorIndex: index); // 生成した番号を引数にして PIDTextField を生成
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
