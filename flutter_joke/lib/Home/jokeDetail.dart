import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class JokeDetail extends StatelessWidget {

  final String contentStr;

  JokeDetail({Key key,@required this.contentStr}) : super(key: key);


  final LinearGradient backgroundGradient = new LinearGradient(
      colors: [new Color.fromRGBO(59, 66, 91, 1.0), new Color.fromRGBO(62, 123, 252, 1.0)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  Future<void> jokeShare(String content) async {
    try {
      final channel = const MethodChannel('channel:Chenli');

      final String nativeSay = await channel.invokeMethod('ChenliShareFile', content);

//      print("$nativeSay");

    } catch(e) {
      print(e.toString());
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new SizedBox.expand(
        child: new Container(
          decoration: new BoxDecoration(gradient: backgroundGradient),
          child: new Stack(
            children: <Widget>[
              new Center(
                child: Text("${HtmlUnescape().convert(contentStr)}",style: TextStyle(color: Colors.white,fontSize: 20.0,fontFamily: "Billabong")),
              ),
              new Align(
                alignment: Alignment.topCenter,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      leading: new IconButton(
                        icon: new Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      actions: <Widget>[
                        new IconButton(
                          icon: new Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            jokeShare("${HtmlUnescape().convert(contentStr)}");
                          }
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}