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
                      barGroups: [
                        BarChartGroupData(x: 0, barsSpace: 8, barRods: [
                          BarChartRodData(
                            toY: 10,
                            color: Colors.blue,
                          ),
                        ]),
                        BarChartGroupData(x: 1, barsSpace: 8, barRods: [
                          BarChartRodData(
                            toY: 10,
                            color: Colors.green,
                          ),
                        ]),
                        BarChartGroupData(x: 2, barsSpace: 8, barRods: [
                          BarChartRodData(
                            toY: 10,
                            color: Colors.orange,
                          ),
                        ]),
                        BarChartGroupData(x: 3, barsSpace: 8, barRods: [
                          BarChartRodData(
                            toY: 10,
                            color: Colors.purple,
                          ),
                        ]),
                      ],
                    ),
                  )
                : LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 5),
                            FlSpot(1, 3),
                            FlSpot(2, 7),
                            FlSpot(3, 4),
                          ],
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
            ),
             Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Placeholder implementation
                      print('Button 1 Pressed');
                    },
                    child: Text('Button 1'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Placeholder implementation
                      print('Button 2 Pressed');
                    },
                    child: Text('Button 2'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Placeholder implementation
                      print('Button 3 Pressed');
                    },
                    child: Text('Button 3'),
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
