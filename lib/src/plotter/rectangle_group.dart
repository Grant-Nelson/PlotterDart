part of plotter;

/**
 * A plotter item for drawing rectangles.
 */
class RectangleGroup extends PlotterItem {

    // The x value for the top-left corner points.
    List<double> _xCoords;

    // The y value for the top-left corner points.
    List<double> _yCoords;

    // The width of all the rectangles.
    double _width;

    // The height of all the rectangles.
    double _height;

    /**
     * Creates a new rectangle plotter item.
     */
    RectangleGroup(double width, double height) {
        this._xCoords = new List<double>();
        this._yCoords = new List<double>();
        this._width = width;
        this._height = height;
    }

    /**
     * Gets the width for all the rectangles.
     * @return The rectangles' width.
     */
    double width() {
        return this._width;
    }

    /**
     * Gets the height for all the rectangles.
     * @return The rectangles' height.
     */
    double height() {
        return this._height;
    }

    /**
     * Sets the width for all the rectangles.
     * @param width The width to set.
     */
    RectangleGroup setWidth(double width) {
        this._width = width;
        return this;
    }

    /**
     * Sets the height for all the rectangles.
     * @param height The height to set.
     * @return This plotter item.
     */
    RectangleGroup setHeight(double height) {
        this._height = height;
        return this;
    }

    /**
     * Adds rectangles to this plotter item.
     * @param val The values for the rectangles to plot.
     * @return This plotter item.
     */
    RectangleGroup add(List<double> val) {
        int count = val.length;
        for (int i = 0; i < count; i += 2) {
            this._xCoords.add(val[i]);
            this._yCoords.add(val[i+1]);
        }
        return this;
    }

    /**
     * The number of rectangles in this item.
     * @return The rectangle count.
     */
    int count() {
        return this._xCoords.length;
    }

    /**
     * Draws the group to the panel.
     * @param r The renderer to draw with.
     */
    void _onDraw(IRenderer r) {
        r.drawRectSet(this._xCoords, this._yCoords, this._width, this._height);
    }

    /**
     * Gets the bounds for the item.
     * @param trans The transformer to apply to the bounds.
     * @return The bounds of the item.
     */
    Bounds _onGetBounds(Transformer trans) {
        Bounds b = new Bounds.empty();
        for (int i = this.count()-1; i >= 0; --i) {
            double x = this._xCoords[i];
            double y = this._yCoords[i];
            b.expand(x, y);
            b.expand(x+this._width, y+this._height);
        }
        return trans.transform(b);
    }
}
