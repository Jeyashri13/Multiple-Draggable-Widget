import 'package:flutter/material.dart';

class PositionedMarker extends StatefulWidget {
  PositionedMarker({Key? key}) : super(key: key);

  @override
  _PositionedMarkerState createState() => _PositionedMarkerState();
}

class _PositionedMarkerState extends State<PositionedMarker> {
  double xPos = Offset.zero.dx;
  double yPos = Offset.zero.dy;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPos,
      left: xPos,
      child: GestureDetector(
        onPanUpdate: (tapInfo) {
          setState(() {
            yPos += tapInfo.delta.dy;
            xPos += tapInfo.delta.dx;
          });
        },
        child: Icon(
          Icons.location_on,
          color: Colors.red,
          size: 34.0,
        ),
      ),
    );
  }
}
