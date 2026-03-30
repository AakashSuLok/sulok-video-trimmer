# Sulok Video Trimmer

A Flutter package for trimming videos with customizable fixed/scrollable trim viewers, playback controls, and GIF export support.

### Features

* Load local video files and initialize playback with `Trimmer.loadVideo`.
* Trim output by start/end milliseconds and save using `Trimmer.saveTrimmedVideo`.
* Export as video (`OutputType.video`) or GIF (`OutputType.gif`).
* Two timeline modes in `TrimViewer`: `fixed` and `scrollable` (or `auto`).
* Enforce both `maxVideoLength` and `minVideoLength` constraints while dragging.
* Customize overlay/handles via `TrimEditorProperties`.
* Customize thumbnails/edge blur/icons via `TrimAreaProperties`.
* Duration labels with selectable display formats (`DurationStyle`).
* Playback control scoped to selected trim range.

> NOTE: Versions `5.0.0` and above uses a native video trimmer without the overhead of `FFmpeg`. Have a look at the Changelog for breaking changes if you are below version `5.0.0`.

`TrimViewer` includes a top duration row (start/end/scrubber time), a thumbnail `TrimArea`, and a `TrimEditor` overlay for range selection.

## Core Parts

* `Trimmer`: load media, save trimmed output, control playback.
* `VideoViewer`: renders the video preview from `Trimmer.videoPlayerController`.
* `TrimViewer`: high-level trimming UI that picks fixed/scrollable mode.
* `FixedTrimViewer` / `ScrollableTrimViewer`: concrete timeline implementations.
* `TrimEditorProperties`: border, scrubber, handle size/shape/colors, drag hit area.
* `TrimAreaProperties`: thumbnail quality/fit/density, blur edges, start/end icons.

## Example

Use the in-repo example integration pattern shown below to embed this package in your app.

## Usage

Add the dependency `video_trimmer` to your **pubspec.yaml** file:

```yaml
dependencies:
  video_trimmer: ^5.0.0
```

### Android configuration

No additional configuration is needed for using on Android platform. You are good to go!

### iOS configuration

* Add the following keys to your **Info.plist** file, located in `<project root>/ios/Runner/Info.plist`:
  ```
  <key>NSCameraUsageDescription</key>
  <string>Used to demonstrate image picker plugin</string>
  <key>NSMicrophoneUsageDescription</key>
  <string>Used to capture audio for image picker plugin</string>
  <key>NSPhotoLibraryUsageDescription</key>
  <string>Used to demonstrate image picker plugin</string>
  ```

## Functionalities

### Loading input video file

```dart
final Trimmer _trimmer = Trimmer();
await _trimmer.loadVideo(videoFile: file);
```

### Saving trimmed video

Use the `onSave` callback to get the output path once trimming is complete.

```dart
await _trimmer.saveTrimmedVideo(
  startValue: _startValue,
  endValue: _endValue,
  onSave: (outputPath) {
    setState(() => _value = outputPath);
  },
);
```

### Video playback state 

Returns the video playback state. If **true** then the video is playing, otherwise it is paused.

```dart
await _trimmer.videoPlaybackControl(
  startValue: _startValue,
  endValue: _endValue,
);
```

## Widgets

### Display a video playback area

```dart
VideoViewer(trimmer: _trimmer)
```

### Display the video trimmer area

```dart
TrimViewer(
  trimmer: _trimmer,
  viewerHeight: 50.0,
  viewerWidth: MediaQuery.of(context).size.width,
  maxVideoLength: const Duration(seconds: 10),
  onChangeStart: (value) => _startValue = value,
  onChangeEnd: (value) => _endValue = value,
  onChangePlaybackState: (value) =>
      setState(() => _isPlaying = value),
)
```

## Example

Before using this example directly in a Flutter app, don't forget to add the `video_trimmer` & `file_picker` packages to your `pubspec.yaml` file.

You can try out this example by replacing the entire content of `main.dart` file of a newly created Flutter project.

```dart
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Trimmer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Trimmer"),
      ),
      body: Center(
        child: Container(
          child: ElevatedButton(
            child: Text("LOAD VIDEO"),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.video,
                allowCompression: false,
              );
              if (result != null) {
                File file = File(result.files.single.path!);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return TrimmerView(file);
                  }),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class TrimmerView extends StatefulWidget {
  final File file;

  TrimmerView(this.file);

  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? value;

    await _trimmer.saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      onSave: (outputPath) {
        setState(() {
          _progressVisibility = false;
          value = outputPath;
        });
      },
    );

    return value;
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Trimmer"),
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                ElevatedButton(
                  onPressed: _progressVisibility
                      ? null
                      : () async {
                          _saveVideo().then((outputPath) {
                            print('OUTPUT PATH: $outputPath');
                            final snackBar = SnackBar(
                                content: Text('Video Saved successfully'));
                            ScaffoldMessenger.of(context).showSnackBar(
                              snackBar,
                            );
                          });
                        },
                  child: Text("SAVE"),
                ),
                Expanded(
                  child: VideoViewer(trimmer: _trimmer),
                ),
                Center(
                  child: TrimViewer(
                    trimmer: _trimmer,
                    viewerHeight: 50.0,
                    viewerWidth: MediaQuery.of(context).size.width,
                    maxVideoLength: const Duration(seconds: 10),
                    onChangeStart: (value) => _startValue = value,
                    onChangeEnd: (value) => _endValue = value,
                    onChangePlaybackState: (value) =>
                        setState(() => _isPlaying = value),
                  ),
                ),
                TextButton(
                  child: _isPlaying
                      ? Icon(
                          Icons.pause,
                          size: 80.0,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.play_arrow,
                          size: 80.0,
                          color: Colors.white,
                        ),
                  onPressed: () async {
                    bool playbackState = await _trimmer.videoPlaybackControl(
                      startValue: _startValue,
                      endValue: _endValue,
                    );
                    setState(() {
                      _isPlaying = playbackState;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## License

This project is distributed under the MIT License. See [LICENSE](LICENSE).
