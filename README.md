![coverage][coverage_badge]

# video_demo
**Goal**: A Flutter project to manage video.

## Requirements
* Computer (Windows, Mac or Linux)
* Android Studio

## Setup the project in Android studio
1. Download the project code, preferably using `git clone git@github.com:YannMancel/video_demo.git`.
2. In Android Studio, select *File* | *Open...*
3. Select the project

## Dependencies
* Flutter Version Management
    * [fvm][dependencies_fvm]
* Generators (assets)
    * [flutter_gen][dependencies_flutter_gen]
* Data class generator
    * [build_runner][dependencies_build_runner]
    * [freezed][dependencies_freezed]
    * [freezed_annotation][dependencies_freezed_annotation]
* State managers
    * [flutter_hooks][dependencies_flutter_hooks]
    * [hooks_riverpod][dependencies_hooks_riverpod]
* Video player
    * [video_player][dependencies_video_player]
* Prevent the screen from sleeping
    * [wakelock][dependencies_wakelock]

## Troubleshooting

### No device available during the compilation and execution steps
* If none of device is present (*Available Virtual Devices* or *Connected Devices*),
    * Either select `Create a new virtual device`
    * or connect and select your phone or tablet

## Useful
* [Download Android Studio][useful_android_studio]
* [Create a new virtual device][useful_virtual_device]
* [Enable developer options and debugging][useful_developer_options]

[flutter_badge]: https://img.shields.io/badge/flutter-v3.0.1-blue?logo=flutter
[dependencies_fvm]: https://fvm.app/
[dependencies_flutter_gen]: https://pub.dev/packages/flutter_gen
[dependencies_build_runner]: https://pub.dev/packages/build_runner
[dependencies_freezed]: https://pub.dev/packages/freezed
[dependencies_freezed_annotation]: https://pub.dev/packages/freezed_annotation
[dependencies_flutter_hooks]: https://pub.dev/packages/flutter_hooks
[dependencies_hooks_riverpod]: https://pub.dev/packages/hooks_riverpod
[dependencies_video_player]: https://pub.dev/packages/video_player
[dependencies_wakelock]: https://pub.dev/packages/wakelock
[useful_android_studio]: https://developer.android.com/studio
[useful_virtual_device]: https://developer.android.com/studio/run/managing-avds.html
[useful_developer_options]: https://developer.android.com/studio/debug/dev-options.html#enable
