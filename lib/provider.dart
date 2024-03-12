//import 'dart:ffi';
//import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usbcan_plugins/usbcan.dart';
//import 'package:usbcan_plugins/frames.dart';

enum Mode {
  dis,
  vel,
  pos,
  berutyoku,
  stablepos,
}

UsbCan usbCan = UsbCan();

final List<StateProvider<int>> modeProviders = List.generate(8, (index) => StateProvider((ref) {return 0;}));

final diag = StateProvider<String>((ref) => 'off');

final List<StateProvider<int>> motorKindProviders = List.generate(8, (index) => StateProvider((ref) {return 1;}));

final indexprovider = StateProvider<int>((ref) => 0);

final List<StateProvider<bool>> isOnProviders = List.generate(8, (index) => StateProvider((ref) {return false;}));

final tyokuVelTarget = StateProvider<double>((ref) => 0);
final tyokuPosTarget = StateProvider<double>((ref) => 0);

final List<StateProvider<TextEditingController>> velkptextfieldcontroller = List.generate(
  8,
  (index) => StateProvider<TextEditingController>((ref) => TextEditingController(text: '0.15')),
);

final List<StateProvider<TextEditingController>> velkitextfieldcontroller = List.generate(
  8,
  (index) => StateProvider<TextEditingController>((ref) => TextEditingController(text: '9.0')),
);

final List<StateProvider<TextEditingController>> poskptextfieldcontroller = List.generate(
  8,
  (index) => StateProvider<TextEditingController>((ref) => TextEditingController(text: '0.5')),
);

final List<StateProvider<TextEditingController>> maxtargetcontroller = List.generate(
  8,
  (index) => StateProvider<TextEditingController>((ref) => TextEditingController(text: '0.0')),
);

final List<StateProvider<double>> targetControllers = List.generate(8, (index) => StateProvider((ref) {return 0.0;}));

final List<StateProvider<TextEditingController>> testcontrollers = List.generate(
  8,
  (index) => StateProvider<TextEditingController>((ref) => TextEditingController(text: '0.0')),
);


