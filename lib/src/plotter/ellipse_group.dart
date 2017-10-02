part of plotter;

/**
 * A plotter item for drawing ellipses.
 */
class EllipseGroup extends PlotterItem {

    // The x value for the top-left corner points.
    List<double> _xCoords;

    // The y value for the top-left corner points.
    List<double> _yCoords;

    // The width of all the ellipses.
    double _width;

    // The height of all the ellipses.
    double _height;

    /**
     * Creates a new ellipse plotter item.
     */
    EllipseGroup(double width, double height) {
        this._xCoords = new List<double>();
        this._yCoords = new List<double>();
        this._width = width;
        this._height = height;
    }

    /**
     * Gets the width for all the ellipses.
     * @return The ellipses' width.
     */
    double width() {
        return this._width;
    }

    /**
     * Gets the height for all the ellipses.
     * @return The ellipses' height.
     */
    double height() {
        return this._height;
    }

    /**
     * Sets the width for all the ellipses.
     * @param width The width to set.
     * @return This plotter item.
     */
    EllipseGroup setWidth(double width) {
        this._width = width;
        return this;
    }

    /**
     * Sets the height for all the ellipses.
     * @param height The height to set.
     * @return This plotter item.
     */
    EllipseGroup setHeight(double height) {
        this._height = height;
        return this;
    }

    /**
     * Adds ellipses to this plotter item.
     * @param val The values for the ellipses to plot.
     */
    EllipseGroup add(List<double> val) {
        int count = val.length;
        for (int i = 0; i < count; i += 2) {
            this._xCoords.add(val[i]);
            this._yCoords.add(val[i+1]);
        }
        return this;
    }

    /**
     * The number of ellipses in this item.
     * @return The ellipse count.
     */
    int count() {
        return this._xCoords.length;
    }

    /**
     * Draws the group to the panel.
     * @param r The renderer to draw with.
     */
    void _onDraw(IRenderer r) {
        r.drawEllipsSet(this._xCoords, this._yCoords, this._width, this._height);
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
