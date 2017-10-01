part of plotter;

/**
 * A group for plotter items.
 */
class Group extends PlotterItem {
    
    // The label for the group.
    String _label;
    
    // Indicates that the group is enabled.
    bool _enabled;
    
    // The plotter items in this group.
    List<PlotterItem> _items;
    
    /**
     * Creates a new plotter item group.
     */
    Group() {
        this._label = "";
        this._enabled = true;
        this._items = new List<PlotterItem>();
    }
    
    /**
     * Gets the label for the item.
     * @return The item's label.
     */
    String label() {
        return this._label;
    }
    
    /**
     * Sets the label to the item.
     * @param label The label to set to the item.
     * @return This plotter item.
     */
    PlotterItem setLabel(String label) {
        this._label = label;
        return this;
    }
    
    /**
     * Indicates if the item is enabled or disabled.
     * @return True if enabled, false if disabled.
     */
    bool enabled() {
        return this._enabled;
    }
    
    /**
     * Sets the enabled state of the item.
     * @param enabled True to enable, false to disable.
     * @return This plotter item.
     */
    PlotterItem setEnabled(bool enabled) {
        this._enabled = enabled;
        return this;
    }
    
    /**
     * The number of items in the group.
     * @return The number of items.
     */
    int count() {
        return this._items.length;
    }
    
    /**
     * The list of items in the group.
     * @return The item list.
     */
    List<PlotterItem> items() {
        return this._items;
    }
    
    /**
     * Adds plotter items to the group.
     * @param items The items to add.
     * @return This plotter item group.
     */
    Group add(List<PlotterItem> items) {
        for (PlotterItem item in items) {
            this._items.add(item);
        }
        return this;
    }
    
    /**
     * Adds a points plotter item with the given data.
     * @param val The values for the points to add.
     * @return The added points plotter item.
     */
    Points addPoints(List<double> val) {
        Points item = new Points().add(val);
        this.add([item]);
        return item;
    }

    /**
     * Adds a lines plotter item with the given data.
     * @param val The values for the lines to add.
     * @return The added lines plotter item.
     */
    Lines addLines(List<double> val) {
        Lines item = new Lines().add(val);
        this.add([item]);
        return item;
    }

    /**
     * Adds a line strip plotter item with the given data.
     * @param val The values for the line strip to add.
     * @return The added line strip plotter item.
     */
    LineStrip addLineStrip(List<double> val) {
        LineStrip item = new LineStrip().add(val);
        this.add([item]);
        return item;
    }

    /**
     * Adds a polygon plotter item with the given data.
     * @param val The values for the polygon to add.
     * @return The added polygon plotter item.
     */
    Polygon addPolygon(List<double> val) {
        Polygon item = new Polygon().add(val);
        this.add([item]);
        return item;
    }
    
    /**
     * Adds a child group item with the given items.
     * @param items The items to put in the group.
     * @return The added group plotter item.
     */
    Group addGroup(List<PlotterItem> items) {
        Group item = new Group().add(items);
        this.add([item]);
        return item;
    }

    /**
     * Draws the group to the panel.
     * @param r The renderer to draw with.
     */
    void _onDraw(IRenderer r) {
        if (this.enabled()) {
            for (PlotterItem item in this._items) {
                item.draw(r);
            }
        }
    }

    /**
     * Gets the bounds for the item.
     * @param trans The transformer to apply to the bounds.
     * @return The bounds of the item.
     */
    Bounds _onGetBounds(Transformer trans) {
        Bounds b = new Bounds.empty();
        if (this.enabled()) {
            for (PlotterItem item in this._items) {
                b.union(item.getBounds(trans));
            }
        } 
        return b;
    }
}
