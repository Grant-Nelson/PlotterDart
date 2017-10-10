part of plotter;

/// A plotter item for drawing ellipses.
class Ellipses extends PlotterItem {
  /// The x value for the top-left corner points.
  List<double> _xCoords;

  /// The y value for the top-left corner points.
  List<double> _yCoords;

  /// The width of the ellipses.
  List<double> _widths;

  /// The height of the ellipses.
  List<double> _heights;

  /// Creates a new ellipse plotter item.
  Ellipses() {
    _xCoords = new List<double>();
    _yCoords = new List<double>();
    _widths = new List<double>();
    _heights = new List<double>();
  }

  /// Adds ellipses to this plotter item.
  void add(List<double> val) {
    int count = val.length;
    for (int i = 0; i < count; i += 4) {
      _xCoords.add(val[i]);
      _yCoords.add(val[i + 1]);
      _widths.add(val[i + 2]);
      _heights.add(val[i + 3]);
    }
  }

  /// The number of ellipses in this item.
  int get count => _xCoords.length;

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) {
    r.drawEllips(_xCoords, _yCoords, _widths, _heights);
  }

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = count - 1; i >= 0; --i) {
      double x = _xCoords[i];
      double y = _yCoords[i];
      b.expand(x, y);
      b.expand(x + _widths[i], y + _heights[i]);
    }
    return trans.transform(b);
  }
}
