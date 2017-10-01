part of plotter;

/**
 * A renderer for drawing plots.
 */
abstract class IRenderer {

  /**
   * Gets the bounds of the panel being drawn on.
   * @return The bounds of the panel.
   */
  Bounds window();

  /**
   * Gets the viewport into the window with the given transformation.
   * @return The current viewport bounds.
   */
  Bounds viewport();

  /**
   * Sets the data bounds.
   * @param dataBounds The bounds of the data to set.
   */
  void setDataBounds(Bounds dataBounds);

  /**
   * The bounds of the data.
   * @return The data bounds.
   */
  Bounds dataBounds();

  /**
   * Gets the transformer for the current data.
   * @return The data transformer.
   */
  Transformer transform();

  /**
   * Sets the transformer for the current data.
   * @param trans The transformer to set.
   */
  void setTransform(Transformer trans);

  /**
   * Gets the point size to draw points with.
   * @return The point size to draw with.
   */
  double pointSize();

  /**
   * Sets the point size to draw points with.
   * @param size The point size to set.
   */
  void setPointSize(double size);

  /**
   * Gets the background color to clear to.
   * @return The background color.
   */
  Color getBackgroundColor();

  /**
   * Sets the background color to clear to.
   * @param color The background color to set.
   */
  void setBackgroundColor(Color color);

  /**
   * Gets the color to draw lines with.
   * @return The line color.
   */
  Color getColor();

  /**
   * Sets the color to draw lines with.
   * @param color The color to set.
   */
  void setColor(Color color);

  /**
   * Gets the color to fill shapes with.
   * @return The fill color, nil for no fill.
   */
  Color getFillColor();

  /**
   * Sets the color to fill shapes with.
   * @param color The color to set.
   */
  void setFillColor(Color color);

  /**
   * Draws a point to the viewport.
   * @param x The x value of the point to draw.
   * @param y The y value of the point to draw.
   */
  void drawPoint(double x, double y);

  /**
   * Draws a set of points to the viewport.
   * @param xCoords The x values of the points to draw.
   * @param yCoords The y values of the points to draw.
   */
  void drawPoints(List<double> xCoords, List<double> yCoords);

  /**
   * Draws a line to the viewport.
   * @param x1 The x value of the first point.
   * @param y1 The y value of the first point.
   * @param x2 The x value of the second point.
   * @param y2 The y value of the second point.
   */
  void drawLine(double x1, double y1, double x2, double y2);

  /**
   * Draws a set of lines to the viewport.
   * @param x1Coords The x values of the first points.
   * @param y1Coords The y values of the first points.
   * @param x2Coords The x values of the second points.
   * @param y2Coords The y values of the second points.
   */
  void drawLines(List<double> x1Coords, List<double> y1Coords, List<double> x2Coords, List<double> y2Coords);

  /**
   * Draws a rectangle to the viewport.
   * @param x1 The x value of the first corner.
   * @param y1 The y value of the first corner.
   * @param x2 The x value of the second corner.
   * @param y2 The y value of the second corner.
   */
  void drawRect(double x1, double y1, double x2, double y2);

  /**
   * Draws a polygon to the viewport.
   * @param xCoords The x values for the polygon.
   * @param yCoords The y values for the polygon.
   */
  void drawPoly(List<double> xCoords, List<double> yCoords);

  /**
   * Draws a line strip to the viewport.
   * @param xCoords The x values for the line strip.
   * @param yCoords The y values for the line strip.
   */
  void drawStrip(List<double> xCoords, List<double> yCoords);
}
