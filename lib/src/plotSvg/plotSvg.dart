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

  /// Indicates that a refresh is pending.
  bool _pendingRender;

  /// Creates a plotter that outputs SVG.
  PlotSvg.fromElem(this._targetDiv, this._plotter) {
    _svg = new svg.SvgSvgElement();
    _svg.style
      ..margin = "0px"
      ..padding = "0px"
      ..width = "100%"
      ..height = "100%";

    _svg
      ..onResize.listen(_resize)
      ..onMouseDown.listen(_mouseDown)
      ..onMouseMove.listen(_mouseMove)
      ..onMouseUp.listen(_mouseUp)
      ..onMouseWheel.listen(_mouseWheelMoved);

    html.window.onResize.listen(_resize);

    _pendingRender = false;
    _targetDiv.append(_svg);
    refresh();
  }

  /// Creates a plotter that outputs SVG.
  factory PlotSvg(String targetDivId, Plotter plot) {
    return new PlotSvg.fromElem(html.querySelector('#' + targetDivId), plot);
  }

  /// Refreshes the SVG drawing.
  void refresh() {
    if (!_pendingRender) {
      _pendingRender = true;
      html.window.requestAnimationFrame((num t) {
        if (_pendingRender) {
          _pendingRender = false;
          _draw();
        }
      });
    }
  }

  /// Draws to the target with SVG.
  void _draw() {
    Renderer r = new Renderer._(_svg, _window, _projection);
    r.clear();
    _plotter.render(r);
    r.finalize();
  }

  /// The width of the div that is being plotted to.
  double get _width {
    var box = _svg.getBoundingClientRect();
    return (box.right - box.left).toDouble();
  }

  /// The height of the div that is being plotted to.
  double get _height {
    var box = _svg.getBoundingClientRect();
    return (box.bottom - box.top).toDouble();
  }

  /// Gets the transformer for the plot target div.
  /// This is the projection from the view coordinates to the window coordinates.
  Transformer get _projection {
    double width = _width;
    double height = _height;
    double size = math.min(width, height);
    if (size <= 0.0) size = 1.0;
    return new Transformer(size, size, 0.5 * width, 0.5 * height);
  }

  /// Gets the window size for the plot.
  Bounds get _window => new Bounds(0.0, 0.0, _width, _height);

  /// Called when the svg is resized.
  void _resize(html.Event _) {
    refresh();
  }

  /// Creates a mouse event for a dart mouse event.
  MouseEvent _mouseLoc(html.MouseEvent e) {
    return new MouseEvent(_window, _projection, e.offset.x.toDouble(), e.offset.y.toDouble(),
        new MouseButtonState(e.button, shiftKey: e.shiftKey, ctrlKey: e.ctrlKey, altKey: e.altKey));
  }

  /// Called when the mouse button is pressed on the panel.
  void _mouseDown(html.MouseEvent e) {
    e.stopPropagation();
    e.preventDefault();
    MouseEvent me = _mouseLoc(e);
    _plotter.onMouseDown(me);
    if (me.redraw) refresh();
  }

  /// Called when the mouse is moved with the button down.
  void _mouseMove(html.MouseEvent e) {
    e.stopPropagation();
    e.preventDefault();
    MouseEvent me = _mouseLoc(e);
    _plotter.onMouseMove(me);
    if (me.redraw) refresh();
  }

  /// Called when the mouse button is released.
  void _mouseUp(html.MouseEvent e) {
    e.stopPropagation();
    e.preventDefault();
    MouseEvent me = _mouseLoc(e);
    _plotter.onMouseUp(me);
    if (me.redraw) refresh();
  }

  /// Called when the mouse wheel is moved.
  void _mouseWheelMoved(html.WheelEvent e) {
    e.stopPropagation();
    e.preventDefault();
    MouseEvent me = _mouseLoc(e);
    double dw = e.deltaY.toDouble() / 1000.0;
    _plotter.onMouseWheel(me, dw);
    if (me.redraw) refresh();
  }
}
