part of plotter;

/// A plotter item for drawing circles.
/// The points are the top-left corner.
class CircleGroup extends BasicCoordsItem {
  /// The radius of all the circles.
  double _radius;

  /// Creates a new circle plotter item.
  CircleGroup(this._radius) : super._(2);

  List<double> get _lefts => this._coords[0];
  List<double> get _tops => this._coords[1];

  /// The radius for all the circles.
  double get radius => this._radius;
  set radius(double radius) => this._radius = radius;

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) =>
    r.drawCircSet(this._lefts, this._tops, this._radius);

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = this.count - 1; i >= 0; --i) b.expand(this._lefts[i], this._tops[i]);
    if (!b.isEmpty) {
      b.expand(b.xmin - this._radius, b.ymin - this._radius);
      b.expand(b.xmax + this._radius, b.ymax + this._radius);
    }
    return trans.transform(b);
  }
}
