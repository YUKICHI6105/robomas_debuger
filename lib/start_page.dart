import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:robomas_debuger/provider.dart';

class RobomasButton extends StatelessWidget {
  const RobomasButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          if (!(await usbCan.connectUSB(0x40a))) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("RobomasController IS NOT CONNECTED"),
              ));
              context.push('/RobomasPages');
            }
            return;
          }

          //connect success

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("RobomasController is CONNECTED"),
            ));
            context.push('/RobomasPages');
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: const Text('Robomas'));
  }
}

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: Colors.blue,
      title: const Text("CRS_Debuger"),
    );
    return Scaffold(
      appBar: appBar,
      body: Center(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        const RobomasButton(),
        ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('USBCAN2'))
      ])),
    );
  }
}
