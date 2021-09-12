import 'package:flutter/material.dart';

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
  Size size = Size(0, 0);
  Offset offset = Offset(0, 0);
  late RenderBox renderBox;
  TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    pos.add(Position(10, 10));
    pos.add(Position(50, 50));
    pos.add(Position(25, 100));
    pos.add(Position(50, 100));

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
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: <Widget>[
        InteractiveViewer(
          minScale: 0.5,
          maxScale: 2.5,
          transformationController: _transformationController,
          onInteractionEnd: (scale) {
            setState(() {
              endScale = _transformationController.value.getMaxScaleOnAxis();
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
              child: CustomMultiChildLayout(
                delegate: DragArea(pos),
                children: <Widget>[
                  for (int i = 0; i < pos.length; i++)
                    LayoutId(
                      id: 't' + i.toString(),
                      child: Draggable(
                        feedback: Icon(Icons.location_on),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                        ),
                        childWhenDragging: Container(),
                        onDragEnd: (DraggableDetails d) {
                          setState(() {
                            renderBox = context.findRenderObject() as RenderBox;
                            offset = renderBox.globalToLocal(d.offset);
                          });
                          print('this is drag detail ' + d.offset.toString());
                          print(
                              'this is adjusted details ' + offset.toString());
                          updateDraggedPosition(i, offset);
                        },
                      ),
                    ),
                ],
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
                      setState(() {
                        pos.add(Position(Offset.zero.dx, Offset.zero.dy));
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
                      if (pos.length > 0) {
                        pos.removeLast();
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return errorDialog;
                            });
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
    );
  }

  void updateDraggedPosition(int i, Offset d) {
    pos[i].setPosition(d.dx, d.dy);
  }
}

class DragArea extends MultiChildLayoutDelegate {
  List<Position> _p = <Position>[];

  DragArea(this._p);

  @override
  void performLayout(Size size) {
    for (int i = 0; i < _p.length; i++) {
      layoutChild('t' + i.toString(), BoxConstraints.loose(size));
      positionChild('t' + i.toString(), Offset(_p[i].x, _p[i].y));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}
