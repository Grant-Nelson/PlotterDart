part of plotter;

/// A plotter item for drawing circles.
/// The points are the top-left corner.
class CircleGroup extends BasicCoordsItem {
  /// The radius of all the circles.
  double _radius;

  /// Creates a new circle plotter item.
  CircleGroup(this._radius) : super._(2);

  List<double> get _lefts => _coords[0];
  List<double> get _tops => _coords[1];

  /// The radius for all the circles.
  double get radius => _radius;
  set radius(double radius) => _radius = radius;

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) {
    r.drawCircSet(_lefts, _tops, _radius);
  }

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = count - 1; i >= 0; --i) b.expand(_lefts[i], _tops[i]);
    if (!b.isEmpty) {
      b.expand(b.xmin - _radius, b.ymin - _radius);
      b.expand(b.xmax + _radius, b.ymax + _radius);
    }
    return trans.transform(b);
  }
}
