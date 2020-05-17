part of plotter;

/// A plotter item for drawing ellipses.
/// The coordinates are the top-left corner and radii.
class Circles extends BasicCoordsItem {
  /// Creates a new ellipse plotter item.
  Circles() : super._(3);

  List<double> get _lefts => this._coords[0];
  List<double> get _tops => this._coords[1];
  List<double> get _radii => this._coords[2];

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) =>
    r.drawCircs(this._lefts, this._tops, this._radii);

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = this.count - 1; i >= 0; --i) {
      double r = this._radii[i];
      double x = this._lefts[i] - r;
      double y = this._tops[i] - r;
      double d = 2.0 * r;
      b.expand(x, y);
      b.expand(x + d, y + d);
    }
    return trans.transform(b);
  }
}
