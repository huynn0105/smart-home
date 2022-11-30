import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:smart_home_app/core/model/node_model.dart';
import 'package:smart_home_app/ui/home_screen.dart';

class SelectNodeScreen extends StatefulWidget {
  const SelectNodeScreen({super.key});

  @override
  State<SelectNodeScreen> createState() => _SelectNodeScreenState();
}

class _SelectNodeScreenState extends State<SelectNodeScreen> {
  DatabaseReference ref = FirebaseDatabase.instance.ref('listNode');
  late SimpleFontelicoProgressDialog _dialog;

  @override
  void initState() {
    _dialog = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[100],
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder(
          stream: ref.onValue,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.active &&
                snap.hasData) {
              Map<dynamic, dynamic>? data = snap.data!.snapshot.value as Map?;
              List<MapEntry<dynamic, dynamic>> entries = [];
              if (data?.entries != null && data!.entries.isNotEmpty) {
                entries = data.entries.toList();
                entries.sort(((a, b) => a.key.compareTo(b.key)));
              }
              return GridView(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                children: [
                  if (entries.isNotEmpty)
                    ...entries
                        .toList()
                        .map(
                          (e) => InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                    path: e.key,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              child: Center(
                                child: Text(
                                  e.key,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  InkWell(
                    onTap: () async {
                      _dialog.show(message: 'Đợi một lát...');
                      DatabaseReference numberRef =
                          FirebaseDatabase.instance.ref('number');
                      final snapshot = await numberRef.get();
                      if (snapshot.exists) {
                        int number = int.parse(snapshot.value.toString());
                        int newNumber = number + 1;
                        await ref
                            .child('Node$newNumber')
                            .set(NodeModel.create().toJson());
                        await numberRef.set(newNumber);
                      }

                      _dialog.hide();
                    },
                    child: const Card(
                      child: Center(
                        child: Icon(
                          Icons.add,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const CircularProgressIndicator();
          }),
    );
  }

  void showResultDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(result),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}
