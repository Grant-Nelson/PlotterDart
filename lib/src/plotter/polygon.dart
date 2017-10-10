part of plotter;

/// The plotter item for plotting a polygon.
class Polygon extends PlotterItem {
  /// The x coordinates for the polygon.
  List<double> _xCoords;

  /// The y coordinates for the polygon.
  List<double> _yCoords;

  /// Creates a polygon plotter item.
  Polygon() {
    _xCoords = new List<double>();
    _yCoords = new List<double>();
  }

  /// Adds points to the polygon.
  void add(List<double> val) {
    int count = val.length;
    for (int i = 0; i < count; i += 2) {
      _xCoords.add(val[i]);
      _yCoords.add(val[i + 1]);
    }
  }

  /// The number of points in the polygon.
  int get count => _xCoords.length;

  /// Called when the polygon is to be draw.
  void _onDraw(IRenderer r) {
    r.drawPoly(_xCoords, _yCoords);
  }

  /// Gets the bounds for the polygon.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = count - 1; i >= 0; --i) b.expand(_xCoords[i], _yCoords[i]);
    return trans.transform(b);
  }
}
