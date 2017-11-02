part of main;

class PointAdder implements plotter.iMouseHandle {
  plotter.Plotter _plot;
  plotter.MouseButtonState _state;
  bool _mouseDown;
  plotter.Points _points;

  PointAdder(this._plot) {
    _state = new plotter.MouseButtonState(0, shiftKey: true);
    _mouseDown = false;
    _points = _plot.addPoints([])
      ..addPointSize(4.0)
      ..addColor(1.0, 0.0, 0.0);
  }

  List<double> transMouse(plotter.MouseEvent e) {
    plotter.Transformer trans = e.projection.mul(_plot.view);
    return [trans.untransformX(e.x), trans.untransformY(e.window.ymax- e.y)];
  }

  void mouseDown(plotter.MouseEvent e) {
    if (e.state.equals(_state)) {
      _mouseDown = true;
      _points.add(transMouse(e));
      e.redraw = true;
    }
  }

  void mouseMove(plotter.MouseEvent e) {
    if (_mouseDown) {
      _points.set(_points.count - 1, transMouse(e));
      e.redraw = true;
    }
  }

  void mouseUp(plotter.MouseEvent e) {
    if (_mouseDown) {
      _points.set(_points.count - 1, transMouse(e));
      _mouseDown = false;
      e.redraw = true;
    }
  }
}
