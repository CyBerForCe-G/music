import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomAppBar extends StatefulWidget {
  //const CustomAppBAr({ Key? key }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SafeArea(
          child: Container(
            child: Shimmer.fromColors(
              child: Text(
                "Music Library",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              baseColor: Colors.white,
              highlightColor: Colors.black,
            ),
          ),
        ),
        Container(
          height: 1000.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        )
      ],
    );
  }
}
