import 'package:flutter/material.dart';
import 'package:music_app/utils/color.dart';
import 'package:music_app/utils/text_style.dart';

Future<dynamic> onLongPressDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: MusicAppColor.C_404C6C,
      content: SizedBox(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text("Add to playlist", style: MusicAppTextStyle.w500),
              trailing: Icon(
                Icons.playlist_add,
                color: MusicAppColor.C_1E1E29,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(
                "Delete from phone",
                style: MusicAppTextStyle.w700,
              ),
              trailing: Icon(Icons.remove, color: MusicAppColor.red),
            )
          ],
        ),
      ),
    ),
  );
}
