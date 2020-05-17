part of plotter;

/// A plotter item for drawing ellipses.
class Ellipses extends BasicCoordsItem {
  /// Creates a new ellipse plotter item.
  Ellipses() : super._(4);

  List<double> get _centerXs => this._coords[0];
  List<double> get _centerYs => this._coords[1];
  List<double> get _xRadii => this._coords[2];
  List<double> get _yRadii => this._coords[3];

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) =>
    r.drawEllipse(this._centerXs, this._centerYs, this._xRadii, this._yRadii);

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = this.count - 1; i >= 0; --i) {
      double xr = this._xRadii[i];
      double yr = this._yRadii[i];
      double x = this._centerXs[i];
      double y = this._centerYs[i];
      b.expand(x - xr, y - yr);
      b.expand(x + xr, y + yr);
    }
    return trans.transform(b);
  }
}
