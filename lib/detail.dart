import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jzmd/api.dart';
import 'package:jzmd/base.dart';

class DetailPage extends StatefulWidget {
  DetailPage();
  @override
  State<StatefulWidget> createState() {
    return DetailPageState();
  }
}

class DetailPageState extends State<DetailPage> {
  Map detail = {};
  List list = [];
  bool init = false;
  DateTime date;
  int select = 0;
  int col = 3;

  getDetail() async {
    Response response =
        await baseApi('/info/' + detail['id'].toString() + '.html');
    RegExp pattern =
        new RegExp('(?<=initIntroData).*?(?=;)', unicode: true, dotAll: true);
    String result = pattern.firstMatch(response.data.toString()).group(0);
    result = result.substring(1, result.length - 1);
    setState(() {
      list = jsonDecode(result);
    });
  }

  Widget getType() {
    List<Widget> child = [];
    for (int i = 0; i < list.length; i++) {
      child.add(InkWell(
          onTap: () {
            setState(() {
              select = i;
            });
          },
          child: Container(
            padding: EdgeInsets.all(10),
              child: Text(
            list[i]['title'],
            style: TextStyle(color: i == select ? Colors.blue : Colors.black),
          ))));
    }
    Row result = new Row(
      children: child,
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (!init) {
      setState(() {
        detail = ModalRoute.of(context).settings.arguments;
        date = DateTime.fromMillisecondsSinceEpoch(
            detail['last_updatetime'] * 1000);
        init = true;
      });
      getDetail();
    }

    return BasePage(
      title: detail['name'],
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom:
                          BorderSide(color: Color.fromRGBO(200, 200, 200, 1)))),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 80,
                  height: 100,
                  color: Color(0xe5e5e5),
                  child: Image(
                    image: NetworkImage(
                        'https://images.dmzj.com/' + detail['cover'],
                        headers: {
                          'Content-Type': 'image/png',
                          'Referer': 'https://m.dmzj.com/latest.html',
                          'User-Agent':
                              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36'
                        }),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail['name'] ?? '',
                          ),
                          Text(
                            detail['types'] ?? '',
                          ),
                          Text(
                              "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}")
                        ]),
                  ),
                )
              ]),
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              constraints: BoxConstraints(
                minHeight: 50,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom:
                          BorderSide(color: Color.fromRGBO(200, 200, 200, 1)))),
              child: Text(detail['description']),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: getType(),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(10),
                child: list.length > 0
                    ? ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: (list[select]['data'].length / col).ceil(),
                        itemBuilder: (BuildContext context, int index) {
                          List<Widget> children = [];
                          for (int c = 0; c < col; c++) {
                            children.add(
                              Expanded(
                                flex: 1,
                                child: index * col + c <
                                        list[select]['data'].length
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed('/read', arguments: list[select]['data'][index * col + c]);
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        200, 200, 200, 1),
                                                    width: 1)),
                                            margin: EdgeInsets.all(10),
                                            padding: EdgeInsets.all(10),
                                            alignment: Alignment.center,
                                            child: Text(
                                                list[select]['data']
                                                        [index * col + c]
                                                    ['chapter_name'],
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis)))
                                    : Container(),
                              ),
                            );
                          }
                          return Container(
                            child: Row(children: children),
                          );
                        })
                    : Container(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
