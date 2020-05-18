part of main;

class ArrowAdder implements plotter.IMouseHandle {
  plotter.Plotter _plot;
  plotter.MouseButtonState _state;
  bool _mouseDown;
  plotter.Lines _arrows;

  ArrowAdder(this._plot) {
    this._state = new plotter.MouseButtonState(0, ctrlKey: true);
    this._mouseDown = false;
    this._arrows = this._plot.addLines([])
      ..addDirected(true)
      ..addColor(1.0, 0.0, 0.0);
  }

  void mouseDown(plotter.MouseEvent e) {
    if (e.state.equals(this._state)) {
      this._mouseDown = true;
      this._arrows.add([e.vpx, e.vpy, e.vpx, e.vpy]);
      e.redraw = true;
    }
  }

  void mouseMove(plotter.MouseEvent e) {
    if (this._mouseDown) {
      List<double> points = this._arrows.get(this._arrows.count - 1, 1);
      points[2] = e.vpx;
      points[3] = e.vpy;
      this._arrows.set(this._arrows.count - 1, points);
      e.redraw = true;
    }
  }

  void mouseUp(plotter.MouseEvent e) {
    if (this._mouseDown) {
      List<double> points = this._arrows.get(this._arrows.count - 1, 1);
      points[2] = e.vpx;
      points[3] = e.vpy;
      this._arrows.set(this._arrows.count - 1, points);
      this._mouseDown = false;
      e.redraw = true;
    }
  }
}
