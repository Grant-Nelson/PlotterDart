library plotter;

import 'dart:math' as math;

part 'bounds.dart';
part 'circle_group.dart';
part 'circle.dart';
part 'color.dart';
part 'color_attr.dart';
part 'data_bounds.dart';
part 'directed_line_attr.dart';
part 'ellipse_group.dart';
part 'ellipses.dart';
part 'fill_color_attr.dart';
part 'grid.dart';
part 'group.dart';
part 'iattribute.dart';
part 'irenderer.dart';
part 'lines.dart';
part 'line_strip.dart';
part 'plotter_item.dart';
part 'points.dart';
part 'point_size_attr.dart';
part 'polygon.dart';
part 'rectangle_group.dart';
part 'rectangle.dart';
part 'trans_attr.dart';
part 'transformer.dart';

/**
 * The plotter to quickly draw 2D plots.
 * Great for reviewing data and debugging 2D algorithms.
 *
 * @example
 *   Plotter plot = new Plotter();
 *   plot.addLines(12.1, 10.1, 10.9, 10.1,
 *                 10.9, 11.1,  6.9, 10.9,
 *                 10.9, 10.9, 10.1, 13.9,
 *                 10.1,  4.9, 10.1, 10.1);
 *   plot.addPoints(12.1, 10.1,   10.9, 10.1,
 *                  10.9, 11.1,    6.9, 10.9,
 *                  10.9, 10.9,   10.1, 13.9,
 *                  10.1,  4.9,   10.1, 10.1).
 *                  addPointSize(4.0);
 *   plot.updateBounds();
 *   plot.focusOnData();
 *   plot.show();
 */
class Plotter {

    // The data bounds for the item's data.
    Bounds _bounds;

    // The transformer from the window to the view.
    Transformer _viewTrans;

    // The items to plot.
    List<PlotterItem> _items;

    /**
     * Creates a new plotter.
     */
    Plotter() {
        this._bounds = new Bounds.empty();
        this._viewTrans = new Transformer.identity();
        this._items = new List<PlotterItem>();

        this._items.add(new Grid());
        this._items.add(new DataBounds());

    }

    /**
     * Focuses on the data.
     * @note May need to call updateBounds before this if the data has changed.
     */
    void focusOnData() {
        this._viewTrans.reset();
        if (!this._bounds.isEmpty()) {
            double scale = 0.9/math.max(this._bounds.width(), this._bounds.height());
            this._viewTrans.setScale(scale, scale);
            this._viewTrans.setOffset(
                    -0.5*(this._bounds.xmin()+this._bounds.xmax())*scale,
                    -0.5*(this._bounds.ymin()+this._bounds.ymax())*scale);
        }
    }

    /**
     * The number of items in the plotter.
     * @return The number of items.
     */
    int count() {
        return this._items.length;
    }

    /**
     * The list of items in the plotter.
     * @return The item list.
     */
    List<PlotterItem> items() {
        return this._items;
    }

    /**
     * Adds plotter items to the plotter.
     * @param items The items to add.
     */
    Plotter add(PlotterItem item) {
        this._items.add(item);
        return this;
    }

    /**
     * Adds a points plotter item with the given data.
     * @param val The values for the points to add.
     * @return The added points plotter item.
     */
    Points addPoints(List<double> val) {
        Points item = new Points().add(val);
        this.add(item);
        return item;
    }

    /**
     * Adds a lines plotter item with the given data.
     * @param val The values for the lines to add.
     * @return The added lines plotter item.
     */
    Lines addLines(List<double> val) {
        Lines item = new Lines().add(val);
        this.add(item);
        return item;
    }

    /**
     * Adds a line strip plotter item with the given data.
     * @param val The values for the line strip to add.
     * @return The added line strip plotter item.
     */
    LineStrip addLineStrip(List<double> val) {
        LineStrip item = new LineStrip().add(val);
        this.add(item);
        return item;
    }

    /**
     * Adds a polygon plotter item with the given data.
     * @param val The values for the polygon to add.
     * @return The added polygon plotter item.
     */
    Polygon addPolygon(List<double> val) {
        Polygon item = new Polygon().add(val);
        this.add(item);
        return item;
    }

    /**
     * Adds a child group item with the given items.
     * @param items The items to put in the group.
     * @return The added group plotter item.
     */
    Group addGroup(List<PlotterItem> items) {
        Group item = new Group().add(items);
        this.add(item);
        return item;
    }

    /**
     * Updates the bounds of the data.
     * This should be called whenever the data has changed.
     */
    void updateBounds() {
        Bounds b = new Bounds.empty();
        for (PlotterItem item in this._items) {
            b.union(item.getBounds(this._viewTrans));
        }
        this._bounds = b;
    }

    /**
     * Renders the plot with the given renderer.
     * @param r The renderer to plot with.
     */
    void render(IRenderer r) {
        r.setDataBounds(this._bounds);
        Transformer trans = r.transform();
        trans = trans.mul(this._viewTrans);
        r.setTransform(trans);
        for (PlotterItem item in this._items) {
            r.setColor(new Color(0.0,  0.0,  0.0));
            item.draw(r);
        }
    }

    /**
     * Gets the transformation from window space to view space.
     * @return The view transformation.
     */
    Transformer view() {
      return this._viewTrans;
    }

    /**
     * Sets the transformation of transforming window space into view space.
     * @param view The view transformation to set.
     */
    void setView(Transformer view) {
      this._viewTrans = view;
    }

    /**
     * Sets the offset of the view transformation.
     * @param x The x value to set.
     * @param y The y value to set.
     */
    void setViewOffset(double x, double y) {
        this._viewTrans.setOffset(x, y);
    }

    /**
     * Sets the view transformation zoom.
     * @note This is 10 to the power of the given value, such that 0 is x1.0 zoom.
     * @param pow The power of the zoom to set.
     */
    void setViewZoom(double pow) {
        double scale = math.pow(10.0, pow);
        this._viewTrans.setScale(scale, scale);
    }

    /**
     * Changes the zoom of the transformation at the given location.
     * @param x The x value of the location to zoom at.
     * @param y The y value of the location to zoom at.
     * @param amount The change in the zoom power.
     */
    void deltaViewZoom(double x, double y, double amount) {
        double prev = math.max(this._viewTrans.xScalar(), this._viewTrans.yScalar());
        double scale = math.pow(10.0, math.log(prev)/math.LN10 - amount);

        if (scale < 1.0e-6) scale = 1.0e-6;
        else if (scale > 1.0e+6) scale = 1.0e+6;

        double dx = (this._viewTrans.dx()-x)*(scale/prev)+x;
        double dy = (this._viewTrans.dy()-y)*(scale/prev)+y;
        this._viewTrans.setOffset(dx, dy);
        this._viewTrans.setScale(scale, scale);
    }
}
