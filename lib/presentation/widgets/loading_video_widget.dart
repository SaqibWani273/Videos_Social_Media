import 'package:flutter/material.dart';

class LoadingVideoWidget extends StatelessWidget {
  const LoadingVideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return AspectRatio(
      aspectRatio: deviceWidth / deviceHeight,
      child: Container(
        color: Colors.black,
        child: const Center(
          heightFactor: 20,
          widthFactor: 5,
          child: CircularProgressIndicator(
            // backgroundColor: Colors.white,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
