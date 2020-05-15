library main;

import 'dart:html' as html;
import 'package:plotterDart/plotter.dart' as plotter;
import 'package:plotterDart/plotSvg.dart' as plotSvg;
import 'package:plotterDart/plotCanvas.dart' as plotCanvas;

part 'boolValue.dart';
part 'pointAdder.dart';
part 'driver.dart';

void main() {
  html.document.title = "Complex";
  html.BodyElement body = html.document.body;

  html.DivElement menu = new html.DivElement();
  menu.className = "menu";
  body.append(menu);

  html.DivElement plotElem = new html.DivElement();
  plotElem.id = "plot_target";
  body.append(plotElem);

  plotter.Plotter plot = new plotter.Plotter();
  plot.MouseHandles.add(new PointAdder(plot));
  plot.MouseHandles.add(new plotter.MouseCoords(plot));

  plotter.IPlot plotOut;
  bool useSVG = Uri.base.queryParameters["SVG"] == "true";
  if (useSVG) plotOut = new plotSvg.PlotSvg("plot_target", plot);
  else plotOut = new plotCanvas.PlotCanvas("plot_target", plot);
  Driver dvr = new Driver(plotOut);

  addMenuView(menu, dvr);
  addMenuTools(menu, dvr);
}

void addMenuView(html.DivElement menu, Driver dvr) {
  html.DivElement dropDown = new html.DivElement()..className = "dropdown";
  menu.append(dropDown);

  html.DivElement text = new html.DivElement()..text = "View";
  dropDown.append(text);

  html.DivElement items = new html.DivElement()..className = "dropdown-content";
  dropDown.append(items);

  addMenuItem(items, "Center View", dvr.centerView);
}

void addMenuTools(html.DivElement menu, Driver dvr) {
  html.DivElement dropDown = new html.DivElement()..className = "dropdown";
  menu.append(dropDown);

  html.DivElement text = new html.DivElement()..text = "Tools";
  dropDown.append(text);

  html.DivElement items = new html.DivElement()..className = "dropdown-content";
  dropDown.append(items);

  addMenuItem(items, "Pan View", dvr.panView);
  addMenuItem(items, "Add Points", dvr.addPoints);
  addMenuItem(items, "Clear All", dvr.clearAll);
}

void addMenuItem(html.DivElement dropDownItems, String text, BoolValue value) {
  html.DivElement item = new html.DivElement()
    ..text = text
    ..className = (value.value ? "dropdown-item-active" : "dropdown-item-inactive")
    ..onClick.listen((_) {
      value.onClick();
    });
  value.onChange.add((bool value) {
    item.className = value ? "dropdown-item-active" : "dropdown-item-inactive";
  });
  dropDownItems.append(item);
}
