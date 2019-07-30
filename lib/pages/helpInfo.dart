import 'package:flutter/material.dart';
import '../bean/helpInfoBean.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
class HelpInfo extends StatefulWidget{

    @override
    State createState() {
        return HelpInfoState();
    }
}

class HelpInfoState extends State<HelpInfo>{
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
                itemBuilder: (context, index){
                    return ListTile(
                        leading: Icon(Icons.help),
                        title: infoData[index],
                        onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context){
                                    if(index == 0) {
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
            ListView.builder(
            itemBuilder: (context, index){
                return ListTile(
                    leading: Icon(Icons.help),
                    title: infoData[index],
                    onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context){
                                return BackgroundImageInfo();
                            }));
                    },
                );
            },
            itemCount: infoData.length,

        );
    }
}

class BackgroundImageInfo extends StatefulWidget{

    @override
    State createState() {
        return BackgroundImageInfoState();
    }
}

class BackgroundImageInfoState extends State<BackgroundImageInfo>{
    Future<List<BgImageInfo>> backgroundImageInfo;
    List<BgImageInfo> _list;
    int total = 0;
    bool isAll = false;
    final limit = 10;
    final type = 1;
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("背景图"),
            ),
            body: ListView.builder(

                        itemBuilder: (context, index){
                            if(index >= total){
                                backgroundImageInfo = getInfo();
                            }
                            if(index >= total && isAll){
                                return Text("");
                            }
                            return FutureBuilder<List<BgImageInfo>>(
                                future: backgroundImageInfo,
                                builder: (context, snapshot){
                                    if(snapshot.hasData){
                                        return Column(
                                            children: <Widget>[
                                                    Text(snapshot.data.elementAt(index).question),
                                                    Text(snapshot.data.elementAt(index).answer, style: TextStyle(fontSize: 12),)
                                                ]
                                            );
                                        }else if(snapshot.hasError){
                                            return Text("${snapshot.error}");
                                        }
                                        return CircularProgressIndicator();
                                    },
                                );
                            }

            ),
        );
    }

    @override
    void initState() {
        super.initState();
        backgroundImageInfo = getInfo();
    }
    Future<List<BgImageInfo>> getInfo() async{
        if(isAll){
            return _list;
        }
        final response =
            await http.get('http://localhost:8001/helpInfo/$type&limit=$limit&offset=$total');
        if(response.statusCode == 200){

            //print(json.decode(response.body));
            final list = json.decode(response.body);

            if(list.length < limit){
                isAll = true;
            }
            for(var l in list){
                _list.add(new BgImageInfo.fromJson(l));
            }
            total = _list.length;
            return _list;

        }else{
            throw Exception('请检查网络链接，稍后重试！');
        }
    }
}