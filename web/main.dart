library main;

import 'package:plotterDart/plotter.dart' as plotter;
import 'package:plotterDart/plotSvg.dart' as plotSvg;
import 'package:plotterDart/plotCanvas.dart' as plotCanvas;

part "pointAdder.dart";

void main() {
  plotter.Plotter plot = new plotter.Plotter();
  addCircleGroup(plot);
  addCircles(plot);
  addEllipseGroup(plot);

  plot.updateBounds();
  plot.focusOnData();
  plot.MouseHandles.add(new PointAdder(plot));
  plot.MouseHandles.add(new plotter.MouseCoords(plot));
  plot.MouseHandles.add(new plotter.MouseCrosshairs(plot));

  bool useCanvas = Uri.base.queryParameters["Canvas"] == "true";
  if (useCanvas) new plotCanvas.PlotCanvas("output", plot);
  else new plotSvg.PlotSvg("output", plot);
}

plotter.Group createBox(plotter.Plotter plot, double x, double y, String title) {
  plotter.Group group = plot.addGroup()
    ..addOffset(x, y);

  group.addRects([0, 10, 90, 80]);
  group.addRects([0, 90, 90, 10])
    ..addFillColor(0.0, 0.0, 0.0, 0.5);

  group.addText(5, 92, 8, title, true)
    ..addFillColor(1.0, 1.0, 1.0);
  
  return group;
}

void addCircleGroup(plotter.Plotter plot) {
  plotter.Group group = createBox(plot, 0.0, 0.0, "Circle Group");
  group.addCircleGroup(1.5, [10, 20,   20, 40,   30, 60]);
  group.addCircleGroup(3.5, [30, 20,   40, 40,   50, 60])
    ..addColor(0.0, 0.0, 1.0)
    ..addFillColor(0.0, 1.0, 0.0);
}

void addCircles(plotter.Plotter plot) {
  plotter.Group group = createBox(plot, 100.0, 0.0, "Circles");
  group.addCircles([10, 20, 1.0,   20, 40, 3.0,   30, 60, 5.0]);
  group.addCircles([30, 20, 2.5,   40, 40, 4.5,   50, 60, 6.5])
    ..addColor(0.0, 0.0, 1.0)
    ..addFillColor(0.0, 1.0, 0.0);
}

void addEllipseGroup(plotter.Plotter plot) {
  plotter.Group group = createBox(plot, 200.0, 0.0, "Ellipse Group");
  group.addEllipseGroup(4.0, 2.0, [10, 20,   20, 40,   30, 60]);
  group.addEllipseGroup(4.0, 8.0, [30, 20,   40, 40,   50, 60])
    ..addColor(0.0, 0.0, 1.0)
    ..addFillColor(0.0, 1.0, 0.0);
}
