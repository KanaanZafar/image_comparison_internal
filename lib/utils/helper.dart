import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_comparison/models/album.dart';
import 'package:image_comparison/utils/constants.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share/share.dart';

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
  PermissionStatus permissionStatus = await Permission.storage.request();

  for (int i = 0; i < assetEntities.length; i++) {
    AssetEntity assetEntity = assetEntities[i];
    File assetFile = await assetEntity.file;
    String imageType = assetFile.path.split('.').last;
    String savePath = '$directoryPath/image_${DateTime.now()}.$imageType';
    final File newImage = await assetFile.copy(savePath);
    if (permissionStatus.isGranted) {
      await ImageGallerySaver.saveFile(
        newImage.path,
        isReturnPathOfIOS: true,
      );
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
