import 'package:flutter/material.dart';
import '../bean/helpInfoBean.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HelpInfo extends StatefulWidget {
    @override
    State createState() {
        return HelpInfoState();
    }
}

class HelpInfoState extends State<HelpInfo> {
    static final infoData = [
        Text("背景图"),
        Text("配对"),
        Text("位置"),
        Text("天气"),
        Text("个人信息"),
    ];

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("帮助中心"),
            ),
            body: ListView.builder(
                itemBuilder: (context, index) {
                    return ListTile(
                        leading: Icon(Icons.help),
                        title: infoData[index],
                        onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                    if (index == 0) {
                                        return BackgroundImageInfo();
                                    }
                                    return BackgroundImageInfo();
                                }));
                        },
                    );
                },
                itemCount: infoData.length,
            ),
        );
    }
}

class BackgroundImageInfo extends StatefulWidget {
    @override
    State createState() {
        return BackgroundImageInfoState();
    }
}

class BackgroundImageInfoState extends State<BackgroundImageInfo> {
    List<BgImageInfo> _list = new List<BgImageInfo>();
    ScrollController _scrollController = ScrollController();
    int page = 0;
    bool isLoading = false;
    bool isAll = false;
    final type = 1;
    final pageSize = 10;
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("背景图"),
            ),
            body: ListView.builder(
                itemCount: _list.length + 1,
                itemBuilder: (context, index) {
                    return _renderRow(context, index);
                },
                controller: _scrollController,
            ));
    }


    Widget _renderRow(BuildContext context, int index) {
        if (index == _list.length) {
            if(_list.length < pageSize){
                return null;
            }
            if (isAll) {
                return Text("没有更多了");
            }
            //load();
            return Text("加载中...");
        }
        if(index > _list.length){
            load();
            return null;
        }
        return Column(
            children: <Widget>[
                Text(
                    _list[index].question,
                    style: TextStyle(fontSize: 41),
                ),
                Text(
                    _list[index].answer,
                    style: TextStyle(fontSize: 32),
                ),
            ],
        );
    }

    @override
    void initState() {
        super.initState();
        load();
        _scrollController.addListener(() {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
                print('滑动到了最底部');
                load();
            }
        });
    }

    Future load() async {
        if (isLoading || isAll) {
            return null;
        }
        isLoading = true;
        final response =
        await http.get('http://localhost:8001/helpInfo/$type?page=$page');
        if (response.statusCode == 200) {
            setState(() {
                final list = json.decode(response.body);
                if (list.length == 0) {
                    isAll = true;
                }
                for (var l in list) {
                    _list.add(new BgImageInfo.fromJson(l));
                }
                isLoading = false;
                page += 1;
            });
        } else {
            throw Exception('请检查网络链接，稍后重试！');
        }
    }

}
