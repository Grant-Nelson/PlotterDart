part of plotter;

/// A mouse handler for outputting coordinates of the mouse, typically to be displayed.
class MouseCoords implements IMouseHandle {
  /// The plotter this mouse handle is changing.
  Plotter _plot;

  /// The lines for the crosshairs.
  Text _text;

  /// Creates a new coordinate handler.
  MouseCoords(this._plot) {
    _text = _plot.addText(0.0, 0.0, 12.0, "");
  }

  /// handles mouse down.
  void mouseDown(MouseEvent e) {}

  /// handles mouse moved.
  void mouseMove(MouseEvent e) {
    String x = _plot.view.untransformX(e.px).toStringAsPrecision(3);
    String y = _plot.view.untransformY(e.py).toStringAsPrecision(3);
    _text
      ..x = (e.x + 3)
      ..y = (e.y - 3)
      ..text = "$x, $y";
    e.redraw = true;
  }

  /// handles mouse up.
  void mouseUp(MouseEvent e) {}
}
