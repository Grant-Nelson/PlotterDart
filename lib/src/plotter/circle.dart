part of plotter;

/// A plotter item for drawing ellipses.
class Circles extends PlotterItem {
  /// The x value for the top-left corner points.
  List<double> _xCoords;

  /// The y value for the top-left corner points.
  List<double> _yCoords;

  /// The radius of the ellipses.
  List<double> _radius;

  /// Creates a new ellipse plotter item.
  Circles() {
    _xCoords = new List<double>();
    _yCoords = new List<double>();
    _radius = new List<double>();
  }

  /// Adds ellipses to this plotter item.
  void add(List<double> val) {
    int count = val.length;
    for (int i = 0; i < count; i += 3) {
      _xCoords.add(val[i]);
      _yCoords.add(val[i + 1]);
      _radius.add(val[i + 2]);
    }
  }

  /// The number of ellipses in this item.
  int get count => _xCoords.length;

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) {
    r.drawCircs(_xCoords, _yCoords, _radius);
  }

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = count - 1; i >= 0; --i) {
      double r = _radius[i];
      double x = _xCoords[i] - r;
      double y = _yCoords[i] - r;
      double d = 2.0 * r;
      b.expand(x, y);
      b.expand(x + d, y + d);
    }
    return trans.transform(b);
  }
}
