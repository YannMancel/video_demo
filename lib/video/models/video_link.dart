import 'package:freezed_annotation/freezed_annotation.dart'
    show DeepCollectionEquality, JsonKey, freezed, optionalTypeArgs;

part 'video_link.freezed.dart';

@freezed
class VideoLink with _$VideoLink {
  const factory VideoLink.network({required String videoPath}) = _Network;
  const factory VideoLink.asset({required String videoPath}) = _Asset;
}
