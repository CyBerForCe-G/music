import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:music/models/music.dart';
import 'package:music/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int curindex = 0;
  Content selectedMusic = music[0], previousSelection = music[0];
  Color selectedColor = music[0].color;
  PlayerState playerState = PlayerState.STOPPED;

  Duration totalDuration = Duration(minutes: 0, seconds: 20);
  Duration position = Duration(minutes: 0, seconds: 0);

  final AudioPlayer audioPlayer = AudioPlayer();

  initAudio() {
    audioPlayer.onDurationChanged.listen((updatedDuration) {
      setState(() {
        totalDuration = updatedDuration;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((updatedPosition) {
      setState(() {
        position = updatedPosition;
      });
    });

    audioPlayer.onPlayerCompletion.listen((event) {
      next();
      setState(() {
        position = totalDuration;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initAudio();
  }

  playAudio(url) {
    audioPlayer.play(url);
    setState(() {
      playerState = PlayerState.PLAYING;
    });
  }

  resumeAudio() {
    audioPlayer.resume();
    setState(() {
      playerState = PlayerState.PLAYING;
    });
  }

  pauseAudio() {
    audioPlayer.pause();
    setState(() {
      playerState = PlayerState.PAUSED;
    });
  }

  stopAudio() {
    audioPlayer.stop();
    setState(() {
      playerState = PlayerState.STOPPED;
    });
  }

  seekAudio(value) {
    audioPlayer.seek(value);
    setState(() {
      position = value;
    });
  }

  next() {
    int len = music.length;
    int index = selectedMusic.id;
    previousSelection = selectedMusic;
    selectedMusic = music[(index + 1) % len];
    playAudio(music[(index + 1) % len].audioUrl);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, selectedColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: [
            100.heightBox,
            "All Musics".text.xl2.semiBold.white.make().px16(),
            20.heightBox,
            ListView.builder(
              itemCount: music.length,
              itemBuilder: (context, index) {
                final m = music[index];
                return Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [Colors.black, selectedColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )),
                  child: ListTile(
                    leading: Icon(
                      Icons.audiotrack_rounded,
                      color: Colors.white,
                    ),
                    title: "${m.name}".text.xl.white.make(),
                    subtitle: "${m.movie}".text.white.make(),
                    onTap: () {
                      playAudio(m.audioUrl);
                      setState(() {
                        selectedColor = m.color;
                        selectedMusic = m;
                      });
                    },
                  ),
                );
              },
            ).expand()
          ].vStack(crossAlignment: CrossAxisAlignment.start),
        ),
      ),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        child: CustomAppBar(),
        preferredSize: Size(screenSize.width, 50.0),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/music1.jpg"),
                  fit: BoxFit.cover),
            ),
          ),
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(
                LinearGradient(
                  colors: [selectedColor, Colors.transparent],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              )
              .seconds(sec: 2)
              .fastOutSlowIn
              .make(),
          VxSwiper.builder(
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayAnimationDuration: 3.seconds,
            itemCount: music.length,
            aspectRatio: 1.0,
            onPageChanged: (index) {
              final color = music[index].color;
              setState(() {
                selectedColor = color;
              });
            },
            itemBuilder: (context, index) {
              final Content mus = music[index];
              return VxBox(
                child: ZStack(
                  [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: VStack(
                        [
                          mus.name.text.xl.white.bold.make(),
                          5.heightBox,
                        ],
                        crossAlignment: CrossAxisAlignment.center,
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.play_circle_fill_rounded,
                          color: Colors.grey,
                          size: 45.0,
                        ).onInkTap(() {
                          playAudio(mus.audioUrl);
                          previousSelection = selectedMusic;
                          selectedMusic = mus;
                        })),
                    Positioned(
                      left: 0.0,
                      top: 0.0,
                      child: VxBox(
                              child: mus.category.text.uppercase.white
                                  .make()
                                  .px16())
                          .height(40)
                          .black
                          .alignCenter
                          .withRounded(value: 10.0)
                          .make(),
                    ),
                  ],
                ),
              )
                  .clip(Clip.antiAlias)
                  .bgImage(
                    DecorationImage(
                      image: NetworkImage(mus.imageUrl),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4), BlendMode.darken),
                    ),
                  )
                  .border(color: mus.color)
                  .withRounded(value: 60.0)
                  .make()
                  .p12();
            },
          ).centered(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: playerState == PlayerState.PLAYING
                    ? VxSwiper.builder(
                        itemCount: 1,
                        autoPlay: true,
                        autoPlayAnimationDuration: 12.seconds,
                        autoPlayCurve: Curves.linear,
                        enableInfiniteScroll: true,
                        height: 40.0,
                        itemBuilder: (context, index) {
                          return Text(
                            "Playing Now - ${selectedMusic.name}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      )
                    : Container(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: [
              SliderTheme(
                data: SliderThemeData(
                    trackHeight: 3.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4.0)),
                child: Slider(
                  value: playerState == PlayerState.STOPPED
                      ? 0
                      : position.inMilliseconds.toDouble(),
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                  onChanged: (value) {
                    seekAudio(Duration(milliseconds: value.toInt()));
                  },
                  min: 0,
                  max: totalDuration.inMilliseconds.toDouble(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    position.toString().split(".")[0],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    totalDuration.toString().split(".")[0],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.skip_previous_rounded,
                    size: 40.0,
                    color: Colors.white,
                  ).onInkTap(() {
                    playAudio(previousSelection.audioUrl);
                  }),
                  SizedBox(
                    width: 25.0,
                  ),
                  Icon(
                    playerState == PlayerState.PLAYING
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_arrow_rounded,
                    size: 55.0,
                    color: Colors.white,
                  ).onInkTap(
                    () {
                      if (playerState == PlayerState.PLAYING) {
                        pauseAudio();
                      } else {
                        resumeAudio();
                      }
                    },
                  ),
                  SizedBox(
                    width: 25.0,
                  ),
                  Icon(
                    Icons.stop_rounded,
                    size: 40.0,
                    color: Colors.white,
                  ).onInkTap(
                    () {
                      stopAudio();
                    },
                  ),
                ],
              ),
            ].vStack(),
          ).pOnly(bottom: context.percentHeight * 7)
        ],
        fit: StackFit.expand,
      ),
    );
  }
}
