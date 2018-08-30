import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../Api/JokeGet.dart';
import 'jokeDetail.dart';
import 'package:html_unescape/html_unescape.dart';

class Collection extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CollectionState();
  }
}


class CollectionState extends State<Collection> {
  List<JokeGet> colljokesData;

  //收藏表查询
  queryCollection() async{
    var databasePath = await getDatabasesPath();
    String path = join(databasePath,"collection.db");

    Database db = await openDatabase(path,version: 1,onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE collectionData (id INTEGER PRIMARY KEY, hashId TEXT, unixtime INTEGER, content TEXT, updatetime TEXT)"
      );
    });

    List<Map> list = await db.rawQuery('select * from collectionData');

    List<JokeGet> sqljokesData = List();
    list.forEach((data){
      JokeGet jo = JokeGet.fromJson(data);
      sqljokesData.add(jo);
    });

    setState(() {
      colljokesData = sqljokesData;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryCollection();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("collection",style:TextStyle(color: Colors.white, fontFamily: "Aveny"),),
        leading: new IconButton(
          icon: new Icon(
            Icons.backspace,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: const Color.fromRGBO(39, 35, 50, 1.0),
      body: colljokesData == null ? new Center(
         child: CircularProgressIndicator()
     ) : new Container(
      padding: const EdgeInsets.all(8.0),
      color: const Color.fromRGBO(39, 35, 50, 1.0),
      child: new GridView.count(
        crossAxisCount: 1,
        shrinkWrap: true,
        childAspectRatio:3.5,
        crossAxisSpacing:8.0,
        children: new List.generate(colljokesData.length, (index){
          JokeGet joke = colljokesData[index];
          return new Card(
            color: const Color.fromRGBO(71, 73, 89, 1.0),
            child: new SingleChildScrollView(
              child: new Container(
                child: new Column(
                  children: <Widget>[
                    new GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    JokeDetail(contentStr: joke.content,)
                            ));
                      },
                      child: new Text(
                          HtmlUnescape().convert(joke.content),
                          maxLines: 3,
                          style:TextStyle(color: Colors.white, fontFamily: "Aveny", fontSize: 17.0)
                      ),
                    ),
//                    new ButtonTheme.bar( // make buttons use the appropriate styles for cards
//                      child: new ButtonBar(
//                        children: <Widget>[
//                          new FlatButton(
//                            color: Color.fromRGBO(62, 123, 252, 1.0),
//                            child: const Text.rich(TextSpan(text:'Details',style: TextStyle(color: Colors.white, fontFamily: "Aveny"))) ,
//                            onPressed: () {
//                              Navigator.push(
//                                  context,
//                                  new MaterialPageRoute(
//                                      builder: (context) =>
//                                          JokeDetail(contentStr: joke.content,)
//                                  ));
//                            },
//                          ),
//                        ],
//                      ),
//                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    ));

  }
}