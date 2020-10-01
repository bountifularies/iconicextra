import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicPlayerScreen(),
      theme: ThemeData(
          primaryColor: Color(0xFF000000),
          primarySwatch: Colors.red,
          primaryTextTheme:
              TextTheme(headline6: TextStyle(color: Color(0xFFFFFFFF)))),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  static const streamUrl = "http://proxima.shoutca.st:8901/stream";
  static const instagrramUrl =
      "https://www.iconicextra.com/index.php/request-a-song/";
  static const facebookUrl = "https://www.facebook.com/IconicExtra1/";
  static const websiteUrl = "http://iconicextra.com";
  static const twwiterUrl = "https://mobile.twitter.com/iconicextra?lang=en-gb";
  static const shareUrl =
      "https://play.google.com/store/apps/details?id=com.edevs.iconicextra";
  static const Link =
      "https://proxima.shoutca.st:2199/api.php?f=json&a[username]=ukbeatz&a[password]=MYSERVER2&xm=server.getstatus";
  bool _isPlaying = false;
  int menuColor = 0xFFFFFFFF;
  int bodyColor = 0xFF000000;
  int textColor = 0xFFFFFFFF;
  int cardBGColor = 0xFF000000;

  String currentSong = '------';
  String genre = '------';

  Timer _timer;
  int _start = 10;

  @override
  void initState() {
    super.initState();
    audioStart();
    playingStatus();
    FlutterRadio.play(url: streamUrl);

    getSongInfo();
    startTimer();
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
  }

  Future<void> audioStop() async {
    await FlutterRadio.stop();
  }

  Future playingStatus() async {
    bool isP = await FlutterRadio.isPlaying();
    setState(() {
      _isPlaying = isP;
    });
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start++;
            print('timer: ' + _start.toString());
            getSongInfo();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backPressed,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/radio-background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(height: 30.0),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.topRight,
                  child: FlatButton(
                      onPressed: () {
                        print('aaaaaaa');
                        appSharing();
                      },
                      child: Image.asset(
                        'assets/sharing.png',
                        color: Colors.blueGrey,
                        scale: 3.0,
                      )),
                ),
              ),
              Expanded(
                flex: 2,
                child: Image.asset('assets/logo redo1cl.png', fit: BoxFit.fill),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        height: 40.0,
                        decoration: new BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.5),
                            border: new Border.all(
                                color: Colors.black54, width: 2.0),
                            borderRadius: new BorderRadius.circular(12.0)),
                        child: new Text(
                          'LIVE ON-AIR NOW',
                          style: GoogleFonts.montserrat(
                              color: Colors.yellowAccent, fontSize: 18),
                        ),
                      ),
                      /* Text(
                        genre,
                        style: GoogleFonts.montserrat(
                            color: Colors.lightBlue, fontSize: 18),
                      ),*/
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        height: 60.0,
                        decoration: new BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.5),
                            border: new Border.all(
                                color: Colors.black54, width: 2.0),
                            borderRadius: new BorderRadius.circular(12.0)),
                        child: new Text(
                          currentSong,
                          style: GoogleFonts.montserrat(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                      /* Text(
                        currentSong,
                        style: GoogleFonts.montserrat(
                            color: Colors.yellow, fontSize: 20),
                      ),*/
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: IconButton(
                          iconSize: 30,
                          onPressed: () {
                            setState(() {
                              playingStatus();
                              FlutterRadio.playOrPause(url: streamUrl);
                              _isPlaying = !_isPlaying;
                            });
                          },
                          icon: Icon(
                            _isPlaying
                                ? FontAwesomeIcons.play
                                : FontAwesomeIcons.pause,
                            color: Color(textColor),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FlatButton(
                              onPressed: () {
                                goToUrl(instagrramUrl);
                              },
                              child: Icon(
                                FontAwesomeIcons.assistiveListeningSystems,
                                color: Colors.yellow,
                                size: 30.0,
                              )),
                          FlatButton(
                              onPressed: () {
                                goToUrl(facebookUrl);
                              },
                              child: Icon(
                                FontAwesomeIcons.facebook,
                                color: Colors.blueAccent,
                                size: 30.0,
                              )),
                          FlatButton(
                              onPressed: () {
                                goToUrl(websiteUrl);
                              },
                              child: Icon(
                                FontAwesomeIcons.firefoxBrowser,
                                color: Colors.redAccent,
                                size: 30.0,
                              )),
                          FlatButton(
                              onPressed: () {
                                goToUrl(twwiterUrl);
                              },
                              child: Icon(
                                FontAwesomeIcons.twitter,
                                color: Colors.lightBlueAccent,
                                size: 30.0,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 40.0,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _backPressed() async {
    return (await showDialog(
          barrierColor: Color(textColor),
          context: context,
          builder: (context) => new AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              'Alert!',
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
              'Do you want to exit Iconic Extra?',
              style: TextStyle(
                color: Color(textColor),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  audioStop();
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  getSongInfo() async {
    final response = await http.get(Link);

    var data = json.decode(response.body);
    setState(() {
      genre = data['response']['data']['status']['genre'].toString();
      currentSong =
          data['response']['data']['status']['currentsong'].toString();
    });
    print('response: ' +
        data['response']['data']['status']['currentsong'].toString());
  }

  void goToUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void appSharing() {
    Share.share('Check out my Iconic Extra Radio Station. ' + shareUrl);
  }
}
