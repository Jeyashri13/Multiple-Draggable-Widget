import 'package:flutter/material.dart';

class PositionedMarker extends StatefulWidget {
  double markerSize;
  PositionedMarker({Key? key, required this.markerSize}) : super(key: key);

  @override
  _PositionedMarkerState createState() => _PositionedMarkerState();
}

class _PositionedMarkerState extends State<PositionedMarker> {
  double xPos = Offset.zero.dx;
  double yPos = Offset.zero.dy;
  double defaultSize = 34.0;

  @override
  void initState() {
    widget.markerSize = defaultSize;

    super.initState();
  }

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
          size: widget.markerSize,
        ),
      ),
    );
  }
}
