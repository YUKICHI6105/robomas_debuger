import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robomas_debuger/provider.dart';
import 'package:robomas_debuger/change_datatype.dart';

Future<bool> sendRobomasDisFrame(
    WidgetRef ref, int motorId, int limitTemp) async {
  Uint8List sendData = Uint8List(19);
  sendData[0] = 3 << 4;
  sendData[0] = sendData[0] + intToUint8List(motorId.toUnsigned(8))[0];
  sendData[1] =
      intToUint8List(ref.watch(motorKindProviders[motorId]).toUnsigned(8))[0] <<
          7;
  sendData[1] =
      sendData[1] + intToUint8List(ref.watch(modeProviders[motorId]).index)[0];
  sendData[2] = intToUint8List(limitTemp)[0];
  sendData[3] = intToUint8List(1)[0];
  debugPrint(sendData.toString());
  return await usbCan.sendUint8List(sendData);
}

Future<bool> sendRobomasVelFrame(
    WidgetRef ref, int motorId, int limitTemp) async {
  Uint8List sendData = Uint8List(19);
  sendData[0] = 3 << 4;
  sendData[0] = sendData[0] + intToUint8List(motorId)[0];
  sendData[1] = intToUint8List(ref.watch(motorKindProviders[motorId]))[0] << 7;
  sendData[1] =
      sendData[1] + intToUint8List(ref.watch(modeProviders[motorId]).index)[0];
  sendData[2] = intToUint8List(limitTemp)[0];
  sendData.setRange(
      3,
      7,
      doubleToFloattoUint8list(
          double.parse(ref.watch(velkptextfieldcontroller[motorId]).text)));
  sendData.setRange(
      7,
      11,
      doubleToFloattoUint8list(
          double.parse(ref.watch(velkitextfieldcontroller[motorId]).text)));
  //sendData.setRange(3, data.length + 3, data);
  debugPrint(sendData.toString());
  return await usbCan.sendUint8List(sendData);
}

Future<bool> sendRobomasPosFrame(
    WidgetRef ref, int motorId, int limitTemp) async {
  Uint8List sendData = Uint8List(19);
  sendData[0] = 3 << 4;
  sendData[0] = sendData[0] + intToUint8List(motorId)[0];
  sendData[1] = intToUint8List(ref.watch(motorKindProviders[motorId]))[0] << 7;
  sendData[1] =
      sendData[1] + intToUint8List(ref.watch(modeProviders[motorId]).index)[0];
  sendData[2] = intToUint8List(limitTemp)[0];
  sendData.setRange(
      3,
      7,
      doubleToFloattoUint8list(
          double.parse(ref.watch(velkptextfieldcontroller[motorId]).text)));
  sendData.setRange(
      7,
      11,
      doubleToFloattoUint8list(
          double.parse(ref.watch(velkitextfieldcontroller[motorId]).text)));
  sendData.setRange(
      11,
      15,
      doubleToFloattoUint8list(
          double.parse(ref.watch(poskptextfieldcontroller[motorId]).text)));
  //sendData.setRange(3, data.length + 3, data);
  return await usbCan.sendUint8List(sendData);
}

Future<bool> sendRobomasTarget(WidgetRef ref, int motorId) async {
  Uint8List sendData = Uint8List(5);
  sendData[0] = 3 << 4;
  sendData[0] =
      sendData[0] + intToUint8List(0x08)[0] + intToUint8List(motorId)[0];
  sendData.setRange(
      1,
      5,
      doubleToFloattoUint8list(
          ref.watch(targetProviders[motorId].notifier).state));
  return await usbCan.sendUint8List(sendData);
}

Future<bool> sendRobomasTargetReset(WidgetRef ref, int motorId) async {
  Uint8List sendData = Uint8List(5);
  sendData[0] = 3 << 4;
  sendData[0] =
      sendData[0] + intToUint8List(0x08)[0] + intToUint8List(motorId)[0];
  ref.read(maxtargetcontroller[motorId]).text = '0.0';
  ref.read(targetProviders[motorId].notifier).state = 0.0;
  sendData.setRange(
      1,
      5,
      doubleToFloattoUint8list(
          ref.watch(targetProviders[motorId].notifier).state));
  return await usbCan.sendUint8List(sendData);
}
