import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jzmd/api.dart';
import 'package:jzmd/base.dart';

class IndexPage extends StatefulWidget {
  IndexPage();
  @override
  State<StatefulWidget> createState() {
    return IndexPageState();
  }
}

class IndexPageState extends State<IndexPage> {
  List list = [];

  @override
  void initState() {
    super.initState();
    getList(0);
  }

  getList(index) async {
    Response response = await baseApi('/latest/'+index.toString()+'.json');
    setState(() {
      list.addAll(jsonDecode(response.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: '最新更新',
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              if(index == list.length - 1){
                getList((list.length/10).ceil());
              }
              DateTime date = DateTime.fromMillisecondsSinceEpoch(list[index]['last_updatetime']*1000);
              return Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Container(
                    width: 80,
                    height: 100,
                    color: Color(0xe5e5e5),
                    child: Image(
                      image: NetworkImage(
                          'https://images.dmzj.com/' + list[index]['cover'],
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
                          Text(list[index]['name'] ?? '', style: TextStyle(fontSize: 20),),
                          Text(list[index]['last_update_chapter_name'] ?? '',),
                          Text(list[index]['types'] ?? '',),
                          Text("${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}")
                        ]
                      ),
                    ),
                  )
                ]),
              );
            }),
      ),
    );
  }
}
