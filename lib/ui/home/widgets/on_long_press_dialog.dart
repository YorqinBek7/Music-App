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
      title: Text(
        "Select option",
        style: MusicAppTextStyle.w500
            .copyWith(color: MusicAppColor.white, fontSize: 22),
      ),
      backgroundColor: MusicAppColor.C_404C6C,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title:
                const Text("Add to favorites", style: MusicAppTextStyle.w500),
            trailing: const Icon(
              Icons.playlist_add,
              color: MusicAppColor.C_1E1E29,
            ),
            onTap: () async {
              Navigator.pop(context);
              context.read<MusicCubit>().musicsInfavorites.add(song);
              await StorageRepository.putList(
                  "favorites", context.read<MusicCubit>().musicsInfavorites);
            },
          ),
        ],
      ),
    ),
  );
}
