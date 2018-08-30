import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Api/Api.dart';
import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'jokeDetail.dart';
import '../Api/JokeGet.dart';
import 'package:html_unescape/html_unescape.dart';


class LayoutWater extends StatefulWidget {
  @override
  LayoutWaterState createState() {
    // TODO: implement createState
    return LayoutWaterState();
  }
}



class LayoutWaterState extends State<LayoutWater> {
  Database db;
  List<JokeGet> jokesData;
  int page = 1;
  var listTotalSize = 0;

  ScrollController _controller = new ScrollController();

  Future<Null> _pullToRefresh() async {
    page = 1;
    getJokeGetSList(false);
    return null;
  }

  LayoutWaterState() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels) {
        // scroll to bottom, get next page data
        print("load more ...$page");
        getJokeGetSList(true);
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //创建数据库
    createDataBase();
    //获取数据对象集合
    getJokeGetSList(false);

  }

  getJokeGetSList(bool isLoadMore){
    var url = Api.MainURL + "&page=$page&pagesize=10";
    http.get(url).then((response) {
      final responseJson = json.decode(response.body);

      final dataJson = responseJson["result"]["data"];
      List dataList = new List.from(dataJson);

      List<JokeGet> tempjokesData = List();
      dataList.forEach((data){
        JokeGet joke = JokeGet.fromJson(data);
        tempjokesData.add(joke);
        AddItemJoke(db, joke);
      });

//    print(db.rawQuery('SELECT * FROM jokeData'));

      setState(() {
        if (!isLoadMore) {
            jokesData = tempjokesData;
          } else {
            page++;
            jokesData.addAll(tempjokesData);
          }
      });
//      print(jokesData.last.content);
    });



  }

  //创建数据库
  createDataBase() async {
    var databasePath = await getDatabasesPath();

    String path = join(databasePath,"joke.db");

    db = await openDatabase(path,version: 1,onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE jokeData (id INTEGER PRIMARY KEY, hashId TEXT, unixtime INTEGER, content TEXT, updatetime TEXT)"
      );
    });


    queryLocal();

    //    //查
//    List<Map> list = await database.rawQuery('select * from jokeData where content=?',["contenttess1"]);
//    print(list);
//
//    //删
//    await database
//        .rawDelete('DELETE FROM jokeData WHERE hashId = ?', ['hashIdtess1']);
//
//    List<Map> list1 = await db.rawQuery('SELECT * FROM jokeData');
//    print(list1);
    //关闭数据库
//    await database.close();
  }

  //请求用完后，开始调用本地的数据库
  queryLocal() async{
    List<Map> list1 = await db.rawQuery('SELECT * FROM jokeData');
    List<JokeGet> sqljokesData = List();
    list1.forEach((data){
      JokeGet jo = JokeGet.fromJson(data);
      sqljokesData.add(jo);
    });

    setState(() {
      jokesData = sqljokesData;
    });
  }

  //数据库查询没有后才增加
  AddItemJoke(Database db,JokeGet onejoke) async {
    List<Map> list = await db.rawQuery('select * from jokeData where hashId=?',["${onejoke.hashId}"]);
    if (list.length == 0) {
      db.rawInsert(
          'INSERT INTO jokeData(hashId, unixtime, content, updatetime) VALUES ("${onejoke.hashId}", "${onejoke.unixtime}", "${onejoke.content}", "${onejoke.updatetime}")');
    }
  }


  //收藏表'保存
  collectiontable(JokeGet onejoke) async{
    var databasePath = await getDatabasesPath();
    String path = join(databasePath,"collection.db");

    Database db = await openDatabase(path,version: 1,onCreate: (Database db, int version) async {
      await db.execute(
      "CREATE TABLE collectionData (id INTEGER PRIMARY KEY, hashId TEXT, unixtime INTEGER, content TEXT, updatetime TEXT)"
      );
    });

    List<Map> list = await db.rawQuery('select * from collectionData where hashId=?',["${onejoke.hashId}"]);
    if (list.length == 0) {
      db.rawInsert(
          'INSERT INTO collectionData(hashId, unixtime, content, updatetime) VALUES ("${onejoke.hashId}", "${onejoke.unixtime}", "${onejoke.content}", "${onejoke.updatetime}")');
    }
  }

  final LinearGradient backgroundGradient = new LinearGradient(
      colors: [new Color.fromRGBO(59, 66, 91, 1.0), new Color.fromRGBO(62, 123, 252, 1.0)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return jokesData == null ? new Center(
      child: CircularProgressIndicator()
    ) : RefreshIndicator(child: new Container(
      padding: const EdgeInsets.all(8.0),
      color: const Color.fromRGBO(39, 35, 50, 1.0),
      child: new GridView.count(
        controller: _controller,
        crossAxisCount: 1,
        shrinkWrap: true,
        childAspectRatio:2.3,
        crossAxisSpacing:8.0,
          children: new List.generate(jokesData.length, (index){
            JokeGet joke = jokesData[index];
          return new Card(
            color: const Color.fromRGBO(39, 35, 50, 1.0),
            margin: EdgeInsets.all(10.0),
            child: new SingleChildScrollView(
              child: new Container(
                decoration: new BoxDecoration(gradient: backgroundGradient),
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
                          style:TextStyle(color: Colors.white, fontFamily: "Aveny",fontSize: 17.0)
                      ),
                    ),

                    new ButtonTheme.bar(
                      child: new ButtonBar(
                      children: <Widget>[
                          new FlatButton(
                            color: Colors.white,
                            child: const Text('Collection',style: TextStyle(color: Color.fromRGBO(44, 83, 153, 1.0), fontFamily: "Aveny")),
                            onPressed: () {
                              collectiontable(joke);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    ), onRefresh: _pullToRefresh);
  }
}