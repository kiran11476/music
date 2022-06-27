// import 'package:flutter/material.dart';
// import 'package:project/Screens/library.dart';

// class MusicSearch extends SearchDelegate<String> {
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [IconButton(onPressed: () {}, icon: const Icon(Icons.clear))];
//   }

//   @override
//   Widget buildLeading(BuildContext context) => IconButton(
//       onPressed: () {
//         close(context, '');
//       },
//       icon: Icon(Icons.arrow_back));

//   @override
//   Widget buildResults(BuildContext context) {
//     return Center(
//       child: Text(
//         query,
//         style: TextStyle(color: Colors.white),
//       ),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final searchedItem = query.isEmpty
//         ? songs
//         : songs
//             .where((element) => element.metas.title!
//                 .toLowerCase()
//                 .startsWith(query.toLowerCase().toString()))
//             .toList();
//     return Container();
//   }
// }

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:project/Screens/homescreen.dart';
import 'package:project/Screens/library.dart';
import 'package:project/playr.dart';

List<SongModel> allSongs = [];

class MySearch extends SearchDelegate {
  Req req = Req.instance;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          color: Colors.white,
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(
            Icons.clear,
          ))
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      textTheme: const TextTheme(displayMedium: TextStyle(color: Colors.white)),
      hintColor: Colors.red,
      appBarTheme: const AppBarTheme(
        color: Colors.black,
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          const InputDecorationTheme(
            border: InputBorder.none,
          ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

// search element
  @override
  Widget buildSuggestions(BuildContext context) {
    final searchSongItems = query.isEmpty
        ? req.songs
        : req.songs
            .where((element) => element.metas.artist!
                .toLowerCase()
                .startsWith(query.toLowerCase().toString()))
            .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: searchSongItems.isEmpty
          ? const Center(
              child: Text(
              "No Songs Found!",
              style: TextStyle(color: Colors.green),
            ))
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15).r,
              child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15).r),
                      child: ListTile(
                        onTap: (() {
                          HomeScreen(
                            index: index,
                          );
                          for (var item in searchSongItems) {
                            req.songs.add(Audio.file(item.toString(),
                                metas: Metas(id: item.toString())));
                          }
                          OpenPlayer(allSongs: req.songs, index: index)
                              .openAssetPlayer(index: index);
                        }),
                        leading: QueryArtworkWidget(
                            artworkHeight: 60.h,
                            artworkWidth: 60.w,
                            id: int.parse(searchSongItems[index].metas.id!),
                            type: ArtworkType.AUDIO),
                        title: Padding(
                          padding: const EdgeInsets.only(
                                  left: 5.0, bottom: 3, top: 3)
                              .r,
                          child: Text(
                            searchSongItems[index].metas.title!,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.sp),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 7.0).r,
                          child: Text(
                            searchSongItems[index].metas.artist!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.play_arrow,
                              size: 25.sp,
                              color: Colors.white,
                            )),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10.h,
                    );
                  },
                  itemCount: searchSongItems.length),
            ),
    );
  }
}
