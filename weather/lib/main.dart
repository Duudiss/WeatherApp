import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'Utils/utils.dart';
import 'weatherPage.dart';
import 'dart:ui';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      routes: {WeatherPage.tag: (context) => WeatherPage()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position position = Position();
  http.Response response;
  AppResponsive appResponsive = AppResponsive();
  bool _loading = true;
  @override
  void didChangeDependencies() {
    appResponsive.setHeight(MediaQuery.of(context).size.height);
    appResponsive.setWidth(MediaQuery.of(context).size.width);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loading = false;
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage('lib/assets/wallpaper.jpg'), fit: BoxFit.cover
                )
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: appResponsive.getHeight(100.0)),
                    child: Text(
                      'Weather APP',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: appResponsive.getWidth(20)),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: appResponsive.getWidth(20),
                          vertical: appResponsive.getHeight(100)),
                      child: Text(
                        'Aplicativo desenvolvido para pegar os dados climáticos de seu região',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(top: appResponsive.getHeight(50))),
                  GestureDetector(
                    onTap: () {
                      (response == null)
                          ? WeatherWidgets()
                              .alertDialog(
                                  context: context,
                                  title: 'Erro',
                                  text:
                                      'Não foi possível pegar a localização atual no momento',
                                  btnConfirmText: 'Tentar Novamente',
                                  btnCancelText: '',
                                  btnCancel: false)
                              .then((value) => _getLocation())
                          : Navigator.pushNamed(context, WeatherPage.tag,
                              arguments: response.body);
                    },
                    child: Container(
                      
                      height: appResponsive.getHeight(50),
                      width: appResponsive.getWidth(200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      child: Center(
                          child: Text(
                        'Buscar',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: appResponsive.getWidth(18)),
                      )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
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

  _getLocation() async {
    try {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _loading = true;
        print(position);
        getWeather();
      });
    } catch (e) {
      print('Permissão não garantida');
      setState(() {
        _loading = false;
      });
    }
  }

  getWeather() async {
    response = await http.post(
        'http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=178fa1b046359da9731ee3b1824800c3&units=metric&lang=pt_br');
    setState(() {
      _loading = false;
    });
  }
}
