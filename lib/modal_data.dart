import 'package:flutter/material.dart';

import 'background_modal_route.dart';

class ModalData extends StatefulWidget {
  const ModalData({super.key});

  @override
  State<StatefulWidget> createState() => _ModalDataState();
}

class _ModalDataState extends State<ModalData> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Stateful Backdrop Overlay Content'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Return Type : Int'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Return Data : $_counter'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Counter : $_counter'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: TextButton(
              onPressed: _incrementCounter,
              child: Text('Increment'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, _counter);
                  },
                  child: Text('Close with data'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
