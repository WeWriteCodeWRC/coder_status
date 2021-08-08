import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codersstatus/components/colorscheme.dart';
import 'package:codersstatus/components/myAppBar.dart';
import 'package:codersstatus/components/myTextFormField.dart';
import 'package:codersstatus/components/myUserTile.dart';
import 'package:codersstatus/components/peerScreenSkeleton.dart';
import 'package:codersstatus/firebase_layer/getUserInfo.dart';
import 'package:codersstatus/firebase_layer/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PeersScreen extends StatefulWidget {
  const PeersScreen({Key key}) : super(key: key);

  @override
  _PeersScreenState createState() => _PeersScreenState();
}

class _PeersScreenState extends State<PeersScreen> {
  List<Widget> listOfUserTiles = [];
  bool isFirstTime = true;

  getPeersList() async {
    listOfUserTiles = [];
    var peers = await GetUserInfo.getUserPeers();
    if (peers.length != 0) {
      for (int i = 0; i < peers.length; i++) {
        var peerDocument = await GetUserInfo.getUserDocument(peers[i]);
        listOfUserTiles.add(MyUserTile(
            peerDocument['id'],
            peerDocument['avatarurl'],
            peerDocument['name'],
            peerDocument['codername']));
      }
    }
    setState(() {
      isFirstTime = false;
    });
  }

  Future futureFunction;

  @override
  void initState() {
    super.initState();
    futureFunction = getPeersList();
  }

  @override
  Widget build(BuildContext context) {
    return isFirstTime
        ? FutureBuilder(
            future: futureFunction,
            builder: (context, snapshot) {
              return PeersScreenSkeleton();
            },
          )
        : Scaffold(
            appBar: PreferredSize(
              child: MyAppBar('Peers'),
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
            ),
            body: listOfUserTiles.length == 0
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'You haven\'t added any Peers',
                            style: TextStyle(
                                color: ColorSchemeClass.lightgrey,
                                fontFamily: 'young',
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isFirstTime = true;
                              });
                            },
                            child: Text(
                              'Refresh',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: ColorSchemeClass.primarygreen,
                                  fontFamily: 'young',
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.028),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    backgroundColor: ColorSchemeClass.unactivatedblack,
                    onRefresh: () async {
                      await getPeersList();
                      return 0;
                    },
                    child: ListView(
                      children: listOfUserTiles,
                    ),
                  ),
          );
  }
}
