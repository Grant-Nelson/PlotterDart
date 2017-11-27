part of plotSvg;

/// A renderer for drawing SVG plots.
class Renderer extends IRenderer {
  /// SVG validator for adding HTML.
  html.NodeValidatorBuilder _svgValidator;

  /// The element to add graphics to.
  svg.SvgSvgElement _svg;

  /// The buffer to temporarily store SVG while drawing.
  StringBuffer _sout;

  /// The bounds of the panel.
  Bounds _window;

  /// The bounds of the data.
  Bounds _dataBounds;

  /// The current transformer for the plot.
  Transformer _trans;

  /// The current point size.
  double _pointSize;

  /// The current background color.
  Color _backClr;

  /// The current line color.
  Color _lineClr;

  /// The CSS draw color currently set.
  String _lineClrStr;

  /// The CSS draw color currently set.
  String _pointClrStr;

  /// The current fill color or null for no fill.
  Color _fillClr;

  /// The CSS fill color currently set.
  String _fillClrStr;

  /// The flag indicating if lines should be drawn directed.
  bool _lineDir;

  /// Creates a new renderer.
  Renderer._(this._svg, this._window, this._trans) {
    _svgValidator = new html.NodeValidatorBuilder()..allowSvg();
    _sout = new StringBuffer();
    _dataBounds = new Bounds.empty();
    _pointSize = 0.0;
    _backClr = new Color(1.0, 1.0, 1.0);
    color = new Color(0.0, 0.0, 0.0);
    fillColor = null;
    _lineDir = false;
  }

  /// The data bounds.
  Bounds get dataBounds => _dataBounds;
  set dataBounds(Bounds dataBounds) => _dataBounds = dataBounds;

  /// Gets the bounds of the panel being drawn on.
  Bounds get window => _window;

  /// Gets the viewport into the window with the given transformation.
  Bounds get viewport => _trans.transform(_window);

  /// The transformer for the current data.
  Transformer get transform => _trans;
  set transform(Transformer trans) => _trans = trans;

  /// The point size to draw points with.
  double get pointSize => _pointSize;
  set pointSize(double size) => _pointSize = size;

  /// The background color to clear to.
  Color get backgroundColor => _backClr;
  void set backgroundColor(Color color) => _backClr = color;

  /// The color to draw lines with.
  Color get color => _lineClr;
  void set color(Color color) {
    _lineClr = color;
    String drawClr = _getColorString(color);
    _lineClrStr = "stroke=\"$drawClr\" stroke-opacity=\"${color.alpha}\" ";
    _pointClrStr = "fill=\"$drawClr\" fill-opacity=\"${color.alpha}\" ";
  }

  /// The color to fill shapes with.
  Color get fillColor => _fillClr;
  void set fillColor(Color color) {
    _fillClr = color;
    if (color != null) {
      String fillClr = _getColorString(color);
      _fillClrStr = "fill=\"$fillClr\" fill-opacity=\"${color.alpha}\" ";
    } else
      _fillClrStr = "fill=\"none\" ";
  }

  /// Indicates if the lines should be drawn directed (with arrows), or not.
  bool get directedLines => _lineDir;
  set directedLines(bool directed) => _lineDir = directed;

  /// Clears the panel to white.
  void clear() {
    _svg.nodes.clear();
    _svg.attributes["viewBox"] = "0 0 ${_window.width} ${_window.height}";
    _svg.style.backgroundColor = _getColorString(_backClr);
    _sout.clear();
  }

  /// Draws a point to the viewport.
  void drawPoint(double x, double y) {
    x = _transX(x);
    y = _transY(y);
    double r = (_pointSize <= 1.0) ? 1.0 : _pointSize;
    _writePoint(x, y, r);
  }

  /// Draws a set of points to the viewport.
  void drawPoints(List<double> xCoords, List<double> yCoords) {
    assert(xCoords.length == yCoords.length);
    for (int i = xCoords.length - 1; i >= 0; --i) {
      drawPoint(xCoords[i], yCoords[i]);
    }
  }

  /// Draws a line to the viewport.
  void drawLine(double x1, double y1, double x2, double y2) {
    double tx1 = _transX(x1);
    double ty1 = _transY(y1);
    double tx2 = _transX(x2);
    double ty2 = _transY(y2);
    _writeLine(tx1, ty1, tx2, ty2);

    if (_lineDir) {
      double dx = x2 - x1;
      double dy = y2 - y1;
      double length = math.sqrt((dx * dx) + (dy * dy));
      if (length > 1.0e-12) {
        dx /= length;
        dy /= length;
        double width = 6.0;
        double height = 4.0;
        double tx3 = tx2 - dx * width;
        double dx3 = dy * height;
        double ty3 = ty2 + dy * width;
        double dy3 = dx * height;
        _writeLine(tx2, ty2, tx3 + dx3, ty3 + dy3);
        _writeLine(tx2, ty2, tx3 - dx3, ty3 - dy3);
      }
    }

    if (_pointSize > 1.0) {
      drawPoint(x1, y1);
      drawPoint(x2, y2);
    }
  }

  /// Draws a set of lines to the viewport.
  void drawLines(List<double> x1Coords, List<double> y1Coords, List<double> x2Coords, List<double> y2Coords) {
    assert(x1Coords.length == y1Coords.length);
    assert(x1Coords.length == x2Coords.length);
    assert(x1Coords.length == y2Coords.length);
    for (int i = x1Coords.length - 1; i >= 0; --i) {
      drawLine(x1Coords[i], y1Coords[i], x2Coords[i], y2Coords[i]);
    }
  }

  /// Draws a rectangle to the viewport.
  void drawRect(double x1, double y1, double x2, double y2) {
    x1 = _transX(x1);
    y1 = _transY(y1);
    x2 = _transX(x2);
    y2 = _transY(y2);
    double width = x2 - x1;
    double height = y1 - y2;
    _writeRect(x1, y2, width, height);
  }

  /// Draws a set of rectangles to the viewport.
  void drawRects(List<double> xCoords, List<double> yCoords, List<double> widths, List<double> heights) {
    assert(xCoords.length == yCoords.length);
    assert(xCoords.length == widths.length);
    assert(xCoords.length == heights.length);
    for (int i = xCoords.length - 1; i >= 0; --i) {
      double x = xCoords[i];
      double y = yCoords[i];
      drawRect(x, y, x + widths[i], y + heights[i]);
    }
  }

  /// Draws a set of rectangles to the viewport.
  void drawRectSet(List<double> xCoords, List<double> yCoords, double width, double height) {
    assert(xCoords.length == yCoords.length);
    for (int i = xCoords.length - 1; i >= 0; --i) {
      double x = xCoords[i];
      double y = yCoords[i];
      drawRect(x, y, x + width, y + height);
    }
  }

  /// Draws an ellipse to the viewport.
  void drawEllip(double x1, double y1, double x2, double y2) {
    x1 = _transX(x1);
    y1 = _transY(y1);
    x2 = _transX(x2);
    y2 = _transY(y2);
    if (x1 > x2) {
      double temp = x1;
      x1 = x2;
      x2 = temp;
    }
    if (y1 > y2) {
      double temp = y1;
      y1 = y2;
      y2 = temp;
    }
    double rx = (x2 - x1) * 0.5;
    double ry = (y2 - y1) * 0.5;
    double cx = x1 + rx;
    double cy = y1 + ry;
    _writeEllipse(cx, cy, rx, ry);
  }

  /// Draws a set of ellipses to the viewport.
  void drawEllips(List<double> xCoords, List<double> yCoords, List<double> widths, List<double> heights) {
    assert(xCoords.length == yCoords.length);
    assert(xCoords.length == widths.length);
    assert(xCoords.length == heights.length);
    for (int i = xCoords.length - 1; i >= 0; --i) {
      double x = xCoords[i];
      double y = yCoords[i];
      drawEllip(x, y, x + widths[i], y + heights[i]);
    }
  }

  /// Draws a set of ellipses to the viewport.
  void drawEllipsSet(List<double> xCoords, List<double> yCoords, double width, double height) {
    assert(xCoords.length == yCoords.length);
    for (int i = xCoords.length - 1; i >= 0; --i) {
      double x = xCoords[i];
      double y = yCoords[i];
      drawEllip(x, y, x + width, y + height);
    }
  }

  /// Draws a set of circles to the viewport.
  void drawCircs(List<double> xCoords, List<double> yCoords, List<double> radius) {
    assert(xCoords.length == yCoords.length);
    assert(xCoords.length == radius.length);
    for (int i = xCoords.length - 1; i >= 0; --i) {
      double r = radius[i];
      double cx = xCoords[i];
      double cy = yCoords[i];
      double x2 = _transX(cx + r);
      double y2 = _transY(cy + r);
      cx = _transX(cx);
      cy = _transY(cy);
      double rx = x2 - cx;
      double ry = y2 - cy;
      _writeEllipse(cx, cy, rx, ry);
    }
  }

  /// Draws a set of circles to the viewport.
  void drawCircSet(List<double> xCoords, List<double> yCoords, double radius) {
    assert(xCoords.length == yCoords.length);
    for (int i = xCoords.length - 1; i >= 0; --i) {
      double cx = xCoords[i];
      double cy = yCoords[i];
      double x2 = _transX(cx + radius);
      double y2 = _transY(cy + radius);
      cx = _transX(cx);
      cy = _transY(cy);
      double rx = x2 - cx;
      double ry = y2 - cy;
      _writeEllipse(cx, cy, rx, ry);
    }
  }

  /// Draws a polygon to the viewport.
  void drawPoly(List<double> xCoords, List<double> yCoords) {
    assert(xCoords.length == yCoords.length);
    int count = xCoords.length;
    if (count >= 3) {
      double x = _transX(xCoords[0]);
      double y = _transY(yCoords[0]);
      _sout.write("<polygon points=\"$x,$y");
      for (int i = 1; i < count; ++i) {
        x = _transX(xCoords[i]);
        y = _transY(yCoords[i]);
        _sout.write(" $x,$y");
      }
      _sout.writeln("\" $_fillClrStr$_lineClrStr/>");
    }

    if (_pointSize > 1.0) {
      drawPoints(xCoords, yCoords);
    }
  }

  /// Draws a line strip to the viewport.
  void drawStrip(List<double> xCoords, List<double> yCoords) {
    assert(xCoords.length == yCoords.length);
    int count = xCoords.length;
    if (count >= 2) {
      double x = _transX(xCoords[0]);
      double y = _transY(yCoords[0]);
      _sout.write("<polyline points=\"$x,$y");
      for (int i = 1; i < count; ++i) {
        x = _transX(xCoords[i]);
        y = _transY(yCoords[i]);
        _sout.write(" $x,$y");
      }
      _sout.writeln("\" fill=\"none\" $_lineClrStr/>");
    }

    if (_pointSize > 1.0) {
      drawPoints(xCoords, yCoords);
    }
  }

  /// Finishes the render and applies the SVG.
  void finalize() {
    _svg.setInnerHtml(_sout.toString(), validator: _svgValidator);
  }

  /// Translates the given x value by the current transformer.
  double _transX(double x) {
    return _trans.transformX(x);
  }

  /// Translates the given y value by the current transformer.
  double _transY(double y) {
    return _window.ymax - _trans.transformY(y);
  }

  /// Gets the SVG color string for the given color.
  String _getColorString(Color color) {
    var r = (color.red * 255.0).floor();
    var g = (color.green * 255.0).floor();
    var b = (color.blue * 255.0).floor();
    return "rgb($r, $g, $b)";
  }

  /// Writes a point SVG to the buffer.
  void _writePoint(double x, double y, double r) {
    _sout.writeln("<circle cx=\"$x\" cy=\"$y\" r=\"$r\" $_pointClrStr />");
  }

  /// Writes a line SVG to the buffer.
  void _writeLine(double x1, double y1, double x2, double y2) {
    _sout.writeln("<line x1=\"$x1\" y1=\"$y1\" x2=\"$x2\" y2=\"$y2\" $_lineClrStr/>");
  }

  /// Writes a rectangle SVG to the buffer.
  void _writeRect(double x, double y, double width, double height) {
    _sout.writeln("<rect x=\"$x\" y=\"$y\" width=\"$width\" height=\"$height\" $_fillClrStr$_lineClrStr/>");
  }

  /// Writes an ellipse SVG to the buffer.
  void _writeEllipse(double cx, double cy, double rx, double ry) {
    _sout.writeln("<ellipse cx=\"$cx\" cy=\"$cy\" rx=\"$rx\" ry=\"$ry\" $_fillClrStr$_lineClrStr/>");
  }
}
