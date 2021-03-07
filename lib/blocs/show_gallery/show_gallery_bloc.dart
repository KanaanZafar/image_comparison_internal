import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:image_comparison/utils/helper.dart';
import 'package:meta/meta.dart';
import 'package:photo_manager/photo_manager.dart';

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
      if (event is FetchGalleryPhotos) {
        bool result = await PhotoManager.requestPermission();
        if (result) {
          if (recentAssetEntities == null) {
            print("-----recent entities null");
            yield FetchingGalleryPhotos();
          } else {
            print("----++++ ${recentAssetEntities.length}");
          }
          recentAssetEntities = await fetchRecentAssetEntities();
          yield GalleryPhotosFetched(assetEntites: recentAssetEntities);
        } else {
          yield PermissionNotGranted();
        }
      }
    } catch (e) {
      yield FailureState(error: e.toString());
    }
  }
}
