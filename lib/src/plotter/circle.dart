part of plotter;

/**
 * A plotter item for drawing ellipses.
 */
class Circles extends PlotterItem {

    // The x value for the top-left corner points.
    List<double> _xCoords;

    // The y value for the top-left corner points.
    List<double> _yCoords;

    // The radius of the ellipses.
    List<double> _radius;

    /**
     * Creates a new ellipse plotter item.
     */
    Circles() {
        this._xCoords = new List<double>();
        this._yCoords = new List<double>();
        this._radius = new List<double>();
    }

    /**
     * Adds ellipses to this plotter item.
     * @param val The values for the ellipses to plot.
     */
    Circles add(List<double> val) {
        int count = val.length;
        for (int i = 0; i < count; i += 3) {
            this._xCoords.add(val[i]);
            this._yCoords.add(val[i+1]);
            this._radius.add(val[i+2]);
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
        r.drawCircs(this._xCoords, this._yCoords, this._radius);
    }

    /**
     * Gets the bounds for the item.
     * @param trans The transformer to apply to the bounds.
     * @return The bounds of the item.
     */
    Bounds _onGetBounds(Transformer trans) {
        Bounds b = new Bounds.empty();
        for (int i = this.count()-1; i >= 0; --i) {
            double r = this._radius[i];
            double x = this._xCoords[i]-r;
            double y = this._yCoords[i]-r;
            double d = 2.0*r;
            b.expand(x, y);
            b.expand(x+d, y+d);
        }
        return trans.transform(b);
    }
}
