part of plotter;

/**
 * The plotter item for plotting a polygon.
 */
class Polygon extends PlotterItem {

    // The x coordinates for the polygon.
    List<double> _xCoords;
    
    // The y coordinates for the polygon.
    List<double> _yCoords;
    
    /**
     * Creates a polygon plotter item.
     */
    Polygon() {
        this._xCoords = new List<double>();
        this._yCoords = new List<double>();
    }
    
    /**
     * Adds points to the polygon.
     * @param val X and y pairs for the points to add.
     * @return This polygon item.
     */
    Polygon add(List<double> val) {
        int count = val.length;
        for (int i = 0; i < count; i += 2) {
            this._xCoords.add(val[i]);
            this._yCoords.add(val[i+1]);
        }
        return this;
    }
    
    /**
     * The number of points in the polygon.
     * @return The polygon point count.
     */
    int count() {
        return this._xCoords.length;
    }

    /**
     * Called when the polygon is to be draw.
     * @param r The renderer to draw with.
     */
    void _onDraw(IRenderer r) {
        r.drawPoly(this._xCoords, this._yCoords);
    }

    /**
     * Gets the bounds for the polygon.
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