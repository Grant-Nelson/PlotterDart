part of plotter;

/**
 * A plotter item for drawing circles.
 */
class CircleGroup extends PlotterItem {

    // The x value for the top-left corner points.
    List<double> _xCoords;

    // The y value for the top-left corner points.
    List<double> _yCoords;

    // The radius of all the circles.
    double _radius;

    /**
     * Creates a new circle plotter item.
     * @param radius The initial radius for all the circles.
     */
    CircleGroup(double radius) {
        this._xCoords = new List<double>();
        this._yCoords = new List<double>();
        this._radius = radius;
    }

    /**
     * Gets the radius for all the circles.
     * @return The circles' radius.
     */
    double radius() {
        return this._radius;
    }

    /**
     * Sets the radius for all the circles.
     * @param radius The radius to set.
     */
    CircleGroup setRadius(double radius) {
        this._radius = radius;
        return this;
    }

    /**
     * Adds circles to this plotter item.
     * @param val The values for the circles to plot.
     * @return This plotter item.
     */
    CircleGroup add(List<double> val) {
        int count = val.length;
        for (int i = 0; i < count; i += 2) {
            this._xCoords.add(val[i]);
            this._yCoords.add(val[i+1]);
        }
        return this;
    }

    /**
     * The number of circles in this item.
     * @return The circle count.
     */
    int count() {
        return this._xCoords.length;
    }

    /**
     * Draws the group to the panel.
     * @param r The renderer to draw with.
     */
    void _onDraw(IRenderer r) {
        r.drawCircSet(this._xCoords, this._yCoords, this._radius);
    }

    /**
     * Gets the bounds for the item.
     * @param trans The transformer to apply to the bounds.
     * @return The bounds of the item.
     */
    Bounds _onGetBounds(Transformer trans) {
        Bounds b = new Bounds.empty();
        double d = 2.0*this._radius;
        for (int i = this.count()-1; i >= 0; --i) {
            double x = this._xCoords[i]-this._radius;
            double y = this._yCoords[i]-this._radius;
            b.expand(x, y);
            b.expand(x+d, y+d);
        }
        return trans.transform(b);
    }
}
