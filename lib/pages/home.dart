import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:ursa_ds_mobile/domain/communications.dart';
import 'package:ursa_ds_mobile/drawer.dart';
import 'package:ursa_ds_mobile/joystick.dart';
import 'package:ursa_ds_mobile/telemetry.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    message.saveRecallState = 1;
    message.advanced = false;

    return Scaffold(
      appBar: AppBar(
        title: Text('URSA Control'),
      ),
      drawer: NavigationDrawer(),
      body: SlidingUpPanel(
        slideDirection: SlideDirection.DOWN,
        parallaxEnabled: true,
        parallaxOffset: 0.5,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        minHeight: 250,
        maxHeight: 250,
        panel: Telemetry(),
        body: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Joystick(),
          ],
        ),
      ),
    );
  }
}
