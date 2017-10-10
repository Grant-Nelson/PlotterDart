part of plotter;

/// A plotter item for drawing circles.
class CircleGroup extends PlotterItem {
  /// The x value for the top-left corner points.
  List<double> _xCoords;

  /// The y value for the top-left corner points.
  List<double> _yCoords;

  /// The radius of all the circles.
  double _radius;

  /// Creates a new circle plotter item.
  CircleGroup(this._radius) {
    _xCoords = new List<double>();
    _yCoords = new List<double>();
  }

  /// The radius for all the circles.
  double get radius => _radius;
  set radius(double radius) => _radius = radius;

  /// Adds circles to this plotter item.
  void add(List<double> val) {
    int count = val.length;
    for (int i = 0; i < count; i += 2) {
      _xCoords.add(val[i]);
      _yCoords.add(val[i + 1]);
    }
  }

  /// The number of circles in this item.
  int get count => _xCoords.length;

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) {
    r.drawCircSet(_xCoords, _yCoords, _radius);
  }

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = count - 1; i >= 0; --i) b.expand(_xCoords[i], _yCoords[i]);
    if (!b.isEmpty) {
      b.expand(b.xmin - _radius, b.ymin - _radius);
      b.expand(b.xmax + _radius, b.ymax + _radius);
    }
    return trans.transform(b);
  }
}
