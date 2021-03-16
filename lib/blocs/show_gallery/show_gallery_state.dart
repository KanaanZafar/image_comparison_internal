part of 'show_gallery_bloc.dart';

@immutable
abstract class ShowGalleryState {}

class ShowGalleryInitial extends ShowGalleryState {}

class FetchingGalleryPhotos extends ShowGalleryState {}

class PermissionNotGranted extends ShowGalleryState {}

class GalleryPhotosFetched extends ShowGalleryState {
  final List<AssetEntity> assetEntites;

  GalleryPhotosFetched({this.assetEntites});
}

class FailureState extends ShowGalleryState {
  final String error;

  FailureState({this.error});
}

class PaymentMessageState extends ShowGalleryState {
  final String message;

  PaymentMessageState({this.message});
}

class AllAlbumsFetched extends ShowGalleryState {
  final List<AssetPathEntity> assetPathEntities;

  AllAlbumsFetched({this.assetPathEntities});
}
