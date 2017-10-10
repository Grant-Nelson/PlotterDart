part of plotter;

/// A plotter item for drawing lines.
class Lines extends PlotterItem {
  /// The x value for the first point.
  List<double> _x1Coords;

  /// The y value for the first point.
  List<double> _y1Coords;

  /// The x value for the second point.
  List<double> _x2Coords;

  /// The y value for the second point.
  List<double> _y2Coords;

  /// Creates a new line plotter item.
  Lines() {
    _x1Coords = new List<double>();
    _y1Coords = new List<double>();
    _x2Coords = new List<double>();
    _y2Coords = new List<double>();
  }

  /// Adds lines to this plotter item.
  void add(List<double> val) {
    int count = val.length;
    for (int i = 0; i < count; i += 4) {
      _x1Coords.add(val[i]);
      _y1Coords.add(val[i + 1]);
      _x2Coords.add(val[i + 2]);
      _y2Coords.add(val[i + 3]);
    }
  }

  /// The number of lines in this item.
  int get count => _x1Coords.length;

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) {
    r.drawLines(_x1Coords, _y1Coords, _x2Coords, _y2Coords);
  }

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = count - 1; i >= 0; --i) {
      b.expand(_x1Coords[i], _y1Coords[i]);
      b.expand(_x2Coords[i], _y2Coords[i]);
    }
    return trans.transform(b);
  }
}
