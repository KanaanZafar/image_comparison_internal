import 'dart:io';

import 'package:firebase_database/firebase_database.dart';

Future<Map<dynamic, dynamic>> readFirebase() async {
  bool internetConnected = await checkInternetConnection();
  if (internetConnected == true) {
    try {
      DatabaseReference dbRef = FirebaseDatabase.instance.reference();

      DataSnapshot dataSnapshot = await dbRef.once();
      print("------dataSnapshot: ${dataSnapshot.value}");
      return dataSnapshot.value;
    } catch (e) {
      print("---error: ${e.toString()}");
    }
  }
  return null;
}

Future<bool> checkInternetConnection() async {
  bool internetConnected;

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      internetConnected = true;
    } else {
      internetConnected = false;
    }
  } on SocketException catch (_) {
    internetConnected = false;
  }
  return internetConnected;
}
