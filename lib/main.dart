import 'package:flutter/material.dart';
import 'package:image_comparison/home.dart';
import 'package:image_comparison/stores/create_comparison_store.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<CreateComparisonStore>(
      create: (_) => CreateComparisonStore(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
