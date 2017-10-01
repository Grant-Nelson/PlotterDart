part of plotter;

/**
 * A plotter item to draw a grid.
 */
class Grid extends PlotterItem {

    // The closest grid color to the background color. 
    Color _backClr;

    // The heaviest grid color.
    Color _foreClr;

    // The axis grid color.
    Color _axisClr;
    
    /**
     * Creates a grid item.
     */
    Grid() {
        this._backClr = new Color(0.9, 0.9, 1.0);
        this._foreClr = new Color(0.5, 0.5, 1.0);
        this._axisClr = new Color(1.0, 0.7, 0.7);
    }
    
    /**
     * Gets the smallest power of 10 which is greater than the given value.
     * @param value The value to get the maximum power of.
     * @return The smallest multiple of 10 greater than the given value.
     */
    int _getMaxPow(double value) {
        return (math.log(value)/math.LN10).ceil();
    }

    /**
     * Gets the number above the given value in multiples of the given power value.
     * @param value The number to get the value above.
     * @param pow The power to get the multiple of.
     * @return The multiple of the given power greater than the given value.
     */
    double _getUpper(double value, double pow) {
        return ((value/pow)*pow).ceilToDouble();
    }

    /**
     * Gets the number below the given value in multiples of the given power value.
     * @param value The number to get the value below.
     * @param pow The power to get the multiple of.
     * @return The multiple of the given power less than the given value.
     */
    double _getLower(double value, double pow) {
        return ((value/pow)*pow).floorToDouble();
    }

    /**
     * Gets a horizontal line at the given offset, adds it to the given group.
     * @param group The group of horizontal lines at a power to add to.
     * @param offset The offset into the view for the horizontal line.
     * @param window The window being drawn into.
     * @param view The viewport of the render space.
     */
    void _getHorz(List<double> group, double offset, Bounds window, Bounds view) {
        double y = (offset-view.ymin()) * window.height() / view.height();
        group.add(y);
    }

    /**
     * The recursive method used to get a horizontal grid line and children grid lines.
     * @param groups The group of horizontal line groups.
     * @param window The window being drawn into.
     * @param view The viewport of the render space.
     * @param pow The minimum power to draw at.
     * @param minOffset The minimum offset into the view.
     * @param maxOffset The maximum offset into the view.
     * @param rmdPow The current offset of the power to get the lines for.
     */
    void _getHorzs(List<List<double>> groups, Bounds window, Bounds view,
                double pow, double minOffset, double maxOffset, int rmdPow) {
        if (rmdPow <= 0) return;
        double lowPow = pow/10.0;
        double offset = minOffset;
        this._getHorzs(groups, window, view, lowPow, offset, offset+pow, rmdPow-1);
        
        if (offset+pow == offset) return;
        List<double> group = groups[rmdPow-1];
        for (offset += pow; offset < maxOffset; offset += pow) {
            this._getHorz(group, offset, window, view);
            this._getHorzs(groups, window, view, lowPow, offset, offset+pow, rmdPow-1);
        }
        this._getHorzs(groups, window, view, lowPow, offset, offset+pow, rmdPow-1);
    }

    /**
     * Gets a vertical line at the given offset, adds it to the given group.
     * @param group The group of vertical lines at a power to add to.
     * @param offset The offset into the view for the vertical line.
     * @param window The window being drawn into.
     * @param view The viewport of the render space.
     */
    void _getVert(List<double> group, double offset, Bounds window, Bounds view) {
        double x = (offset-view.xmin())*window.width()/view.width();
        group.add(x);
    }

    /**
     * The recursive method used to get a vertical grid line and children grid lines.
     * @param groups The group of vertical line groups.
     * @param window The window being drawn into.
     * @param view The viewport of the render space.
     * @param pow The minimum power to draw at.
     * @param minOffset The minimum offset into the view.
     * @param maxOffset The maximum offset into the view.
     * @param rmdPow The current offset of the power to get the lines for.
     */
    void _getVerts(List<List<double>> groups, Bounds window, Bounds view,
                double pow, double minOffset, double maxOffset, int rmdPow) {
        if (rmdPow <= 0) return;
        double lowPow = pow/10.0;
        double offset = minOffset;
        this._getVerts(groups, window, view, lowPow, offset, offset+pow, rmdPow-1);
        
        if (offset+pow == offset) return;
        List<double> group = groups[rmdPow-1];
        for (offset += pow; offset < maxOffset; offset += pow) {
            this._getVert(group, offset, window, view);
            this._getVerts(groups, window, view, lowPow, offset, offset+pow, rmdPow-1);
        }
        this._getVerts(groups, window, view, lowPow, offset, offset+pow, rmdPow-1);
    }
    
    /**
     * Sets the linearly interpolated color used for the grid lines to the renderer.
     * @param r The renderer to to set the color to.
     * @param rmdPow The current offset of the power to get the color for.
     * @param diff The difference in the powers.
     */
    void _setColor(IRenderer r, int rmdPow, int diff) {
        double fraction = rmdPow/diff.toDouble();
        double red   = this._backClr.red()  +fraction*(this._foreClr.red()  -this._backClr.red());
        double green = this._backClr.green()+fraction*(this._foreClr.green()-this._backClr.green());
        double blue  = this._backClr.blue() +fraction*(this._foreClr.blue() -this._backClr.blue());
        r.setColor(new Color(red, green, blue));
    }
    
    /**
     * Draws the grid lines.
     * @param r The renderer to draw to.
     * @param window The window being drawn into.
     * @param view The viewport of the render space.
     */
    void _drawGrid(IRenderer r, Bounds window, Bounds view) {
        int maxPow = math.max(
                this._getMaxPow(view.width()),
                this._getMaxPow(view.height()));
        int minPow = math.min(
                this._getMaxPow(view.width()*5.0/window.width()),
                this._getMaxPow(view.height()*5.0/window.height()));
        
        int diff = maxPow-minPow;
        double pow = math.pow(10, maxPow.toDouble()-1);
        double maxXOffset = this._getUpper(view.xmax(), pow);
        double minXOffset = this._getLower(view.xmin(), pow);
        double maxYOffset = this._getUpper(view.ymax(), pow);
        double minYOffset = this._getLower(view.ymin(), pow);

        List<List<double>> horzs = new List<List<double>>();
        List<List<double>> verts = new List<List<double>>();
        for (int i = 0; i < diff; ++i) {
            horzs.add(new List<double>());
            verts.add(new List<double>());
        }
        this._getHorzs(horzs, window, view, pow, minYOffset, maxYOffset, diff);
        this._getVerts(verts, window, view, pow, minXOffset, maxXOffset, diff);
        
        for (int i = 0; i < diff; ++i) {
            this._setColor(r, i, diff);
            for (double y in horzs[i]) {
                r.drawLine(window.xmin(), y, window.xmax(), y);
            }
            for (double x in verts[i]) {
                r.drawLine(x, window.ymin(), x, window.ymax());
            }
        }
    }
    
    /**
     * Draws the axis grid lines.
     * @param r The renderer to draw to.
     * @param window The window being drawn into.
     * @param view The viewport of the render space.
     */
    void _drawAxis(IRenderer r, Bounds window, Bounds view) {
        if ((view.xmin() <= 0.0) && (view.xmax() >= 0.0)) {
          List<double> group = new List<double>();
            this._getVert(group, 0.0, window, view);
            if (group.length == 1) {
                r.setColor(this._axisClr);
                double x = group[0];
                r.drawLine(x, window.ymin(), x, window.ymax());
            }
        }
        
        if ((view.ymin() <= 0.0) && (view.ymax() >= 0.0)) {
          List<double> group = new List<double>();
            this._getHorz(group, 0.0, window, view);
            if (group.length == 1) {
                r.setColor(this._axisClr);
                double y = group[0];
                r.drawLine(window.xmin(), y, window.xmax(), y);
            }
        }
    }
    
    /**
     * Draws the grid item.
     * @param r The renderer to draw with.
     */
    void _onDraw(IRenderer r) {
        Bounds window = r.window();
        Bounds view = r.viewport();
        if (view.width() <= 0.0) return;
        if (view.height() <= 0.0) return;
        
        Transformer last = r.transform();
        r.setTransform(new Transformer.identity());
        
        this._drawGrid(r, window, view);
        this._drawAxis(r, window, view);

        r.setTransform(last);
    }

    /**
     * Get the bounds for the grid.
     * @param trans The transformer of the current data.
     * @return This is always empty for a grid item.
     */
    Bounds _onGetBounds(Transformer trans) {
        return new Bounds.empty();
    }
}
