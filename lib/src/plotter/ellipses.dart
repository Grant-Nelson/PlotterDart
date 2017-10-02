part of plotter;

/**
 * A plotter item for drawing ellipses.
 */
class Ellipses extends PlotterItem {

    // The x value for the top-left corner points.
    List<double> _xCoords;

    // The y value for the top-left corner points.
    List<double> _yCoords;

    // The width of the ellipses.
    List<double> _widths;

    // The height of the ellipses.
    List<double> _heights;

    /**
     * Creates a new ellipse plotter item.
     */
    Ellipses() {
        this._xCoords = new List<double>();
        this._yCoords = new List<double>();
        this._widths = new List<double>();
        this._heights = new List<double>();
    }

    /**
     * Adds ellipses to this plotter item.
     * @param val The values for the ellipses to plot.
     */
    Ellipses add(List<double> val) {
        int count = val.length;
        for (int i = 0; i < count; i += 4) {
            this._xCoords.add(val[i]);
            this._yCoords.add(val[i+1]);
            this._widths.add(val[i+2]);
            this._heights.add(val[i+3]);
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
        r.drawEllips(this._xCoords, this._yCoords, this._widths, this._heights);
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
            b.expand(x+this._widths[i], y+this._heights[i]);
        }
        return trans.transform(b);
    }
}
