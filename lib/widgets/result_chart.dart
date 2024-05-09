import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ResultChart extends StatelessWidget {
  final List<charts.Series<ResultData, String>> seriesList; // Corregir el tipo de la lista
  final bool animate;

  ResultChart(this.seriesList, {required this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
    );
  }
}

List<charts.Series<ResultData, String>> createSampleData() {
  final data = [
    ResultData('Correctas', 10),
    ResultData('Incorrectas', 5),
  ];

  return [
    charts.Series<ResultData, String>(
      id: 'Resultados',
      domainFn: (ResultData data, _) => data.category,
      measureFn: (ResultData data, _) => data.value,
      data: data,
      labelAccessorFn: (ResultData data, _) => '${data.category}: ${data.value}',
    )
  ];
}

class ResultData {
  final String category;
  final int value;

  ResultData(this.category, this.value);
}
