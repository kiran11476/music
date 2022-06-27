import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:marquee/marquee.dart';

import 'function.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:project/Screens/library.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

AssetsAudioPlayer play = AssetsAudioPlayer.withId('0');

class HomeScreen extends StatelessWidget {
  Req req = Req.instance;
  int? index;
  List<SongModel> fullsongs = [];
  List<SongModel>? songModel2;

  HomeScreen({Key? key, this.index})
      : super(
          key: key,
        );
  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  final OnAudioRoom _audioRoom = OnAudioRoom();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> songmodel = [];

  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    List<SongModel> songmodel = [];
    if (songModel2 == null) {
      _audioQuery.querySongs().then((value) {
        songmodel = value;
      });
    } else {
      songmodel = songModel2!;
    }
    _audioQuery.querySongs().then((value) {
      fullsongs = value;
    });

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 1, 4, 17),
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(145, 0, 0, 0),
          ),
          backgroundColor: const Color.fromARGB(176, 0, 0, 0),
          title: const Text('Music Player'),
          centerTitle: true,
        ),
        body: play.builderCurrent(
            builder: (BuildContext context, Playing? playing) {
          final myAudio = find(req.songs, playing!.audio.assetAudioPath);

          int? key;
          // for (var fav in favorites) {
          //   if (playing!.playlist.current.metas.title == fav.title) {
          //     isFav = true;
          //     key = fav.key;
          //   }
          // }
          return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  colors: [
                    // Color.fromARGB(255, 26, 43, 85),
                    Color.fromARGB(255, 0, 0, 1),
                    Color.fromARGB(255, 5, 13, 35),
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
                              border: Border.all(
                                  color: const Color.fromARGB(255, 17, 16, 16),
                                  width: 4)),
                          child: QueryArtworkWidget(
                            nullArtworkWidget: const Icon(
                              Icons.music_note_outlined,
                              size: 80,
                              color: Color.fromARGB(166, 255, 255, 255),
                            ),
                            artworkHeight: 60,
                            artworkWidth: 60,
                            id: int.parse(myAudio.metas.id!),
                            type: ArtworkType.AUDIO,
                            artworkBorder: BorderRadius.circular(8),
                          ),
                          width: 250.h,
                          height: 400.w,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
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

                    SizedBox(
                      height: 20.h,
                    ),
                    play.builderRealtimePlayingInfos(
                        builder: (context, RealtimePlayingInfos infos) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ProgressBar(
                          timeLabelTextStyle: const TextStyle(
                              color: Color.fromARGB(255, 230, 230, 230)),
                          timeLabelType: TimeLabelType.remainingTime,
                          baseBarColor:
                              const Color.fromARGB(255, 240, 235, 235),
                          progressBarColor:
                              const Color.fromARGB(122, 26, 90, 154),
                          thumbColor: Colors.blue,
                          barHeight: 4,
                          thumbRadius: 8,
                          progress: infos.currentPosition,
                          total: infos.duration,
                          onSeek: (slide) {
                            play.seek(slide);
                          },
                        ),
                      );
                    }),
                    SizedBox(
                      height: 20.h,
                    ),

                    //     }),
                    Container(
                      height: 120,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (isFav == false) {
                                _audioRoom.addTo(
                                    RoomType.FAVORITES,
                                    fullsongs[playing.index]
                                        .getMap
                                        .toFavoritesEntity(),
                                    ignoreDuplicate: false);

                                Fluttertoast.showToast(
                                    msg: "Added to favorites",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.SNACKBAR,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        const Color.fromARGB(255, 11, 11, 12),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                _audioRoom.deleteFrom(RoomType.FAVORITES, key!);
                                Fluttertoast.showToast(
                                    msg: "removed from favorites",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.SNACKBAR,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        const Color.fromARGB(255, 187, 27, 27),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                            icon: Icon(
                              isFav
                                  ? Icons.favorite_outline_outlined
                                  : Icons.favorite,
                              size: 30,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              play.previous();
                            },
                            icon: Icon(
                              Icons.skip_previous,
                              size: 40.sp,
                              color: const Color.fromARGB(255, 3, 2, 2),
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
                                      iconSize: 40.sp,
                                    );
                                  }),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                play.next();
                              },
                              icon: Icon(
                                Icons.skip_next,
                                size: 40.sp,
                                color: Color.fromARGB(255, 12, 12, 12),
                              )),
                          IconButton(
                            onPressed: () async {
                              dialogbox(
                                  context,
                                  int.parse(playing.playlist.current.metas.id!),
                                  playing.playlist.currentIndex,
                                  songmodel);
                              // dialogBox(
                              //     context,
                              //     int.parse(playing.playlist.current.metas.id!),
                              //     playing.playlist.currentIndex,
                              //     songmodel);
                            },
                            icon: Icon(
                              Icons.playlist_add,
                              size: 40.sp,
                              color: const Color.fromARGB(255, 12, 12, 12),
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
