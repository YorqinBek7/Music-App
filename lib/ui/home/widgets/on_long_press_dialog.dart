import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/cubit/music_cubit.dart';
import 'package:music_app/data/shared_preferences.dart';
import 'package:music_app/utils/color.dart';
import 'package:music_app/utils/text_style.dart';

Future<dynamic> onLongPressDialog({
  required BuildContext context,
  required String song,
  required int indexSelectedMusic,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: MusicAppColor.C_404C6C,
      content: SizedBox(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title:
                  const Text("Add to playlist", style: MusicAppTextStyle.w500),
              trailing: const Icon(
                Icons.playlist_add,
                color: MusicAppColor.C_1E1E29,
              ),
              onTap: () async {
                Navigator.pop(context);
                context.read<MusicCubit>().musicsInPlaylist.add(song);
                await StorageRepository.putList(
                    "favorites", context.read<MusicCubit>().musicsInPlaylist);
              },
            ),
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                try {
                  File file = File(context.read<MusicCubit>().songs[0].path);
                  await file.delete();
                  file.deleteSync(recursive: true);
                } catch (e) {
                  throw Exception(e);
                }
              },
              title: const Text(
                "Delete from phone",
                style: MusicAppTextStyle.w700,
              ),
              trailing: const Icon(Icons.remove, color: MusicAppColor.red),
            )
          ],
        ),
      ),
    ),
  );
}
