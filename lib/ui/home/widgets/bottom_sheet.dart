import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

bottomsheet({
  required BuildContext context,
  required int index,
  required List<String> nameSongs,
  required List<FileSystemEntity> songs,
  required AudioPlayer player,
}) async {
  showMaterialModalBottomSheet(
    context: context,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * .95,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              width: 200,
              height: 200,
              child: LottieBuilder.asset("assets/lotties/default_music.json")),
          Text(nameSongs[index]),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 5,
            color: Colors.blue,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.skip_previous),
              ),
              IconButton(
                onPressed: () async {
                  await player.play(DeviceFileSource(songs[index].path));
                },
                icon: const Icon(Icons.play_arrow),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.skip_next))
            ],
          ),
        ],
      ),
    ),
  );
}
