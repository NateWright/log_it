import 'package:flutter/material.dart';
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
  bool isBarGraph = false;
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
              const Text('Line Color', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
               DropdownButton<Color>(
                  value: graphColor,
                  items: [
                    for (final color in [
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                      Colors.orange,
                      Colors.yellow,
                      Colors.purple,
                    ])
                      DropdownMenuItem<Color>(
                        value: color,
                        child: Container(
                          color: color,
                          height: 20,
                        ),
                      )
                  ],
                  onChanged: (selectedColor) {
                    setState(() {
                      graphColor = selectedColor!;
                    });
                  },
                  hint: Text('Select Line Color'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Background Color', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                DropdownButton<Color>(
                  value: graphBackgroundColor,
                  items: [
                    for (final bgColor in [
                      Colors.white,
                      Colors.grey,
                      Colors.black,
                      Colors.blueGrey,
                      Colors.teal,
                    ])
                      DropdownMenuItem<Color>(
                        value: bgColor,
                        child: Container(
                          color: bgColor,
                          height: 20, 
                        ),
                      )
                  ],
                  onChanged: (selectedBgColor) {
                    setState(() {
                      graphBackgroundColor = selectedBgColor!;
                    });
                  },
                  hint: Text('Select Background Color'),
                ),
              ],
            ),
             ElevatedButton(
              onPressed: () {
              setState(() {
                showGridLines = !showGridLines;
              });
            },
            child: Text('Toggle Gridlines'),
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
                FlSpot(index.toDouble(), n.data)
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

