import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usbcan_plugins/usbcan.dart';
import 'package:usbcan_plugins/frames.dart';

enum Mode {
  dis,
  vel,
  pos,
  berutyoku,
  stablepos,
}

UsbCan usbCan = UsbCan();
final modeProvider = StateProvider<RobomasterMotorMode>((ref) => RobomasterMotorMode.dis);
final motorId = StateProvider<int>((ref) => 0);
final diag = StateProvider<String>((ref) => 'off');
final motorKind = StateProvider<RobomasterMotorType>((ref) => RobomasterMotorType.c620);

// final velKp = StateProvider<double>((ref) => 0.0);
// final velKi = StateProvider<double>((ref) => 0.0);
// final velKd = StateProvider<double>((ref) => 0.0);
// final vellimitIe = StateProvider<double>((ref) => 0.0);
// final posKp = StateProvider<double>((ref) => 0.0);
// final posKi = StateProvider<double>((ref) => 0.0);
// final posKd = StateProvider<double>((ref) => 0.0);
// final poslimitIe = StateProvider<double>((ref) => 0.0);
final tyokuVelTarget = StateProvider<double>((ref) => 0);
final tyokuPosTarget = StateProvider<double>((ref) => 0);

final velkptextfieldcontroller = StateProvider<TextEditingController>((ref) => TextEditingController());
final velkitextfieldcontroller = StateProvider<TextEditingController>((ref) => TextEditingController());
final velkdtextfieldcontroller = StateProvider<TextEditingController>((ref) => TextEditingController());
final vellimitIetextfieldcontroller = StateProvider<TextEditingController>((ref) => TextEditingController());
final poskptextfieldcontroller = StateProvider<TextEditingController>((ref) => TextEditingController());
final poskitextfieldcontroller = StateProvider<TextEditingController>((ref) => TextEditingController());
final poskdtextfieldcontroller = StateProvider<TextEditingController>((ref) => TextEditingController());
final poslimitIetextfieldcontroller = StateProvider<TextEditingController>((ref) => TextEditingController());
final targetcontroller = StateProvider<TextEditingController>((ref) => TextEditingController());