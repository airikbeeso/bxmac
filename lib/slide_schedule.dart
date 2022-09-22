import 'package:flutter/material.dart';

class SlideSchedule extends StatelessWidget {
  SlideSchedule({Key? key, required this.getStatus, required this.setSwitch})
      : super(key: key);
  late Function getStatus;
  late Function(bool a) setSwitch;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "OFF",
                    style: TextStyle(
                        fontSize: 25.0,
                        fontFamily: 'roboto',
                        color: Colors.white),
                  )),
              Switch(
                  value: snapshot.data as bool,
                  onChanged: (value) {
                    setSwitch(value);
                  }),
              const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text("ON",
                      style: TextStyle(
                          fontSize: 25.0,
                          fontFamily: 'roboto',
                          color: Colors.white))),
            ],
          );
        } else {
          return const SizedBox(
            height: 10.0,
          );
        }
      },
      future: getStatus(),
    );
  }
}
