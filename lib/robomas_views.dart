import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robomas_debuger/provider.dart';
import 'package:robomas_debuger/robomas_calculation.dart';

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
    return DropdownButton(
      onTap: () => debugPrint(context.toString()),
      value: ref.watch(motorKindProviders[motorIndex]),
      items: const [
        DropdownMenuItem(value: 0, child: Text('C610')),
        DropdownMenuItem(value: 1, child: Text('C620')),
      ],
      onChanged: (value) {
        ref.read(motorKindProviders[motorIndex].notifier).state = value!;
        if (ref.read(motorKindProviders[motorIndex].notifier).state == 1) {
          if (ref.read(targetProviders[motorIndex].notifier).state > 942 ||
              ref.read(targetProviders[motorIndex].notifier).state < -942) {
            ref.read(targetProviders[motorIndex].notifier).state = 0.0;
          }
        }
      },
    );
  }
}

class ModeButton extends ConsumerWidget {
  const ModeButton({Key? key, required this.motorIndex}) : super(key: key);
  final int motorIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButton(
      onTap: () => debugPrint(context.toString()),
      value: ref.watch(modeProviders[motorIndex]),
      items: const [
        DropdownMenuItem(value: Mode.dis, child: Text('dis')),
        DropdownMenuItem(value: Mode.vel, child: Text('vel')),
        DropdownMenuItem(value: Mode.pos, child: Text('pos'))
      ],
      onChanged: (value) {
        ref.read(modeProviders[motorIndex].notifier).state = value ?? Mode.dis;
        switch (ref.read(modeProviders[motorIndex])) {
          case Mode.dis:
            ref.read(isOnProviders[motorIndex].notifier).state = false;
            break;
          case Mode.vel:
            ref.read(isOnProviders[motorIndex].notifier).state = false;
            if (ref.read(motorKindProviders[motorIndex].notifier).state == 1) {
              if (ref.read(targetProviders[motorIndex].notifier).state > 942 ||
                  ref.read(targetProviders[motorIndex].notifier).state < -942) {
                ref.read(targetProviders[motorIndex].notifier).state = 0.0;
              }
            } else {
              if (ref.read(targetProviders[motorIndex].notifier).state > 1885 ||
                  ref.read(targetProviders[motorIndex].notifier).state < -1885) {
                ref.read(targetProviders[motorIndex].notifier).state = 0.0;
              }
            }
            break;
          case Mode.pos:
            ref.read(isOnProviders[motorIndex].notifier).state = false;
            if (ref.read(targetProviders[motorIndex].notifier).state >
                    double.parse(
                        ref.watch(maxtargetcontroller[motorIndex]).text) ||
                ref.read(targetProviders[motorIndex].notifier).state <
                    -1 *
                        double.parse(
                            ref.watch(maxtargetcontroller[motorIndex]).text)) {
              ref.read(targetProviders[motorIndex].notifier).state = 0.0;
            }
            break;
          default:
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
  const FrameSendButton({Key? key, required this.motorIndex}) : super(key: key);
  final int motorIndex;

  final limitTemp = 50;

  Future<void> _sendFrame(
      BuildContext context,
      WidgetRef ref,
      Future<bool> Function(WidgetRef ref, int motorId, int limitTemp)
          sendRobomasFrame) async {
    List<bool> data = await Future.wait(List.generate(
        8, (index) => sendRobomasDisFrame(ref, index, limitTemp)));
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
          switch (ref.watch(modeProviders[motorIndex])) {
            case Mode.dis:
              await _sendFrame(context, ref, sendRobomasDisFrame);
              break;
            case Mode.vel:
              await _sendFrame(context, ref, sendRobomasVelFrame);
              break;
            case Mode.pos:
              await _sendFrame(context, ref, sendRobomasPosFrame);
              break;
            default:
              // TODO: Handle this case.
              break;
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: const Text('SendFrame'));
  }
}

class TargetResetButton extends ConsumerWidget {
  const TargetResetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        onPressed: () async {
          List<bool> data = await Future.wait(
              List.generate(8, (index) => sendRobomasTargetReset(ref, index)));
          bool allTrue = data.every((element) => element);
          if (!context.mounted) return;
          if (allTrue) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Target Reset Error"),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Target Reset"),
            ));
          }
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
    return Switch(
        value: ref.watch(isOnProviders[motorIndex]),
        onChanged: (value) {
          ref.read(isOnProviders[motorIndex].notifier).state = value;
          if (!value) return; //isOff. It should not send target.

          switch (ref.read(modeProviders[motorIndex])) {
            case Mode.dis:
              break;
            case Mode.vel:
              sendRobomasTarget(ref, motorIndex);
              break;
            case Mode.pos:
              sendRobomasTarget(ref, motorIndex);
              break;
            default:
              //TODO: handle this case
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
    switch (ref.watch(modeProviders[motorIndex])) {
      case Mode.dis:
        return const Text('dis mode');
      case Mode.vel:
        if (ref.read(motorKindProviders[motorIndex].notifier).state == 1) {
          if (ref.read(targetProviders[motorIndex].notifier).state > 942 ||
              ref.read(targetProviders[motorIndex].notifier).state < -942) {
            ref.read(targetProviders[motorIndex].notifier).state = 0.0;
          }
          return Slider(
            value: ref.watch(targetProviders[motorIndex]),
            onChanged: (value) {
              ref.read(targetProviders[motorIndex].notifier).state = value;
              if (ref.read(isOnProviders[motorIndex])) {
                sendRobomasTarget(ref, motorIndex);
              }
            },
            min: -942,
            max: 942,
            divisions: 0x8000,
            label: ref.watch(targetProviders[motorIndex]).toString(),
          );
        } else {
          return Slider(
            value: ref.watch(targetProviders[motorIndex]),
            onChanged: (value) {
              ref.read(targetProviders[motorIndex].notifier).state = value;
              if (ref.read(isOnProviders[motorIndex])) {
                sendRobomasTarget(ref, motorIndex);
              }
            },
            min: -1885,
            max: 1885,
            divisions: 0x8000,
            label: ref.watch(targetProviders[motorIndex]).toString(),
          );
        }
      case Mode.pos:
        // if(double.parse(ref.watch(targetcontroller).text)!=0.0){
        if (ref.read(targetProviders[motorIndex].notifier).state >
                double.parse(ref.watch(maxtargetcontroller[motorIndex]).text) ||
            ref.read(targetProviders[motorIndex].notifier).state <
                -1 *
                    double.parse(
                        ref.watch(maxtargetcontroller[motorIndex]).text)) {
          ref.read(targetProviders[motorIndex].notifier).state = 0.0;
        }
        if (double.parse(ref.watch(maxtargetcontroller[motorIndex]).text) ==
            0.0) {
          ref.read(maxtargetcontroller[motorIndex]).text = '0.1';
        }
        return Slider(
          value: ref.watch(targetProviders[motorIndex]),
          onChanged: (value) {
            if (value >
                    double.parse(
                        ref.watch(maxtargetcontroller[motorIndex]).text) ||
                value <
                    -1 *
                        double.parse(
                            ref.watch(maxtargetcontroller[motorIndex]).text)) {
              ref.read(targetProviders[motorIndex].notifier).state = 0.0;
            } else {
              ref.read(targetProviders[motorIndex].notifier).state = value;
              sendRobomasTarget(ref, motorIndex);
            }
          },
          min: -1 *
              double.parse(ref.watch(maxtargetcontroller[motorIndex]).text),
          max: double.parse(ref.watch(maxtargetcontroller[motorIndex]).text),
          divisions: 0x8000,
          label: ref.watch(targetProviders[motorIndex]).toString(),
        );
      default:
        return const Text('error');
    }
  }
}

class TargetWidget extends ConsumerWidget {
  const TargetWidget({Key? key, required this.motorIndex}) : super(key: key);
  final int motorIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (ref.watch(modeProviders[motorIndex])) {
      case Mode.dis:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('  ${motorIndex + 1} :'),
            TargetSlider(motorIndex: motorIndex),
          ],
        );
      case Mode.vel:
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
      case Mode.pos:
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
      default:
        return const Text('error');
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
