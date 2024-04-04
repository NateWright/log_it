import 'package:flutter/material.dart';
import 'package:log_it/src/log_feature/graph_settings.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:log_it/src/log_feature/numeric.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphView extends StatefulWidget {
  static const routeName = '/graph_view';
  final Log log;
  const GraphView({super.key, required this.log});

  @override
  GraphViewState createState() => GraphViewState();
}

class GraphViewState extends State<GraphView> {
  Future<List<Numeric>>? futureData;
  Future<GraphSettings>? futureGraphSettings;
  GraphSettings? gSettings;
  late List<Numeric> dataPoints;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    futureData ??= Provider.of<LogProvider>(context).getDataNumeric(widget.log);
    futureGraphSettings ??=
        Provider.of<LogProvider>(context).logGetSettings(widget.log);
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (gSettings == null) return;
        Provider.of<LogProvider>(context, listen: false)
            .logUpdateSettings(widget.log, gSettings!);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          shadowColor: theme.shadowColor,
          title: Text(
            widget.log.title,
            style: theme.textTheme.headlineLarge,
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: Future.wait([
            futureData as Future<List<Numeric>>,
            futureGraphSettings as Future<GraphSettings>
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            dataPoints = snapshot.data![0] as List<Numeric>;
            gSettings = snapshot.data![1] as GraphSettings;
            GraphSettings graphSettings = gSettings!;
            return ListView(
              children: [
                GraphWidget(
                    dataPoints: dataPoints, graphSettings: graphSettings),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Type:',
                        style: theme.textTheme.bodyLarge,
                      ),
                      DropdownMenu<GraphType>(
                        initialSelection: graphSettings.graphType,
                        dropdownMenuEntries: [
                          for (final t in GraphType.values)
                            DropdownMenuEntry<GraphType>(
                              value: t,
                              label: t.name.toUpperCase(),
                            )
                        ],
                        onSelected: (t) {
                          if (t == null) {
                            return;
                          }
                          setState(() {
                            graphSettings.graphType = t;
                          });
                        },
                        hintText: 'Select Line Color',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Color:',
                        style: theme.textTheme.bodyLarge,
                      ),
                      DropdownMenu<GraphColor>(
                        initialSelection: graphSettings.graphColor,
                        dropdownMenuEntries: [
                          for (final color in GraphColor.values)
                            DropdownMenuEntry<GraphColor>(
                              value: color,
                              label: color.name.toUpperCase(),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        color.value),
                                foregroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        getTextColorForBackground(color.value)),
                              ),
                            )
                        ],
                        menuStyle: MenuStyle(backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          return graphSettings.graphColor.value;
                        })),
                        onSelected: (selectedColor) {
                          if (selectedColor == null) {
                            return;
                          }
                          setState(() {
                            graphSettings.graphColor = selectedColor;
                          });
                        },
                        hintText: 'Select Line Color',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Background:',
                        style: theme.textTheme.bodyLarge,
                      ),
                      DropdownMenu<GraphBackgroundColor>(
                        initialSelection: graphSettings.graphBackgroundColor,
                        dropdownMenuEntries: [
                          for (final color in GraphBackgroundColor.values)
                            DropdownMenuEntry<GraphBackgroundColor>(
                              value: color,
                              label: color.name.toUpperCase(),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        color.value),
                                foregroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        getTextColorForBackground(color.value)),
                              ),
                            )
                        ],
                        menuStyle: MenuStyle(backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          return graphSettings.graphBackgroundColor.value;
                        })),
                        onSelected: (selectedColor) {
                          if (selectedColor == null) {
                            return;
                          }
                          setState(() {
                            graphSettings.graphBackgroundColor = selectedColor;
                          });
                        },
                        hintText: 'Select Line Color',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Grid Lines:',
                        style: theme.textTheme.bodyLarge,
                      ),
                      Switch(
                        value: graphSettings.showGridLines,
                        onChanged: (value) {
                          setState(() {
                            graphSettings.showGridLines = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Curved:',
                        style: theme.textTheme.bodyLarge,
                      ),
                      Switch(
                        value: graphSettings.isCurved,
                        onChanged: (value) {
                          setState(() {
                            graphSettings.isCurved = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Color getTextColorForBackground(Color backgroundColor) {
  if (ThemeData.estimateBrightnessForColor(backgroundColor) ==
      Brightness.dark) {
    return Colors.white;
  }

  return Colors.black;
}

class GraphWidget extends StatelessWidget {
  final List<Numeric> dataPoints;
  final GraphSettings graphSettings;

  const GraphWidget({
    super.key,
    required this.dataPoints,
    required this.graphSettings,
  });
  @override
  Widget build(BuildContext context) {
    dynamic child;
    switch (graphSettings.graphType) {
      case GraphType.bar:
        child = _barChart();
      case GraphType.line:
        child = _lineChart();
      default:
        throw UnimplementedError();
    }
    return SizedBox(width: 400, height: 300, child: child);
  }


  LineChart _lineChart() {
    return LineChart(
      LineChartData(
        titlesData: const FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true)
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true)
        ),
        ),
        backgroundColor: graphSettings.graphBackgroundColor.value,
        lineBarsData: [
          LineChartBarData(
            isCurved: graphSettings.isCurved,
            spots: [
              for (final (index, n) in dataPoints.indexed)
                FlSpot(index.toDouble(), n.data)
            ],
            color: graphSettings.graphColor.value,
          ),
        ],
        gridData: FlGridData(show: graphSettings.showGridLines),
      ),
    );
  }

  BarChart _barChart() {
    return BarChart(
      BarChartData(
        titlesData: const FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true)
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true)
        ),
        ),
        backgroundColor: graphSettings.graphBackgroundColor.value,
        barGroups: [
          for (final (index, n) in dataPoints.indexed)
            BarChartGroupData(
              x: index,
              barsSpace: 8,
              barRods: [
                BarChartRodData(
                  toY: n.data,
                  color: graphSettings.graphColor.value,
                ),
              ],
            )
        ],
        gridData: FlGridData(show: graphSettings.showGridLines),
      ),
    );
  }
}
