import 'package:agro_care_web/providers/statictics_provider.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class StaticticsPage extends StatefulWidget {
  const StaticticsPage({super.key});

  @override
  State<StaticticsPage> createState() => _StaticticsPageState();
}

class _StaticticsPageState extends State<StaticticsPage> {
  StaticticsProvider? provider;

  void onReload() {
    provider!.databaseLoaded = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    provider ??= context.watch();

    if (!provider!.databaseLoaded) {
      provider!.checkForUpdate();
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Statictics"),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    final chart1 = PieChart(
      key: const ValueKey("PieChart1"),
      dataMap: provider!.selectedOptions,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: math.min(MediaQuery.of(context).size.width / 3.2, 300),
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      emptyColor: Colors.grey,
      emptyColorGradient: const [
        Color(0xff6c5ce7),
        Colors.blue,
      ],
      baseChartColor: Colors.transparent,
      legendLabels: const {
        'op-1': "আমি মাঠে ফসল ফলাই",
        'op-2': "আমি বাড়ির বাগানে ফসল ফলাই",
        'op-3': "আমি টবে ফসল ফলাই",
      },
    );
    final chart2 = PieChart(
      key: const ValueKey("PieChart2"),
      dataMap: provider!.selectedCrops,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: math.min(MediaQuery.of(context).size.width / 3.2, 300),
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      emptyColor: Colors.grey,
      emptyColorGradient: const [
        Color(0xff6c5ce7),
        Colors.blue,
      ],
      baseChartColor: Colors.transparent,
      legendLabels: const {
        "tomato": "টমেটো",
        "potato": "আলু",
        "corn": "ভুট্টা",
        "cucumber": "শশা",
        "onion": "পেঁয়াজ",
        "red_chili": "মরিচ",
        "eggplant": "বেগুন",
        "pumpkin": "মিষ্টি কুমড়া",
      },
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Statictics"),
        actions: (provider!.databaseLoaded)
            ? [
                IconButton.filledTonal(
                  onPressed: onReload,
                  icon: const Icon(Icons.replay_rounded),
                ),
                const SizedBox(width: 16),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Selected Options",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              chart1,
              const SizedBox(height: 10),
              const Text(
                "Selected Crops",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              chart2,
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
