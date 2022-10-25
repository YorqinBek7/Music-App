import 'package:flutter/material.dart';

class PlaylistContainers extends StatelessWidget {
  final String title;
  final String byWho;
  final String image;
  const PlaylistContainers(
      {super.key,
      required this.title,
      required this.byWho,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(image, width: 70)),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
              Text(
                byWho,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
