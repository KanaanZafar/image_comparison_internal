import 'package:flutter/material.dart';
import 'package:image_comparison/screens/show_gallery.dart';
import 'package:image_comparison/utils/constants.dart';
import 'package:image_comparison/utils/size_config.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => ShowGalleryScreen()));
          },
          child: Text(Constants.showGallery),
        ),
      ),
    );
  }
}
