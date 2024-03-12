
// import 'package:flutter/services.dart';
//import 'package:usbcan_plugins/usbcan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robomas_debuger/provider.dart';
//import 'package:usbcan_plugins/frames.dart';
// import 'package:robomas_debuger/change_datatype.dart';
import 'package:robomas_debuger/robomas_views.dart';
// import 'package:usbcan_plugins/frames.dart';

class RobomasControllCenter extends ConsumerWidget {
  const RobomasControllCenter({Key? key, /*required this.number*/}) : super(key: key);
  // final int number;

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return Scaffold(
      body: ListView(
        children: const [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FrameSendButton(number: 1,),
              TargetResetButton(),
            ],
          ),
          TargetWidget(number: 1),
          TargetWidget(number: 2),
          TargetWidget(number: 3),
          TargetWidget(number: 4),
          TargetWidget(number: 5),
          TargetWidget(number: 6),
          TargetWidget(number: 7),
          TargetWidget(number: 8),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context, WidgetRef ref){
  //   return const Scaffold(
  //     body:  Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         //mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           PIDTextField(),
  //           Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text('Mode:'),
  //               ModeButton(),
  //               FrameSendButton(),
  //             ],
  //           ),
  //           Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               TargetTextField(),
  //               TargetSendButton(),
  //             ],
  //           ),
  //           Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               // DebugTextField(),
  //               DiagButton()
  //             ],
  //           ),
  //           Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               // DebugTextField(),
  //               TargetSlider()
  //             ],
  //           ),
  //         ]
  //       )
  //     )
  //   );
  // }
}

class RobomasSetting extends ConsumerWidget {
  const RobomasSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 8, // PIDTextField の数をカウント
        itemBuilder: (context, index) {
          return PIDTextField(number: index + 1); // 生成した番号を引数にして PIDTextField を生成
        },
      ),
    );
  }
}

class RobomasPages extends ConsumerWidget {
  const RobomasPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Robomas_Debuger"),
      ),
      body: [
        const RobomasControllCenter(),
        const RobomasSetting(),
      ][ref.watch(indexprovider)],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting'
          ),
        ],
        currentIndex: ref.watch(indexprovider),
        onTap: (value) {
          ref.read(indexprovider.notifier).state = value;
        },
      ),
    );
  }
}