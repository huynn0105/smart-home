import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_home_app/core/model/data_model.dart';

class ThresHoldScreen extends StatefulWidget {
  const ThresHoldScreen({super.key});

  @override
  State<ThresHoldScreen> createState() => _ThresHoldScreenState();
}

class _ThresHoldScreenState extends State<ThresHoldScreen> {
  late TextEditingController tempControllker, lightController, humiController;

  DocumentReference<DataModel> thresholdDoc = FirebaseFirestore.instance
      .collection('smart_home')
      .doc('threshold')
      .withConverter(
          fromFirestore: (snapshots, _) =>
              DataModel.fromJson(snapshots.data()!),
          toFirestore: (data, _) => data.toJson());
  @override
  void initState() {
    tempControllker = TextEditingController();
    lightController = TextEditingController();
    humiController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[100],
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Threshold',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot<DataModel>>(
                stream: thresholdDoc.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    DataModel dataModel = snapshot.requireData.data()!;
                    tempControllker.text = dataModel.temp;
                    lightController.text = dataModel.light;
                    humiController.text = dataModel.humi;
                    return Column(
                      children: [
                        CustomTextField(
                          title: 'Temp',
                          controller: tempControllker,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          title: 'Light',
                          controller: lightController,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          title: 'Humi',
                          controller: humiController,
                        ),
                      ],
                    );
                  }
                  return const CircularProgressIndicator();
                }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await thresholdDoc.update(DataModel(
                  humi: humiController.text,
                  light: lightController.text,
                  temp: tempControllker.text,
                ).toJson());

                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.title,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
