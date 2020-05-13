part of plotter;

/// A plotter item for drawing lines.
class Lines extends BasicCoordsItem {
  /// Creates a new line plotter item.
  Lines() : super._(4);

  List<double> get _x1 => this._coords[0];
  List<double> get _y1 => this._coords[1];
  List<double> get _x2 => this._coords[2];
  List<double> get _y2 => this._coords[3];

  /// Draws the group to the panel.
  void _onDraw(IRenderer r) =>
    r.drawLines(this._x1, this._y1, this._x2, this._y2);

  /// Gets the bounds for the item.
  Bounds _onGetBounds(Transformer trans) {
    Bounds b = new Bounds.empty();
    for (int i = this.count - 1; i >= 0; --i) {
      b.expand(this._x1[i], this._y1[i]);
      b.expand(this._x2[i], this._y2[i]);
    }
    return trans.transform(b);
  }
}
