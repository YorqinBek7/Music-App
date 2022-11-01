import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:music_app/cubit/music_cubit.dart';
import 'package:music_app/utils/color.dart';
import 'package:music_app/utils/text_style.dart';

Duration currentPosition = Duration();
bottomsheet({
  required BuildContext context,
  required List<String> nameSongs,
  required AudioPlayer player,
  required Duration musicDuration,
}) async {
  showMaterialModalBottomSheet(
    backgroundColor: MusicAppColor.C_536987,
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          player.onPositionChanged.listen(
            (event) => {
              currentPosition = event,
              setState(
                () => {},
              )
            },
          );
          return SizedBox(
            height: MediaQuery.of(context).size.height * .95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    width: 200,
                    height: 200,
                    child: LottieBuilder.asset(
                      "assets/lotties/default_music.json",
                      animate: context.read<MusicCubit>().isPlaying,
                    )),
                Text(
                  nameSongs[context.read<MusicCubit>().activeSongIndex],
                  style: MusicAppTextStyle.w500,
                ),
                Slider(
                    max: musicDuration.inSeconds.toDouble(),
                    onChanged: (double value) {
                      player.seek(Duration(seconds: value.toInt()));
                      currentPosition = Duration(seconds: value.toInt());
                      setState(
                        () => {},
                      );
                    },
                    value: currentPosition.inSeconds.toDouble()),
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
                          context.read<MusicCubit>().isPlaying =
                              !context.read<MusicCubit>().isPlaying;
                          context.read<MusicCubit>().isPlaying
                              ? await player.resume()
                              : await player.pause();
                          setState(() => {});
                        },
                        icon: Icon(
                          context.watch<MusicCubit>().isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
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
                          setState(
                            () => {},
                          );
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
      );
    },
  );
}
