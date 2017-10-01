part of plotter;

/**
 * The abstract for all plotter items.
 */
abstract class PlotterItem {
    
    // The set of attributes for this item.
    List<IAttribute> _attrs;
    
    /**
     * Creates a plotter item.
     */
    PlotterItem() {
        this._attrs = new List<IAttribute>();
    }
    
    /**
     * Gets the set of attributes for this item.
     * @return The set of attributes.
     */
    List<IAttribute> attributes() {
        return this._attrs;
    }

    /**
     * Adds an attribute to this item.
     * @param attr The attribute to add.
     * @return This plotter item.
     */
    PlotterItem addAttr(IAttribute attr) {
        this._attrs.add(attr);
        return this;
    }
    
    /**
     * Adds a color attribute to this item.
     * @param red The red color component.
     * @param green The green color component.
     * @param blue The blue color component.
     * @return This plotter item.
     */
    PlotterItem addColor(double red, double green, double blue) {
        this.addAttr(new ColorAttr.rgb(red, green, blue));
        return this;
    }
    
    /**
     * Adds a point size attribute to this item.
     * @param size The point size.
     * @return This plotter item.
     */
    PlotterItem addPointSize(double size) {
        this.addAttr(new PointSizeAttr(size));
        return this;
    }
    
    /**
     * Adds a filled attribute to this item.
     * @param filled True if filled, false if not filled.
     * @return This plotter item.
     */
    PlotterItem addFillColor(double red, double green, double blue) {
        this.addAttr(new FillColorAttr.rgb(red, green, blue));
        return this;
    }
    
    /**
     * Draws the item to the panel.
     * @param r The renderer to draw with.
     */
    void draw(IRenderer r) {
        final int count = this._attrs.length;
        for (int i = 0; i < count; i++) {
            this._attrs[i]._pushAttr(r);
        }
        this._onDraw(r);
        for (int i = count-1; i >= 0; i--) {
            this._attrs[i]._popAttr(r);
        }
    }

    /**
     * Gets the bounds for this item.
     * @param trans The current transformer for the bounds.
     * @return The bounds of the item.
     */
    Bounds getBounds(Transformer trans) {
        final int count = this._attrs.length;
        for (int i = 0; i < count; i++) {
            IAttribute attr = this._attrs[i];
            if (attr is TransAttr) {
                trans = attr.apply(trans);
            }
        }
        Bounds b = this._onGetBounds(trans);
        for (int i = count-1; i >= 0; i--) {
            IAttribute attr = this._attrs[i];
            if (attr is TransAttr) {
                trans = attr.unapply(trans);
            }
        }
        return b;
    }
    
    /**
     * The abstract method to draw to the panel.
     * @param r The renderer to draw with.
     */
    void _onDraw(IRenderer r);
    
    /**
     * The abstract method for getting the bounds for the item.
     * @param trans The transformer to apply to the bounds.
     * @return The bounds of the item.
     */
    Bounds _onGetBounds(Transformer trans);
}
