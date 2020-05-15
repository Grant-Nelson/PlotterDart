part of main;

class PointAdder implements plotter.IMouseHandle {
  plotter.Plotter _plot;
  plotter.MouseButtonState _state;
  bool _mouseDown;
  plotter.Points _points;

  PointAdder(this._plot) {
    this._state = new plotter.MouseButtonState(0, shiftKey: true);
    this._mouseDown = false;
    this._points = this._plot.addPoints([])
      ..addPointSize(4.0)
      ..addColor(1.0, 0.0, 0.0);
  }

  List<double> transMouse(plotter.MouseEvent e) {
    plotter.Transformer trans = e.projection.mul(this._plot.view);
    return [trans.untransformX(e.x), trans.untransformY(e.window.ymax - e.y)];
  }

  void mouseDown(plotter.MouseEvent e) {
    if (e.state.equals(this._state)) {
      this._mouseDown = true;
      this._points.add(transMouse(e));
      e.redraw = true;
    }
  }

  void mouseMove(plotter.MouseEvent e) {
    if (this._mouseDown) {
      this._points.set(this._points.count - 1, this.transMouse(e));
      e.redraw = true;
    }
  }

  void mouseUp(plotter.MouseEvent e) {
    if (this._mouseDown) {
      this._points.set(this._points.count - 1, this.transMouse(e));
      this._mouseDown = false;
      e.redraw = true;
    }
  }
}
