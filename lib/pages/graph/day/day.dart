import 'package:app_get/models/day_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class DayGraph extends StatelessWidget {
  final List<DayDataMap> data;
  const DayGraph({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < data.length - 1; i++) {
      data[i].isResistanceOn = data[i + 1].isResistanceOn;
    }

    return SfCartesianChart(
      onTrackballPositionChanging: (TrackballArgs args) {
        if (args.chartPointInfo.seriesIndex == 1) {
          args.chartPointInfo.header = 'header';
          args.chartPointInfo.label = 'label';
        } else {
          args.chartPointInfo.header = null;
          args.chartPointInfo.label = null;
        }
      },
      series: <ChartSeries<DayDataMap, dynamic>>[
        StepAreaSeries<DayDataMap, dynamic>(
          dataSource: data,
          xValueMapper: (DayDataMap map, _) => DayDataMap.formatTime(
            map.timeOfDay,
          ),
          yValueMapper: (DayDataMap map, _) => map.isResistanceOn,
          yAxisName: 'Resistencia',
          name: 'Resistencia',
          color: Theme.of(context).colorScheme.primary,
          opacity: 0.3,
          animationDuration: 2000,
          enableTooltip: false,
          markerSettings: const MarkerSettings(isVisible: false),
        ),
        LineSeries<DayDataMap, dynamic>(
          dataSource: data,
          xValueMapper: (DayDataMap map, _) => DayDataMap.formatTime(
            map.timeOfDay,
          ),
          yValueMapper: (DayDataMap map, _) => map.temperature,
          yAxisName: 'Temperatura',
          dataLabelMapper: (DayDataMap map, _) => '${map.temperature}°C',
          name: 'Temperatura',
          color: Colors.white,
          width: 3,
          enableTooltip: true,
          animationDuration: 2000,
        ),
      ],
      zoomPanBehavior: ZoomPanBehavior(
        enableDoubleTapZooming: true,
        enablePinching: true,
        enableMouseWheelZooming: true,
        enablePanning: true,
      ),
      primaryYAxis: NumericAxis(
        name: 'Temperatura',
        associatedAxisName: 'Temperatura',
        majorGridLines: const MajorGridLines(width: 0),
        minorGridLines: const MinorGridLines(width: 0),
        labelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w300,
        ),
        labelFormat: '{value}°C',
        decimalPlaces: 0,
        interval: 5,
        maximumLabels: 6,
        enableAutoIntervalOnZooming: false,
        numberFormat: NumberFormat.decimalPattern(),
      ),
      primaryXAxis: DateTimeAxis(
        axisLine: const AxisLine(
          width: 0,
        ),
        majorGridLines: const MajorGridLines(width: 0.5),
        labelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w300,
        ),
        dateFormat: DateFormat().add_Hm(),
        maximumLabels: 6,
      ),
      axes: [
        NumericAxis(
          minimum: 0,
          maximum: 1,
          associatedAxisName: 'Resistencia',
          name: 'Resistencia',
          majorGridLines: const MajorGridLines(width: 0),
          minorGridLines: const MinorGridLines(width: 0),
          isVisible: false,
        ),
      ],
      borderWidth: 0,
      trackballBehavior: TrackballBehavior(
        enable: true,
        markerSettings: const TrackballMarkerSettings(
          markerVisibility: TrackballVisibilityMode.hidden,
        ),
        activationMode: ActivationMode.singleTap,
        tooltipSettings: InteractiveTooltip(
          enable: false,
          color: Theme.of(context).colorScheme.primary,
          arrowLength: 0,
          arrowWidth: 0,
          canShowMarker: false,
        ),
        lineColor: Colors.white,
        lineDashArray: const [1, 3],
        builder: (context, trackballDetails) {
          String value = 'Temp: ${trackballDetails.point?.y}°C';
          String hour =
              "Hora: ${trackballDetails.point?.x.hour.toString().padLeft(2, '0')}:${trackballDetails.point?.x.minute.toString().padLeft(2, '0')}";
          String res = data[trackballDetails.pointIndex!].isResistanceOn == 1
              ? 'ON'
              : 'OFF';

          if (trackballDetails.seriesIndex == 0) return const SizedBox.shrink();

          return Container(
            child: Column(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  hour,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  res,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            height: 80,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
          );
        },
      ),
    );
  }
}
