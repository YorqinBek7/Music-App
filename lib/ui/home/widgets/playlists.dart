import 'package:flutter/material.dart';
import 'package:music_app/utils/color.dart';
import 'package:music_app/utils/text_style.dart';

class PlaylistContainers extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final String image;
  const PlaylistContainers(
      {super.key,
      required this.title,
      required this.image,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        width: MediaQuery.of(context).size.width / 2 - 20,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: MusicAppColor.grey.withOpacity(.5),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(image, width: 70)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: MusicAppTextStyle.w500),
                const SizedBox(height: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
