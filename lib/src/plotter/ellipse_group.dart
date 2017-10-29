part of plotter;

/// A plotter item for drawing ellipses.{
/// The points are the top-left corner of the ellipses.
class EllipseGroup extends BasicCoordsItem {
  /// The width of all the ellipses.
  double _width;

  /// The height of all the ellipses.
  double _height;

  /// Creates a new ellipse plotter item.
  EllipseGroup(this._width, this._height) : super._(2);

  List<double> get _lefts => _coords[0];
  List<double> get _tops => _coords[1];

  /// The width for all the ellipses.
  double get width => _width;
  set width(double width) => _width = width;

  /// The height for all the ellipses.
  double get height => _height;
  set height(double height) => _height = height;

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) {
    r.drawEllipsSet(_lefts, _tops, _width, _height);
  }

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = count - 1; i >= 0; --i) b.expand(_lefts[i], _tops[i]);
    if (!b.isEmpty) b.expand(b.xmax + _width, b.ymax + _height);
    return trans.transform(b);
  }
}
