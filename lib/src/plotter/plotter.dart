library plotter;

import 'dart:math' as math;

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
part 'irenderer.dart';
part 'lines.dart';
part 'line_strip.dart';
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
///   plot.addLines(12.1, 10.1, 10.9, 10.1,
///                 10.9, 11.1,  6.9, 10.9,
///                 10.9, 10.9, 10.1, 13.9,
///                 10.1,  4.9, 10.1, 10.1);
///   plot.addPoints(12.1, 10.1,   10.9, 10.1,
///                  10.9, 11.1,    6.9, 10.9,
///                  10.9, 10.9,   10.1, 13.9,
///                  10.1,  4.9,   10.1, 10.1).
///                  addPointSize(4.0);
///   plot.updateBounds();
///   plot.focusOnData();
///   plot.show();
class Plotter {
  /// The data bounds for the item's data.
  Bounds _bounds;

  /// The transformer from the window to the view.
  Transformer _viewTrans;

  /// The items to plot.
  List<PlotterItem> _items;

  /// Creates a new plotter.
  Plotter() {
    _bounds = new Bounds.empty();
    _viewTrans = new Transformer.identity();
    _items = new List<PlotterItem>();

    _items.add(new Grid());
    _items.add(new DataBounds());
  }

  /// Focuses on the data.
  /// Note: May need to call updateBounds before this if the data has changed.
  void focusOnData() {
    _viewTrans.reset();
    if (!_bounds.isEmpty) {
      double scale = 0.95 / math.max(_bounds.width, _bounds.height);
      _viewTrans.setScale(scale, scale);
      _viewTrans.setOffset(-0.5 * (_bounds.xmin + _bounds.xmax) * scale,
          -0.5 * (_bounds.ymin + _bounds.ymax) * scale);
    }
  }

  /// The number of items in the plotter.
  int get count => _items.length;

  /// The list of items in the plotter.
  List<PlotterItem> get items => _items;

  /// Adds plotter items to the plotter.
  void add(PlotterItem item) => _items.add(item);

  /// Adds a points plotter item with the given data.
  Points addPoints(List<double> val) {
    Points item = new Points()..add(val);
    add(item);
    return item;
  }

  /// Adds a lines plotter item with the given data.
  Lines addLines(List<double> val) {
    Lines item = new Lines()..add(val);
    add(item);
    return item;
  }

  /// Adds a line strip plotter item with the given data.
  LineStrip addLineStrip(List<double> val) {
    LineStrip item = new LineStrip()..add(val);
    add(item);
    return item;
  }

  /// Adds a polygon plotter item with the given data.
  Polygon addPolygon(List<double> val) {
    Polygon item = new Polygon()..add(val);
    add(item);
    return item;
  }

  /// Adds a child group item with the given items.
  Group addGroup(List<PlotterItem> items) {
    Group item = new Group()..add(items);
    add(item);
    return item;
  }

  /// Updates the bounds of the data.
  /// This should be called whenever the data has changed.
  void updateBounds() {
    Bounds b = new Bounds.empty();
    for (PlotterItem item in _items) b.union(item.getBounds(_viewTrans));
    _bounds = b;
  }

  /// Renders the plot with the given renderer.
  void render(IRenderer r) {
    r.dataBounds = _bounds;
    Transformer trans = r.transform;
    trans = trans.mul(_viewTrans);
    r.transform = trans;
    for (PlotterItem item in _items) {
      r.color = new Color(0.0, 0.0, 0.0);
      item.draw(r);
    }
  }

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

  /// Changes the zoom of the transformation at the given location.
  void deltaViewZoom(double x, double y, double amount) {
    double prev = math.max(_viewTrans.xScalar, _viewTrans.yScalar);
    double scale = math.pow(10.0, math.log(prev) / math.LN10 - amount);

    if (scale < _minZoom)
      scale = _minZoom;
    else if (scale > _maxZoom) scale = _maxZoom;

    double dx = (_viewTrans.dx - x) * (scale / prev) + x;
    double dy = (_viewTrans.dy - y) * (scale / prev) + y;
    _viewTrans.setOffset(dx, dy);
    _viewTrans.setScale(scale, scale);
  }
}
