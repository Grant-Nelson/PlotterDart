part of plotter;

/**
 * A plotter item for drawing lines.
 */
class Lines extends PlotterItem {

    // The x value for the first point.
    List<double> _x1Coords;

    // The y value for the first point.
    List<double> _y1Coords;

    // The x value for the second point.
    List<double> _x2Coords;

    // The y value for the second point.
    List<double> _y2Coords;

    /**
     * Creates a new line plotter item.
     */
    Lines() {
        this._x1Coords = new List<double>();
        this._y1Coords = new List<double>();
        this._x2Coords = new List<double>();
        this._y2Coords = new List<double>();
    }

    /**
     * Adds lines to this plotter item.
     * @param val The values for the lines to plot.
     */
    Lines add(List<double> val) {
        int count = val.length;
        for (int i = 0; i < count; i += 4) {
            this._x1Coords.add(val[i]);
            this._y1Coords.add(val[i+1]);
            this._x2Coords.add(val[i+2]);
            this._y2Coords.add(val[i+3]);
        }
        return this;
    }

    /**
     * The number of lines in this item.
     * @return The line count.
     */
    int count() {
        return this._x1Coords.length;
    }

    /**
     * Draws the group to the panel.
     * @param r The renderer to draw with.
     */
    void _onDraw(IRenderer r) {
        r.drawLines(this._x1Coords, this._y1Coords,
                    this._x2Coords, this._y2Coords);
    }

    /**
     * Gets the bounds for the item.
     * @param trans The transformer to apply to the bounds.
     * @return The bounds of the item.
     */
    Bounds _onGetBounds(Transformer trans) {
        Bounds b = new Bounds.empty();
        for (int i = this.count()-1; i >= 0; --i) {
            b.expand(this._x1Coords[i], this._y1Coords[i]);
            b.expand(this._x2Coords[i], this._y2Coords[i]);
        }
        return trans.transform(b);
    }
}
