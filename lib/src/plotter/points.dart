part of plotter;

/**
 * A plotter item for points.
 */
class Points extends PlotterItem {

    // The x coordinates for the points.
    List<double> _xCoords;
    
    // The y coordinates for the points.
    List<double> _yCoords;

    /**
     * Creates a points plotter item.
     */
    Points() {
        this._xCoords = new List<double>();
        this._yCoords = new List<double>();
    }

    /**
     * Adds points to the item.
     * @param val The points to add.
     * @return This points item.
     */
    Points add(List<double> val) {
        int count = val.length;
        for (int i = 0; i < count; i += 2) {
            this._xCoords.add(val[i]);
            this._yCoords.add(val[i+1]);
        }
        return this;
    }

    /**
     * The number of points.
     * @return The point count.
     */
    int count() {
        return this._xCoords.length;
    }

    /**
     * Draws the group to the panel.
     * @param r The renderer to draw with.
     */
    void _onDraw(IRenderer r) {
        r.drawPoints(this._xCoords, this._yCoords);
    }

    /**
     * Gets the bounds for the item.
     * @param trans The transformer to apply to the bounds.
     * @return The bounds of the item.
     */
    Bounds _onGetBounds(Transformer trans) {
        Bounds b = new Bounds.empty();
        for (int i = this.count()-1; i >= 0; --i) {
            b.expand(this._xCoords[i], this._yCoords[i]);
        }
        return trans.transform(b);
    }
}
