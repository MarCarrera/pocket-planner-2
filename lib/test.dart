import 'package:flutter/material.dart';

import 'background_modal_route.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backdrop Modal Route Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // could be anything other than string,
  // depends on your BackdropModalRoute<T> return type
  String? backdropResult = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Backdrop Modal Route'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text('Return Data : $backdropResult'),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    // stateful default
                    Container(
                      child: TextButton(
                        child: Text(
                          "Default Backdrop (Stateful) \n (Int Return)",
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () async {
                          handleStatefulBackdropContent(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void handleStatelessBackdropContent(BuildContext context) async {
  //   final result = await Navigator.push(
  //     context,
  //     BackdropModalRoute<String>(
  //       overlayContentBuilder: (context) => StatelessBackdropOverlayContent(),
  //     ),
  //   );

  //   setState(() {
  //     backdropResult = result;
  //   });
  // }

  void handleStatefulBackdropContent(BuildContext context) async {
    final result = await Navigator.push(
      context,
      BackdropModalRoute<int>(
        overlayContentBuilder: (context) => CounterContentStateful(),
      ),
    );

    setState(() {
      backdropResult = result.toString();
    });
  }

  // void handleCustomizedBackdropContent(BuildContext context) async {
  //   await Navigator.push(
  //     context,
  //     BackdropModalRoute<void>(
  //       overlayContentBuilder: (context) {
  //         return Container(
  //           height: MediaQuery.of(context).size.height - 100.0,
  //           alignment: Alignment.center,
  //           padding: const EdgeInsets.all(24),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: <Widget>[
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Text('Customized Backdrop Modal'),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Text('Barrier Dismiss Disabled'),
  //               ),
  //               ElevatedButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: Text('Close'),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //       topPadding: 100.0,
  //       barrierColorVal: Colors.deepPurple,
  //       backgroundColor: Colors.amberAccent,
  //       backdropShape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(60),
  //           topRight: Radius.circular(60),
  //           bottomLeft: Radius.circular(200),
  //           bottomRight: Radius.circular(200),
  //         ),
  //       ),
  //       barrierLabelVal: 'Customized Backdrop',
  //       shouldMaintainState: false,
  //       canBarrierDismiss: false,
  //     ),
  //   );
  // }

  // void handleCustomBackdropModalRoute(BuildContext context) async {
  //   final result = await Navigator.push(
  //     context,
  //     CustomBackdropModalRoute(),
  //   );

  //   setState(() {
  //     backdropResult =
  //         result != null && result.isNotEmpty ? result.join(', ') : null;
  //   });
  // }
}

class CounterContentStateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CounterContentStatefulState();
}

class _CounterContentStatefulState extends State<CounterContentStateful> {
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
