part of plotter;

/// A plotter item for drawing rectangles.
class RectangleGroup extends BasicCoordsItem {
  /// The width of all the rectangles.
  double _width;

  /// The height of all the rectangles.
  double _height;

  /// Creates a new rectangle plotter item.
  RectangleGroup(this._width, this._height) : super._(2);

  List<double> get _x => this._coords[0];
  List<double> get _y => this._coords[1];

  /// The width for all the rectangles.
  double get width => this._width;
  set width(double width) => this._width = width;

  /// The height for all the rectangles.
  double get height => this._height;
  set height(double height) => this._height = height;

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) =>
    r.drawRectSet(this._x, this._y, this._width, this._height);

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = this.count - 1; i >= 0; --i) b.expand(this._x[i], this._y[i]);
    if (!b.isEmpty) b.expand(b.xmax + this._width, b.ymax + this._height);
    return trans.transform(b);
  }
}
