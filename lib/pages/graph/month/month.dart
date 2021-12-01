import 'package:app_get/models/month_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class MonthGraph extends StatelessWidget {
  final List<MonthDataMap> data;

  const MonthGraph({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      series: [
        ColumnSeries(
          dataSource: data,
          xValueMapper: (MonthDataMap map, _) => map.dayNumber,
          yValueMapper: (MonthDataMap map, _) => map.powerConsumed,
          yAxisName: 'Consumo',
          name: 'Consumo',
          xAxisName: 'Dia',
          enableTooltip: true,
          animationDuration: 2000,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Colors.white,
            ],
            end: Alignment.topRight,
            begin: Alignment.bottomLeft,
            stops: const [0.7, 1],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
      ],
      primaryYAxis: NumericAxis(
        name: 'Consumo',
        associatedAxisName: 'Consumo',
        majorGridLines: const MajorGridLines(width: 0),
        minorGridLines: const MinorGridLines(width: 0),
        labelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w300,
        ),
        labelFormat: '{value}kWh',
        enableAutoIntervalOnZooming: false,
        numberFormat: NumberFormat.decimalPattern(),
      ),
      primaryXAxis: NumericAxis(
        numberFormat: NumberFormat.decimalPattern(),
        interval: 1,
        minimum: 0,
        decimalPlaces: 0,
        majorGridLines: const MajorGridLines(width: 0),
        minorGridLines: const MinorGridLines(width: 0),
        labelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w300,
        ),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        tooltipPosition: TooltipPosition.pointer,
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enableDoubleTapZooming: true,
        enablePinching: true,
        enableMouseWheelZooming: true,
        enablePanning: true,
        zoomMode: ZoomMode.x,
      ),
    );
  }
}
