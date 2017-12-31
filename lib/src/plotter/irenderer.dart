part of plotter;

/// A renderer for drawing plots.
abstract class IRenderer {
  /// The bounds of the panel being drawn on.
  Bounds get window;

  /// The viewport into the window with the given transformation.
  Bounds get viewport;

  /// The bounds of the data to set.
  Bounds get dataBounds;
  set dataBounds(Bounds dataBounds);

  /// The transformer for the current data.
  Transformer get transform;
  set transform(Transformer trans);

  /// The point size to draw points with.
  double get pointSize;
  set pointSize(double size);

  /// The background color to clear to.
  Color get backgroundColor;
  set backgroundColor(Color color);

  /// The color to draw lines with.
  Color get color;
  set color(Color color);

  /// The color to fill shapes with.
  Color get fillColor;
  set fillColor(Color color);

  /// Indicates if the lines should be drawn directed (with arrows), or not.
  bool get directedLines;
  set directedLines(bool directed);

  /// Draws text to the viewport.
  void drawText(double x, double y, double size, String text);

  /// Draws a point to the viewport.
  void drawPoint(double x, double y);

  /// Draws a set of points to the viewport.
  void drawPoints(List<double> xCoords, List<double> yCoords);

  /// Draws a line to the viewport.
  void drawLine(double x1, double y1, double x2, double y2);

  /// Draws a set of lines to the viewport.
  void drawLines(List<double> x1Coords, List<double> y1Coords, List<double> x2Coords, List<double> y2Coords);

  /// Draws a rectangle to the viewport.
  void drawRect(double x1, double y1, double x2, double y2);

  /// Draws a set of rectangles to the viewport.
  void drawRects(List<double> xCoords, List<double> yCoords, List<double> widths, List<double> heights);

  /// Draws a set of rectangles to the viewport.
  void drawRectSet(List<double> xCoords, List<double> yCoords, double width, double height);

  /// Draws a set of ellipse to the viewport.
  void drawEllipse(List<double> xCoords, List<double> yCoords, List<double> widths, List<double> heights);

  /// Draws a set of ellipse to the viewport.
  void drawEllipseSet(List<double> xCoords, List<double> yCoords, double width, double height);

  /// Draws a set of circles to the viewport.
  void drawCircs(List<double> xCoords, List<double> yCoords, List<double> radius);

  /// Draws a set of circles to the viewport.
  void drawCircSet(List<double> xCoords, List<double> yCoords, double radius);

  /// Draws a polygon to the viewport.
  void drawPoly(List<double> xCoords, List<double> yCoords);

  /// Draws a line strip to the viewport.
  void drawStrip(List<double> xCoords, List<double> yCoords);
}
