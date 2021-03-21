import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:image_comparison/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<dynamic, dynamic>> readFirebase() async {
  try {
    bool internetConnected = await checkInternetConnection();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (internetConnected == true) {
      DatabaseReference dbRef = FirebaseDatabase.instance.reference();
      DataSnapshot dataSnapshot = await dbRef.once();
      sharedPreferences.setString(
          Constants.dataFromFirebase, json.encode(dataSnapshot.value));
      return dataSnapshot.value;
    } else {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String data = sharedPreferences.getString(Constants.dataFromFirebase);
      if (data != null) {
        Map apiData = json.decode(data);
        return apiData;
      }
    }
  } catch (e) {
    print("-----error: ${e.toString()}");
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
