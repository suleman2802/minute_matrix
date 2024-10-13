import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../Providers/user_provider.dart';

class ChartWidget extends StatelessWidget {
  double meetingHoursConsumed;
  double totalMeetingHours;

  ChartWidget(this.meetingHoursConsumed,this.totalMeetingHours);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  positionFactor: 0.1,
                  angle: 90,
                  widget: Text(
                    meetingHoursConsumed.toStringAsFixed(0) + ' / ${totalMeetingHours.toString()}',
                    style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),
                  ))
            ],
            pointers: <GaugePointer>[
              RangePointer(
                value: meetingHoursConsumed,
                color: Theme.of(context).primaryColor,
                cornerStyle: CornerStyle.bothCurve,
                width: 0.2,
                sizeUnit: GaugeSizeUnit.factor,
              )
            ],
            minimum: 0,
            maximum: 100,
            showLabels: false,
            showTicks: false,
            axisLineStyle: AxisLineStyle(
              thickness: 0.2,
              cornerStyle: CornerStyle.bothCurve,
              color: Theme.of(context).canvasColor,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
          ),
        ],
      ),
    );
  }
}
