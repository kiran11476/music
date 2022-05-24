import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  @override
  Widget build(BuildContext context) {
    final OnAudioRoom _audioroom = OnAudioRoom();
    List<FavoritesEntity>? favoriteSongs = [];
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 53, 85, 53),
              Color.fromARGB(255, 75, 71, 71)
            ],
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Favorites'),
              backgroundColor: Colors.black,
            ),
            body: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.data == null || snapshot.data == '') {
                  return Center(child: CircularProgressIndicator());
                }

                favoriteSongs = snapshot.data as List<FavoritesEntity>?;

                return ListView.builder(itemBuilder: (context, index) {
                  return ListTile(
                    leading: QueryArtworkWidget(
                        id: favoriteSongs![index].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget:
                            const Padding(padding: EdgeInsets.only(top: 5.0)
                                // Text(favoriteSongs![index].title),
                                )),
                    trailing: Icon(Icons.do_not_touch),
                  );
                });
              },
              future: _audioroom.queryFavorites(),
            )));
  }
}
