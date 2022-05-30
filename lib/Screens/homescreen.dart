import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:project/Screens/library.dart';
import 'package:on_audio_room/on_audio_room.dart';

class HomeScreen extends StatefulWidget {
  int? index;
  List<SongModel> fullsongs = [];
  HomeScreen({Key? key, this.index})
      : super(
          key: key,
        );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

AssetsAudioPlayer play = AssetsAudioPlayer.withId('0');

class _HomeScreenState extends State<HomeScreen> {
  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  double _currentSliderValue = 20;
  int _currentSelectedIndex = 0;
  final OnAudioRoom _audioRoom = OnAudioRoom();
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    _audioQuery.querySongs().then((value) {
      widget.fullsongs = value;
    });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(213, 0, 0, 0),
          title: const Text('Music Player'),
          centerTitle: true,
        ),
        body: play.builderCurrent(
            builder: (BuildContext context, Playing? playing) {
          final myAudio = find(songs, playing!.audio.assetAudioPath);
          bool isFav = false;
          int? key;

          return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(177, 0, 0, 0),
                    Color.fromARGB(255, 0, 0, 0)
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 4)),
                          child: QueryArtworkWidget(
                            artworkHeight: 60,
                            artworkWidth: 60,
                            id: int.parse(myAudio.metas.id!),
                            type: ArtworkType.AUDIO,
                            artworkBorder: BorderRadius.circular(8),
                          ),
                          width: 350,
                          height: 400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 30.0,
                      child: Marquee(
                        fadingEdgeEndFraction: 0.2,
                        fadingEdgeStartFraction: 0.2,
                        text: myAudio.metas.title!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 25),
                        velocity: 20,
                        startAfter: Duration.zero,
                        blankSpace: 100,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Slider(
                        thumbColor: const Color.fromARGB(231, 255, 255, 255),
                        activeColor: const Color.fromARGB(138, 255, 255, 255),
                        value: _currentSliderValue,
                        max: 100,
                        onChanged: (double value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        }),
                    Container(
                      height: 120,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (isFav != true) {
                                _audioRoom.addTo(
                                    RoomType.FAVORITES,
                                    widget.fullsongs[playing.index].getMap
                                        .toFavoritesEntity(),
                                    ignoreDuplicate: false);
                              } else {
                                _audioRoom.deleteFrom(RoomType.FAVORITES, key!);
                              }
                            },
                            icon: const Icon(Icons.favorite),
                            color: Colors.red,
                          ),
                          IconButton(
                            onPressed: () {
                              play.previous();
                            },
                            icon: const Icon(
                              Icons.skip_previous,
                              size: 40,
                              color: Color.fromARGB(255, 3, 2, 2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: IconButton(
                              onPressed: () {},
                              icon: PlayerBuilder.isPlaying(
                                  player: play,
                                  builder: (context, isPlaying) {
                                    return IconButton(
                                      onPressed: () {
                                        play.playOrPause();
                                      },
                                      icon: Icon(isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow),
                                      iconSize: 40,
                                    );
                                  }),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              play.next();
                            },
                            icon: const Icon(
                              Icons.skip_next,
                              size: 40.0,
                              color: Color.fromARGB(255, 12, 12, 12),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.playlist_add,
                              size: 40.0,
                              color: Color.fromARGB(255, 12, 12, 12),
                            ),
                          ),
                        ],
                      ),
                      color: Colors.white,
                    ),
                    const SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                        )
                        // color: Colors.white,
                        ),
                  ],
                ),
              ));
        }));
  }
}
