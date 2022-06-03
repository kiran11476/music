import 'dart:io';

import 'package:flutter/material.dart';

import 'package:project/Screens/favorites.dart';

import 'package:project/Screens/playlist.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Drag extends StatelessWidget {
  const Drag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(96, 0, 0, 0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'MUSIC PLAYER',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w700),
              ),
            ),
            height: 200.h,
            width: double.infinity,
          ),
          SizedBox(
            height: 10.h,
          ),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const FavScreen()));
              },
              child: tileList(
                Icons.favorite,
                'Favorites',
              )),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PlayScreen()));
              },
              child: tileList(Icons.add_photo_alternate, ' playlist')),
          GestureDetector(
              onTap: () {
                showAboutDialog(
                    context: context,
                    applicationName: 'Music',
                    applicationIcon: const Icon(Icons.music_note_outlined),
                    applicationVersion: "Version1.0.20.");
              },
              child: tileList(Icons.privacy_tip_outlined, 'About')),
          GestureDetector(
              onTap: () => exit(0), child: tileList(Icons.exit_to_app, 'Exit')),
          SizedBox(
            height: 50.h,
          ),
          const Text(
            ' Version 2.0.1',
            textAlign: TextAlign.justify,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

Widget tileList(
  IconData icon,
  String title,
) {
  return Column(
    children: [
      SizedBox(
        height: 10.h,
      ),
      ListTile(
        leading: CircleAvatar(
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ],
  );
}
