//import 'dart:ffi';
//import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'usbcan.dart';
//import 'package:usbcan_plugins/frames.dart';

enum Mode {
  dis,
  vel,
  pos,
  berutyoku,
  stablepos,
}

UsbCan usbCan = UsbCan();

final List<StateProvider<Mode>> modeProviders = List.generate(
    8,
    (index) => StateProvider((ref) {
          return Mode.dis;
        }));

final List<StateProvider<double>> targetProviders = List.generate(
    8,
    (index) => StateProvider((ref) {
          return 0.0;
        }));

// now is not used. It is only called from [DiagDropdownButton]
final diagProvider = StateProvider<String>((ref) => 'off');

final List<StateProvider<int>> motorKindProviders = List.generate(
    8,
    (index) => StateProvider((ref) {
          return 1;
        }));

final List<StateProvider<bool>> isOnProviders = List.generate(
    8,
    (index) => StateProvider((ref) {
          return false;
        }));

final List<StateProvider<TextEditingController>> velkptextfieldcontroller =
    List.generate(
  8,
  (index) => StateProvider<TextEditingController>(
      (ref) => TextEditingController(text: '0.15')),
);

final List<StateProvider<TextEditingController>> velkitextfieldcontroller =
    List.generate(
  8,
  (index) => StateProvider<TextEditingController>(
      (ref) => TextEditingController(text: '9.0')),
);

final List<StateProvider<TextEditingController>> poskptextfieldcontroller =
    List.generate(
  8,
  (index) => StateProvider<TextEditingController>(
      (ref) => TextEditingController(text: '0.5')),
);

final List<StateProvider<TextEditingController>> maxtargetcontroller =
    List.generate(
  8,
  (index) => StateProvider<TextEditingController>(
      (ref) => TextEditingController(text: '0.0')),
);
