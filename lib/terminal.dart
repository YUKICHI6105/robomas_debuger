import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
//import 'package:usbcan_plugins/usbcan.dart';
import 'package:robomas_debuger/provider.dart';

class RobomasButton extends ConsumerWidget{
  const RobomasButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return ElevatedButton(
      onPressed: () async {
            if (!(await usbCan.connectUSB(0x040a))) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("RobomasController IS NOT CONNECTED"),
                ));
                // context.push('/RobomasPages');
              }
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("RobomasController CONNECTED"),
                ));
                context.push('/RobomasPages');
              }
            }
          },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      child: const Text('Robomas')
    );
  }
}

class USBCAN2Button extends ConsumerWidget{
  const USBCAN2Button({Key? key}) : super(key: key);

  push(BuildContext context){
    context.push('/b');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      child: const Text('USBCAN2')
    );
  }
}

class Terminal extends ConsumerWidget{
  const Terminal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final appBar = AppBar(
      backgroundColor: Colors.blue,
      title: const Text("CRS_Debuger"),
    );
    return Scaffold(
      appBar: appBar,
      body: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RobomasButton(),
            USBCAN2Button()
          ]
        )
      ),
    );
  }
}
