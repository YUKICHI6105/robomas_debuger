import 'package:flutter/services.dart';
//import 'package:usbcan_plugins/usbcan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robomas_debuger/provider.dart';
//import 'package:usbcan_plugins/frames.dart';
import 'package:robomas_debuger/change_datatype.dart';

Future<bool> sendRobomasDisFrame(WidgetRef ref, int limitTemp) async {
  Uint8List sendData = Uint8List(19);
  sendData[0] = 3 << 4;
  sendData[0] = sendData[0] + intToUint8List(ref.watch(motorId))[0];
  sendData[1] = intToUint8List(ref.watch(motorKind))[0] << 7;
  sendData[1] = sendData[1] + intToUint8List(ref.watch(modeProvider))[0];
  sendData[2] = intToUint8List(limitTemp)[0];
  sendData[3] = intToUint8List(1)[0];
  return await usbCan.sendUint8List(sendData);
}

Future<bool> sendRobomasVelFrame(WidgetRef ref, int limitTemp) async {
  Uint8List sendData = Uint8List(19);
  sendData[0] = 3 << 4;
  sendData[0] = sendData[0] + intToUint8List(ref.watch(motorId))[0];
  sendData[1] = intToUint8List(ref.watch(motorKind))[0] << 7;
  sendData[1] = sendData[1] + intToUint8List(ref.watch(modeProvider))[0];
  sendData[2] = intToUint8List(limitTemp)[0];
  sendData.setRange(3, 7, doubleToFloattoUint8list(double.parse(ref.watch(velkptextfieldcontroller).text)));
  sendData.setRange(7, 11, doubleToFloattoUint8list(double.parse(ref.watch(velkitextfieldcontroller).text)));
  sendData.setRange(11, 15, doubleToFloattoUint8list(double.parse(ref.watch(velkdtextfieldcontroller).text)));
  sendData.setRange(15, 19, doubleToFloattoUint8list(double.parse(ref.watch(vellimitIetextfieldcontroller).text)));
  //sendData.setRange(3, data.length + 3, data);
  return await usbCan.sendUint8List(sendData);
}

Future<bool> sendRobomasPosFrame(WidgetRef ref, int limitTemp) async {
  Uint8List sendData = Uint8List(19);
  sendData[0] = 3 << 4;
  sendData[0] = sendData[0] + intToUint8List(ref.watch(motorId))[0];
  sendData[1] = intToUint8List(ref.watch(motorKind))[0] << 7;
  sendData[1] = sendData[1] + intToUint8List(ref.watch(modeProvider))[0];
  sendData[2] = intToUint8List(limitTemp)[0];
  sendData.setRange(3, 7, doubleToFloattoUint8list(double.parse(ref.watch(poskptextfieldcontroller).text)));
  sendData.setRange(7, 11, doubleToFloattoUint8list(double.parse(ref.watch(poskitextfieldcontroller).text)));
  sendData.setRange(11, 15, doubleToFloattoUint8list(double.parse(ref.watch(poskdtextfieldcontroller).text)));
  sendData.setRange(15, 19, doubleToFloattoUint8list(double.parse(ref.watch(poslimitIetextfieldcontroller).text)));
  //sendData.setRange(3, data.length + 3, data);
  return await usbCan.sendUint8List(sendData);
}

Future<bool> sendRobomasTarget(WidgetRef ref) async {
  Uint8List sendData = Uint8List(5);
  sendData[0] = 3 << 4;
  sendData[0] = sendData[0] + intToUint8List(0x08)[0] + intToUint8List(ref.watch(motorId))[0];
  sendData.setRange(1, 5, doubleToFloattoUint8list(double.parse(ref.watch(targetcontroller).text)));
  // Uint8List data = doubleToFloattoUint8list(target);
  // for(int i = 0; i < 4; i++){
  //   sendData[i+1] = data[i];
  // }
  // sendData[1] = doubleToFloattoUint8list(target)[0];
  // sendData[2] = doubleToFloattoUint8list(target)[1];
  // sendData[3] = doubleToFloattoUint8list(target)[2];
  // sendData[4] = doubleToFloattoUint8list(target)[3];
  return await usbCan.sendUint8List(sendData);
}

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
          value: 0,
          child: Text('dis')
        ),
        DropdownMenuItem(
          value: 1,
          child: Text('vel')
        ),
        DropdownMenuItem(
          value: 2,
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
    // final RobomasterSettingFrame robomasterDisSettingFrame = RobomasterSettingFrame(
    //   ref.watch(motorKind),
    //   ref.watch(modeProvider),
    //   ref.watch(motorId),
    //   50,
    //   1,
    //   0,
    //   0,
    //   0
    // );
    // final RobomasterSettingFrame robomasterVelSettingFrame = RobomasterSettingFrame(
    //   ref.watch(motorKind),
    //   ref.watch(modeProvider),
    //   ref.watch(motorId),
    //   50,
    //   check(ref.watch(velkptextfieldcontroller).text),
    //   check(ref.watch(velkitextfieldcontroller).text),
    //   check(ref.watch(velkdtextfieldcontroller).text),
    //   check(ref.watch(vellimitIetextfieldcontroller).text)
    // );
    // final RobomasterSettingFrame robomasterPosSettingFrame = RobomasterSettingFrame(
    //   ref.watch(motorKind),
    //   ref.watch(modeProvider),
    //   ref.watch(motorId),
    //   50,
    //   check(ref.watch(poskptextfieldcontroller).text),
    //   check(ref.watch(poskitextfieldcontroller).text),
    //   check(ref.watch(poskdtextfieldcontroller).text),
    //   check(ref.watch(poslimitIetextfieldcontroller).text)
    // );
    // push(BuildContext context, WidgetRef ref){
    //   () async{
    //     if(await sendRobomasFrame(0, 0, 0, 0, a)){
    //       // if(context.mounted){
    //       //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       //     content: Text("Frame Send"),
    //       //   ));
    //       // }
    //     }
    //   };
    // switch(ref.watch(modeProvider)){
    //   case 0:
    //   () async{
    //     if(await sendRobomasFrame(0, 0, 0, 0, a)){
    //       // if(context.mounted){
    //       //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       //     content: Text("Frame Send"),
    //       //   ));
    //       // }
    //     }
    //   };
    //     break;
    //   case 1:
    //   // () async{
    //   //   if(await sendRobomasFrame(ref.watch(motorId), ref.watch(motorKind), ref.watch(modeProvider), 50, data)){
    //       if(context.mounted){
    //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //           content: Text("Frame Send"),
    //         ));
    //   //     }
    //   //   }
    //   };
    //     break;
    //   case 2:
    //   () async{
    //     if(await sendRobomasFrame(ref.watch(motorId), ref.watch(motorKind), ref.watch(modeProvider), 50, data)){
    //       if(context.mounted){
    //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //           content: Text("Frame Send"),
    //         ));
    //       }
    //     }
    //   };
    //     break;
    // }
  // }
    return ElevatedButton(
      onPressed: () async{
        switch(ref.watch(modeProvider)){
          case 0:
            if(await sendRobomasDisFrame(ref, 50)){
              if(context.mounted){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Frame Send"),
                ));
              }
            }
            break;
          case 1:
            if(await sendRobomasVelFrame(ref, 50)){
              if(context.mounted){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Frame Send"),
                ));
              }
            }
            break;
          case 2:
            if(await sendRobomasPosFrame(ref, 50)){
              if(context.mounted){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Frame Send"),
                ));
              }
            }
            break;
        }
      },
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
      onPressed:  () async { if(await sendRobomasTarget(ref)){
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Target Send"),
          ));
        }
      }},
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