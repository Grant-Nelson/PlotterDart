part of plotter;

/// A plotter item for drawing rectangles.
class RectangleGroup extends BasicCoordsItem {
  /// The width of all the rectangles.
  double _width;

  /// The height of all the rectangles.
  double _height;

  /// Creates a new rectangle plotter item.
  RectangleGroup(this._width, this._height) : super._(2);

  List<double> get _x => _coords[0];
  List<double> get _y => _coords[1];

  /// The width for all the rectangles.
  double get width => _width;
  set width(double width) => _width = width;

  /// The height for all the rectangles.
  double get height => _height;
  set height(double height) => _height = height;

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) {
    r.drawRectSet(_x, _y, _width, _height);
  }

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = count - 1; i >= 0; --i) b.expand(_x[i], _y[i]);
    if (!b.isEmpty) b.expand(b.xmax + _width, b.ymax + _height);
    return trans.transform(b);
  }
}
