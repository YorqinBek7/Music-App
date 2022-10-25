import 'package:flutter/material.dart';

class PlaylistContainers extends StatelessWidget {
  final String title;
  final String byWho;
  const PlaylistContainers(
      {super.key, required this.title, required this.byWho});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const FlutterLogo(
            size: 90,
          ),
          Column(
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
          )
        ],
      ),
    );
  }
}
