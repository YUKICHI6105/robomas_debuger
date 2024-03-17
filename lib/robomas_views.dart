import 'package:flutter/services.dart';
//import 'package:usbcan_plugins/usbcan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robomas_debuger/provider.dart';
//import 'package:usbcan_plugins/frames.dart';
// import 'package:robomas_debuger/change_datatype.dart';
import 'package:robomas_debuger/robomas_calculation.dart';

class BasicTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? errorText;
  const BasicTextField({super.key,required this.controller,required this.errorText,required this.labelText});

  @override
  Widget build(BuildContext context) {
    final con = Container(
      width: 73,
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
    // return con;
    return con;
  }
}

class MoterKindButton extends ConsumerWidget {
  const MoterKindButton({Key? key, required this.number}) : super(key: key);
  final int number;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButton(
      onTap: () => debugPrint(context.toString()),
      value: ref.watch(motorKindProviders[number]),
      items: const [
        DropdownMenuItem(
          value: 0,
          child: Text('C610')
        ),
        DropdownMenuItem(
          value: 1,
          child: Text('C620')
        ),
      ],
      onChanged: (value) {
        ref.read(motorKindProviders[number].notifier).state = value!;
        if(ref.read(motorKindProviders[number].notifier).state == 1){
          if(ref.read(targetControllers[number].notifier).state > 942 || ref.read(targetControllers[number].notifier).state < -942){
            ref.read(targetControllers[number].notifier).state = 0.0;
          }
        }
      },
    );
  }
}

class ModeButton extends ConsumerWidget {
  const ModeButton({Key? key, required this.number}) : super(key: key);
  final int number;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return DropdownButton(
      onTap: () => debugPrint(context.toString()),
      value: ref.watch(modeProviders[number]),
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
        ref.read(modeProviders[number].notifier).state = value!;
        if(ref.read(modeProviders[number].notifier).state == 1){
          if(ref.read(targetControllers[number].notifier).state > 942 || ref.read(targetControllers[number].notifier).state < -942){
            ref.read(targetControllers[number].notifier).state = 0.0;
          }
        }
      },
    );
  }
}

class PIDTextField extends ConsumerWidget {
  const PIDTextField({super.key, required this.number});
  final int number;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final velkptextfield = BasicTextField(
    controller: ref.read(velkptextfieldcontroller[number-1]),
    labelText: 'velKp',
    errorText: null
  );

  final velkitextfield = BasicTextField(
    controller: ref.read(velkitextfieldcontroller[number-1]),
    labelText: 'velKi',
    errorText: null
  );

  final poskptextfield = BasicTextField(
    controller: ref.read(poskptextfieldcontroller[number-1]),
    labelText: 'posKp',
    errorText: null
  );

  return  Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.values[5],
      children: [
        Text('  $number:'),
        MoterKindButton(number: number-1,),
        ModeButton(number: number-1,),
        velkptextfield,
        velkitextfield,
        poskptextfield,
      ],
      
  );

    // return Container(
    //   width: 400,
    //   height: 350,
    //   margin: const EdgeInsets.fromLTRB(20,0,20,0),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           velkptextfield,
    //           velkitextfield,
    //           poskptextfield,
    //         ],
    //       ),
    //     ]
    //   )
    // );
  }
}

class FrameSendButton extends ConsumerWidget{
  const FrameSendButton({Key? key, required this.number}) : super(key: key);
  final int number;

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
        switch(ref.watch(modeProviders[number])){
          case 0:
          List<int> data = [0,0,0,0,0,0,0,0];
            for(int i=0; i<8; i++){
              if(await sendRobomasDisFrame(ref, i, 50)){
                data[i] = 1;
              }
            }
            if(data.contains(0)){
              if(context.mounted){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Frame Send Error"),
                ));
              }
            }else{
              if(context.mounted){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Frame Send"),
                ));
              }
            }
            break;
          case 1:
            List<int> data = [0,0,0,0,0,0,0,0];
            for(int i=0; i<8; i++){
              if(await sendRobomasVelFrame(ref, i,50)){
                data[i] = 1;
              }
            }
            if(data.contains(0)){
              if(context.mounted){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Frame Send Error"),
                ));
              }
            }else{
              if(context.mounted){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Frame Send"),
                ));
              }
            }
            break;
          case 2:
            List<int> data = [0,0,0,0,0,0,0,0];
            for(int i=0; i<8; i++){
              if(await sendRobomasPosFrame(ref, i,50)){
                data[i] = 1;
              }
            }
            if(data.contains(0)){
              if(context.mounted){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Frame Send Error"),
                ));
              }
            }else{
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

class TargetResetButton extends ConsumerWidget{
  const TargetResetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return ElevatedButton(
      onPressed: () async { 
        List<int> data = [0,0,0,0,0,0,0,0];
        for(int i=0; i<8; i++){
          if(await sendRobomasTargetReset(ref,i)){
            data[i] = 1;
          }
        }
        if(data.contains(0)){
          if(context.mounted){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Target Reset Error"),
            ));
          }
        }else{
          if(context.mounted){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Target Reset"),
            ));
          }
        }
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child: const Text('ResetTarget')
    );
  }
}

class TargetSendButton extends ConsumerWidget{
  const TargetSendButton({Key? key, required this.number}) : super(key: key);
  final int number;

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return Switch(
      value: ref.watch(isOnProviders[number]), 
      onChanged: (value) {
        ref.read(isOnProviders[number].notifier).state = value;
        switch(ref.read(modeProviders[number])){
          case 0:
            break;
          case 1:
            if(ref.read(isOnProviders[number])){
              sendRobomasTarget(ref, number);
            }
            break;
          case 2:
            if(ref.read(isOnProviders[number])){
              sendRobomasTarget(ref, number);
            }
            break;
        }
      }
    );


    // return ElevatedButton(
    //   onPressed:  () async { if(await sendRobomasTarget(ref)){
    //     if(context.mounted){
    //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //         content: Text("Target Send"),
    //       ));
    //     }
    //   }},
    //   style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
    //   child: const Text('SendTarget')
    // );
  }
}

class TargetTextField extends ConsumerWidget {
  const TargetTextField({super.key, required this.number});
  final int number;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BasicTextField(
      controller: ref.watch(maxtargetcontroller[number]),
      errorText: null,
      labelText: 'max_target'
    );
  }
}

class TargetSlider extends ConsumerWidget {
  const TargetSlider({Key? key, required this.number}) : super(key: key);
  final int number;

  @override
  Widget build(BuildContext context, WidgetRef ref){
    switch(ref.watch(modeProviders[number])){
      case 0:
        return const Text('dis mode');
      case 1:
      if(ref.read(targetControllers[number].notifier).state > 1885 || ref.read(targetControllers[number].notifier).state < -1885){
        ref.read(targetControllers[number].notifier).state = 0.0;
      }
      if(ref.read(motorKindProviders[number].notifier).state == 1){
        if(ref.read(targetControllers[number].notifier).state > 942 || ref.read(targetControllers[number].notifier).state < -942){
          ref.read(targetControllers[number].notifier).state = 0.0;
        }
        return Slider(
          value: ref.watch(targetControllers[number]),
          onChanged: (value) {
            ref.read(targetControllers[number].notifier).state = value;
            if(ref.read(isOnProviders[number])){
              sendRobomasTarget(ref, number);
            }
          },
          min: -942,
          max: 942,
          divisions: 0x8000,
          label: ref.watch(targetControllers[number]).toString(),
        );
      }else{
        return Slider(
          value: ref.watch(targetControllers[number]),
          onChanged: (value) {
            ref.read(targetControllers[number].notifier).state = value;
            if(ref.read(isOnProviders[number])){
              sendRobomasTarget(ref, number);
            }
          },
          min: -1885,
          max: 1885,
          divisions: 0x8000,
          label: ref.watch(targetControllers[number]).toString(),
        );
      }
      case 2:
      // if(double.parse(ref.watch(targetcontroller).text)!=0.0){
        if(ref.read(targetControllers[number].notifier).state > double.parse(ref.watch(maxtargetcontroller[number]).text) || ref.read(targetControllers[number].notifier).state < -1*double.parse(ref.watch(maxtargetcontroller[number]).text)){
          ref.read(targetControllers[number].notifier).state = 0.0;
        }
        if(double.parse(ref.watch(maxtargetcontroller[number]).text) == 0.0){
          ref.read(maxtargetcontroller[number]).text = '0.1';
        }
        return Slider(
          value: ref.watch(targetControllers[number]),
          onChanged: (value) {
            if(value > double.parse(ref.watch(maxtargetcontroller[number]).text) || value < -1*double.parse(ref.watch(maxtargetcontroller[number]).text)){
              ref.read(targetControllers[number].notifier).state = 0.0;
            }else{
              ref.read(targetControllers[number].notifier).state = value;
              sendRobomasTarget(ref, number);
            }
          },
          min: -1*double.parse(ref.watch(maxtargetcontroller[number]).text),
          max: double.parse(ref.watch(maxtargetcontroller[number]).text),
          divisions: 0x8000,
          label: ref.watch(targetControllers[number]).toString(),
        );
      // }else{
      //   return const Text('error');
      // }
      default:
        return const Text('error');
    }
  }
}

class TargetWidget extends ConsumerWidget {
  const TargetWidget({Key? key ,required this.number}) : super(key: key);
  final int number;

  @override
  Widget build(BuildContext context, WidgetRef ref){
    switch(ref.watch(modeProviders[number-1])){
      case 0:
      return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('  $number :'),
            TargetSlider(number:number-1),
          ],
        );
      case 1:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('  $number :'),
            TargetSendButton(number: number-1,),
            TargetSlider(number:number-1),
          ],
        );
      case 2:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('  $number :'),
            TargetSendButton(number: number-1,),
            TargetTextField(number: number-1),
            TargetSlider(number:number-1),
          ],
        );
      default:
        return const Text('error');
    }  
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