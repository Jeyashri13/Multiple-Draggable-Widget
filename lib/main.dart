import 'package:flutter/material.dart';
import 'package:widget_image/draggableMarker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: 'Flutter Demo Home '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Position {
  Position(this._x, this._y);

  setPosition(double x, double y) {
    this._x = x;
    this._y = y;
  }

  double get x {
    return this._x;
  }

  double get y {
    return this._y;
  }

  double _x;
  double _y;
}

class _MyHomePageState extends State<MyHomePage> {
  List<Position> pos = <Position>[];
  AlertDialog errorDialog = AlertDialog();
  double endScale = 0;
  TransformationController _transformationController =
      TransformationController();
  List<PositionedMarker> _markers = [];
  double newMarkerSize = 0;

  @override
  void initState() {
    for (var i = 0; i < 3; i++) {
      _markers.add(PositionedMarker(
        markerSize: 34.0,
      ));
    }

    errorDialog = AlertDialog(
      title: Text('Oops!'),
      content: Text("Markers not found!"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
      ],
    );

    endScale = _transformationController.value.getMaxScaleOnAxis();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: <Widget>[
          InteractiveViewer(
            minScale: 0.5,
            maxScale: 2.5,
            transformationController: _transformationController,
            onInteractionEnd: (scale) {
              setState(() {
                endScale = _transformationController.value.getMaxScaleOnAxis();
                newMarkerSize = 34.0 / endScale;
              });
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/map.PNG"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Stack(
                  children: _markers,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        print(pos.length);
                        setState(() {
                          _markers.add(PositionedMarker(
                            markerSize: newMarkerSize,
                          ));
                        });
                      },
                      icon: Icon(Icons.add),
                      label: Text('Add Marker'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        if (_markers.length > 0) {
                          _markers.removeLast();
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return errorDialog;
                            },
                          );
                        }
                      });
                    },
                    icon: Icon(Icons.delete),
                    label: Text('Remove Marker'),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}

