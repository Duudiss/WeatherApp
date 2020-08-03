import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Utils/utils.dart';

class WeatherPage extends StatefulWidget {
  static const String tag = '/weatherPage';
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String data;
  Map<String, dynamic> map = Map<String, dynamic>();
  AppResponsive _responsive = AppResponsive();
  http.Response response;
  bool _loading = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data = ModalRoute.of(context).settings.arguments;
    map = json.decode(data);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage('lib/assets/wallpaper.jpg'), fit: BoxFit.cover
                )
              ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () =>
                          Navigator.popUntil(context, ModalRoute.withName('/')),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.location_on, size: _responsive.getWidth(20)),
                    Padding(
                        padding:
                            EdgeInsets.only(left: _responsive.getHeight(10))),
                    Text(
                      map['name'] + ' - ' + map['sys']['country'],
                      style: TextStyle(fontSize: _responsive.getWidth(20)),
                    ),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(top: _responsive.getHeight(50))),
                Text(
                  map['main']['temp'].toStringAsFixed(0) + '°C',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _responsive.getWidth(30)),
                ),
                Text(
                  map['weather'][0]['description'],
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: _responsive.getWidth(20)),
                ),
                Padding(
                    padding: EdgeInsets.only(top: _responsive.getHeight(20))),
                Text(
                  'Temperatura Aparente',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: _responsive.getWidth(20)),
                ),
                Text(
                  map['main']['feels_like'].toStringAsFixed(0) + '°C',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _responsive.getWidth(20)),
                ),
                Padding(
                    padding: EdgeInsets.only(top: _responsive.getHeight(20))),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Min/' + map['main']['temp_min'].toStringAsFixed(0) + '°C',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: _responsive.getWidth(20)),
                  ),
                  Text(
                    ' Máx/' + map['main']['temp_max'].toStringAsFixed(0) + '°C',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: _responsive.getWidth(20)),
                  ),
                ]),
                Padding(
                    padding: EdgeInsets.only(top: _responsive.getHeight(200))),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _loading = true;
                    });

                    refresh();
                  },
                  child: Icon(Icons.refresh),
                )
              ],
            ),
          ),
        )),
        _loading
            ? Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white))),
              )
            : Container()
      ],
    );
  }

  refresh() {
    http
        .post(
            'http://api.openweathermap.org/data/2.5/weather?lat=${map['coord']['lat']}&lon=${map['coord']['lon']}&appid=178fa1b046359da9731ee3b1824800c3&units=metric&lang=pt_br')
        .then((value) {
      setState(() {
        map = json.decode(value.body);
        _loading = false;
      });
    });
  }
}
