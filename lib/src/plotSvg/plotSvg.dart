library plotSvg;

import 'dart:html' as html;
import 'dart:math' as math;
import '../plotter/plotter.dart';

part 'renderer.dart';

/// Plotter renderer which outputs SVG.
class PlotSvg {
  /// The target html div to write to.
  html.Element _targetDiv;

  /// The SVG html validator.
  html.NodeValidatorBuilder _svgValidator;

  /// The plotter to render.
  Plotter _plotter;

  /// The start dx when panning the view.
  double _startdx;

  /// The start dy when panning the view.
  double _startdy;

  /// The initial mouse x location on a mouse pressed.
  int _msx;

  /// The initial mouse y location on a mouse pressed.
  int _msy;

  /// True indicates a mouse pan has been started.
  bool _panStarted;

  /// Creates a plotter that outputs SVG.
  PlotSvg.fromElem(html.Element div, this._plotter) {
    _svgValidator = new html.NodeValidatorBuilder()..allowSvg();
    _targetDiv = div;
    _startdx = 0.0;
    _startdy = 0.0;
    _msx = 0;
    _msy = 0;
    _panStarted = false;

    _targetDiv.onResize.listen((e) => _draw());
    _targetDiv.onMouseDown.listen((e) => _mouseDown(e));
    _targetDiv.onMouseMove.listen((e) => _mouseMove(e));
    _targetDiv.onMouseUp.listen((e) => _mouseUp(e));
    _targetDiv.onMouseWheel.listen((e) => _mouseWheelMoved(e));
    _draw();
  }

  /// Creates a plotter that outputs SVG.
  factory PlotSvg(String targetDivId, Plotter plot) {
    return new PlotSvg.fromElem(html.querySelector('#' + targetDivId), plot);
  }

  /// The width of the div that is being plotted to.
  double get _width => _targetDiv.clientWidth.toDouble();

  /// The height of the div that is being plotted to.
  double get _height => _targetDiv.clientHeight.toDouble();

  /// Gets the transformer for the plot target div.
  Transformer get _trans {
    double width = _width;
    double height = _height;
    double size = math.min(width, height);
    if (size <= 0.0) size = 1.0;
    return new Transformer(size, size, 0.5 * width, 0.5 * height);
  }

  /// Draws to the target with SVG.
  void _draw() {
    double width = _width;
    double height = _height;
    Bounds window = new Bounds(0.0, 0.0, width, height);
    var r = new Renderer(window, _trans);
    r.clear();
    _plotter.render(r);
    var svg = r.output;

    _targetDiv.setInnerHtml(svg, validator: _svgValidator);
  }

  /// Called when the mouse button is pressed on the panel.
  void _mouseDown(html.MouseEvent e) {
    e.stopPropagation();
    if (e.button == 0) {
      _panStarted = true;
      _msx = e.client.x;
      _msy = e.client.y;
      _startdx = _plotter.view.dx;
      _startdy = _plotter.view.dy;
    }
  }

  /// Called when the mouse is moved with the button down.
  void _mouseMove(html.MouseEvent e) {
    e.stopPropagation();
    if (_panStarted) {
      double scale = math.min(_width, _height);
      double dx = (e.client.x - _msx).toDouble() / scale;
      double dy = (_msy - e.client.y).toDouble() / scale;
      _plotter.setViewOffset(dx + _startdx, dy + _startdy);
      _draw();
    }
  }

  /// Called when the mouse button is released.
  void _mouseUp(html.MouseEvent e) {
    e.stopPropagation();
    _panStarted = false;
  }

  /// Called when the mouse wheel is moved.
  void _mouseWheelMoved(html.WheelEvent e) {
    e.stopPropagation();
    e.preventDefault();
    Transformer trans = _trans;
    double dx = trans.untransformX(e.offset.x.toDouble());
    double dy = trans.untransformY(_height - e.offset.y.toDouble());
    double dw = e.deltaY.toDouble() / 1000.0;
    _plotter.deltaViewZoom(dx, dy, dw);
    _draw();
  }
}
