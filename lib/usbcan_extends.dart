import 'package:usbcan_plugins/usbcan.dart';
import 'package:usb_serial/usb_serial.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robomas_debuger/provider.dart';

class RobomasUsb extends UsbCan {

  Future<bool> connectUSBwithpid(int productid) async {
    UsbDevice? newDevice;
    //Search a usbcan.
    List<UsbDevice> devices = await UsbSerial.listDevices();
    for (var element in devices) {
      if (Platform.isAndroid) {
        if (element.vid == 0x0483 && element.pid == productid) {
          newDevice = element;
          break;
        }
      } else if (Platform.isWindows) {
        if (element.vid == 0x0483) {
          newDevice = element;
          break;
        }
      }
    }
    if (newDevice == null) return false;

    if (device != null && device!.port != null) {
      await device!.port!.close();
    }
    print("Connecting to ...");
    device = newDevice;

    if (device == null) {
      return false;
    }
    try {
      await device!.create();
    } catch (e) {
      return false;
    }
    if (device!.port == null) return false;
    device!.port!.setPortParameters(
        115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    print("Connecting to ...");
    //open a port.
    if (!(await device!.port!.open())) return false;

    print("Connecting to ...");
    return true;
  }

  Future<bool> sendRobomasTargetReset(WidgetRef ref, int motorId) async {
    ref.read(maxtargetcontroller[motorId]).text = '0.0';
    ref.read(robomasterParameterFrameProviders[motorId].notifier).state.target = 0.0;
    return await sendFrame(ref.watch(robomasterParameterFrameProviders[motorId].notifier).state.generateTargetFrame());
  }

}