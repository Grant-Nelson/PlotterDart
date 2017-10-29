part of plotter;

/// The plotter item for plotting a polygon.
class Polygon extends BasicCoordsItem {

  /// Creates a polygon plotter item.
  Polygon(): super._(2);

  List<double> get _x => _coords[0];
  List<double> get _y => _coords[1];

  /// Called when the polygon is to be draw.
  void _onDraw(IRenderer r) {
    r.drawPoly(_x, _y);
  }

  /// Gets the bounds for the polygon.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = count - 1; i >= 0; --i) b.expand(_x[i], _y[i]);
    return trans.transform(b);
  }
}
