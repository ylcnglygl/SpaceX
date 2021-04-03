import 'dart:async';
import 'package:flutter/material.dart';
import 'package:starship/model/spacex.dart';
import 'package:starship/service/fetch_data.dart';
import 'package:starship/style/theme.dart' as Style;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<SpaceX> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: Scaffold(
        backgroundColor: Style.Colors.secondColor,
        appBar: appBar(),
        body: SingleChildScrollView(
          child: Center(
            child: FutureBuilder<SpaceX>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data.links.patch.small);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      linksPatchSmall(snapshot),
                      sizedBoxHeight(context),
                      stalinkHeadline(snapshot, context),
                      starlinkBodyLine(snapshot, context),
                      sizedBoxHeight(context),
                      subDetail(context, snapshot),
                      youtubeVideoController(context, snapshot),
                      sizedBoxHeight(context),
                      ElevatedButton.icon(
                        label: Text('Starlink on Wikipedia'),
                        style: ElevatedButton.styleFrom(
                          primary: Style.Colors.titleColor,
                        ),
                        icon: Icon(Icons.web),
                        onPressed: () async {
                          if (await canLaunch(snapshot.data.links.wikipedia)) {
                            await launch(snapshot.data.links.wikipedia);
                          }
                        },
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }

  Row subDetail(BuildContext context, AsyncSnapshot<SpaceX> snapshot) {
    return Row(
      children: [
        flightNumber(context, snapshot),
        Spacer(),
        successText(context, snapshot),
      ],
    );
  }

  Row successText(BuildContext context, AsyncSnapshot<SpaceX> snapshot) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 20.0, bottom: 20.0),
          child: Text(
            "Success: ",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 10.0, top: 20.0, bottom: 20.0, right: 40.0),
          child: snapshot.data.success
              ? Image.asset(
                  'assets/true.png',
                  height: MediaQuery.of(context).size.height * 1 / 25,
                )
              : Text('Unsucceed'),
        ),
      ],
    );
  }

  Row flightNumber(BuildContext context, AsyncSnapshot<SpaceX> snapshot) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 40.0, top: 20.0, bottom: 20.0),
          child: Text(
            "Flight Number: ",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0, top: 20.0, bottom: 20.0),
          child: Text(
            snapshot.data.flightNumber.toString(),
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
        backgroundColor: Style.Colors.titleColor,
        title: Row(
          children: <Widget>[
            Container(
              height: 100,
              width: 200,
              child: Image.asset(
                "assets/logo.png",
                fit: BoxFit.cover,
              ),
            ),
          ],
        ));
  }

  Container youtubeVideoController(
      BuildContext context, AsyncSnapshot<SpaceX> snapshot) {
    return Container(
      height: MediaQuery.of(context).size.height * 4 / 10,
      width: MediaQuery.of(context).size.width * 8 / 10,
      child: YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId: snapshot.data.links.youtubeId,
          flags: YoutubePlayerFlags(
            hideControls: false,
            controlsVisibleAtStart: true,
            autoPlay: false,
            mute: false,
          ),
        ),
        showVideoProgressIndicator: true,
      ),
    );
  }

  Padding starlinkBodyLine(
      AsyncSnapshot<SpaceX> snapshot, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        snapshot.data.details,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  Padding stalinkHeadline(
      AsyncSnapshot<SpaceX> snapshot, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        snapshot.data.name,
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }

  SizedBox sizedBoxHeight(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 1 / 50,
    );
  }

  Padding linksPatchSmall(AsyncSnapshot<SpaceX> snapshot) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Image.network(snapshot.data.links.patch.small),
    );
  }
}
