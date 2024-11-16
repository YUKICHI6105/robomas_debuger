import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robomas_debuger/usbcan_extends.dart';
import 'package:usbcan_plugins/frames.dart';
import 'package:robomas_debuger/frame.dart';

enum Mode {
  dis,
  vel,
  pos,
  berutyoku,
  stablepos,
}

RobomasUsb robomasUsb = RobomasUsb();

final List<StateProvider<RobomasterParameterFrame>> robomasterParameterFrameProviders =
    List.generate(
  8,
  (index) => StateProvider((ref) {
    return RobomasterParameterFrame(
      RobomasterMotorType.c610,
      RobomasterMotorMode.dis,
      index,
      0.0,
      0.0,
      0.0,
    );
  }),
);

// now is not used. It is only called from [DiagDropdownButton]
final diagProvider = StateProvider<String>((ref) => 'off');

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
