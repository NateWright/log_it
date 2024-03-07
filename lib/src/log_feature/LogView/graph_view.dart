import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:log_it/src/components/form_date_picker.dart';
import 'package:log_it/src/components/form_time_picker.dart';
import 'package:log_it/src/log_feature/CreateForm/log_create_form.dart';
import 'package:log_it/src/log_feature/LogView/log_data_view.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:log_it/src/log_feature/numeric.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';


class GraphView extends StatefulWidget {
  static const routeName = '/graph_view';
  final Log? log;

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

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: theme.shadowColor,
        title: Text(
          'Graph View - ${widget.log?.title ?? 'No Log Provided'}',
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
                widget.log?.title ?? 'No Log Provided',
                style: theme.textTheme.headlineMedium,
              ),
            ),
            // Toggle between BarChart and LineChart based on isBarGraph
            SizedBox(
              width: 400,
              height: 300,
              child: isBarGraph ? 
                 BarChart(
                    BarChartData(
                      backgroundColor: graphBackgroundColor,
                      barGroups: [
                        BarChartGroupData(x: 0, barsSpace: 8, barRods: [
                          BarChartRodData(
                            toY: 10,
                            color: graphColor,
                          ),
                        ]),
                        BarChartGroupData(x: 1, barsSpace: 8, barRods: [
                          BarChartRodData(
                            toY: 10,
                            color: graphColor,
                          ),
                        ]),
                        BarChartGroupData(x: 2, barsSpace: 8, barRods: [
                          BarChartRodData(
                            toY: 10,
                            color: graphColor,
                          ),
                        ]),
                        BarChartGroupData(x: 3, barsSpace: 8, barRods: [
                          BarChartRodData(
                            toY: 10,
                            color: graphColor,
                          ),
                        ]),
                      ],
                      gridData: FlGridData(show: showGridLines),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(show: true),
                      backgroundColor: graphBackgroundColor,
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 5),
                            FlSpot(1, 3),
                            FlSpot(2, 7),
                            FlSpot(3, 4),
                          ],
                          color: graphColor,
                        ),
                      ],
                      gridData: FlGridData(show: showGridLines),
                    ),
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