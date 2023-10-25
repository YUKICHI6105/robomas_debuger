import 'package:flutter/services.dart';
//import 'package:usbcan_plugins/usbcan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robomas_debuger/provider.dart';
import 'package:usbcan_plugins/frames.dart';


class BasicTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? errorText;
  const BasicTextField({super.key,required this.controller,required this.errorText,required this.labelText});

  @override
  Widget build(BuildContext context) {
    final con = Container(
      width: 160,
      height: 40,
      margin: const EdgeInsets.fromLTRB(10,10,10,10),
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

class ModeButton extends ConsumerWidget {
  const ModeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return DropdownButton(
      onTap: () => debugPrint(context.toString()),
      value: ref.watch(modeProvider),
      items: const [
        DropdownMenuItem(
          value: RobomasterMotorMode.dis,
          child: Text('dis')
        ),
        DropdownMenuItem(
          value: RobomasterMotorMode.vel,
          child: Text('vel')
        ),
        DropdownMenuItem(
          value: RobomasterMotorMode.pos,
          child: Text('pos')
        )
      ],
      onChanged: (value) {
        ref.read(modeProvider.notifier).state = value!;
      },
    );
  }
}

class DiagButton extends ConsumerWidget {
  const DiagButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return DropdownButton(
      onTap: () => debugPrint(context.toString()),
      value: ref.watch(diag).toString(),
      items: const [
        DropdownMenuItem(
          value: 'off',
          child: Text('off')
        ),
        DropdownMenuItem(
          value: 'on',
          child: Text('on')
        ),
      ],
      onChanged: (value) {
        ref.read(diag.notifier).state = value.toString();
      },
    );
  }
}

double check(String value){
  double doubleValue = 0.0;
  try {
    doubleValue = double.parse(value);
    // doubleValue は有効な double 値です
  } catch (e) {
    doubleValue = 0.0;
    // パースに失敗した場合のエラーハンドリング
  }
    return doubleValue;
}

class FrameSendButton extends ConsumerWidget{
  const FrameSendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final RobomasterSettingFrame robomasterDisSettingFrame = RobomasterSettingFrame(
      ref.watch(motorKind),
      ref.watch(modeProvider),
      ref.watch(motorId),
      50,
      1,
      0,
      0,
      0
    );
    final RobomasterSettingFrame robomasterVelSettingFrame = RobomasterSettingFrame(
      ref.watch(motorKind),
      ref.watch(modeProvider),
      ref.watch(motorId),
      50,
      check(ref.watch(velkptextfieldcontroller).text),
      check(ref.watch(velkitextfieldcontroller).text),
      check(ref.watch(velkdtextfieldcontroller).text),
      check(ref.watch(vellimitIetextfieldcontroller).text)
    );
    final RobomasterSettingFrame robomasterPosSettingFrame = RobomasterSettingFrame(
      ref.watch(motorKind),
      ref.watch(modeProvider),
      ref.watch(motorId),
      50,
      check(ref.watch(poskptextfieldcontroller).text),
      check(ref.watch(poskitextfieldcontroller).text),
      check(ref.watch(poskdtextfieldcontroller).text),
      check(ref.watch(poslimitIetextfieldcontroller).text)
    );
    push(BuildContext context, WidgetRef ref){
    switch(ref.watch(modeProvider)){
      case RobomasterMotorMode.dis:
      () async{
        if(await usbCan.sendFrame(robomasterDisSettingFrame)){
          if(context.mounted){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Frame Send"),
            ));
          }
        }
      };
        break;
      case RobomasterMotorMode.vel:
      () async{
        if(await usbCan.sendFrame(robomasterVelSettingFrame)){
          if(context.mounted){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Frame Send"),
            ));
          }
        }
      };
        break;
      case RobomasterMotorMode.pos:
      () async{
        if(await usbCan.sendFrame(robomasterPosSettingFrame)){
          if(context.mounted){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Frame Send"),
            ));
          }
        }
      };
        break;
    }
  }
    return ElevatedButton(
      onPressed: () => push(context, ref),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      child: const Text('SendFrame')
    );
  }
}

class TargetSendButton extends ConsumerWidget{
  const TargetSendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return ElevatedButton(
      onPressed: () => usbCan.sendFrame(RobomasterTargetFrame(ref.watch(motorId),double.parse(ref.watch(targetcontroller).text))),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      child: const Text('SendTarget')
    );
  }
}

class TargetTextField extends ConsumerWidget {
  const TargetTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BasicTextField(
      controller: ref.watch(targetcontroller),
      errorText: null,
      labelText: 'target'
    );
  }
}

class PIDTextField extends ConsumerWidget {
  const PIDTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final velkptextfield = BasicTextField(
    controller: ref.read(velkptextfieldcontroller),
    labelText: 'velKp',
    errorText: null
  );

  final velkitextfield = BasicTextField(
    controller: ref.read(velkitextfieldcontroller),
    labelText: 'velKi',
    errorText: null
  );

  final velkdtextfield = BasicTextField(
    controller: ref.read(velkdtextfieldcontroller),
    labelText: 'velKd',
    errorText: null
  );

  final vellimitIetextfield = BasicTextField(
    controller: ref.read(vellimitIetextfieldcontroller),
    labelText: 'vellimitIe',
    errorText: null
  );

  final poskptextfield = BasicTextField(
    controller: ref.read(poskptextfieldcontroller),
    labelText: 'posKp',
    errorText: null
  );

  final poskitextfield = BasicTextField(
    controller: ref.read(poskitextfieldcontroller),
    labelText: 'posKi',
    errorText: null
  );

  final poskdtextfield = BasicTextField(
    controller: ref.read(poskdtextfieldcontroller),
    labelText: 'posKd',
    errorText: null
  );

  final poslimitIetextfield = BasicTextField(
    controller: ref.read(poslimitIetextfieldcontroller),
    labelText: 'poslimitIe',
    errorText: null
  );
    return Container(
      width: 400,
      height: 350,
      margin: const EdgeInsets.fromLTRB(20,0,20,0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              velkptextfield,
              velkitextfield,
              velkdtextfield,
              vellimitIetextfield
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              poskptextfield,
              poskitextfield,
              poskdtextfield,
              poslimitIetextfield
            ],
          )
        ]
      )
    );
  }
}

class RobomasPage extends StatefulWidget {
  const RobomasPage({Key? key}) : super(key: key);

  @override
  State<RobomasPage> createState() => _RobomasPageState();
}

// class DebugTextField extends ConsumerWidget{
//   const DebugTextField({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref){
//     return Text(ref.watch(modeProvider).toString());
//   }
// }

class _RobomasPageState extends State<RobomasPage> {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: Colors.blue,
      title: const Text("Robomas_Debuger"),
    );
    return Scaffold(
      appBar: appBar,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PIDTextField(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Mode:'),
                ModeButton(),
                FrameSendButton(),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TargetTextField(),
                TargetSendButton(),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // DebugTextField(),
                DiagButton()
              ],
            ),
          ]
        )
      )
    );
  }
}