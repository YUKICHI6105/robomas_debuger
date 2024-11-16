import 'package:usbcan_plugins/frames.dart';
import 'dart:typed_data';

class RobomasterParameterFrame implements Frame {
  RobomasterParameterFrame(
    this.motorType,
    this.motorMode,
    this.motorNumber,
    this.velkp,
    this.velki,
    this.poskp,
  );

  static const int commandID = 3;
  static const int temparture = 50;
  double velkp;
  double velki;
  double poskp;
  RobomasterMotorMode motorMode;
  final int motorNumber;
  RobomasterMotorType motorType;
  double target = 0;
  double berutokuVelTarget = 0;
  double berutokuPosTarget = 0;
  double stablePosLimitVel = 0;
  
  Frame generateTargetFrame() {
    RobomasterTargetFrame targetFrame = RobomasterTargetFrame(motorNumber, target);
    return targetFrame;
  } 

  @override
  Uint8List toUint8List() {
    int mode = switch (motorMode) {
      RobomasterMotorMode.dis => 0,
      RobomasterMotorMode.vel => 1,
      RobomasterMotorMode.pos => 2,
      // RobomasterMotorMode.berutyoku => 3,
      // RobomasterMotorMode.stablepos => 4,
    };

    var data = Uint8List(19);
    data[0] = (commandID << 4) + 0x7 & motorNumber;
    data[1] = (motorType == RobomasterMotorType.c610 ? 1 : 0) << 7 + mode;
    data[2] = temparture;
    switch(motorMode){
      // case RobomasterMotorMode.berutyoku:
      //   data.setRange(3, 3 + 4 * 5,
      //       Float32List.fromList([velkp, velki, poskp, berutokuVelTarget, berutokuPosTarget]).buffer.asUint8List());
      //   break;
      // case RobomasterMotorMode.stablepos:
      //   data.setRange(3, 3 + 4 * 4,
      //       Float32List.fromList([velkp, velki, poskp, stablePosLimitVel]).buffer.asUint8List());
      //   break;
      default:
        data.setRange(3, 3 + 4 * 3,
            Float32List.fromList([velkp, velki, poskp]).buffer.asUint8List());
    }
    return data;
  }
}