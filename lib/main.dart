import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

BuildContext scaffoldContext;

displaySnackBar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    content: Text(msg),
    action: SnackBarAction(
      label: 'Ok',
    ),
  );
  Scaffold.of(scaffoldContext).showSnackBar(snackBar);
}

void main() {
  runApp(MaterialApp(
    title: "LED",
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    getInitLedState(); // Getting initial state of LED, which is by default off
  }
  //var assetImage1 = new AssetImage("assets/on.jpg");
  var assetImage2 = new AssetImage("assets/on.jpg");
  String _myImage1 = "assets/off.jpg";

  String _status = '';
  String url =
      'http://192.168.1.40:80/'; //IP Address which is configured in NodeMCU Sketch
  var response;

  getInitLedState() async {
    try {
      response = await http.get(url, headers: {"Accept": "plain/text"});
      setState(() {

      });
    } catch (e) {
      // If NodeMCU is not connected, it will throw error
      print(e);
      if (this.mounted) {
        setState(() {
          _status = 'Not Connected';
        });
      }
    }
  }



  turnOffLed() async {
    try {
      response =
      await http.get(url + 'led/off', headers: {"Accept": "plain/text"});
      setState(() {
        //status = response.body;
        //print(response.body);
          _myImage1 = "assets/off.jpg";

      });


    } catch (e) {
      // If NodeMCU is not connected, it will throw error
      print(e);
      displaySnackBar(context, 'Module Not Connected');

    }
    setState(() {


    });
  }

  turnOnLed() async {
    try {
      response =
      await http.get(url + 'led/on', headers: {"Accept": "plain/text"});
      setState(() {
        _myImage1 = "assets/on.jpg";

      });
    } catch (e) {
      // If NodeMCU is not connected, it will throw error
      print(e);
      displaySnackBar(context, 'Module Not Connected');
    }

  }

  BuildContext scaffoldContext;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text("NodeMCU With Flutter"),
        centerTitle: true,
      ),
      body: Builder(builder: (BuildContext context) {



        scaffoldContext = context;

        return ListView(
          children: <Widget>[
            Center(
                child: Image(
                  image: AssetImage(
                    _myImage1,
                  ),
                  height: 400.0,
                  width: 400.0,
                )
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90.0)),
                    textColor: Colors.black,
                    color: Colors.green,
                    onPressed: turnOnLed,
                    child: Text('Turn LED ON'),

                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90.0)),
                    color: Colors.redAccent,
                    onPressed: turnOffLed,
                    child: Text('Turn LED OFF'),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );}}