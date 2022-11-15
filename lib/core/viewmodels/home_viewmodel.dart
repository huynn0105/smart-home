import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeViewModel extends ChangeNotifier {
  Stream collectionStream =
      FirebaseFirestore.instance.collection('smart-home').snapshots();
}
