part of plotter;

/// A plotter item for drawing ellipses.{
/// The points are the top-left corner of the ellipses.
class EllipseGroup extends BasicCoordsItem {
  /// The x radius of all the ellipses.
  double _xRadius;

  /// The y radius of all the ellipses.
  double _yRadius;

  /// Creates a new ellipse plotter item.
  EllipseGroup(this._xRadius, this._yRadius) : super._(2);

  List<double> get _centerXs => this._coords[0];
  List<double> get _centerYs => this._coords[1];

  /// The width for all the ellipses.
  double get xRadii => this._xRadius;
  set xRadii(double xRadii) => this._xRadius = xRadii;

  /// The height for all the ellipses.
  double get yRadii => this._yRadius;
  set yRadii(double yRadii) => this._yRadius = yRadii;

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) =>
    r.drawEllipseSet(this._centerXs, this._centerYs, this._xRadius, this._yRadius);

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = this.count - 1; i >= 0; --i)
      b.expand(this._centerXs[i], this._centerYs[i]);
    if (!b.isEmpty) {
      b.expand(b.xmin - this._xRadius, b.ymin - this._yRadius);
      b.expand(b.xmax + this._xRadius, b.ymax + this._yRadius);
    }
    return trans.transform(b);
  }
}
