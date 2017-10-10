part of plotter;

/// A plotter item for drawing a line strip.
class LineStrip extends PlotterItem {
  /// The x coordinates for the line strip points.
  List<double> _xCoords;

  /// The y coordinates for the line strip points.
  List<double> _yCoords;

  /// Creates a line strip plotter item.
  LineStrip() {
    _xCoords = new List<double>();
    _yCoords = new List<double>();
  }

  /// Adds points to the line strip.
  void add(List<double> val) {
    int count = val.length;
    for (int i = 0; i < count; i += 2) {
      _xCoords.add(val[i]);
      _yCoords.add(val[i + 1]);
    }
  }

  /// The number of points in the line strip.
  int get count => _xCoords.length;

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) {
    r.drawStrip(_xCoords, _yCoords);
  }

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = count - 1; i >= 0; --i) b.expand(_xCoords[i], _yCoords[i]);
    return trans.transform(b);
  }
}
