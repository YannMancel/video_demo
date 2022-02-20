import 'package:flutter/foundation.dart' show optionalTypeArgs;
import 'package:freezed_annotation/freezed_annotation.dart'
    show DeepCollectionEquality, JsonKey, freezed;

part 'video_state.freezed.dart';

@freezed
class VideoState with _$VideoState {
  const factory VideoState.notInitialized() = _NotInitialized;
  const factory VideoState.initialized() = _Initialized;
  const factory VideoState.play() = _Play;
  const factory VideoState.pause() = _Pause;
  const factory VideoState.error({required Exception exception}) = _Error;
}
