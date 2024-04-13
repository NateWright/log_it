import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:log_it/src/log_feature/graph_settings.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:log_it/src/log_feature/numeric.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GraphWidget(
                    log: widget.log,
                    dataPoints: dataPoints,
                    graphSettings: graphSettings,
                  ),
                ),
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
                                  getTextColorForBackground(color.value),
                                ),
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
                settingsItem(
                  title: 'Aggregate',
                  theme: theme,
                  child: Switch(
                    value: graphSettings.aggregate,
                    onChanged: (value) {
                      setState(() {
                        graphSettings.aggregate = value;
                      });
                    },
                  ),
                ),
                settingsItem(
                  title: 'Aggregate Interval:',
                  theme: theme,
                  child: DropdownMenu<AggregateInterval>(
                    enabled: graphSettings.aggregate,
                    initialSelection: graphSettings.aggregateInterval,
                    dropdownMenuEntries: [
                      for (final v in AggregateInterval.values)
                        DropdownMenuEntry<AggregateInterval>(
                          value: v,
                          label: v.name.toUpperCase(),
                        )
                    ],
                    onSelected: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        graphSettings.aggregateInterval = value;
                      });
                    },
                    hintText: 'Select Aggregate Interval',
                  ),
                ),
                settingsItem(
                  title: 'Aggregate Type:',
                  theme: theme,
                  child: DropdownMenu<AggregateType>(
                    enabled: graphSettings.aggregate,
                    initialSelection: graphSettings.aggregateType,
                    dropdownMenuEntries: [
                      for (final v in AggregateType.values)
                        DropdownMenuEntry<AggregateType>(
                          value: v,
                          label: v.name.toUpperCase(),
                        )
                    ],
                    onSelected: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        graphSettings.aggregateType = value;
                      });
                    },
                    hintText: 'Select Aggregate Type',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget settingsItem(
      {required String title,
      required ThemeData theme,
      required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyLarge,
          ),
          child
        ],
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
  final Log log;
  final List<Numeric> dataPoints;
  final GraphSettings graphSettings;

  const GraphWidget({
    super.key,
    required this.log,
    required this.dataPoints,
    required this.graphSettings,
  });
  @override
  Widget build(BuildContext context) {
    dynamic series;
    DateFormat formatter = DateFormat('HH:mm');
    if (dataPoints.length >= 2) {
      final firstPoint = dataPoints.first.date;
      final lastPoint = dataPoints.last.date;

      if (lastPoint.isAfter(firstPoint.add(const Duration(days: 30)))) {
        formatter = DateFormat("MM/yyyy");
      } else if (lastPoint.isAfter(firstPoint.add(const Duration(days: 1)))) {
        formatter = DateFormat("MM/dd");
      }
    }

    List<Numeric> aggregatedData = [];
    if(dataPoints.isNotEmpty && graphSettings.aggregate) {
      dataPoints.sort(
          (num1, num2) {
            if (num1.date.isBefore(num2.date)) {
              return -1;
            }
            return 1;
          }
      );
      DateTime prevDate = dataPoints.first.date;
      double prevSum = dataPoints.first.data;
      int count = 1;
      for (int i = 1; i < dataPoints.length; i++){
        Numeric n = dataPoints[i];
        if(checkAggregate(prevDate, n.date)){
          prevSum += n.data;
          count += 1;
        } else {
          switch(graphSettings.aggregateType) {
            case AggregateType.sum:
              break;
            case AggregateType.average:
              prevSum /= count;
              break;
          }
          aggregatedData.add(Numeric(date: prevDate, data: prevSum));
          prevDate = n.date;
          prevSum = n.data;
          count = 1;
        }
      }
      switch(graphSettings.aggregateType) {
        case AggregateType.sum:
          break;
        case AggregateType.average:
          prevSum /= count;
          break;
      }
      aggregatedData.add(Numeric(date: prevDate, data: prevSum));
    } else {
      aggregatedData = dataPoints;
    }
    print(aggregatedData);

    switch (graphSettings.graphType) {
      case GraphType.bar:
        series = _barChart(aggregatedData);
      case GraphType.line:
        series = _lineChart(aggregatedData);
      default:
        throw UnimplementedError();
    }

    return AspectRatio(
      aspectRatio: 1,
      child: SfCartesianChart(
        primaryXAxis: DateTimeCategoryAxis(
          axisLine: AxisLine(color: graphSettings.foregroundColor),
          labelStyle: TextStyle(color: graphSettings.foregroundColor),
          majorGridLines: MajorGridLines(
            color: graphSettings.showGridLines
                ? graphSettings.foregroundColor
                : Colors.transparent,
          ),
          dateFormat: formatter,
        ),
        primaryYAxis: NumericAxis(
          axisLine: AxisLine(color: graphSettings.foregroundColor),
          labelStyle: TextStyle(color: graphSettings.foregroundColor),
          majorGridLines: MajorGridLines(
            color: graphSettings.showGridLines
                ? graphSettings.foregroundColor
                : Colors.transparent,
          ),
          title: AxisTitle(
            text: log.unit,
            textStyle: TextStyle(
              color: graphSettings.foregroundColor,
            ),
          ),
        ),
        series: series,
        backgroundColor: graphSettings.graphBackgroundColor.value,
        plotAreaBorderColor: graphSettings.foregroundColor,
      ),
    );
  }

  _lineChart(List<Numeric> data) {
    return <CartesianSeries>[
      // Renders line chart
      LineSeries<Numeric, DateTime>(
        width: 4,
        dataSource: data,
        xValueMapper: (Numeric n, _) => n.date,
        yValueMapper: (Numeric n, _) => n.data,
        color: graphSettings.graphColor.value,
      )
    ];
  }

  _barChart(List<Numeric> data) {
    return <ColumnSeries<Numeric, DateTime>>[
      ColumnSeries<Numeric, DateTime>(
        dataSource: data,
        xValueMapper: (Numeric n, _) => n.date,
        yValueMapper: (Numeric n, _) => n.data,
        color: graphSettings.graphColor.value,
      ),
    ];
  }
  bool checkAggregate(DateTime prevDate, DateTime d) {
    switch(graphSettings.aggregateInterval){
      case AggregateInterval.day:
        if(prevDate.day == d.day && prevDate.month == d.month && prevDate.year == d.year){
          return true;
        } else {
          return false;
        }
      case AggregateInterval.week:
        if(Jiffy.parseFromDateTime(prevDate).weekOfYear == Jiffy.parseFromDateTime(d).weekOfYear && prevDate.year == d.year){
          return true;
        } else {
          return false;
        }
      case AggregateInterval.month:
        if(prevDate.month == d.month && prevDate.year == d.year){
          return true;
        } else {
          return false;
        }
      case AggregateInterval.year:
        if(prevDate.year == d.year){
          return true;
        } else {
          return false;
        }
    }
  }
}
