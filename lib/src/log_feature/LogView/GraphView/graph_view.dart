import 'package:flutter/material.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:log_it/src/log_feature/numeric.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

enum GraphColor {
  red(Colors.red),
  green(Colors.green),
  blue(Colors.blue),
  orange(Colors.orange),
  yellow(Colors.yellow),
  purple(Colors.purple);

  const GraphColor(this.value);
  final Color value;
}

enum BackgroundColor {
  white(Colors.white),
  grey(Colors.grey),
  black(Colors.black),
  blueGrey(Colors.blueGrey),
  teal(Colors.teal);

  const BackgroundColor(this.value);
  final Color value;
}

class GraphView extends StatefulWidget {
  static const routeName = '/graph_view';
  final Log log;

  const GraphView({super.key, required this.log});

  @override
  GraphViewState createState() => GraphViewState();
}

class GraphViewState extends State<GraphView> {
  bool isBarGraph = false;
  bool isCurve = false;
  bool showGridLines = true;
  GraphColor graphColor = GraphColor.blue;
  BackgroundColor graphBackground = BackgroundColor.white;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final futureData =
        Provider.of<LogProvider>(context).getDataNumeric(widget.log);
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: theme.shadowColor,
        title: Text(
          widget.log.title,
          style: theme.textTheme.headlineLarge,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isBarGraph ? Icons.show_chart : Icons.bar_chart,
            ),
            onPressed: () {
              setState(() {
                isBarGraph = !isBarGraph;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Toggle between BarChart and LineChart based on isBarGraph
            SizedBox(
              width: 400,
              height: 300,
              child: FutureBuilder(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return isBarGraph
                        ? _barChart(snapshot.data!)
                        : _lineChart(snapshot.data!);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
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
                    dropdownMenuEntries: [
                      for (final color in GraphColor.values)
                        DropdownMenuEntry<GraphColor>(
                          value: color,
                          label: color.name.toUpperCase(),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(color.value),
                            foregroundColor:
                                const MaterialStatePropertyAll<Color>(
                                    Colors.black),
                          ),
                        )
                    ],
                    menuStyle: MenuStyle(backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      return graphColor.value;
                    })),
                    onSelected: (selectedColor) {
                      if (selectedColor == null) {
                        return;
                      }
                      setState(() {
                        graphColor = selectedColor;
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
                  DropdownMenu<BackgroundColor>(
                    dropdownMenuEntries: [
                      for (final color in BackgroundColor.values)
                        DropdownMenuEntry<BackgroundColor>(
                          value: color,
                          label: color.name.toUpperCase(),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(color.value),
                            foregroundColor: MaterialStatePropertyAll<Color>(
                                getTextColorForBackground(color.value)),
                          ),
                        )
                    ],
                    menuStyle: MenuStyle(backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      return graphBackground.value;
                    })),
                    onSelected: (selectedColor) {
                      if (selectedColor == null) {
                        return;
                      }
                      setState(() {
                        graphBackground = selectedColor;
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
                    value: showGridLines,
                    onChanged: (value) {
                      setState(() {
                        showGridLines = value;
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
                    value: isCurve,
                    onChanged: (value) {
                      setState(() {
                        isCurve = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChart _lineChart(List<Numeric> data) {
    return LineChart(
      LineChartData(
        titlesData: const FlTitlesData(show: true),
        backgroundColor: graphBackground.value,
        lineBarsData: [
          LineChartBarData(
            isCurved: isCurve,
            spots: [
              for (final (index, n) in data.indexed)
                FlSpot(index.toDouble(), n.data)
            ],
            color: graphColor.value,
          ),
        ],
        gridData: FlGridData(show: showGridLines),
      ),
    );
  }

  BarChart _barChart(List<Numeric> data) {
    return BarChart(
      BarChartData(
        backgroundColor: graphBackground.value,
        barGroups: [
          for (final (index, n) in data.indexed)
            BarChartGroupData(
              x: index,
              barsSpace: 8,
              barRods: [
                BarChartRodData(
                  toY: n.data,
                  color: graphColor.value,
                ),
              ],
            )
        ],
        gridData: FlGridData(show: showGridLines),
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
