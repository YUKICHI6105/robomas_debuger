// import 'dart:async';

// import 'stream_list_builder.dart';
// import 'package:usbcan_plugins/usbcan.dart';
// import 'package:flutter/material.dart';

// import 'package:usbcan_plugins/widgets.dart';

// void sendRobomasFrame(List frame){
//   final List<int> data = frame;
//   final Uint8List bytes = Uint8List.fromList(data);
//   usbPort.write(bytes);
// }

// void sendRobomasTarget(int target){
//   final List<int> data = <Uint8>[0x31,0x00,0x00,0x00,0x00,0x00];
//   final Uint8List bytes = Uint8List.fromList(data);
//   usbPort.write(bytes);
// }