import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:music_app/utils/color.dart';
import 'package:music_app/utils/text_style.dart';

bottomsheet({
  required BuildContext context,
  required int index,
  required List<String> nameSongs,
  required List<FileSystemEntity> songs,
  required AudioPlayer player,
  required bool isPlaying,
}) async {
  showMaterialModalBottomSheet(
    backgroundColor: MusicAppColor.C_536987,
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .95,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: isPlaying
                    ? LottieBuilder.asset("assets/lotties/default_music.json")
                    : Image.asset("assets/images/default_image.jpg"),
              ),
              Text(
                nameSongs[index],
                style: MusicAppTextStyle.w500,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 5,
                color: MusicAppColor.blue,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: MusicAppColor.white, shape: BoxShape.circle),
                    child: IconButton(
                      onPressed: () {
                        setState(() => {});
                      },
                      icon: const Icon(
                        Icons.skip_previous,
                        size: 25,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: MusicAppColor.white, shape: BoxShape.circle),
                    child: IconButton(
                      onPressed: () async {
                        isPlaying = !isPlaying;
                        isPlaying
                            ? await player.resume()
                            : await player.pause();
                        setState(() => {});
                      },
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 30,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: MusicAppColor.white, shape: BoxShape.circle),
                    child: IconButton(
                      onPressed: () {
                        setState(() => {});
                      },
                      icon: const Icon(
                        Icons.skip_next,
                        size: 25,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
