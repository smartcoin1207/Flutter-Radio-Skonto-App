// import 'dart:math';
// import 'dart:ui' as ui;
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:radio_skonto/helpers/app_colors.dart';
//
// enum TimeLabelLocation {
//   above,
//   below,
//   sides,
//   none,
// }
//
// enum TimeLabelType {
//   totalTime,
//   remainingTime,
// }
//
// enum BarCapShape {
//   round,
//   square,
// }
//
// class AppProgressBar extends LeafRenderObjectWidget {
//   const AppProgressBar({
//     Key? key,
//     required this.progress,
//     required this.total,
//     this.buffered,
//     this.onSeek,
//     this.onDragStart,
//     this.onDragUpdate,
//     this.onDragEnd,
//     this.barHeight = 5.0,
//     this.baseBarColor,
//     this.progressBarColor,
//     this.bufferedBarColor,
//     this.barCapShape = BarCapShape.round,
//     this.thumbRadius = 10.0,
//     this.thumbColor,
//     this.thumbGlowColor,
//     this.thumbGlowRadius = 30.0,
//     this.thumbCanPaintOutsideBar = true,
//     this.timeLabelLocation,
//     this.timeLabelType,
//     this.timeLabelTextStyle,
//     this.timeLabelPadding = 0.0,
//   }) : super(key: key);
//
//   final Duration progress;
//   final Duration total;
//   final Duration? buffered;
//   final ValueChanged<Duration>? onSeek;
//   final ThumbDragStartCallback? onDragStart;
//   final ThumbDragUpdateCallback? onDragUpdate;
//   final VoidCallback? onDragEnd;
//   final double barHeight;
//   final Color? baseBarColor;
//   final Color? progressBarColor;
//   final Color? bufferedBarColor;
//   final BarCapShape barCapShape;
//   final double thumbRadius;
//   final Color? thumbColor;
//   final Color? thumbGlowColor;
//   final double thumbGlowRadius;
//   final bool thumbCanPaintOutsideBar;
//   final TimeLabelLocation? timeLabelLocation;
//   final TimeLabelType? timeLabelType;
//   final TextStyle? timeLabelTextStyle;
//   final double timeLabelPadding;
//
//   @override
//   RenderObject createRenderObject(BuildContext context) {
//     final theme = Theme.of(context);
//     final primaryColor = theme.colorScheme.primary;
//     final textStyle = timeLabelTextStyle ?? theme.textTheme.bodyLarge;
//     final textScaleFactor = MediaQuery.textScaleFactorOf(context);
//     return _RenderProgressBar(
//       progress: progress,
//       total: total,
//       buffered: buffered ?? Duration.zero,
//       onSeek: onSeek,
//       onDragStart: onDragStart,
//       onDragUpdate: onDragUpdate,
//       onDragEnd: onDragEnd,
//       barHeight: barHeight,
//       baseBarColor: baseBarColor ?? primaryColor.withOpacity(0.24),
//       progressBarColor: progressBarColor ?? primaryColor,
//       bufferedBarColor: bufferedBarColor ?? primaryColor.withOpacity(0.24),
//       barCapShape: barCapShape,
//       thumbRadius: thumbRadius,
//       thumbColor: thumbColor ?? primaryColor,
//       thumbGlowColor:
//       thumbGlowColor ?? (thumbColor ?? primaryColor).withAlpha(80),
//       thumbGlowRadius: thumbGlowRadius,
//       thumbCanPaintOutsideBar: thumbCanPaintOutsideBar,
//       timeLabelLocation: timeLabelLocation ?? TimeLabelLocation.below,
//       timeLabelType: timeLabelType ?? TimeLabelType.totalTime,
//       timeLabelTextStyle: textStyle,
//       timeLabelPadding: timeLabelPadding,
//       textScaleFactor: textScaleFactor,
//     );
//   }
//
//   @override
//   void updateRenderObject(BuildContext context, RenderObject renderObject) {
//     final theme = Theme.of(context);
//     final primaryColor = theme.colorScheme.primary;
//     final textStyle = timeLabelTextStyle ?? theme.textTheme.bodyLarge;
//     final textScaleFactor = MediaQuery.textScaleFactorOf(context);
//     (renderObject as _RenderProgressBar)
//       ..progress = progress
//       ..total = total
//       ..buffered = buffered ?? Duration.zero
//       ..onSeek = onSeek
//       ..onDragStart = onDragStart
//       ..onDragUpdate = onDragUpdate
//       ..onDragEnd = onDragEnd
//       ..barHeight = barHeight
//       ..baseBarColor = baseBarColor ?? primaryColor.withOpacity(0.24)
//       ..progressBarColor = progressBarColor ?? primaryColor
//       ..bufferedBarColor = bufferedBarColor ?? primaryColor.withOpacity(0.24)
//       ..barCapShape = barCapShape
//       ..thumbRadius = thumbRadius
//       ..thumbColor = thumbColor ?? primaryColor
//       ..thumbGlowColor =
//           thumbGlowColor ?? (thumbColor ?? primaryColor).withAlpha(80)
//       ..thumbGlowRadius = thumbGlowRadius
//       ..thumbCanPaintOutsideBar = thumbCanPaintOutsideBar
//       ..timeLabelLocation = timeLabelLocation ?? TimeLabelLocation.below
//       ..timeLabelType = timeLabelType ?? TimeLabelType.totalTime
//       ..timeLabelTextStyle = textStyle
//       ..timeLabelPadding = timeLabelPadding
//       ..textScaleFactor = textScaleFactor;
//   }
//
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(StringProperty('progress', progress.toString()));
//     properties.add(StringProperty('total', total.toString()));
//     properties.add(StringProperty('buffered', buffered.toString()));
//     properties.add(ObjectFlagProperty<ValueChanged<Duration>>('onSeek', onSeek,
//         ifNull: 'unimplemented'));
//     properties.add(ObjectFlagProperty<ThumbDragStartCallback>(
//         'onDragStart', onDragStart,
//         ifNull: 'unimplemented'));
//     properties.add(ObjectFlagProperty<ThumbDragUpdateCallback>(
//         'onDragUpdate', onDragUpdate,
//         ifNull: 'unimplemented'));
//     properties.add(ObjectFlagProperty<VoidCallback>('onDragEnd', onDragEnd,
//         ifNull: 'unimplemented'));
//     properties.add(DoubleProperty('barHeight', barHeight));
//     properties.add(ColorProperty('baseBarColor', baseBarColor));
//     properties.add(ColorProperty('progressBarColor', progressBarColor));
//     properties.add(ColorProperty('bufferedBarColor', bufferedBarColor));
//     properties.add(StringProperty('barCapShape', barCapShape.toString()));
//     properties.add(DoubleProperty('thumbRadius', thumbRadius));
//     properties.add(ColorProperty('thumbColor', thumbColor));
//     properties.add(ColorProperty('thumbGlowColor', thumbGlowColor));
//     properties.add(DoubleProperty('thumbGlowRadius', thumbGlowRadius));
//     properties.add(
//       FlagProperty(
//         'thumbCanPaintOutsideBar',
//         value: thumbCanPaintOutsideBar,
//         ifTrue: 'true',
//         ifFalse: 'false',
//         showName: true,
//       ),
//     );
//     properties
//         .add(StringProperty('timeLabelLocation', timeLabelLocation.toString()));
//     properties.add(StringProperty('timeLabelType', timeLabelType.toString()));
//     properties
//         .add(DiagnosticsProperty('timeLabelTextStyle', timeLabelTextStyle));
//     properties.add(DoubleProperty('timeLabelPadding', timeLabelPadding));
//   }
// }
//
// typedef ThumbDragStartCallback = void Function(ThumbDragDetails details);
// typedef ThumbDragUpdateCallback = void Function(ThumbDragDetails details);
//
// class ThumbDragDetails {
//   const ThumbDragDetails({
//     this.timeStamp = Duration.zero,
//     this.globalPosition = Offset.zero,
//     this.localPosition = Offset.zero,
//   });
//
//   final Duration timeStamp;
//   final Offset globalPosition;
//   final Offset localPosition;
//
//   @override
//   String toString() => '${objectRuntimeType(this, 'ThumbDragDetails')}('
//       'time: $timeStamp, '
//       'global: $globalPosition, '
//       'local: $localPosition)';
// }
//
// class _EagerHorizontalDragGestureRecognizer
//     extends HorizontalDragGestureRecognizer {
//   @override
//   void addAllowedPointer(PointerDownEvent event) {
//     super.addAllowedPointer(event);
//     resolve(GestureDisposition.accepted);
//   }
//
//   @override
//   String get debugDescription => '_EagerHorizontalDragGestureRecognizer';
// }
//
// class _RenderProgressBar extends RenderBox {
//   _RenderProgressBar({
//     required Duration progress,
//     required Duration total,
//     required Duration buffered,
//     ValueChanged<Duration>? onSeek,
//     ThumbDragStartCallback? onDragStart,
//     ThumbDragUpdateCallback? onDragUpdate,
//     VoidCallback? onDragEnd,
//     required double barHeight,
//     required Color baseBarColor,
//     required Color progressBarColor,
//     required Color bufferedBarColor,
//     required BarCapShape barCapShape,
//     double thumbRadius = 20.0,
//     required Color thumbColor,
//     required Color thumbGlowColor,
//     double thumbGlowRadius = 30.0,
//     bool thumbCanPaintOutsideBar = true,
//     required TimeLabelLocation timeLabelLocation,
//     required TimeLabelType timeLabelType,
//     TextStyle? timeLabelTextStyle,
//     double timeLabelPadding = 0.0,
//     double textScaleFactor = 1.0,
//   })  : _total = total,
//         _buffered = buffered,
//         _onSeek = onSeek,
//         _onDragStartUserCallback = onDragStart,
//         _onDragUpdateUserCallback = onDragUpdate,
//         _onDragEndUserCallback = onDragEnd,
//         _barHeight = barHeight,
//         _baseBarColor = baseBarColor,
//         _progressBarColor = progressBarColor,
//         _bufferedBarColor = bufferedBarColor,
//         _barCapShape = barCapShape,
//         _thumbRadius = thumbRadius,
//         _thumbColor = thumbColor,
//         _thumbGlowColor = thumbGlowColor,
//         _thumbGlowRadius = thumbGlowRadius,
//         _thumbCanPaintOutsideBar = thumbCanPaintOutsideBar,
//         _timeLabelLocation = timeLabelLocation,
//         _timeLabelType = timeLabelType,
//         _timeLabelTextStyle = timeLabelTextStyle,
//         _timeLabelPadding = timeLabelPadding,
//         _textScaleFactor = textScaleFactor {
//     _drag = _EagerHorizontalDragGestureRecognizer()
//       ..onStart = _onDragStart
//       ..onUpdate = _onDragUpdate
//       ..onEnd = _onDragEnd
//       ..onCancel = _finishDrag;
//     if (!_userIsDraggingThumb) {
//       _progress = progress;
//       _thumbValue = _proportionOfTotal(_progress);
//     }
//   }
//
//   _EagerHorizontalDragGestureRecognizer? _drag;
//   late double _thumbValue;
//   bool _userIsDraggingThumb = false;
//
//   double get _defaultSidePadding {
//     const minPadding = 5.0;
//     return (_thumbCanPaintOutsideBar) ? thumbRadius + minPadding : minPadding;
//   }
//
//   void _onDragStart(DragStartDetails details) {
//     _userIsDraggingThumb = true;
//     _updateThumbPosition(details.localPosition);
//     onDragStart?.call(ThumbDragDetails(
//       timeStamp: _currentThumbDuration(),
//       globalPosition: details.globalPosition,
//       localPosition: details.localPosition,
//     ));
//   }
//
//   void _onDragUpdate(DragUpdateDetails details) {
//     _updateThumbPosition(details.localPosition);
//     onDragUpdate?.call(ThumbDragDetails(
//       timeStamp: _currentThumbDuration(),
//       globalPosition: details.globalPosition,
//       localPosition: details.localPosition,
//     ));
//   }
//
//   void _onDragEnd(DragEndDetails details) {
//     onDragEnd?.call();
//     onSeek?.call(_currentThumbDuration());
//     _finishDrag();
//   }
//
//   void _finishDrag() {
//     _userIsDraggingThumb = false;
//     markNeedsPaint();
//   }
//
//   Duration _currentThumbDuration() {
//     final thumbMilliseconds = _thumbValue * total.inMilliseconds;
//     return Duration(milliseconds: thumbMilliseconds.round());
//   }
//
//   void _updateThumbPosition(Offset localPosition) {
//     final dx = localPosition.dx;
//     double lengthBefore = 0.0;
//     double lengthAfter = 0.0;
//     if (_timeLabelLocation == TimeLabelLocation.sides) {
//       lengthBefore =
//           _leftLabelSize.width + _defaultSidePadding + _timeLabelPadding;
//       lengthAfter =
//           _rightLabelSize.width + _defaultSidePadding + _timeLabelPadding;
//     }
//     final barCapRadius = _barHeight / 2;
//     double barStart = lengthBefore + barCapRadius;
//     double barEnd = size.width - lengthAfter - barCapRadius;
//     final barWidth = barEnd - barStart;
//     final position = (dx - barStart).clamp(0.0, barWidth);
//     _thumbValue = (position / barWidth);
//     _progress = _currentThumbDuration();
//     markNeedsPaint();
//   }
//
//   Duration get progress => _progress;
//   Duration _progress = Duration.zero;
//
//   set progress(Duration value) {
//     final clamp = _clampDuration(value);
//     if (_progress == clamp) {
//       return;
//     }
//     if (_labelLengthDifferent(_progress, clamp)) {
//       _clearLabelCache();
//     }
//     if (!_userIsDraggingThumb) {
//       _progress = clamp;
//       _thumbValue = _proportionOfTotal(clamp);
//     }
//     markNeedsPaint();
//   }
//
//   bool _labelLengthDifferent(Duration first, Duration second) {
//     return (first.inMinutes < 10 && second.inMinutes >= 10) ||
//         (first.inMinutes >= 10 && second.inMinutes < 10) ||
//         (first.inHours == 0 && second.inHours != 0) ||
//         (first.inHours != 0 && second.inHours == 0) ||
//         (first.inHours < 10 && second.inHours >= 10) ||
//         (first.inHours >= 10 && second.inHours < 10);
//   }
//
//   TextPainter? _cachedLeftLabel;
//
//   Size get _leftLabelSize {
//     _cachedLeftLabel ??= _leftTimeLabel();
//     return _cachedLeftLabel!.size;
//   }
//
//   TextPainter? _cachedRightLabel;
//
//   Size get _rightLabelSize {
//     _cachedRightLabel ??= _rightTimeLabel();
//     return _cachedRightLabel!.size;
//   }
//
//   void _clearLabelCache() {
//     _cachedLeftLabel = null;
//     _cachedRightLabel = null;
//   }
//
//   TextPainter _leftTimeLabel() {
//     final text = _getTimeString(progress);
//     return _layoutText(text);
//   }
//
//   TextPainter _rightTimeLabel() {
//     switch (timeLabelType) {
//       case TimeLabelType.totalTime:
//         final text = _getTimeString(total);
//         return _layoutText(text);
//       case TimeLabelType.remainingTime:
//         final remaining = total - progress;
//         final text = '-${_getTimeString(remaining)}';
//         return _layoutText(text);
//     }
//   }
//
//   TextPainter _layoutText(String text) {
//     TextPainter textPainter = TextPainter(
//       text: TextSpan(text: text, style: _timeLabelTextStyle),
//       textDirection: TextDirection.ltr,
//       textScaleFactor: textScaleFactor,
//     );
//     textPainter.layout(minWidth: 0, maxWidth: double.infinity);
//     return textPainter;
//   }
//
//   Duration get total => _total;
//   Duration _total;
//
//   set total(Duration value) {
//     final clamp = (value.isNegative) ? Duration.zero : value;
//     if (_total == clamp) {
//       return;
//     }
//     if (_labelLengthDifferent(_total, clamp)) {
//       _clearLabelCache();
//     }
//     _total = clamp;
//     if (!_userIsDraggingThumb) {
//       _thumbValue = _proportionOfTotal(progress);
//     }
//     markNeedsPaint();
//   }
//
//   Duration get buffered => _buffered;
//   Duration _buffered;
//
//   set buffered(Duration value) {
//     final clamp = _clampDuration(value);
//     if (_buffered == clamp) {
//       return;
//     }
//     _buffered = clamp;
//     markNeedsPaint();
//   }
//
//   Duration _clampDuration(Duration value) {
//     if (value.isNegative) return Duration.zero;
//     if (value.compareTo(_total) > 0) return _total;
//     return value;
//   }
//
//   ValueChanged<Duration>? get onSeek => _onSeek;
//   ValueChanged<Duration>? _onSeek;
//
//   set onSeek(ValueChanged<Duration>? value) {
//     if (value == _onSeek) {
//       return;
//     }
//     _onSeek = value;
//   }
//
//   ThumbDragStartCallback? get onDragStart => _onDragStartUserCallback;
//   ThumbDragStartCallback? _onDragStartUserCallback;
//
//   set onDragStart(ThumbDragStartCallback? value) {
//     if (value == _onDragStartUserCallback) {
//       return;
//     }
//     _onDragStartUserCallback = value;
//   }
//
//   ThumbDragUpdateCallback? get onDragUpdate => _onDragUpdateUserCallback;
//   ThumbDragUpdateCallback? _onDragUpdateUserCallback;
//
//   set onDragUpdate(ThumbDragUpdateCallback? value) {
//     if (value == _onDragUpdateUserCallback) {
//       return;
//     }
//     _onDragUpdateUserCallback = value;
//   }
//
//   VoidCallback? get onDragEnd => _onDragEndUserCallback;
//   VoidCallback? _onDragEndUserCallback;
//
//   set onDragEnd(VoidCallback? value) {
//     if (value == _onDragEndUserCallback) {
//       return;
//     }
//     _onDragEndUserCallback = value;
//   }
//
//   double get barHeight => _barHeight;
//   double _barHeight;
//
//   set barHeight(double value) {
//     if (_barHeight == value) return;
//     _barHeight = value;
//     markNeedsPaint();
//   }
//
//   Color get baseBarColor => _baseBarColor;
//   Color _baseBarColor;
//
//   set baseBarColor(Color value) {
//     if (_baseBarColor == value) return;
//     _baseBarColor = value;
//     markNeedsPaint();
//   }
//
//   Color get progressBarColor => _progressBarColor;
//   Color _progressBarColor;
//
//   set progressBarColor(Color value) {
//     if (_progressBarColor == value) return;
//     _progressBarColor = value;
//     markNeedsPaint();
//   }
//
//   Color get bufferedBarColor => _bufferedBarColor;
//   Color _bufferedBarColor;
//
//   set bufferedBarColor(Color value) {
//     if (_bufferedBarColor == value) return;
//     _bufferedBarColor = value;
//     markNeedsPaint();
//   }
//
//   BarCapShape get barCapShape => _barCapShape;
//   BarCapShape _barCapShape;
//
//   set barCapShape(BarCapShape value) {
//     if (_barCapShape == value) return;
//     _barCapShape = value;
//     markNeedsPaint();
//   }
//
//   Color get thumbColor => _thumbColor;
//   Color _thumbColor;
//
//   set thumbColor(Color value) {
//     if (_thumbColor == value) return;
//     _thumbColor = value;
//     markNeedsPaint();
//   }
//
//   double get thumbRadius => _thumbRadius;
//   double _thumbRadius;
//
//   set thumbRadius(double value) {
//     if (_thumbRadius == value) return;
//     _thumbRadius = value;
//     markNeedsLayout();
//   }
//
//   Color get thumbGlowColor => _thumbGlowColor;
//   Color _thumbGlowColor;
//
//   set thumbGlowColor(Color value) {
//     if (_thumbGlowColor == value) return;
//     _thumbGlowColor = value;
//     if (_userIsDraggingThumb) markNeedsPaint();
//   }
//
//   double get thumbGlowRadius => _thumbGlowRadius;
//   double _thumbGlowRadius;
//
//   set thumbGlowRadius(double value) {
//     if (_thumbGlowRadius == value) return;
//     _thumbGlowRadius = value;
//     markNeedsLayout();
//   }
//
//   bool get thumbCanPaintOutsideBar => _thumbCanPaintOutsideBar;
//   bool _thumbCanPaintOutsideBar;
//
//   set thumbCanPaintOutsideBar(bool value) {
//     if (_thumbCanPaintOutsideBar == value) return;
//     _thumbCanPaintOutsideBar = value;
//     markNeedsPaint();
//   }
//
//   TimeLabelLocation get timeLabelLocation => _timeLabelLocation;
//   TimeLabelLocation _timeLabelLocation;
//
//   set timeLabelLocation(TimeLabelLocation value) {
//     if (_timeLabelLocation == value) return;
//     _timeLabelLocation = value;
//     markNeedsLayout();
//   }
//
//   TimeLabelType get timeLabelType => _timeLabelType;
//   TimeLabelType _timeLabelType;
//
//   set timeLabelType(TimeLabelType value) {
//     if (_timeLabelType == value) return;
//     _timeLabelType = value;
//     _clearLabelCache();
//     markNeedsLayout();
//   }
//
//   TextStyle? get timeLabelTextStyle => _timeLabelTextStyle;
//   TextStyle? _timeLabelTextStyle;
//
//   set timeLabelTextStyle(TextStyle? value) {
//     if (_timeLabelTextStyle == value) return;
//     _timeLabelTextStyle = value;
//     _clearLabelCache();
//     markNeedsLayout();
//   }
//
//   double get timeLabelPadding => _timeLabelPadding;
//   double _timeLabelPadding;
//
//   set timeLabelPadding(double value) {
//     if (_timeLabelPadding == value) return;
//     _timeLabelPadding = value;
//     markNeedsLayout();
//   }
//
//   double get textScaleFactor => _textScaleFactor;
//   double _textScaleFactor;
//
//   set textScaleFactor(double value) {
//     if (_textScaleFactor == value) return;
//     _textScaleFactor = value;
//     _clearLabelCache();
//     markNeedsLayout();
//   }
//
//   static const _minDesiredWidth = 100.0;
//
//   @override
//   double computeMinIntrinsicWidth(double height) => _minDesiredWidth;
//
//   @override
//   double computeMaxIntrinsicWidth(double height) => _minDesiredWidth;
//
//   @override
//   double computeMinIntrinsicHeight(double width) => _calculateDesiredHeight();
//
//   @override
//   double computeMaxIntrinsicHeight(double width) => _calculateDesiredHeight();
//
//   @override
//   bool hitTestSelf(Offset position) => true;
//
//   @override
//   void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
//     assert(debugHandleEvent(event, entry));
//     if (event is PointerDownEvent) {
//       _drag?.addPointer(event);
//     }
//   }
//
//   @override
//   void performLayout() {
//     size = computeDryLayout(constraints);
//   }
//
//   @override
//   Size computeDryLayout(BoxConstraints constraints) {
//     final desiredWidth = constraints.maxWidth;
//     final desiredHeight = _calculateDesiredHeight();
//     final desiredSize = Size(desiredWidth, desiredHeight);
//     return constraints.constrain(desiredSize);
//   }
//
//   double _calculateDesiredHeight() {
//     switch (_timeLabelLocation) {
//       case TimeLabelLocation.below:
//       case TimeLabelLocation.above:
//         return _heightWhenLabelsAboveOrBelow();
//       case TimeLabelLocation.sides:
//         return _heightWhenLabelsOnSides();
//       default:
//         return _heightWhenNoLabels();
//     }
//   }
//
//   double _heightWhenLabelsAboveOrBelow() {
//     return _heightWhenNoLabels() + _textHeight() + _timeLabelPadding;
//   }
//
//   double _heightWhenLabelsOnSides() {
//     return max(_heightWhenNoLabels(), _textHeight());
//   }
//
//   double _heightWhenNoLabels() {
//     return max(2 * _thumbRadius, _barHeight);
//   }
//
//   double _textHeight() {
//     return _leftLabelSize.height;
//   }
//
//   @override
//   bool get isRepaintBoundary => true;
//
//   @override
//   void paint(PaintingContext context, Offset offset) {
//     final canvas = context.canvas;
//     canvas.save();
//     canvas.translate(offset.dx, offset.dy);
//
//     switch (_timeLabelLocation) {
//       case TimeLabelLocation.above:
//       case TimeLabelLocation.below:
//         _drawProgressBarWithLabelsAboveOrBelow(canvas);
//         break;
//       case TimeLabelLocation.sides:
//         _drawProgressBarWithLabelsOnSides(canvas);
//         break;
//       default:
//         _drawProgressBarWithoutLabels(canvas);
//     }
//
//     canvas.restore();
//   }
//
//   void _drawProgressBarWithLabelsAboveOrBelow(Canvas canvas) {
//     final barWidth = size.width;
//     final barHeight = _heightWhenNoLabels();
//     final isLabelBelow = _timeLabelLocation == TimeLabelLocation.below;
//     final labelDy = (isLabelBelow) ? barHeight + _timeLabelPadding : 0.0;
//     final leftLabelOffset = Offset(0, labelDy);
//     _leftTimeLabel().paint(canvas, leftLabelOffset);
//     final rightLabelDx = size.width - _rightLabelSize.width;
//     final rightLabelOffset = Offset(rightLabelDx, labelDy);
//     _rightTimeLabel().paint(canvas, rightLabelOffset);
//     final barDy =
//     (isLabelBelow) ? 0.0 : _leftLabelSize.height + _timeLabelPadding;
//     _drawProgressBar(canvas, Offset(0, barDy), Size(barWidth, barHeight));
//   }
//
//   void _drawProgressBarWithLabelsOnSides(Canvas canvas) {
//     final leftLabelSize = _leftLabelSize;
//     final verticalOffset = size.height / 2 - leftLabelSize.height / 2;
//     final leftLabelOffset = Offset(0, verticalOffset);
//     _leftTimeLabel().paint(canvas, leftLabelOffset);
//     final rightLabelSize = _rightLabelSize;
//     final rightLabelWidth = rightLabelSize.width;
//     final totalLabelDx = size.width - rightLabelWidth;
//     final totalLabelOffset = Offset(totalLabelDx, verticalOffset);
//     _rightTimeLabel().paint(canvas, totalLabelOffset);
//     final leftLabelWidth = leftLabelSize.width;
//     final barHeight = _heightWhenNoLabels();
//     final barWidth = size.width -
//         2 * _defaultSidePadding -
//         2 * _timeLabelPadding -
//         leftLabelWidth -
//         rightLabelWidth;
//     final barDy = size.height / 2 - barHeight / 2;
//     final barDx = leftLabelWidth + _defaultSidePadding + _timeLabelPadding;
//     _drawProgressBar(canvas, Offset(barDx, barDy), Size(barWidth, barHeight));
//   }
//
//   void _drawProgressBarWithoutLabels(Canvas canvas) {
//     final barWidth = size.width;
//     final barHeight = 2 * _thumbRadius;
//     _drawProgressBar(canvas, Offset.zero, Size(barWidth, barHeight));
//   }
//
//   void _drawProgressBar(Canvas canvas, Offset offset, Size localSize) {
//     canvas.save();
//     canvas.translate(offset.dx, offset.dy);
//     _drawBaseBar(canvas, localSize);
//     _drawBufferedBar(canvas, localSize);
//     _drawCurrentProgressBar(canvas, localSize);
//     _drawThumb(canvas, localSize);
//     canvas.restore();
//   }
//
//   void _drawBaseBar(Canvas canvas, Size localSize) {
//     _drawBar(
//       canvas: canvas,
//       availableSize: localSize,
//       widthProportion: 1.0,
//       color: baseBarColor,
//     );
//   }
//
//   void _drawBufferedBar(Canvas canvas, Size localSize) {
//     _drawBar(
//       canvas: canvas,
//       availableSize: localSize,
//       widthProportion: _proportionOfTotal(_buffered),
//       color: bufferedBarColor,
//     );
//   }
//
//   void _drawCurrentProgressBar(Canvas canvas, Size localSize) {
//     _drawProBar(
//       canvas: canvas,
//       availableSize: localSize,
//       widthProportion: _proportionOfTotal(_progress),
//       color: progressBarColor,
//     );
//   }
//
//   void _drawProBar(
//       {required Canvas canvas,
//         required Size availableSize,
//         required double widthProportion,
//         required Color color}) {
//     final strokeCap = (_barCapShape == BarCapShape.round)
//         ? StrokeCap.round
//         : StrokeCap.square;
//     final capRadius = _barHeight / 2;
//     final adjustedWidth = availableSize.width - barHeight;
//     final dx = widthProportion * adjustedWidth + capRadius;
//     final startPoint = Offset(capRadius, availableSize.height / 2);
//     var endPoint = Offset(dx, availableSize.height / 2);
//     final baseBarPaint = Paint()
//       ..shader = ui.Gradient.linear(
//           startPoint, endPoint, [const Color(0x00000000), AppColors.green])
//       ..strokeCap = strokeCap
//       ..strokeWidth = _barHeight;
//     canvas.drawLine(startPoint, endPoint, baseBarPaint);
//   }
//
//   void _drawBar({
//     required Canvas canvas,
//     required Size availableSize,
//     required double widthProportion,
//     required Color color,
//   }) {
//     final strokeCap = (_barCapShape == BarCapShape.round)
//         ? StrokeCap.round
//         : StrokeCap.square;
//     final baseBarPaint = Paint()
//       ..color = color
//       ..strokeCap = strokeCap
//       ..strokeWidth = _barHeight;
//     final capRadius = _barHeight / 2;
//     final adjustedWidth = availableSize.width - barHeight;
//     final dx = widthProportion * adjustedWidth + capRadius;
//     final startPoint = Offset(capRadius, availableSize.height / 2);
//     var endPoint = Offset(dx, availableSize.height / 2);
//     canvas.drawLine(startPoint, endPoint, baseBarPaint);
//   }
//
//   void _drawThumb(Canvas canvas, Size localSize) {
//     final thumbPaint = Paint()..color = thumbColor;
//     final barCapRadius = _barHeight / 2;
//     final availableWidth = localSize.width - _barHeight;
//     var thumbDx = _thumbValue * availableWidth + barCapRadius;
//     if (!_thumbCanPaintOutsideBar) {
//       thumbDx = thumbDx.clamp(_thumbRadius, localSize.width - _thumbRadius);
//     }
//     final center = Offset(thumbDx, localSize.height / 2);
//     if (_userIsDraggingThumb) {
//       final thumbGlowPaint = Paint()..color = thumbGlowColor;
//       canvas.drawCircle(center, thumbGlowRadius, thumbGlowPaint);
//     }
//     canvas.drawCircle(center, thumbRadius, thumbPaint);
//   }
//
//   double _proportionOfTotal(Duration duration) {
//     if (total.inMilliseconds == 0) {
//       return 0.0;
//     }
//     return duration.inMilliseconds / total.inMilliseconds;
//   }
//
//   String _getTimeString(Duration time) {
//     final minutes =
//     time.inMinutes.remainder(Duration.minutesPerHour).toString();
//     final seconds = time.inSeconds
//         .remainder(Duration.secondsPerMinute)
//         .toString()
//         .padLeft(2, '0');
//     return time.inHours > 0
//         ? "${time.inHours}:${minutes.padLeft(2, "0")}:$seconds"
//         : "$minutes:$seconds";
//   }
//
//   @override
//   void describeSemanticsConfiguration(SemanticsConfiguration config) {
//     super.describeSemanticsConfiguration(config);
//     config.textDirection = TextDirection.ltr;
//     config.label = 'Progress bar';
//     config.value = '${(_thumbValue * 100).round()}%';
//     config.onIncrease = increaseAction;
//     final increased = _thumbValue + _semanticActionUnit;
//     config.increasedValue = '${((increased).clamp(0.0, 1.0) * 100).round()}%';
//     config.onDecrease = decreaseAction;
//     final decreased = _thumbValue - _semanticActionUnit;
//     config.decreasedValue = '${((decreased).clamp(0.0, 1.0) * 100).round()}%';
//   }
//
//   static const double _semanticActionUnit = 0.05;
//
//   void increaseAction() {
//     final newValue = _thumbValue + _semanticActionUnit;
//     _thumbValue = (newValue).clamp(0.0, 1.0);
//     markNeedsPaint();
//     markNeedsSemanticsUpdate();
//   }
//
//   void decreaseAction() {
//     final newValue = _thumbValue - _semanticActionUnit;
//     _thumbValue = (newValue).clamp(0.0, 1.0);
//     markNeedsPaint();
//     markNeedsSemanticsUpdate();
//   }
// }
