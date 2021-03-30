import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_gallery_saver/flutter_gallery_saver.dart';
import 'package:image_comparison/models/album.dart';
import 'package:image_comparison/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share/share.dart';
import 'package:device_info/device_info.dart';
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
      await PhotoManager.getAssetPathList(type: RequestType.image);
  String recent = Platform.isAndroid ? "recent" : "recents";

  int recentIndex = assetPathEntities
      .indexWhere((element) => element.name.toLowerCase() == recent);

  List<AssetEntity> assetEntitiesList = []; //List<AssetEntity>();
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

Future<List<Album>> getAllAlbums() async {
  List<AssetPathEntity> assetPathEntities =
      await PhotoManager.getAssetPathList(type: RequestType.image);
  List<Album> albumsList = List<Album>();
  for (AssetPathEntity assetPathEntity in assetPathEntities) {
    List<AssetEntity> assetEntities = await assetPathEntity.assetList;
    Album album = Album();
    album.albumName = assetPathEntity.name;
    album.photosInAlbum = assetEntities;
    albumsList.add(album);
  }
  return albumsList;
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

saveIntoLocalDirectory(List<AssetEntity> assetEntities) async {
  PermissionStatus permissionStatus = await Permission.storage.request();
  for (int i = 0; i < assetEntities.length; i++) {
    AssetEntity assetEntity = assetEntities[i];
    Uint8List bytes = await assetEntity.originBytes;
    if (permissionStatus.isGranted) {
      final result = await FlutterGallerySaver.saveImage(
        bytes,
        quality: 80,
        albumName: Constants.iFavorites,
      );
      print("saveImage result: " + result); //这个result文件存储地址

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
  await Share.share(Constants.playStoreLink);
}
Future<String> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//  if (Theme.of(context).platform == TargetPlatform.iOS) {
//    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
//    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
//  } else {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
//  }
}