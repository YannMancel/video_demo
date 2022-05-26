// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'video_link.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$VideoLink {
  String get videoPath => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String videoPath) network,
    required TResult Function(String videoPath) asset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String videoPath)? network,
    TResult Function(String videoPath)? asset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String videoPath)? network,
    TResult Function(String videoPath)? asset,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Network value) network,
    required TResult Function(_Asset value) asset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Network value)? network,
    TResult Function(_Asset value)? asset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Network value)? network,
    TResult Function(_Asset value)? asset,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VideoLinkCopyWith<VideoLink> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoLinkCopyWith<$Res> {
  factory $VideoLinkCopyWith(VideoLink value, $Res Function(VideoLink) then) =
      _$VideoLinkCopyWithImpl<$Res>;
  $Res call({String videoPath});
}

/// @nodoc
class _$VideoLinkCopyWithImpl<$Res> implements $VideoLinkCopyWith<$Res> {
  _$VideoLinkCopyWithImpl(this._value, this._then);

  final VideoLink _value;
  // ignore: unused_field
  final $Res Function(VideoLink) _then;

  @override
  $Res call({
    Object? videoPath = freezed,
  }) {
    return _then(_value.copyWith(
      videoPath: videoPath == freezed
          ? _value.videoPath
          : videoPath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_NetworkCopyWith<$Res> implements $VideoLinkCopyWith<$Res> {
  factory _$$_NetworkCopyWith(
          _$_Network value, $Res Function(_$_Network) then) =
      __$$_NetworkCopyWithImpl<$Res>;
  @override
  $Res call({String videoPath});
}

/// @nodoc
class __$$_NetworkCopyWithImpl<$Res> extends _$VideoLinkCopyWithImpl<$Res>
    implements _$$_NetworkCopyWith<$Res> {
  __$$_NetworkCopyWithImpl(_$_Network _value, $Res Function(_$_Network) _then)
      : super(_value, (v) => _then(v as _$_Network));

  @override
  _$_Network get _value => super._value as _$_Network;

  @override
  $Res call({
    Object? videoPath = freezed,
  }) {
    return _then(_$_Network(
      videoPath: videoPath == freezed
          ? _value.videoPath
          : videoPath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Network implements _Network {
  const _$_Network({required this.videoPath});

  @override
  final String videoPath;

  @override
  String toString() {
    return 'VideoLink.network(videoPath: $videoPath)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Network &&
            const DeepCollectionEquality().equals(other.videoPath, videoPath));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(videoPath));

  @JsonKey(ignore: true)
  @override
  _$$_NetworkCopyWith<_$_Network> get copyWith =>
      __$$_NetworkCopyWithImpl<_$_Network>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String videoPath) network,
    required TResult Function(String videoPath) asset,
  }) {
    return network(videoPath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String videoPath)? network,
    TResult Function(String videoPath)? asset,
  }) {
    return network?.call(videoPath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String videoPath)? network,
    TResult Function(String videoPath)? asset,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(videoPath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Network value) network,
    required TResult Function(_Asset value) asset,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Network value)? network,
    TResult Function(_Asset value)? asset,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Network value)? network,
    TResult Function(_Asset value)? asset,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class _Network implements VideoLink {
  const factory _Network({required final String videoPath}) = _$_Network;

  @override
  String get videoPath => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_NetworkCopyWith<_$_Network> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_AssetCopyWith<$Res> implements $VideoLinkCopyWith<$Res> {
  factory _$$_AssetCopyWith(_$_Asset value, $Res Function(_$_Asset) then) =
      __$$_AssetCopyWithImpl<$Res>;
  @override
  $Res call({String videoPath});
}

/// @nodoc
class __$$_AssetCopyWithImpl<$Res> extends _$VideoLinkCopyWithImpl<$Res>
    implements _$$_AssetCopyWith<$Res> {
  __$$_AssetCopyWithImpl(_$_Asset _value, $Res Function(_$_Asset) _then)
      : super(_value, (v) => _then(v as _$_Asset));

  @override
  _$_Asset get _value => super._value as _$_Asset;

  @override
  $Res call({
    Object? videoPath = freezed,
  }) {
    return _then(_$_Asset(
      videoPath: videoPath == freezed
          ? _value.videoPath
          : videoPath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Asset implements _Asset {
  const _$_Asset({required this.videoPath});

  @override
  final String videoPath;

  @override
  String toString() {
    return 'VideoLink.asset(videoPath: $videoPath)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Asset &&
            const DeepCollectionEquality().equals(other.videoPath, videoPath));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(videoPath));

  @JsonKey(ignore: true)
  @override
  _$$_AssetCopyWith<_$_Asset> get copyWith =>
      __$$_AssetCopyWithImpl<_$_Asset>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String videoPath) network,
    required TResult Function(String videoPath) asset,
  }) {
    return asset(videoPath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String videoPath)? network,
    TResult Function(String videoPath)? asset,
  }) {
    return asset?.call(videoPath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String videoPath)? network,
    TResult Function(String videoPath)? asset,
    required TResult orElse(),
  }) {
    if (asset != null) {
      return asset(videoPath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Network value) network,
    required TResult Function(_Asset value) asset,
  }) {
    return asset(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Network value)? network,
    TResult Function(_Asset value)? asset,
  }) {
    return asset?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Network value)? network,
    TResult Function(_Asset value)? asset,
    required TResult orElse(),
  }) {
    if (asset != null) {
      return asset(this);
    }
    return orElse();
  }
}

abstract class _Asset implements VideoLink {
  const factory _Asset({required final String videoPath}) = _$_Asset;

  @override
  String get videoPath => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_AssetCopyWith<_$_Asset> get copyWith =>
      throw _privateConstructorUsedError;
}
