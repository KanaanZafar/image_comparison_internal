import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_comparison/utils/size_config.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image/image.dart' as IMG;

enum ComparisonType { fourPhotos, threePhotos, twoPhotos }

extension ComparsionTypeValue on ComparisonType {
  String get value {
    switch (this) {
      case ComparisonType.twoPhotos:
        return "twoPhotos";
      case ComparisonType.threePhotos:
        return "threePhotos";
      case ComparisonType.fourPhotos:
        return "fourPhotos";
      default:
        return null;
    }
  }
}

Future<List<AssetEntity>> fetchRecentAssetEntities() async {
  List<AssetPathEntity> assetPathEntities =
      await PhotoManager.getAssetPathList();
  String recent = Platform.isAndroid ? "recent" : "recents";

  int recentIndex = assetPathEntities
      .indexWhere((element) => element.name.toLowerCase() == recent);

  List<AssetEntity> assetEntitiesList = List<AssetEntity>();
  if (recentIndex > -1) {
    AssetPathEntity assetPathEntity = assetPathEntities[recentIndex];
    List<AssetEntity> assetEntities = await assetPathEntity.assetList;
    assetEntities.forEach((element) {
      if (element.type == AssetType.image) {
        assetEntitiesList.add(element);
      }
    });
    assetEntitiesList.sort((a, b) => b.createDateTime.millisecondsSinceEpoch
        .compareTo(a.createDateTime.millisecondsSinceEpoch));
  }
  return assetEntitiesList;
}

setOrientationVertical() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

setOrientationHorizontal() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  print("----height: ${SizeConfig.screenHeight}");
  print("-----width: ${SizeConfig.screenWidth}");
}

saveIntoLocalDirectory(List<AssetEntity> assetEntities) async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String directoryPath = appDocumentsDirectory.path;
  PermissionStatus permissionStatus = await Permission.storage.request();
  print("-----permissionStatus: ${permissionStatus}");
  for (int i = 0; i < assetEntities.length; i++) {
    AssetEntity assetEntity = assetEntities[i];
    File assetFile = await assetEntity.file;
    String imageType = assetFile.path.split('.').last;
    String savePath = '$directoryPath/image_${DateTime.now()}.$imageType';
    final File newImage = await assetFile.copy(savePath);
    print("------+++++${newImage.lengthSync()}");
    if (permissionStatus.isGranted) {
//      final result = await ImageGallerySaver.saveFile(newImage.path);
      final result =
          await ImageGallerySaver.saveImage(newImage.readAsBytesSync());
      print("-----result: ${result}");
    }
  }
}
