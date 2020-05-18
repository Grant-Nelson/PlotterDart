part of plotter;

/// A plotter item for drawing ellipses.
/// The coordinates are the x and y center points and radii.
class Circles extends BasicCoordsItem {
  /// Creates a new ellipse plotter item.
  Circles() : super._(3);

  List<double> get _centerXs => this._coords[0];
  List<double> get _centerYs => this._coords[1];
  List<double> get _radii => this._coords[2];

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) =>
    r.drawCircs(this._centerXs, this._centerYs, this._radii);

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = this.count - 1; i >= 0; --i) {
      double r = this._radii[i];
      double x = this._centerXs[i];
      double y = this._centerYs[i];
      b.expand(x - r, y - r);
      b.expand(x + r, y + r);
    }
    return trans.transform(b);
  }
}
