import 'package:flutter/material.dart';

class AppResponsive {
  static AppResponsive _instance;
  static const double _WIDTH = 414;
  static const double _HEIGHT = 736;
  double _percentualWidth;
  double _percentualHeight;
  

  factory AppResponsive() {
    _instance ??= AppResponsive._internalConstructor();

    return _instance;
  }

  AppResponsive._internalConstructor();

  void setWidth(double width) {
    if (_percentualWidth == null) {
      _percentualWidth = width / _WIDTH;
      if (_percentualWidth > 1) {
        _percentualWidth = 1;
      }
    }
  }

  void setHeight(double height) {
    if (_percentualHeight == null) {
      //desconsidera o tamanho da statusBar e da actionBar
      _percentualHeight = height / _HEIGHT;
      if (_percentualHeight > 1) {
        _percentualHeight = 1;
      }
    }
  }

  double getWidth(double width) => _percentualWidth * width;
  double getHeight(double height) => _percentualHeight * height;
}

 class WeatherWidgets
{
  static WeatherWidgets _instance;
  AppResponsive _responsive;

  factory WeatherWidgets() {
    _instance ??= WeatherWidgets._internal();
    return _instance;
  }

  WeatherWidgets._internal() {
    _responsive = AppResponsive();
  }
  Future<dynamic> alertDialog({
    @required BuildContext context,
    @required String title,
    @required String text,
    @required String btnConfirmText,
    @required String btnCancelText,
    bool btnCancel = true,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0.0),
            backgroundColor: Colors.transparent,
            content: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            _responsive.getWidth(12.0),
                            _responsive.getHeight(11.0),
                            _responsive.getWidth(12.0),
                            0.0),
                        color: Colors.transparent,
                        child: Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: _responsive.getWidth(29.0)),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _responsive.getWidth(16.0),
                        color: Colors.black,
                        letterSpacing: 0.1,
                        height: 1.46,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: _responsive.getHeight(19.0),
                      horizontal: _responsive.getWidth(29.0),
                    ),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _responsive.getWidth(12),
                        color: Colors.black,
                        letterSpacing: 0.1,
                        height: 1.83,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: _responsive.getWidth(29.0)),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(true),
                      child: Container(
                        height: _responsive.getHeight(42.0),
                        width: _responsive.getWidth(270.0),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.blue,
                              Colors.lightBlue
                            ]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0))),
                        child: Center(
                          child: Text(
                            btnConfirmText,
                            style: TextStyle(
                              fontSize: _responsive.getWidth(14),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  btnCancel
                      ? GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                                vertical: _responsive.getHeight(26.0)),
                            child: Text(
                              btnCancelText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: _responsive.getWidth(14),
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                letterSpacing: 0.1,
                                height: 1.35,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                              bottom: _responsive.getHeight(24.0)),
                        )
                ],
              ),
            ),
          );
        });
  }}