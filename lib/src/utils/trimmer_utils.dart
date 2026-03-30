import 'dart:typed_data';
import 'dart:ui';

import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

/// Generates a stream of thumbnails for a given video.
///
/// This function generates a specified number of thumbnails for a video at
/// different timestamps and yields them as a stream of lists of byte arrays.
///
/// Parameters:
/// - `videoPath` (required): The path to the video file.
/// - `videoDuration` (required): The duration of the video in milliseconds.
/// - `numberOfThumbnails` (required): The number of thumbnails to generate.
/// - `quality` (required): The quality of the thumbnails (percentage).
/// - `onThumbnailLoadingComplete` (required): A callback function that is
///   called when all thumbnails have been generated.
///
/// Returns:
/// A stream of lists of byte arrays, where each list contains the generated
/// thumbnails up to that point.
///
/// Example usage:
/// ```dart
/// final thumbnailStream = generateThumbnail(
///   videoPath: 'path/to/video.mp4',
///   videoDuration: 60000, // 1 minute
///   numberOfThumbnails: 10,
///   quality: 50,
///   onThumbnailLoadingComplete: () {
///     print('Thumbnails generated successfully!');
///   },
/// );
///
/// await for (final thumbnails in thumbnailStream) {
///   // Process the thumbnails
/// }
/// ```
///
/// Throws:
/// An error if the thumbnails could not be generated.
Stream<List<Uint8List?>> generateThumbnail({
  required String videoPath,
  required int videoDuration,
  required int numberOfThumbnails,
  required double thumbnailHeight,
  required int quality,
  required VoidCallback onThumbnailLoadingComplete,
}) async* {
  final double eachPart = videoDuration / numberOfThumbnails;
  final List<Uint8List?> thumbnailBytes = [];
  // Generate slightly larger thumbnails than visible tile height so timeline
  // frames stay sharp when rendered in dense mode.
  final requestedHeight = (thumbnailHeight * 2).round().clamp(
        thumbnailHeight.toInt(),
        720,
      );

  try {
    // Generate video thumbnails
    for (int i = 1; i <= numberOfThumbnails; i++) {
      Uint8List? bytes;

      // Calculate the timestamp for the thumbnail in milliseconds
      final timestamp = (eachPart * i).toInt();

      // Generate the thumbnail image bytes
      bytes = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        timeMs: timestamp,
        maxHeight: requestedHeight,
        quality: quality,
      );

      thumbnailBytes.add(bytes);

      if (thumbnailBytes.length == numberOfThumbnails) {
        onThumbnailLoadingComplete();
      }

      yield thumbnailBytes;
    }
  } catch (_) {}
}
