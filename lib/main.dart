import 'package:flutter/material.dart';
import 'package:image_comparison/screens/show_gallery.dart';
import 'package:image_comparison/stores/create_comparison_store.dart';
import 'package:image_comparison/utils/helper.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setOrientationVertical();
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
        debugShowCheckedModeBanner: false, home: ShowGalleryScreen() //Home(),
        );
  }
}
