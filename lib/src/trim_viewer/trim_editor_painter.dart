import 'package:flutter/material.dart';

class TrimEditorPainter extends CustomPainter {
  /// To define the start offset
  final Offset startPos;

  /// To define the end offset
  final Offset endPos;

  /// To define the horizontal length of the selected video area
  final double scrubberAnimationDx;

  /// For specifying a circular border radius
  /// to the corners of the trim area.
  /// By default it is set to `4.0`.
  final double borderRadius;

  /// For specifying a size to the start holder
  /// of the video trimmer area.
  /// By default it is set to `0.5`.
  final double startCircleSize;

  /// For specifying a size to the end holder
  /// of the video trimmer area.
  /// By default it is set to `0.5`.
  final double endCircleSize;

  /// For specifying the width of the border around
  /// the trim area. By default it is set to `3`.
  final double borderWidth;

  /// For specifying the width of the video scrubber
  final double scrubberWidth;

  /// For specifying whether to show the scrubber
  final bool showScrubber;

  /// For specifying a color to the border of
  /// the trim area. By default it is set to `Colors.white`.
  final Color borderPaintColor;

  /// For specifying a color to the circle.
  /// By default it is set to `Colors.white`
  final Color circlePaintColor;

  /// For specifying a color to the video
  /// scrubber inside the trim area. By default it is set to
  /// `Colors.white`.
  final Color scrubberPaintColor;

  /// For specifying a dark color outside selected trim area.
  final Color outsideOverlayColor;

  /// For specifying the width of the left/right drag handles.
  final double handleWidth;

  /// For specifying the color of small handle grip lines.
  final Color handleGripColor;

  /// Controls handle height relative to track height.
  final double handleHeightFactor;

  /// Controls how much of handle sits outside selected frame.
  final double handleOutsideFraction;

  /// Reserved visual side space inside the trim widget.
  final double visualHorizontalPadding;

  /// Reserved visual top/bottom space inside the trim widget.
  final double visualVerticalPadding;

  /// For drawing the trim editor slider
  ///
  /// The required parameters are [startPos], [endPos]
  /// & [scrubberAnimationDx]
  ///
  /// * [startPos] to define the start offset
  ///
  ///
  /// * [endPos] to define the end offset
  ///
  ///
  /// * [scrubberAnimationDx] to define the horizontal length of the
  /// selected video area
  ///
  ///
  /// The optional parameters are:
  ///
  /// * [startCircleSize] for specifying a size to the start holder
  /// of the video trimmer area.
  /// By default it is set to `0.5`.
  ///
  ///
  /// * [endCircleSize] for specifying a size to the end holder
  /// of the video trimmer area.
  /// By default it is set to `0.5`.
  ///
  ///
  /// * [borderRadius] for specifying a circular border radius
  /// to the corners of the trim area.
  /// By default it is set to `4.0`.
  ///
  ///
  /// * [borderWidth] for specifying the width of the border around
  /// the trim area. By default it is set to `3`.
  ///
  ///
  /// * [scrubberWidth] for specifying the width of the video scrubber
  ///
  ///
  /// * [showScrubber] for specifying whether to show the scrubber
  ///
  ///
  /// * [borderPaintColor] for specifying a color to the border of
  /// the trim area. By default it is set to `Colors.white`.
  ///
  ///
  /// * [circlePaintColor] for specifying a color to the circle.
  /// By default it is set to `Colors.white`.
  ///
  ///
  /// * [scrubberPaintColor] for specifying a color to the video
  /// scrubber inside the trim area. By default it is set to
  /// `Colors.white`.
  ///
  TrimEditorPainter({
    required this.startPos,
    required this.endPos,
    required this.scrubberAnimationDx,
    this.startCircleSize = 0.5,
    this.endCircleSize = 0.5,
    this.borderRadius = 4,
    this.borderWidth = 3,
    this.scrubberWidth = 1,
    this.showScrubber = true,
    this.borderPaintColor = Colors.white,
    this.circlePaintColor = Colors.white,
    this.scrubberPaintColor = Colors.white,
    this.outsideOverlayColor = const Color(0x66000000),
    this.handleWidth = 10.0,
    this.handleGripColor = Colors.white,
    this.handleHeightFactor = 0.5,
    this.handleOutsideFraction = 0.5,
    this.visualHorizontalPadding = 0.0,
    this.visualVerticalPadding = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var borderPaint = Paint()
      ..color = borderPaintColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var circlePaint = Paint()
      ..color = circlePaintColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    var scrubberPaint = Paint()
      ..color = scrubberPaintColor
      ..strokeWidth = scrubberWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var outsideOverlayPaint = Paint()
      ..color = outsideOverlayColor
      ..style = PaintingStyle.fill;

    final sidePad = visualHorizontalPadding.clamp(0.0, size.width / 3);
    final verticalPad = visualVerticalPadding.clamp(0.0, size.height / 3);
    final innerWidth = (size.width - (sidePad * 2)).clamp(1.0, size.width);

    // Drag logic uses coordinates in inner trim area space.
    // We just offset paint positions by the same padding used around child.
    final mappedStartX = sidePad + startPos.dx;
    final mappedEndX = sidePad + endPos.dx;
    final mappedScrubberX = sidePad + scrubberAnimationDx;
    final mappedTopY = verticalPad + startPos.dy;
    final mappedBottomY = verticalPad + endPos.dy;

    final rect = Rect.fromPoints(
      Offset(mappedStartX, mappedTopY),
      Offset(mappedEndX, mappedBottomY),
    );
    final roundedRect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    if (showScrubber) {
      if (mappedScrubberX.toInt() > mappedStartX.toInt()) {
        canvas.drawLine(
          Offset(mappedScrubberX, mappedTopY),
          Offset(mappedScrubberX, mappedBottomY),
          scrubberPaint,
        );
      }
    }

    // Overlays are painted only inside the padded inner area.
    if (startPos.dx > 0) {
      canvas.drawRect(
        Rect.fromLTRB(sidePad, mappedTopY, mappedStartX, mappedBottomY),
        outsideOverlayPaint,
      );
    }
    if (endPos.dx < innerWidth) {
      canvas.drawRect(
        Rect.fromLTRB(
            mappedEndX, mappedTopY, size.width - sidePad, mappedBottomY),
        outsideOverlayPaint,
      );
    }

    canvas.drawRRect(roundedRect, borderPaint);
    _drawHandle(
      canvas: canvas,
      centerX: mappedStartX,
      topY: mappedTopY,
      bottomY: mappedBottomY,
      maxWidth: size.width,
      isStartHandle: true,
      visualRadius: startCircleSize,
      handlePaint: circlePaint,
    );
    _drawHandle(
      canvas: canvas,
      centerX: mappedEndX,
      topY: mappedTopY,
      bottomY: mappedBottomY,
      maxWidth: size.width,
      isStartHandle: false,
      visualRadius: endCircleSize,
      handlePaint: circlePaint,
    );
  }

  void _drawHandle({
    required Canvas canvas,
    required double centerX,
    required double topY,
    required double bottomY,
    required double maxWidth,
    required bool isStartHandle,
    required double visualRadius,
    required Paint handlePaint,
  }) {
    final height = (bottomY - topY).clamp(1.0, double.infinity);
    final maxLeft = (maxWidth - handleWidth).clamp(0.0, double.infinity);
    final outsideFraction = handleOutsideFraction.clamp(0.0, 1.0);
    // Start handle grows to left side of border, end handle grows to right side.
    final rawLeft = isStartHandle
        ? centerX - (handleWidth * outsideFraction)
        : centerX - (handleWidth * (1 - outsideFraction));
    final left = rawLeft.clamp(0.0, maxLeft);
    final heightFactor = handleHeightFactor.clamp(0.2, 1.0);
    final handleHeightCap = (height - 2).clamp(0.0, double.infinity).toDouble();
    final minHandleHeight = handleHeightCap < 12.0 ? handleHeightCap : 12.0;
    if (handleHeightCap <= 0) return;
    final handleHeight = (height * heightFactor)
        .clamp(minHandleHeight, handleHeightCap)
        .toDouble();
    final handleTop = topY + ((height - handleHeight) / 2);
    final handleRect =
        Rect.fromLTWH(left, handleTop, handleWidth, handleHeight);
    final cornerRadius = Radius.circular(visualRadius.clamp(0, handleWidth));
    final handleRRect = RRect.fromRectAndRadius(handleRect, cornerRadius);
    canvas.drawRRect(handleRRect, handlePaint);

    final gripPaint = Paint()
      ..color = handleGripColor
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final gripHeight = (handleHeight * 0.6).clamp(6, 14).toDouble();
    final gripTop = handleTop + ((handleHeight - gripHeight) / 2);
    final gripX = handleRect.center.dx;
    canvas.drawLine(
      Offset(gripX, gripTop),
      Offset(gripX, gripTop + gripHeight),
      gripPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
