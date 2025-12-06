import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robomas_debuger/provider.dart';
import 'package:robomas_debuger/frame.dart';
import 'package:usbcan_plugins/frames.dart';

class BasicTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? errorText;
  const BasicTextField(
      {super.key,
      required this.controller,
      this.errorText,
      required this.labelText});

  @override
  Widget build(BuildContext context) {
    final con = Container(
      width: 73,
      height: 40,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: TextField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          errorText: errorText,
        ),
      ),
    );
    return con;
  }
}

class MoterKindButton extends ConsumerWidget {
  const MoterKindButton({Key? key, required this.motorIndex}) : super(key: key);
  final int motorIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frame = ref.watch(robomasterParameterFrameProviders[motorIndex]);

    return DropdownButton(
      onTap: () => debugPrint(context.toString()),
      value: frame.motorType,
      items: const [
        DropdownMenuItem(value: RobomasterMotorType.c610, child: Text('C610')),
        DropdownMenuItem(value: RobomasterMotorType.c620, child: Text('C620')),
      ],
      onChanged: (value) {
        if (value == null) return;

        final newFrame = frame.copyWith(motorType: value);
     
        if (value == RobomasterMotorType.c620 &&
            (frame.target > 942 || frame.target < -942)) {
          newFrame.target = 0.0;
        } else {
          newFrame.target = frame.target;
        }

        // state に新しいインスタンスを代入
        ref.read(robomasterParameterFrameProviders[motorIndex].notifier).state =
            newFrame;
      },
    );
  }
}

class ModeButton extends ConsumerWidget {
  const ModeButton({Key? key, required this.motorIndex}) : super(key: key);
  final int motorIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frame = ref.watch(robomasterParameterFrameProviders[motorIndex]);

    return DropdownButton(
      onTap: () => debugPrint(context.toString()),
      value: frame.motorMode,
      items: const [
        DropdownMenuItem(value: RobomasterMotorMode.dis, child: Text('dis')),
        DropdownMenuItem(value: RobomasterMotorMode.vel, child: Text('vel')),
        DropdownMenuItem(value: RobomasterMotorMode.pos, child: Text('pos'))
      ],
      onChanged: (value) {
        if (value == null){
          ref.read(robomasterParameterFrameProviders[motorIndex].notifier).state = frame.copyWith(motorMode: RobomasterMotorMode.dis);
          return;
        }
        final newframe = frame.copyWith(motorMode: value);
        switch (newframe.motorMode)  {
          case RobomasterMotorMode.dis:
            ref.read(isOnProviders[motorIndex].notifier).state = false;
            ref.read(robomasterParameterFrameProviders[motorIndex].notifier).state = newframe;
            break;
          case RobomasterMotorMode.vel:
            ref.read(isOnProviders[motorIndex].notifier).state = false;
            if (frame.motorType == RobomasterMotorType.c620) {
              if (frame.target > 942 || frame.target < -942) {
                ref.read(robomasterParameterFrameProviders[motorIndex].notifier).state = newframe.copyWith(target: 0.0);
              } else {
                ref.read(robomasterParameterFrameProviders[motorIndex].notifier).state = newframe;
              }
            } else {
              if (frame.target > 1885 || frame.target < -1885) {
                ref.read(robomasterParameterFrameProviders[motorIndex].notifier).state = newframe.copyWith(target: 0.0);
              } else {
                ref.read(robomasterParameterFrameProviders[motorIndex].notifier).state = newframe;
              }
            }
            break;
          case RobomasterMotorMode.pos:
            ref.read(isOnProviders[motorIndex].notifier).state = false;
            if (frame.target >
                    double.parse(
                        ref.watch(maxtargetcontroller[motorIndex]).text) ||
                frame.target <
                    -1 *
                        double.parse(
                            ref.watch(maxtargetcontroller[motorIndex]).text)) {
              ref.read(robomasterParameterFrameProviders[motorIndex].notifier).state = newframe.copyWith(target: 0.0);
            } else {
              ref.read(robomasterParameterFrameProviders[motorIndex].notifier).state = newframe;
            }
            break;
        }
      }
    );
  }
}

class PIDTextField extends ConsumerWidget {
  const PIDTextField({super.key, required this.motorIndex});
  final int motorIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final velkptextfield = BasicTextField(
        controller: ref.read(velkptextfieldcontroller[motorIndex]),
        labelText: 'velKp',
        errorText: null);

    final velkitextfield = BasicTextField(
        controller: ref.read(velkitextfieldcontroller[motorIndex]),
        labelText: 'velKi',
        errorText: null);

    final poskptextfield = BasicTextField(
        controller: ref.read(poskptextfieldcontroller[motorIndex]),
        labelText: 'posKp',
        errorText: null);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.values[5],
      children: [
        Text('  ${motorIndex + 1}:'),
        MoterKindButton(
          motorIndex: motorIndex,
        ),
        ModeButton(
          motorIndex: motorIndex,
        ),
        velkptextfield,
        velkitextfield,
        poskptextfield,
      ],
    );
  }
}

class FrameSendButton extends ConsumerWidget {
  const FrameSendButton({Key? key}) : super(key: key);

  Future<void> _sendFrame(
      BuildContext context,
      WidgetRef ref) async {
    List<bool> data = await Future.wait(List.generate(
        8, (index) => robomasUsb.sendFrame(ref.watch(robomasterParameterFrameProviders[index].notifier).state)));
    bool allTrue = data.every((element) => element);
    if (!context.mounted) return;
    if (!allTrue) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Frame Send Error"),
      ));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Frame Send"),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        onPressed: () async {
          await _sendFrame(context, ref);
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: const Text('SendFrame'));
  }
}

class TargetResetButton extends ConsumerWidget {
  const TargetResetButton({Key? key}) : super(key: key);

  Future<void> _sendResetFrame(
    BuildContext context, WidgetRef ref) async {
  // すべてのモーターターゲットをリセット
  List<Future<bool>> resetFutures = List.generate(8, (index) async {
    ref.read(maxtargetcontroller[index]).text = '0.0';
    ref.read(robomasterParameterFrameProviders[index].notifier).state.target = 0.0;
    return await robomasUsb.sendFrame(
        ref.watch(robomasterParameterFrameProviders[index].notifier).state.generateTargetFrame());
  });

  // フレーム送信結果を待つ
  List<bool> resetResults = await Future.wait(resetFutures);
  bool allResetsSuccessful = resetResults.every((result) => result);

  // コンテキストがまだ有効か確認
  if (!context.mounted) return;

  // 成功・失敗のメッセージを表示
  if (!allResetsSuccessful) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Frame Reset Error"),
    ));
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text("Frame Reset Successful"),
  ));
}



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        onPressed: () async {
          await _sendResetFrame(context, ref);
          },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        child: const Text('ResetTarget'));
  }
}

class TargetSendButton extends ConsumerWidget {
  const TargetSendButton({Key? key, required this.motorIndex})
      : super(key: key);
  final int motorIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frame = ref.watch(robomasterParameterFrameProviders[motorIndex]);

    return Switch(
        value: ref.watch(isOnProviders[motorIndex]),
        onChanged: (value) {
          ref.read(isOnProviders[motorIndex].notifier).state = value;
          if (!value) {
            ref.read(robomasterParameterFrameProviders[motorIndex].notifier).state =
                frame.copyWith(target: 0.0);
            return; //isOff. It should not send target.
          }

          switch (ref.read(robomasterParameterFrameProviders[motorIndex].notifier).state.motorMode) {
            case RobomasterMotorMode.dis:
              break;
            case RobomasterMotorMode.vel:
            case RobomasterMotorMode.pos:
              robomasUsb.sendFrame(ref.watch(robomasterParameterFrameProviders[motorIndex].notifier).state.generateTargetFrame());
              break;
          }
        });
  }
}

class TargetTextField extends ConsumerWidget {
  const TargetTextField({super.key, required this.motorIndex});
  final int motorIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BasicTextField(
        controller: ref.watch(maxtargetcontroller[motorIndex]),
        labelText: 'max_target');
  }
}

class TargetSlider extends ConsumerWidget {
  const TargetSlider({Key? key, required this.motorIndex}) : super(key: key);
  final int motorIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frame = ref.watch(robomasterParameterFrameProviders[motorIndex]);
    switch (frame.motorMode) {
      case RobomasterMotorMode.dis:
        return const Text('dis mode');
      case RobomasterMotorMode.vel:
        if (frame.motorType == RobomasterMotorType.c620) {
          return Slider(
            value: frame.target,
            onChanged: (value) {
              RobomasterParameterFrame newframe;
              if (frame.target > 942 || frame.target < -942) {
                newframe = frame.copyWith(target: 0.0);
              }else if(ref.read(isOnProviders[motorIndex])==false){
                newframe = frame.copyWith(target: 0.0);
              } else {
                newframe = frame.copyWith(target: value);
              }
              ref.read(robomasterParameterFrameProviders[motorIndex].notifier).state = newframe;
              if (ref.read(isOnProviders[motorIndex])) {
                robomasUsb.sendFrame(newframe);
              }
            },
            min: -942,
            max: 942,
            divisions: 0x8000,
            label: frame.target.toString(),
          );
        } else {
          return Slider(
            value: frame.target,
            onChanged: (value) {
              RobomasterParameterFrame newframe;
              if (frame.target > 1885 || frame.target < -1885) {
                newframe = frame.copyWith(target: 0.0);
              }else if(ref.read(isOnProviders[motorIndex])==false){
                newframe = frame.copyWith(target: 0.0);
              } else {
                newframe = frame.copyWith(target: value);
              }
              ref.read(robomasterParameterFrameProviders[motorIndex].notifier).state = newframe;
              if (ref.read(isOnProviders[motorIndex])) {
                robomasUsb.sendFrame(newframe);
              }
            },
            min: -1885,
            max: 1885,
            divisions: 0x8000,
            label: frame.target.toString(),
          );
        }
      case RobomasterMotorMode.pos:
        if (double.parse(ref.watch(maxtargetcontroller[motorIndex]).text) ==
            0.0 || double.parse(ref.watch(maxtargetcontroller[motorIndex]).text) < 0) {
          ref.read(maxtargetcontroller[motorIndex]).text = '0.1';
        }
        return Slider(
          value: frame.target,
          onChanged: (value) {
            if (value >
                    double.parse(
                        ref.watch(maxtargetcontroller[motorIndex]).text) ||
                value <
                    -1 *
                        double.parse(
                            ref.watch(maxtargetcontroller[motorIndex]).text) ||
                            ref.read(isOnProviders[motorIndex]) == false) {
              ref.read(robomasterParameterFrameProviders[motorIndex].notifier).state = frame.copyWith(target: 0.0);
            } else {
              ref.read(robomasterParameterFrameProviders[motorIndex].notifier).state = frame.copyWith(target: value);
              robomasUsb.sendFrame(frame.copyWith(target: value));
            }
          },
          min: -1 * double.parse(ref.watch(maxtargetcontroller[motorIndex]).text),
          max: double.parse(ref.watch(maxtargetcontroller[motorIndex]).text),
          divisions: 0x8000,
          label: frame.target.toString(),
        );
    }
  }
}

class TargetWidget extends ConsumerWidget {
  const TargetWidget({Key? key, required this.motorIndex}) : super(key: key);
  final int motorIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (ref.watch(robomasterParameterFrameProviders[motorIndex]).motorMode) {
      case RobomasterMotorMode.dis:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('  ${motorIndex + 1} :'),
            TargetSlider(motorIndex: motorIndex),
          ],
        );
      case RobomasterMotorMode.vel:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('  ${motorIndex + 1} :'),
            TargetSendButton(
              motorIndex: motorIndex,
            ),
            TargetSlider(motorIndex: motorIndex),
          ],
        );
      case RobomasterMotorMode.pos:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('  ${motorIndex + 1} :'),
            TargetSendButton(
              motorIndex: motorIndex,
            ),
            TargetTextField(motorIndex: motorIndex),
            TargetSlider(motorIndex: motorIndex),
          ],
        );
    }
  }
}

class DiagDropdownButton extends ConsumerWidget {
  const DiagDropdownButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButton(
      onTap: () => debugPrint(context.toString()),
      value: ref.watch(diagProvider),
      items: const [
        DropdownMenuItem(value: 'off', child: Text('off')),
        DropdownMenuItem(value: 'on', child: Text('on')),
      ],
      onChanged: (value) {
        ref.read(diagProvider.notifier).state = value ?? "";
      },
    );
  }
}
