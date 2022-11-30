import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home_app/core/model/control_model.dart';
import 'package:smart_home_app/core/model/data_model.dart';
import 'package:smart_home_app/ui/smart_device_box.dart';
import 'package:smart_home_app/ui/threshold_screen.dart';

class HomeScreen extends StatefulWidget {
  final String path;
  const HomeScreen({
    super.key,
    required this.path,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  DatabaseReference ref = FirebaseDatabase.instance.ref('listNode');

  late DatabaseReference controlDoc;
  late DatabaseReference dataDoc;

  @override
  void initState() {
    controlDoc = ref.child(widget.path).child('control');
    dataDoc = ref.child(widget.path).child('data');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.grey[100],
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ThresHoldScreen(
                        path: widget.path,
                      )));
            },
            child: Icon(
              Icons.settings,
              size: 30,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        children: [
          // welcome home
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome ${widget.path}",
                  style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          StreamBuilder(
              stream: dataDoc.onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  DataModel dataModel = DataModel.fromJson(
                      snapshot.requireData.snapshot.value as Map);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _DataBox(title: 'Temp', value: '${dataModel.temp} ℃'),
                      _DataBox(
                          title: 'Light', value: dataModel.light.toString()),
                      _DataBox(title: 'Humi', value: dataModel.humi.toString()),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              }),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(
              thickness: 1,
              color: Color.fromARGB(255, 204, 204, 204),
            ),
          ),
          const SizedBox(height: 15),
          // smart devices grid
          StreamBuilder(
            stream: controlDoc.onValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final ControlModel controlModel =
                    ControlModel.fromJson(snapshot.data!.snapshot.value as Map);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Auto Control",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: controlModel.autoControl,
                              onChanged: (value) async {
                                await controlDoc.update({'autoControl': value});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // grid
                    AbsorbPointer(
                      absorbing: controlModel.autoControl,
                      child: Opacity(
                        opacity: controlModel.autoControl ? 0.5 : 1,
                        child: GridView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1.2,
                          ),
                          children: [
                            SmartDeviceBox(
                              smartDeviceName: 'Lamp',
                              iconPath: 'assets/light-bulb.png',
                              powerOn: controlModel.lamp,
                              onChanged: (value) async =>
                                  await controlDoc.update(
                                {'lamp': value},
                              ),
                            ),
                            SmartDeviceBox(
                              smartDeviceName: 'Motor',
                              iconPath: 'assets/air-conditioner.png',
                              powerOn: controlModel.motor,
                              onChanged: (value) async =>
                                  await controlDoc.update(
                                {'motor': value},
                              ),
                            ),
                            SmartDeviceBox(
                              smartDeviceName: 'Fan',
                              iconPath: 'assets/fan.png',
                              powerOn: controlModel.fan,
                              onChanged: (value) async =>
                                  await controlDoc.update(
                                {'fan': value},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }
}

class _DataBox extends StatelessWidget {
  const _DataBox({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(44, 164, 167, 189),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
