library main;

import 'package:plotterDart/plotter.dart' as plotter;
import 'package:plotterDart/plotSvg.dart' as plotSvg;
import 'package:plotterDart/plotCanvas.dart' as plotCanvas;

part "pointAdder.dart";

void main() {
  plotter.Plotter plot = new plotter.Plotter();

  plot.addRectGroup(90, 80, [  0,  10,  100,  10,  200,  10,  300,  10,  400,  10,
                               0, 110,  100, 110,  200, 110,  300, 110,  400, 110]);
  plot.addRectGroup(90, 10, [  0,  90,  100,  90,  200,  90,  300,  90,  400,  90,
                               0, 190,  100, 190,  200, 190,  300, 190,  400, 190])
    ..addFillColor(0.0, 0.0, 0.0, 0.5);
  
  plot.addText(5, 192, 8, "Circle Group", true);
  plot.addCircleGroup(1.0, [10, 120, 20, 140, 30, 160]);

  plot.addText(105, 192, 8, "Circles", true);

  plot.addText(205, 192, 8, "Ellipse Group", true);

  plot.addText(305, 192, 8, "Ellipses", true);

  plot.addText(405, 192, 8, "Line Strip", true);

  plot.addText(5, 92, 8, "Lines", true);

  plot.addText(105, 92, 8, "Points", true);
  
  plot.addText(205, 92, 8, "Polygon", true);
  
  plot.addText(305, 92, 8, "Rectangle Group", true);

  plot.addText(405, 92, 8, "Rectangles", true);

  // plot.addLines([12.1, 10.1, 10.9, 10.1,
  //                10.9, 11.1,  6.9, 10.9,
  //                10.9, 10.9, 10.1, 13.9,
  //                10.1,  4.9, 10.1, 10.1]);
  // plot.addPoints([12.1, 10.1,   10.9, 10.1,
  //                 10.9, 11.1,    6.9, 10.9,
  //                 10.9, 10.9,   10.1, 13.9,
  //                 10.1,  4.9,   10.1, 10.1])
  //   ..addPointSize(4.0);
  // plot.addCircles([3.0, 3.0, 1.0,
  //                  2.0, 2.0, 1.0,
  //                  3.0, 2.0, 0.5,
  //                  2.0, 3.0, 0.25]);
  // plot.addEllipses([4.0, 13.0, 0.5, 1.0,
  //                   4.0, 12.0, 0.5, 0.5,
  //                   4.0, 11.0, 0.5, 0.25]);

  plot.updateBounds();
  plot.focusOnData();
  plot.MouseHandles.add(new PointAdder(plot));
  plot.MouseHandles.add(new plotter.MouseCoords(plot));
  plot.MouseHandles.add(new plotter.MouseCrosshairs(plot));

  bool useSVG = Uri.base.queryParameters["SVG"] == "true";
  if (useSVG) new plotSvg.PlotSvg("output", plot);
  else new plotCanvas.PlotCanvas("output", plot);
}
