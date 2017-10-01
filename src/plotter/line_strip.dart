part of plotter;

/**
 * A plotter item for drawing a line strip.
 */
class LineStrip extends PlotterItem {

    // The x coordinates for the line strip points.
    List<double> _xCoords;
    
    // The y coordinates for the line strip points.
    List<double> _yCoords;
    
    /**
     * Creates a line strip plotter item.
     */
    LineStrip() {
        this._xCoords = new List<double>();
        this._yCoords = new List<double>();
    }
    
    /**
     * Adds points to the line strip.
     * @param val The points to add.
     * @return This line strip item.
     */
    LineStrip add(List<double> val) {
        int count = val.length;
        for (int i = 0; i < count; i += 2) {
            this._xCoords.add(val[i]);
            this._yCoords.add(val[i+1]);
        }
        return this;
    }

    /**
     * The number of points in the line strip.
     * @return The line strip point count.
     */
    int count() {
        return this._xCoords.length;
    }

    /**
     * Draws the group to the panel.
     * @param r The renderer to draw with.
     */
    void _onDraw(IRenderer r) {
        r.drawStrip(this._xCoords, this._yCoords);
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