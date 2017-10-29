library plotter;

import 'dart:math' as math;

part 'base_coords_item.dart';
part 'bounds.dart';
part 'circle_group.dart';
part 'circle.dart';
part 'color.dart';
part 'color_attr.dart';
part 'data_bounds.dart';
part 'directed_line_attr.dart';
part 'ellipse_group.dart';
part 'ellipses.dart';
part 'fill_color_attr.dart';
part 'grid.dart';
part 'group.dart';
part 'iattribute.dart';
part 'imouse_handle.dart';
part 'irenderer.dart';
part 'lines.dart';
part 'line_strip.dart';
part 'mouse_pan.dart';
part 'plotter_item.dart';
part 'points.dart';
part 'point_size_attr.dart';
part 'polygon.dart';
part 'rectangle_group.dart';
part 'rectangle.dart';
part 'trans_attr.dart';
part 'transformer.dart';

/// minimum plotter zoom value.
const double _minZoom = 1.0e-6;

/// maximum plotter zoom value.
const double _maxZoom = 1.0e+6;

/// The plotter to quickly draw 2D plots.
/// Great for reviewing data and debugging 2D algorithms.
///
/// Example:
///   Plotter plot = new Plotter();
///   plot.addLines([12.1, 10.1, 10.9, 10.1,
///                  10.9, 11.1,  6.9, 10.9,
///                  10.9, 10.9, 10.1, 13.9,
///                  10.1,  4.9, 10.1, 10.1]);
///   plot.addPoints([12.1, 10.1,   10.9, 10.1,
///                   10.9, 11.1,    6.9, 10.9,
///                   10.9, 10.9,   10.1, 13.9,
///                   10.1,  4.9,   10.1, 10.1]).
///                  addPointSize(4.0);
///   plot.updateBounds();
///   plot.focusOnData();
///   plot.show();
class Plotter extends Group {
  /// The data bounds for the item's data.
  Bounds _bounds;

  /// The transformer from the window to the view.
  Transformer _viewTrans;

  /// The set of mouse handles.
  List<iMouseHandle> _msHndls;

  /// Creates a new plotter.
  Plotter([String label = ""]) : super(label) {
    _bounds = new Bounds.empty();
    _viewTrans = new Transformer.identity();
    _msHndls = new List<iMouseHandle>()..add(new MousePan(this, new MouseButtonState(0)));
    add([new Grid(), new DataBounds()]);
    addColor(0.0, 0.0, 0.0);
  }

  /// Focuses on the data.
  /// Note: May need to call updateBounds before this if the data has changed.
  void focusOnData() {
    _viewTrans.reset();
    if (!_bounds.isEmpty) {
      double scale = 0.95 / math.max(_bounds.width, _bounds.height);
      _viewTrans.setScale(scale, scale);
      _viewTrans.setOffset(-0.5 * (_bounds.xmin + _bounds.xmax) * scale, -0.5 * (_bounds.ymin + _bounds.ymax) * scale);
    }
  }

  /// Updates the bounds of the data.
  /// This should be called whenever the data has changed.
  void updateBounds() {
    _bounds = _onGetBounds(_viewTrans);
  }

  /// Renders the plot with the given renderer.
  void render(IRenderer r) {
    r.dataBounds = _bounds;
    Transformer trans = r.transform;
    trans = trans.mul(_viewTrans);
    r.transform = trans;
    draw(r);
  }

  /// Gets the list of mouse handles,
  List<iMouseHandle> get MouseHandles => _msHndls;

  /// The transformation from window space to view space.
  Transformer get view => _viewTrans;
  set view(Transformer view) => _viewTrans = view;

  /// Sets the offset of the view transformation.
  void setViewOffset(double x, double y) => _viewTrans.setOffset(x, y);

  /// Sets the view transformation zoom.
  /// Note: This is 10 to the power of the given value, such that 0 is x1.0 zoom.
  void setViewZoom(double pow) {
    double scale = math.pow(10.0, pow);
    _viewTrans.setScale(scale, scale);
  }

  /// Handles mouse down events.
  void onMouseDown(MouseEvent ms) {
    for (iMouseHandle hndl in _msHndls) hndl.mouseDown(ms);
  }

  /// Handles mouse move events.
  void onMouseMove(MouseEvent ms) {
    for (iMouseHandle hndl in _msHndls) hndl.mouseMove(ms);
  }

  /// Handles mouse up events.
  void onMouseUp(MouseEvent ms) {
    for (iMouseHandle hndl in _msHndls) hndl.mouseUp(ms);
  }

  /// Handles mouse wheel move events.
  void onMouseWheel(MouseEvent me, double dw) {
    double x = me.px;
    double y = me.py;
    double amount = dw;

    double prev = math.max(_viewTrans.xScalar, _viewTrans.yScalar);
    double scale = math.pow(10.0, math.log(prev) / math.LN10 - amount);

    if (scale < _minZoom)
      scale = _minZoom;
    else if (scale > _maxZoom) scale = _maxZoom;

    double dx = (_viewTrans.dx - x) * (scale / prev) + x;
    double dy = (_viewTrans.dy - y) * (scale / prev) + y;
    _viewTrans.setOffset(dx, dy);
    _viewTrans.setScale(scale, scale);

    me.redraw = true;
  }
}
