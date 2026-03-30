import 'package:flutter/material.dart';

class TrimEditorProperties {
  /// For specifying a size to the holder at the
  /// two ends of the video trimmer area, while it is `idle`.
  ///
  /// By default it is set to `5.0`.
  final double circleSize;

  /// For specifying a size to the holder at
  /// the two ends of the video trimmer area, while it is being
  /// `dragged`.
  ///
  /// By default it is set to `8.0`.
  final double circleSizeOnDrag;

  /// For specifying the width of the border around
  /// the trim area. By default it is set to `3`.
  final double borderWidth;

  /// For specifying the width of the video scrubber
  final double scrubberWidth;

  /// For specifying a circular border radius
  /// to the corners of the trim area.
  ///
  /// By default it is set to `4.0`.
  final double borderRadius;

  /// For specifying a color to the circle.
  ///
  /// By default it is set to `Colors.white`.
  final Color circlePaintColor;

  /// For specifying a color to the border of
  /// the trim area.
  ///
  /// By default it is set to `Colors.white`.
  final Color borderPaintColor;

  /// For specifying a color to the video
  /// scrubber inside the trim area.
  ///
  /// By default it is set to `Colors.white`.
  final Color scrubberPaintColor;

  /// For specifying a dark color outside the selected trim area.
  ///
  /// By default it is semi-transparent black.
  final Color outsideOverlayColor;

  /// For specifying the width of the left and right trim handles.
  ///
  /// By default it is set to `10`.
  final double handleWidth;

  /// For specifying a color to the small grip lines on each handle.
  ///
  /// By default it is set to `Colors.white`.
  final Color handleGripColor;

  /// Controls handle height relative to trim track height.
  ///
  /// Example: `0.5` means handle height is 50% of track height.
  final double handleHeightFactor;

  /// Controls how much handle sits outside the selected range.
  ///
  /// - `0.5`: half inside + half outside (centered on border)
  /// - `0.6`: 60% outside, 40% inside
  final double handleOutsideFraction;

  /// Reserved visual space on left and right inside the trim widget.
  ///
  /// This helps handles protrude outside the selected border while still
  /// remaining visible inside the widget bounds.
  final double visualHorizontalPadding;

  /// Reserved visual space on top and bottom inside the trim widget.
  ///
  /// This creates an inset trim track so border/handles do not touch
  /// the exact widget edges.
  final double visualVerticalPadding;

  /// Determines the touch size of the side handles, left and right. The rest, in
  /// the center, will move the whole frame if [maxVideoLength] is inferior to the
  /// total duration of the video.
  final int sideTapSize;

  /// Helps defining the Trim Editor properties.
  ///
  /// A better look at the structure of the **Trim Viewer**:
  ///
  /// ![](https://raw.githubusercontent.com/sbis04/video_trimmer/new_editor/screenshots/trim_viewer_preview_small.png)
  ///
  ///
  /// All the parameters are optional:
  ///
  /// * [circleSize] for specifying a size to the holder at the
  /// two ends of the video trimmer area, while it is `idle`.
  /// By default it is set to `5.0`.
  ///
  ///
  /// * [circleSizeOnDrag] for specifying a size to the holder at
  /// the two ends of the video trimmer area, while it is being
  /// `dragged`. By default it is set to `8.0`.
  ///
  ///
  /// * [borderWidth] for specifying the width of the border around
  /// the trim area. By default it is set to `3.0`.
  ///
  /// * [scrubberWidth] for specifying the width of the video scrubber.
  /// By default it is set to `1.0`.
  ///
  ///
  /// * [borderRadius] for applying a circular border radius
  /// to the corners of the trim area. By default it is set to `4.0`.
  ///
  ///
  /// * [circlePaintColor] for specifying a color to the circle.
  /// By default it is set to `Colors.white`.
  ///
  ///
  /// * [borderPaintColor] for specifying a color to the border of
  /// the trim area. By default it is set to `Colors.white`.
  ///
  ///
  /// * [scrubberPaintColor] for specifying a color to the video
  /// scrubber inside the trim area. By default it is set to
  /// `Colors.white`.
  ///
  ///
  /// * [sideTapSize] determines the touch size of the side handles, left and right.
  /// The rest, in the center, will move the whole frame if [maxVideoLength] is
  /// inferior to the total duration of the video.
  ///
  const TrimEditorProperties({
    this.circleSize = 5.0,
    this.circleSizeOnDrag = 8.0,
    this.borderWidth = 3.0,
    this.scrubberWidth = 1.0,
    this.borderRadius = 4.0,
    this.circlePaintColor = Colors.white,
    this.borderPaintColor = Colors.white,
    this.scrubberPaintColor = Colors.white,
    this.outsideOverlayColor = const Color(0x66000000),
    this.handleWidth = 10.0,
    this.handleGripColor = Colors.white,
    this.handleHeightFactor = 0.5,
    this.handleOutsideFraction = 0.5,
    this.visualHorizontalPadding = 0.0,
    this.visualVerticalPadding = 0.0,
    this.sideTapSize = 24,
  })  : assert(circleSize >= 0),
        assert(circleSizeOnDrag >= 0),
        assert(borderWidth >= 0),
        assert(scrubberWidth >= 0),
        assert(borderRadius >= 0),
        assert(handleWidth >= 0),
        assert(handleHeightFactor >= 0 && handleHeightFactor <= 1),
        assert(handleOutsideFraction >= 0 && handleOutsideFraction <= 1),
        assert(visualHorizontalPadding >= 0),
        assert(visualVerticalPadding >= 0),
        assert(sideTapSize >= 0);
}
