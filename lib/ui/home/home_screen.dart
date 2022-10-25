// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:music_app/ui/home/widgets/bottom_sheet.dart';
import 'package:music_app/ui/home/widgets/playlists.dart';
import 'package:music_app/utils/functions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as print;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer player = AudioPlayer();
  List<FileSystemEntity> _files = [];
  List<FileSystemEntity> _songs = [];
  List<String> _nameSongs = [];
  String name = "";
  String name2 = "";
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    await player.setSource(AssetSource("audios/music_1.mp3"));
    var permission = await Permission.storage.request();

    if (permission == PermissionStatus.denied) {
      await Permission.storage.request();
    }

    Directory dir = Directory('/storage/emulated/0/Music/Telegram/');
    String mp3Path = dir.toString();

    _files = dir.listSync(recursive: true, followLinks: false);
    getMusicFromStorage(
      songs: _songs,
      files: _files,
      nameOfReversed: name,
      nameOfSongs: name2,
      setState: (value) => {
        setState(
          () => {},
        )
      },
    );
  }

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
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _songs.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () async {
                  await bottomsheet(
                      context: context,
                      index: index,
                      nameSongs: _nameSongs,
                      songs: _songs,
                      player: player);
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  decoration: const BoxDecoration(color: Colors.red),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _nameSongs[index],
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
