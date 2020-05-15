library main;

import 'package:plotterDart/plotter.dart' as plotter;
import 'package:plotterDart/plotSvg.dart' as plotSvg;
import 'package:plotterDart/plotCanvas.dart' as plotCanvas;

part "pointAdder.dart";

void main() {
  plotter.Plotter plot = new plotter.Plotter();

  plot.addLines([12.1, 10.1, 10.9, 10.1,
                 10.9, 11.1,  6.9, 10.9,
                 10.9, 10.9, 10.1, 13.9,
                 10.1,  4.9, 10.1, 10.1]);
  plot.addPoints([12.1, 10.1,   10.9, 10.1,
                  10.9, 11.1,    6.9, 10.9,
                  10.9, 10.9,   10.1, 13.9,
                  10.1,  4.9,   10.1, 10.1])
    ..addPointSize(4.0);
  
  plot.updateBounds();
  plot.focusOnData();
  plot.MouseHandles.add(new PointAdder(plot));
  plot.MouseHandles.add(new plotter.MouseCoords(plot));

  bool useSVG = Uri.base.queryParameters["SVG"] == "true";
  if (useSVG) new plotSvg.PlotSvg("output", plot);
  else new plotCanvas.PlotCanvas("output", plot);
}
