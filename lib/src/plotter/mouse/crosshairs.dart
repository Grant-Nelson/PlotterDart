part of plotter;

/// Adds crosshairs at the mouse location.
class MouseCrosshairs implements IMouseHandle {
  /// The plotter this mouse handle is changing.
  Plotter _plot;

  /// The lines for the crosshairs.
  Lines _lines;

  /// Creates a new mouse crosshairs.
  MouseCrosshairs(this._plot) {
    _lines = _plot.addLines([])..addColor(1.0, 0.0, 0.0);
  }

  /// Implements interface but has no effect.
  void mouseDown(MouseEvent e) {}

  /// Handles mouse movement to update the crosshairs.
  void mouseMove(MouseEvent e) {
    Transformer trans = e.projection.mul(_plot.view);
    double x = trans.untransformX(e.x);
    double y = trans.untransformY(e.window.ymax - e.y);
    double d = x - trans.untransformX(e.x + 10.0);
    _lines.clear();
    _lines.add([x - d, y, x + d, y, x, y - d, x, y + d]);
    e.redraw = true;
  }

  /// Implements interface but has no effect.
  void mouseUp(MouseEvent e) {}
}
