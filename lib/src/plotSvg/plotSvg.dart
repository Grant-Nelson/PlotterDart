library plotSvg;

import 'dart:html' as html;
import 'dart:math' as math;
import 'dart:svg' as svg;

import '../plotter/plotter.dart';

part 'renderer.dart';

/// Plotter renderer which outputs SVG.
class PlotSvg {
  /// The target html div to write to.
  html.Element _targetDiv;

  /// The SVG element.
  svg.SvgSvgElement _svg;

  /// The plotter to render.
  Plotter _plotter;

  /// Creates a plotter that outputs SVG.
  PlotSvg.fromElem(this._targetDiv, this._plotter) {
    _svg = new svg.SvgSvgElement();
    _svg.style
      ..margin = "0px"
      ..padding = "0px"
      ..width = "100%"
      ..height = "100%";

    _svg
      ..onResize.listen((e) => _draw())
      ..onMouseDown.listen((e) => _mouseDown(e))
      ..onMouseMove.listen((e) => _mouseMove(e))
      ..onMouseUp.listen((e) => _mouseUp(e))
      ..onMouseWheel.listen((e) => _mouseWheelMoved(e));

    _targetDiv.append(_svg);
    _draw();
  }

  /// Creates a plotter that outputs SVG.
  factory PlotSvg(String targetDivId, Plotter plot) {
    return new PlotSvg.fromElem(html.querySelector('#' + targetDivId), plot);
  }

  /// The width of the div that is being plotted to.
  double get _width => _svg.clientWidth.toDouble();

  /// The height of the div that is being plotted to.
  double get _height => _svg.clientHeight.toDouble();

  /// Gets the transformer for the plot target div.
  Transformer get _trans {
    double width = _width;
    double height = _height;
    double size = math.min(width, height);
    if (size <= 0.0) size = 1.0;
    return new Transformer(size, size, 0.5 * width, 0.5 * height);
  }

  /// Gets the window size for the plot.
  Bounds get _window => new Bounds(0.0, 0.0, _width, _height);

  /// Draws to the target with SVG.
  void _draw() {
    Renderer r = new Renderer(_svg, _window, _trans);
    r.clear();
    _plotter.render(r);
  }

  /// Creates a mouse event for a dart mouse event.
  MouseEvent _mouseLoc(html.MouseEvent e) {
    Transformer trans2 = _trans.mul(_plotter.view);
    return new MouseEvent(_window, trans2, e.client.x.toDouble(), e.client.y.toDouble(),
      new MouseButtonState(e.button, shiftKey: e.shiftKey, ctrlKey: e.ctrlKey, altKey: e.altKey));
  }

  /// Called when the mouse button is pressed on the panel.
  void _mouseDown(html.MouseEvent e) {
    e.stopPropagation();
    e.preventDefault();
    MouseEvent me = _mouseLoc(e);
    _plotter.onMouseDown(me);
    if (me.redraw) _draw();
  }

  /// Called when the mouse is moved with the button down.
  void _mouseMove(html.MouseEvent e) {
    e.stopPropagation();
    e.preventDefault();
    MouseEvent me = _mouseLoc(e);
    _plotter.onMouseMove(me);
    if (me.redraw) _draw();
  }

  /// Called when the mouse button is released.
  void _mouseUp(html.MouseEvent e) {
    e.stopPropagation();
    e.preventDefault();
    MouseEvent me = _mouseLoc(e);
    _plotter.onMouseUp(me);
    if (me.redraw) _draw();
  }

  /// Called when the mouse wheel is moved.
  void _mouseWheelMoved(html.WheelEvent e) {
    e.stopPropagation();
    e.preventDefault();
    MouseEvent me = _mouseLoc(e);
    double dw = e.deltaY.toDouble() / 1000.0;
    _plotter.onMouseWheel(me, dw);
    if (me.redraw) _draw();
  }
}
