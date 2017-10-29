import 'package:plotterDart/plotter.dart' as plotter;
import 'package:plotterDart/plotSvg.dart' as plotSvg;

void main() {
  plotter.Plotter plot = new plotter.Plotter();

  plot.addLines([10.0, 10.0, -10.0, -10.0, -10.0, 10.0, 10.0, -10.0]);
  //plot.addLines([12.1, 10.1, 10.9, 10.1, 10.9, 11.1, 6.9, 10.9, 10.9, 10.9, 10.1, 13.9, 10.1, 4.9, 10.1, 10.1]);
  //plot.addPoints(
  //    [12.1, 10.1, 10.9, 10.1, 10.9, 11.1, 6.9, 10.9, 10.9, 10.9, 10.1, 13.9, 10.1, 4.9, 10.1, 10.1]).addPointSize(4.0);
  plot.updateBounds();
  plot.focusOnData();
  plot.MouseHandles.add(new PointAdder(plot));

  new plotSvg.PlotSvg("output", plot);
}

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

  void mouseDown(plotter.MouseEvent e) {
    if (e.state.equals(_state)) {
      _mouseDown = true;
      _points.add([e.x, e.y]);
      e.redraw = true;
    }
  }

  void mouseMove(plotter.MouseEvent e) {
    if (_mouseDown) {
      _points.set(_points.count-1, [e.x, e.y]);
      e.redraw = true;
    }
  }

  void mouseUp(plotter.MouseEvent e) {
    if (_mouseDown) {
      _points.set(_points.count-1, [e.x, e.y]);
      _mouseDown = false;
      e.redraw = true;
    }
  }
}
