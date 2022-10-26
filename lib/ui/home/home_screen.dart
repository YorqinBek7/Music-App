// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:music_app/ui/home/widgets/playlists.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff080812),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff0f0f1d),
        actions: [
          Container(
            padding: const EdgeInsets.all(5),
            width: 300,
            child: const TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffefefff),
                suffixIcon: Icon(Icons.search),
                hintText: "Search a music",
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, style: BorderStyle.none),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff404c6c),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Text("Rasm"),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const Text("Your Playlist", style: TextStyle(color: Colors.white)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PlaylistContainers(
                byWho: 'noone',
                title: 'Best song 2022',
              ),
              const PlaylistContainers(
                byWho: 'noone',
                title: 'Best song 2022',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PlaylistContainers(
                byWho: 'noone',
                title: 'Best song 2022',
              ),
              const PlaylistContainers(
                byWho: 'noone',
                title: 'Best song 2022',
              ),
            ],
          )
        ],
      ),
    );
  }
}
