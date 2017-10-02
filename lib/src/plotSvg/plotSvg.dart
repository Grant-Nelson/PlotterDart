library plotSvg;

import 'dart:html' as dom;
import 'dart:math' as math;
import '../plotter/plotter.dart';

part 'renderer.dart';

class PlotSvg {

    // The identifier of the target html dive to write to.
    final String _targetDivId;

    // The target html div to write to.
    dom.Element _targetDiv;

    // The SVG html validator.
    dom.NodeValidatorBuilder _svgValidator;

    // The plotter to render.
    Plotter _plotter;

    // The start dx when panning the view.
    double _startdx;

    // The start dy when panning the view.
    double _startdy;

    // The initial mouse x location on a mouse pressed.
    int _msx;

    // The initial mouse y location on a mouse pressed.
    int _msy;

    // True indicates a mouse pan has been started.
    bool _panStarted;

    /**
     * Creates a plotter that outputs SVG.
     */
    PlotSvg(this._targetDivId, this._plotter) {
        this._svgValidator = new dom.NodeValidatorBuilder()
          ..allowSvg();
        this._targetDiv = dom.querySelector('#'+this._targetDivId);
        this._startdx = 0.0;
        this._startdy = 0.0;
        this._msx = 0;
        this._msy = 0;
        this._panStarted = false;

        this._targetDiv.onResize.listen((e) => this._draw());
        this._targetDiv.onMouseDown.listen((e) => this._mouseDown(e));
        this._targetDiv.onMouseMove.listen((e) => this._mouseMove(e));
        this._targetDiv.onMouseUp.listen((e) => this._mouseUp(e));
        this._targetDiv.onMouseWheel.listen((e) => this._mouseWheelMoved(e));
        this._draw();
    }

    /**
     * The width of the div that is being plotted to.
     */
    double _width() {
      return this._targetDiv.clientWidth.toDouble();
    }

    /**
     * The height of the div that is being plotted to.
     */
    double _height() {
      return this._targetDiv.clientHeight.toDouble();
    }

    /**
     * Gets the transformer for the plot target div.
     */
    Transformer _trans() {
        double width = this._width();
        double height = this._height();
        double size = math.min(width, height);
        return new Transformer(size, size, 0.5*width, 0.5*height);
    }

    /**
     * Draws to the target with SVG.
     */
    void _draw() {
        double width = this._width();
        double height = this._height();
        Bounds window = new Bounds(0.0, 0.0, width, height);

        var r = new Renderer(window, this._trans());
        r.clear();
        this._plotter.render(r);
        var svg = r.output();

        _targetDiv.setInnerHtml(svg, validator: _svgValidator);
    }

    /**
     * Called when the mouse button is pressed on the panel.
     * @param e The mouse event for the button pressed.
     */
    void _mouseDown(dom.MouseEvent e) {
        e.stopPropagation();
        if (e.button == 0) {
            this._panStarted = true;
            this._msx = e.client.x;
            this._msy = e.client.y;
            this._startdx = this._plotter.view().dx();
            this._startdy = this._plotter.view().dy();
        }
    }

    /**
     * Called when the mouse is moved with the button down.
     * @param e The mouse event for the drag.
     */
    void _mouseMove(dom.MouseEvent e) {
        e.stopPropagation();
        if (this._panStarted) {
            double scale = math.min(this._width(), this._height());
            double dx = (e.client.x-this._msx).toDouble()/scale;
            double dy = (this._msy-e.client.y).toDouble()/scale;
            this._plotter.setViewOffset(dx+this._startdx, dy+this._startdy);
            this._draw();
        }
    }

    /**
     * Called when the mouse button is released.
     * @param e The mouse event for the button release.
     */
    void _mouseUp(dom.MouseEvent e) {
        e.stopPropagation();
        this._panStarted = false;
    }

    /**
     * Called when the mouse wheel is moved.
     * @param e The mouse event for the wheel move.
     */
    void _mouseWheelMoved(dom.WheelEvent e) {
        e.stopPropagation();
        e.preventDefault();
        Transformer trans = this._trans();
        double dx = trans.untransformX(e.client.x.toDouble());
        double dy = trans.untransformY(this._height()-e.client.y.toDouble());
        double dw = e.deltaY.toDouble()/1000.0;
        this._plotter.deltaViewZoom(dx, dy, dw);
        this._draw();
    }
}
