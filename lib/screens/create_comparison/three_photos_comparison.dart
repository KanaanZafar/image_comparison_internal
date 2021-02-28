import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_comparison/components/large_image_tile.dart';
import 'package:image_comparison/components/side_action_bar.dart';
import 'package:image_comparison/stores/create_comparison_store.dart';
import 'package:image_comparison/utils/helper.dart';
import 'package:provider/provider.dart';

class ThreePhotosComparison extends StatefulWidget {
  @override
  _ThreePhotosComparisonState createState() => _ThreePhotosComparisonState();
}

class _ThreePhotosComparisonState extends State<ThreePhotosComparison> {
  CreateComparisonStore createComparisonStore;

  @override
  void initState() {
    createComparisonStore =
        Provider.of<CreateComparisonStore>(context, listen: false);
    setOrientationHorizontal();
    super.initState();
  }

  @override
  void dispose() {
    setOrientationVertical();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: createComparisonStore.isSaving
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Please Wait",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CupertinoActivityIndicator()
                ],
              )
            : Row(
                children: [
                  LargeImageTile(),
                  LargeImageTile(),
                  LargeImageTile(),
                  SideActionBar(),
                ],
              ),
      ),
    );
  }
}
