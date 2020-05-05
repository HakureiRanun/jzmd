import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jzmd/api.dart';

class ReadPage extends StatefulWidget {
  ReadPage();
  @override
  State<StatefulWidget> createState() {
    return ReadPageState();
  }
}

class ReadPageState extends State<ReadPage> {
  bool init = false;
  Map detail = {};
  List list = [];

  getPic() async {
    Response response = await baseApi('/view/' +
        detail['comic_id'].toString() +
        '/' +
        detail['id'].toString() +
        '.html');
    RegExp pattern =
        new RegExp('(?<=initData).*?(?=;)', dotAll: true);
    RegExp pattern_1 =
        new RegExp('https:.*?.(jpg|png)', dotAll: true);
    RegExp pattern_2 = new RegExp('\\\\u[0-9|a-f]{4}',dotAll: true );
    String firstResult = pattern.firstMatch(response.data.toString()).group(0);
    Iterable<RegExpMatch> images = pattern_1.allMatches(firstResult);
    for (Match i in images) {
      String a = i.group(0).replaceAll('\\\/', '/');
      a = a.replaceAllMapped(pattern_2, (Match match){
        return Uri.encodeComponent(new String.fromCharCode(_hexToInt(match.group(0).substring(2))));
      });
      setState(() {
        list.add(a);
      });
    }
  }

  
int _hexToInt(String hex) {
  int val = 0;
  int len = hex.length;
  for (int i = 0; i < len; i++) {
    int hexDigit = hex.codeUnitAt(i);
    if (hexDigit >= 48 && hexDigit <= 57) {
      val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 65 && hexDigit <= 70) {
      // A..F
      val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 97 && hexDigit <= 102) {
      // a..f
      val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
    } else {
      throw new FormatException("Invalid hexadecimal value");
    }
  }
  return val;
}


  @override
  Widget build(BuildContext context) {
    if (!init) {
      setState(() {
        detail = ModalRoute.of(context).settings.arguments;
        init = true;
      });
      getPic();
    }
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      child:
          list.length > 0
              ? ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Image.network(list[index],headers: {
                        'Referer': 'https://m.dmzj.com/view/'+detail['comic_id'].toString()+'/'+detail['id'].toString()+'.html'
                      },),
                    );
                  })
              :
          Container(),
    ));
  }
}