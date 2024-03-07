import 'package:flutter/material.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:log_it/src/log_feature/numeric.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphView extends StatefulWidget {
  static const routeName = '/graph_view';
  final Log log;

  GraphView({Key? key, required this.log}) : super(key: key);

  @override
  GraphViewState createState() => GraphViewState();
}

class GraphViewState extends State<GraphView> {
  bool isBarGraph = true; // Set to false for line graph
  bool showGridLines = true;
  Color graphColor = Colors.blue;
  Color graphBackgroundColor = Colors.white;

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
          'Graph View - ${widget.log.title}',
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.log.title,
                style: theme.textTheme.headlineMedium,
              ),
            ),
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
                  return const Text('Loading'); // TODO: Add loading icon
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Rotate through a predefined set of colors
                      graphColor = _getNextColor(graphColor);
                    });
                  },
                  child: Text('Rotate Color'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Rotate through a predefined set of background colors
                      graphBackgroundColor =
                          _getNextBackgroundColor(graphBackgroundColor);
                    });
                  },
                  child: Text('Rotate Background Color'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Toggle gridlines
                      showGridLines = !showGridLines;
                    });
                  },
                  child: Text('Toggle Gridlines'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Placeholder implementation
                    print('Button 4 Pressed');
                  },
                  child: Text('Button 4'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement any action for the floating action button if needed
        },
        tooltip: 'Action',
        child: const Icon(Icons.add),
      ),
    );
  }

  LineChart _lineChart(List<Numeric> data) {
    return LineChart(
      LineChartData(
        titlesData: const FlTitlesData(show: true),
        backgroundColor: graphBackgroundColor,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (final (index, n) in data.indexed)
                FlSpot(n.date.millisecondsSinceEpoch.toDouble(), n.data)
            ],
            color: graphColor,
          ),
        ],
        gridData: FlGridData(show: showGridLines),
      ),
    );
  }

  BarChart _barChart(List<Numeric> data) {
    return BarChart(
      BarChartData(
        backgroundColor: graphBackgroundColor,
        barGroups: [
          for (final (index, n) in data.indexed)
            BarChartGroupData(
              x: index,
              barsSpace: 8,
              barRods: [
                BarChartRodData(
                  toY: n.data,
                  color: graphColor,
                ),
              ],
            )
        ],
        gridData: FlGridData(show: showGridLines),
      ),
    );
  }
}

Color _getNextColor(Color currentColor) {
  List<Color> availableColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.yellow,
    Colors.purple,
  ];

  int currentIndex = availableColors.indexOf(currentColor);
  int nextIndex = (currentIndex + 1) % availableColors.length;

  return availableColors[nextIndex];
}

Color _getNextBackgroundColor(Color currentColor) {
  // Predefined set of background colors
  List<Color> availableBackgroundColors = [
    Colors.white,
    Colors.grey,
    Colors.black,
    Colors.blueGrey,
    Colors.teal,
  ];
  int currentIndex = availableBackgroundColors.indexOf(currentColor);
  int nextIndex = (currentIndex + 1) % availableBackgroundColors.length;

  return availableBackgroundColors[nextIndex];
}
