import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image_comparison/utils/constants.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:save_in_gallery/save_in_gallery.dart';
import 'package:share/share.dart';
import 'package:path/path.dart';

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
}
/*
saveIntoLocalDirectory2(List<AssetEntity> assetEntities) async {
  Directory baseDirectory = await getApplicationDocumentsDirectory();
  String directoryToBeCreated = Constants.iFavorites;
  String finalDirectory = join(baseDirectory.path, directoryToBeCreated);
  Directory directory = Directory(finalDirectory);
  bool exists = await directory.exists();

  if (exists) {
  } else {
    await directory.create(recursive: true);
  }
  PermissionStatus permissionStatus = await Permission.storage.request();
  for (int i = 0; i < assetEntities.length; i++) {
    AssetEntity assetEntity = assetEntities[i];
    File assetFile = await assetEntity.file;
    String imageType = assetFile.path.split('.').last;
    String savePath = '${directory.path}/image_${DateTime.now()}.$imageType';
    final File newImage = await assetFile.copy(savePath);
    if (permissionStatus.isGranted) {
      await ImageGallerySaver.saveFile(
        newImage.path,
      );
      /*final result = await ImageGallerySaver.saveImage(
        newImage.readAsBytesSync(),
        name: Constants.iFavorites,
      ); */
    }
  }
} */

saveIntoLocalDirectory(List<AssetEntity> assetEntities) async {
//  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  Directory appDocumentsDirectory;
  Directory appDocDirFolder;
  if (Platform.isAndroid) {
    appDocumentsDirectory = await getExternalStorageDirectory();
    String newPath = "";

    List<String> paths = appDocumentsDirectory.path.split("/");
    for (int x = 1; x < paths.length; x++) {
      String folder = paths[x];
      if (folder != "Android") {
        newPath += "/" + folder;
      } else {
        break;
      }
    }
    newPath = newPath + "/${Constants.iFavorites}";
    appDocDirFolder = Directory(newPath);
  } else if (Platform.isIOS) {
    appDocumentsDirectory = await getTemporaryDirectory();
    appDocDirFolder =
        Directory('${appDocumentsDirectory.path}/${Constants.iFavorites}/');
  }

  bool exists = await appDocDirFolder.exists();
  String directoryPath;
  if (exists) {
    directoryPath = appDocDirFolder.path;
  } else {
    Directory appDocDirIfavorites =
        await appDocDirFolder.create(recursive: true);
    directoryPath = appDocDirIfavorites.path;
  }
//  ImageGallerySaver.
  PermissionStatus permissionStatus = await Permission.storage.request();
/*  List<Uint8List> bytesList = List<Uint8List>();
  for (int i = 0; i < assetEntities.length; i++) {
    AssetEntity assetEntity = assetEntities[i];
    Uint8List bytes = await assetEntity.originBytes;
    bytesList.add(bytes);
  }
  ImageSaver imageSaver = ImageSaver();
  await imageSaver.saveImages(
      imageBytes: bytesList, directoryName: "iFavsBakchodi");
*/
  for (int i = 0; i < assetEntities.length; i++) {
    AssetEntity assetEntity = assetEntities[i];
    File assetFile = await assetEntity.file;
//    Uint8List imageBytes = await assetEntity.originBytes;
    String imageType = assetFile.path.split('.').last;
    String savePath = '$directoryPath/image_${DateTime.now()}.$imageType';
    final File newImage = await assetFile.copy(savePath);
    if (permissionStatus.isGranted) {
      await ImageGallerySaver.saveFile(
        newImage.path,
        isReturnPathOfIOS: true,
      );
//      await ImageGallerySaver.saveImage(
//        imageBytes,
//        name: "IfavsBakchodi",
//        isReturnImagePathOfIOS: true,
//      );
    }
  }
}

shareWithOtherApps(List<AssetEntity> assetEntities) async {
  List<String> paths = List<String>();

  for (AssetEntity assetEntity in assetEntities) {
    File file = await assetEntity.file;
    paths.add(file.path);
  }
  Share.shareFiles(
    paths,
  );
}

shareApp() async {
  await Share.share("https://fremontinfotech.wixsite.com/gingerapps");
}
/*
Future<bool> saveVideo(String url, String fileName) async {
  Directory directory;
  try {
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
      String newPath = "";
      print(directory);
      List<String> paths = directory.path.split("/");
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }
      newPath = newPath + "/RPSApp";
      directory = Directory(newPath);
    } else {
      if (await _requestPermission(Permission.photos)) {
        directory = await getTemporaryDirectory();
      } else {
        return false;
      }
    }
    File saveFile = File(directory.path + "/$fileName");
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    if (await directory.exists()) {
      await dio.download(url, saveFile.path,
          onReceiveProgress: (value1, value2) {
        setState(() {
          progress = value1 / value2;
        });
      });
      if (Platform.isIOS) {
        await ImageGallerySaver.saveFile(saveFile.path,
            isReturnPathOfIOS: true);
      }
      return true;
    }
    return false;
  } catch (e) {
    print(e);
    return false;
  }
}
*/
