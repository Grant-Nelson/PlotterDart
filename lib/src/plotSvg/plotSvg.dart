library plotSvg;

import 'dart:html' as html;
import 'dart:math' as math;
import 'dart:svg' as svg;

import '../plotter/plotter.dart';

part 'renderer.dart';

/// Plotter renderer which outputs SVG.
class PlotSvg implements IPlot {
  /// The target html div to write to.
  html.Element _targetDiv;

  /// The SVG element.
  svg.SvgSvgElement _svg;

  /// The plotter to render.
  Plotter _plotter;

  /// The renderer used to plot with.
  Renderer _renderer;

  /// Indicates that a refresh is pending.
  bool _pendingRender;

  /// Creates a plotter that outputs SVG.
  PlotSvg.fromElem(this._targetDiv, this._plotter) {
    this._svg = new svg.SvgSvgElement();
    this._renderer = new Renderer._(this._svg);
    this._svg.style
      ..margin  = "0px"
      ..padding = "0px"
      ..width   = "100%"
      ..height  = "100%";

    this._svg
      ..onResize.listen(this._resize)
      ..onMouseDown.listen(this._mouseDown)
      ..onMouseMove.listen(this._mouseMove)
      ..onMouseUp.listen(this._mouseUp)
      ..onMouseWheel.listen(this._mouseWheelMoved);

    html.window.onResize.listen(this._resize);

    this._pendingRender = false;
    this._targetDiv.append(this._svg);
    this.refresh();
  }

  /// Creates a plotter that outputs SVG.
  factory PlotSvg(String targetDivId, Plotter plot) =>
    new PlotSvg.fromElem(html.querySelector('#' + targetDivId), plot);

  /// Refreshes the SVG drawing.
  void refresh() {
    if (!this._pendingRender) {
      this._pendingRender = true;
      html.window.requestAnimationFrame((num t) {
        if (this._pendingRender) {
          this._pendingRender = false;
          this._draw();
        }
      });
    }
  }

  /// Gets the plotter to render.
  Plotter get plotter => this._plotter;

  /// Draws to the target with SVG.
  void _draw() {
    this._renderer.reset(this._window, this._projection);
    this._plotter.render(this._renderer);
    this._renderer.finalize();
  }

  /// The width of the div that is being plotted to.
  double get _width {
    html.Rectangle<num> box = this._svg.getBoundingClientRect();
    return (box.right - box.left).toDouble();
  }

  /// The height of the div that is being plotted to.
  double get _height {
    html.Rectangle<num> box = this._svg.getBoundingClientRect();
    return (box.bottom - box.top).toDouble();
  }

  /// Gets the transformer for the plot target div.
  /// This is the projection from the view coordinates to the window coordinates.
  Transformer get _projection {
    double width = this._width;
    double height = this._height;
    double size = math.min(width, height);
    if (size <= 0.0) size = 1.0;
    return new Transformer(size, size, 0.5 * width, 0.5 * height);
  }

  /// Gets the window size for the plot.
  Bounds get _window => new Bounds(0.0, 0.0, this._width, this._height);

  /// Called when the svg is resized.
  void _resize(html.Event _) => refresh();

  /// Creates a mouse event for a dart mouse event.
  MouseEvent _mouseLoc(html.MouseEvent e) {
    svg.Point pt = this._svg.createSvgPoint();
    pt.x = e.client.x;
    pt.y = e.client.y;
    svg.Point local = pt.matrixTransform(this._svg.getScreenCtm().inverse());
    return new MouseEvent(this._window, this._projection, local.x, local.y,
      new MouseButtonState(e.button, shiftKey: e.shiftKey, ctrlKey: e.ctrlKey, altKey: e.altKey));
  }

  /// Called when the mouse button is pressed on the panel.
  void _mouseDown(html.MouseEvent e) {
    e.stopPropagation();
    e.preventDefault();
    MouseEvent me = this._mouseLoc(e);
    this._plotter.onMouseDown(me);
    if (me.redraw) this.refresh();
  }

  /// Called when the mouse is moved with the button down.
  void _mouseMove(html.MouseEvent e) {
    e.stopPropagation();
    e.preventDefault();
    MouseEvent me = this._mouseLoc(e);
    this._plotter.onMouseMove(me);
    if (me.redraw) this.refresh();
  }

  /// Called when the mouse button is released.
  void _mouseUp(html.MouseEvent e) {
    e.stopPropagation();
    e.preventDefault();
    MouseEvent me = this._mouseLoc(e);
    this._plotter.onMouseUp(me);
    if (me.redraw) this.refresh();
  }

  /// Called when the mouse wheel is moved.
  void _mouseWheelMoved(html.WheelEvent e) {
    e.stopPropagation();
    e.preventDefault();
    MouseEvent me = this._mouseLoc(e);
    double dw = e.deltaY.toDouble() / 1000.0;
    this._plotter.onMouseWheel(me, dw);
    this._plotter.onMouseMove(me);
    if (me.redraw) this.refresh();
  }
}
