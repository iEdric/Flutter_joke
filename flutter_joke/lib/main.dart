import 'package:flutter/material.dart';
import 'Home/LayoutWater.dart' as layoutWater;
import 'package:flutter_joke/Home/collectionDetail.dart';
import 'package:flutter/cupertino.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        backgroundColor: Color.fromRGBO(39, 35, 50, 1.0),
        primaryColor: Color.fromRGBO(39, 35, 50, 1.0),
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyHomePageState();
  }
}


class MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{

  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3);
  }


  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      backgroundColor: const Color.fromRGBO(39, 35, 50, 1.0),
      appBar: new AppBar(
        title: new Text("Flutter Joke",style: TextStyle(color: Colors.white, fontFamily: "Billabong")),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.collections_bookmark,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                        Collection()
                )),
          ),
        ],
      ),
//        bottomNavigationBar: new Material(
//            color: const Color.fromRGBO(39, 35, 50, 1.0),
//            child: new TabBar(controller: controller, tabs: <Tab>[
//              new Tab(icon: new Icon(Icons.polymer, size: 30.0)),
//              new Tab(icon: new Icon(Icons.pages, size: 30.0)),
//              new Tab(icon: new Icon(Icons.flight_takeoff, size: 30.0)),
//            ])),
        body:
//        new TabBarView(controller: controller, children: <Widget>[
          new layoutWater.LayoutWater(),
//          new SourceLibraryScreen.SourceLibraryScreen(),
//          new CategoriesScreen.CategoriesScreen(),
//          new BookmarkScreen.BookmarksScreen(),
//        ])
    );
  }
}