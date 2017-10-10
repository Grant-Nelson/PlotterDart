part of plotter;

/// A plotter item for points.
class Points extends PlotterItem {
  /// The x coordinates for the points.
  List<double> _xCoords;

  /// The y coordinates for the points.
  List<double> _yCoords;

  /// Creates a points plotter item.
  Points() {
    _xCoords = new List<double>();
    _yCoords = new List<double>();
  }

  /// Adds points to the item.
  void add(List<double> val) {
    int count = val.length;
    for (int i = 0; i < count; i += 2) {
      _xCoords.add(val[i]);
      _yCoords.add(val[i + 1]);
    }
  }

  /// The number of points.
  int get count => _xCoords.length;

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) {
    r.drawPoints(_xCoords, _yCoords);
  }

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = count - 1; i >= 0; --i) b.expand(_xCoords[i], _yCoords[i]);
    return trans.transform(b);
  }
}
