part of plotter;

/**
 * A plotter item to draw the data bounds.
 */
class DataBounds extends PlotterItem {
    
    /**
     * Creates a new data bound plotter item.
     * Adds a default color attribute.
     */
    DataBounds() {
        this.attributes().add(new ColorAttr.rgb(1.0, 0.75, 0.75));
    }

    /**
     * Called to draw to the panel.
     * @param r The renderer to draw with.
     */
    void _onDraw(IRenderer r) {
        r.drawRect(r.dataBounds().xmin(), r.dataBounds().ymin(),
                   r.dataBounds().xmax(), r.dataBounds().ymax());
    }

    /**
     * Get the bounds for the item.
     * @param trans The transformer to apply to the bounds.
     * @return The bounds of the item.
     */
    Bounds _onGetBounds(Transformer trans) {
        return new Bounds.empty();
    }
}