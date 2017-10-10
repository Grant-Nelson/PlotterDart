part of plotSvg;

/**
 * A renderer for drawing SVG plots.
 */
class Renderer extends IRenderer {
  // The graphics object to draw to the panel with.
  StringBuffer _sout;

  // The bounds of the panel.
  Bounds _window;

  // The bounds of the data.
  Bounds _dataBounds;

  // The current transformer for the plot.
  Transformer _trans;

  // The current point size.
  double _pointSize;

  // The current background color.
  Color _backClr;

  // The current line color.
  Color _lineClr;

  // The CSS draw color currently set.
  String _lineClrStr;

  // The current fill color or null for no fill.
  Color _fillClr;

  // The CSS fill color currently set.
  String _fillClrStr;

  // The flag indicating if lines should be drawn directed.
  bool _lineDir;

  /**
     * Creates a new renderer.
     * @param window The bounds of the panel.
     * @param trans The current transformer for the plot.
     */
  Renderer(Bounds window, Transformer trans) {
    this._sout = new StringBuffer();
    this._window = window;
    this._dataBounds = new Bounds.empty();
    this._trans = trans;
    this._pointSize = 0.0;
    this._backClr = new Color(1.0, 1.0, 1.0);
    this.setColor(new Color(0.0, 0.0, 0.0));
    this.setFillColor(null);
    this._lineDir = false;
  }

  /**
     * Gets the created SVG elements as a string.
     * @return The SVG string.
     */
  String output() {
    return this._sout.toString() + "</svg>";
  }

  /**
     * Sets the data bounds.
     * @param dataBounds The bounds of the data to set.
     */
  void setDataBounds(Bounds dataBounds) {
    this._dataBounds = dataBounds;
  }

  /**
     * Gets the bounds of the panel being drawn on.
     * @return The bounds of the panel.
     */
  Bounds window() {
    return this._window;
  }

  /**
     * Gets the viewport into the window with the given transformation.
     * @return The current viewport bounds.
     */
  Bounds viewport() {
    return this._trans.transform(this._window);
  }

  /**
     * The bounds of the data.
     * @return The data bounds.
     */
  Bounds dataBounds() {
    return this._dataBounds;
  }

  /**
     * Gets the transformer for the current data.
     * @return The data transformer.
     */
  Transformer transform() {
    return this._trans;
  }

  /**
     * Sets the transformer for the current data.
     * @param trans The transformer to set.
     */
  void setTransform(Transformer trans) {
    this._trans = trans;
  }

  /**
     * Gets the point size to draw points with.
     * @return The point size to draw with.
     */
  double pointSize() {
    return this._pointSize;
  }

  /**
     * Sets the point size to draw points with.
     * @param size The point size to set.
     */
  void setPointSize(double size) {
    this._pointSize = size;
  }

  /**
     * Gets the background color to clear to.
     * @return The background color.
     */
  Color getBackgroundColor() {
    return this._backClr;
  }

  /**
     * Sets the background color to clear to.
     * @param color The background color to set.
     */
  void setBackgroundColor(Color color) {
    this._backClr = color;
  }

  /**
     * Gets the color to draw lines with.
     * @return The line color.
     */
  Color getColor() {
    return this._lineClr;
  }

  /**
     * Sets the color to draw lines with.
     * @param color The color to set.
     */
  void setColor(Color color) {
    this._lineClr = color;
    String drawClr = this._getColorString(color);
    this._lineClrStr =
        "stroke=\"$drawClr\" stroke-opacity=\"${color.alpha()}\" ";
  }

  /**
     * Gets the color to fill shapes with.
     * @return The fill color, nil for no fill.
     */
  Color getFillColor() {
    return this._fillClr;
  }

  /**
     * Sets the color to fill shapes with.
     * @param color The color to set.
     */
  void setFillColor(Color color) {
    this._fillClr = color;
    if (color != null) {
      String fillClr = this._getColorString(color);
      this._fillClrStr = "fill=\"$fillClr\" fill-opacity=\"${color.alpha()}\" ";
    } else
      this._fillClrStr = "fill=\"none\" ";
  }

  /**
     * Gets if the lines should be drawn directed (with arrows), or not.
     * @return  True if drawn directed, false otherwise.
     */
  bool getDirectedLines() {
    return this._lineDir;
  }

  /**
     * Sets if the lines should be drawn directed (with arrows), or not.
     * @param  directed  True to drawn directed, false otherwise.
     */
  void setDirectedLines(bool directed) {
    this._lineDir = directed;
  }

  /**
     * Clears the panel to white.
     */
  void clear() {
    this._sout.clear();
    String backClr = this._getColorString(this._backClr);
    var width = this._window.width();
    var height = this._window.height();
    this._sout.writeln(
        "<svg viewBox=\"0 0 $width $height\" style=\"background-color: $backClr\";>");
  }

  /**
     * Draws a point to the viewport.
     * @param x The x value of the point to draw.
     * @param y The y value of the point to draw.
     */
  void drawPoint(double x, double y) {
    x = this._transX(x);
    y = this._transY(y);
    double r = (this._pointSize <= 1.0) ? 1.0 : this._pointSize;
    this._writePoint(x, y, r);
  }

  /**
     * Draws a set of points to the viewport.
     * @param xCoords The x values of the points to draw.
     * @param yCoords The y values of the points to draw.
     */
  void drawPoints(List<double> xCoords, List<double> yCoords) {
    for (int i = xCoords.length - 1; i >= 0; --i) {
      this.drawPoint(xCoords[i], yCoords[i]);
    }
  }

  /**
     * Draws a line to the viewport.
     * @param x1 The x value of the first point.
     * @param y1 The y value of the first point.
     * @param x2 The x value of the second point.
     * @param y2 The y value of the second point.
     */
  void drawLine(double x1, double y1, double x2, double y2) {
    double tx1 = this._transX(x1);
    double ty1 = this._transY(y1);
    double tx2 = this._transX(x2);
    double ty2 = this._transY(y2);
    this._writeLine(tx1, ty1, tx2, ty2);

    if (this._lineDir) {
      double dx = x2 - x1;
      double dy = y2 - y1;
      double length = math.sqrt(dx * dx + dy * dy);
      if (length > 1.0e-12) {
        dx /= length;
        dy /= length;
        double width = 6.0;
        double height = 4.0;
        double tx3 = tx2 - dx * width;
        double dx3 = dy * height;
        double ty3 = tx2 + dy * width;
        double dy3 = dx * height;
        this._writeLine(tx2, ty2, tx3 + dx3, ty3 + dy3);
        this._writeLine(tx2, ty2, tx3 - dx3, ty3 - dy3);
      }
    }

    if (this._pointSize > 1.0) {
      this.drawPoint(x1, y1);
      this.drawPoint(x2, y2);
    }
  }

  /**
     * Draws a set of lines to the viewport.
     * @param x1Coords The x values of the first points.
     * @param y1Coords The y values of the first points.
     * @param x2Coords The x values of the second points.
     * @param y2Coords The y values of the second points.
     */
  void drawLines(List<double> x1Coords, List<double> y1Coords,
      List<double> x2Coords, List<double> y2Coords) {
    for (int i = x1Coords.length - 1; i >= 0; --i) {
      this.drawLine(x1Coords[i], y1Coords[i], x2Coords[i], y2Coords[i]);
    }
  }

  /**
     * Draws a rectangle to the viewport.
     * @param x1 The x value of the first corner.
     * @param y1 The y value of the first corner.
     * @param x2 The x value of the second corner.
     * @param y2 The y value of the second corner.
     */
  void drawRect(double x1, double y1, double x2, double y2) {
    x1 = this._transX(x1);
    y1 = this._transY(y1);
    x2 = this._transX(x2);
    y2 = this._transY(y2);
    double width = x2 - x1;
    double height = y1 - y2;
    this._writeRect(x1, y2, width, height);
  }

  /**
     * Draws a set of rectangles to the viewport.
     * @param xCoords The x values of the top-left corner points.
     * @param yCoords The y values of the top-left corner points.
     * @param widths The width values of the rectangles.
     * @param heights The height values of the rectangles.
     */
  void drawRects(List<double> xCoords, List<double> yCoords,
      List<double> widths, List<double> heights) {
    for (int i = xCoords.length - 1; i >= 0; --i) {
      double x = xCoords[i];
      double y = yCoords[i];
      this.drawRect(x, y, x + widths[i], y + heights[i]);
    }
  }

  /**
     * Draws a set of rectangles to the viewport.
     * @param xCoords The x values of the top-left corner points.
     * @param yCoords The y values of the top-left corner points.
     * @param width The width of all the rectangles.
     * @param height The height of all the rectangles.
     */
  void drawRectSet(
      List<double> xCoords, List<double> yCoords, double width, double height) {
    for (int i = xCoords.length - 1; i >= 0; --i) {
      double x = xCoords[i];
      double y = yCoords[i];
      this.drawRect(x, y, x + width, y + height);
    }
  }

  /**
     * Draws an ellipse to the viewport.
     * @param x1 The x value of the first corner.
     * @param y1 The y value of the first corner.
     * @param x2 The x value of the second corner.
     * @param y2 The y value of the second corner.
     */
  void drawEllip(double x1, double y1, double x2, double y2) {
    x1 = this._transX(x1);
    y1 = this._transY(y1);
    x2 = this._transX(x2);
    y2 = this._transY(y2);
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
    this._writeEllipse(cx, cy, rx, ry);
  }

  /**
     * Draws a set of ellipses to the viewport.
     * @param xCoords The x values of the top-left corner points.
     * @param yCoords The y values of the top-left corner points.
     * @param widths The width values of the ellipses.
     * @param heights The height values of the ellipses.
     */
  void drawEllips(List<double> xCoords, List<double> yCoords,
      List<double> widths, List<double> heights) {
    for (int i = xCoords.length - 1; i >= 0; --i) {
      double x = xCoords[i];
      double y = yCoords[i];
      this.drawEllip(x, y, x + widths[i], y + heights[i]);
    }
  }

  /**
     * Draws a set of ellipses to the viewport.
     * @param xCoords The x values of the top-left corner points.
     * @param yCoords The y values of the top-left corner points.
     * @param width The width of all the ellipses.
     * @param height The height of all the ellipses.
     */
  void drawEllipsSet(
      List<double> xCoords, List<double> yCoords, double width, double height) {
    for (int i = xCoords.length - 1; i >= 0; --i) {
      double x = xCoords[i];
      double y = yCoords[i];
      this.drawEllip(x, y, x + width, y + height);
    }
  }

  /**
     * Draws a set of circles to the viewport.
     * @param xCoords The x values of the top-left corner points.
     * @param yCoords The y values of the top-left corner points.
     * @param radius The radius values of the circles.
     */
  void drawCircs(
      List<double> xCoords, List<double> yCoords, List<double> radius) {
    for (int i = xCoords.length - 1; i >= 0; --i) {
      double r = radius[i];
      double cx = xCoords[i];
      double cy = yCoords[i];
      double x2 = this._transX(cx + r);
      double y2 = this._transY(cy + r);
      cx = this._transX(cx);
      cy = this._transY(cy);
      double rx = x2 - cx;
      double ry = y2 - cy;
      this._writeEllipse(cx, cy, rx, ry);
    }
  }

  /**
     * Draws a set of circles to the viewport.
     * @param xCoords The x values of the top-left corner points.
     * @param yCoords The y values of the top-left corner points.
     * @param radius The radius of all the circles.
     */
  void drawCircSet(List<double> xCoords, List<double> yCoords, double radius) {
    for (int i = xCoords.length - 1; i >= 0; --i) {
      double cx = xCoords[i];
      double cy = yCoords[i];
      double x2 = this._transX(cx + radius);
      double y2 = this._transY(cy + radius);
      cx = this._transX(cx);
      cy = this._transY(cy);
      double rx = x2 - cx;
      double ry = y2 - cy;
      this._writeEllipse(cx, cy, rx, ry);
    }
  }

  /**
     * Draws a polygon to the viewport.
     * @param xCoords The x values for the polygon.
     * @param yCoords The y values for the polygon.
     */
  void drawPoly(List<double> xCoords, List<double> yCoords) {
    int count = xCoords.length;
    if (count >= 3) {
      double x = this._transX(xCoords[0]);
      double y = this._transY(yCoords[0]);
      this._sout.write("<polygon points=\"$x,$y");
      for (int i = 1; i < count; ++i) {
        x = this._transX(xCoords[i]);
        y = this._transY(yCoords[i]);
        this._sout.write(" $x,$y");
      }
      this._sout.writeln("\" $_fillClrStr$_lineClrStr/>");
    }

    if (this._pointSize > 1.0) {
      this.drawPoints(xCoords, yCoords);
    }
  }

  /**
     * Draws a line strip to the viewport.
     * @param xCoords The x values for the line strip.
     * @param yCoords The y values for the line strip.
     */
  void drawStrip(List<double> xCoords, List<double> yCoords) {
    int count = xCoords.length;
    if (count >= 2) {
      double x = this._transX(xCoords[0]);
      double y = this._transY(yCoords[0]);
      this._sout.write("<polyline points=\"$x,$y");
      for (int i = 1; i < count; ++i) {
        x = this._transX(xCoords[i]);
        y = this._transY(yCoords[i]);
        this._sout.write(" $x,$y");
      }
      this._sout.writeln("\" fill=\"none\" $_lineClrStr/>");
    }

    if (this._pointSize > 1.0) {
      this.drawPoints(xCoords, yCoords);
    }
  }

  void _writePoint(double x, double y, double r) {
    this._sout.writeln(
        "  <circle cx=\"$x\" cy=\"$y\" r=\"$r\" fill=\"$_fillClrStr\" />");
  }

  void _writeLine(double x1, double y1, double x2, double y2) {
    this._sout.writeln(
        "  <line x1=\"$x1\" y1=\"$y1\" x2=\"$x2\" y2=\"$y2\" $_lineClrStr/>");
  }

  void _writeRect(double x, double y, double width, double height) {
    this._sout.writeln(
        "  <rect x=\"$x\" y=\"$y\" width=\"$width\" height=\"$height\" $_fillClrStr$_lineClrStr/>");
  }

  void _writeEllipse(double cx, double cy, double rx, double ry) {
    this._sout.write(
        "  <ellipse cx=\"$cx\" cy=\"$cy\" rx=\"$rx\" ry=\"$ry\" $_fillClrStr$_lineClrStr/>");
  }

  /**
     * Translates the given x value by the current transformer.
     * @param x The x value to transform.
     * @return The transformed x value.
     */
  double _transX(double x) {
    return this._trans.transformX(x);
  }

  /**
     * Translates the given y value by the current transformer.
     * @param y The y value to transform.
     * @return The transformed y value.
     */
  double _transY(double y) {
    return this._window.ymax() - this._trans.transformY(y);
  }

  String _getColorString(Color color) {
    var r = (color.red() * 255.0).floor();
    var g = (color.green() * 255.0).floor();
    var b = (color.blue() * 255.0).floor();
    return "rgb($r, $g, $b)";
  }
}
