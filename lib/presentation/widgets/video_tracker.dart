// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class VideoTracker extends StatelessWidget {
  final int rowNo;
  final int colNo;
  final bool hasChild;
  final int totalRows;
  const VideoTracker({
    super.key,
    required this.rowNo,
    required this.colNo,
    required this.hasChild,
    required this.totalRows,
  });

  @override
  Widget build(BuildContext context) {
    int rows = rowNo + (totalRows - rowNo > 3 ? 3 : totalRows - rowNo);
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        colNo,
        (rowIndex) {
          if (rowIndex + 1 == colNo) {
            //0-indexed
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                rows,
                (colIndex) {
                  if (colIndex + 1 == rowNo) {
                    //0-indexed
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Dot(
                          color: Colors.white,
                          radius: 10,
                        ),
                        if (hasChild) const Dot()
                      ],
                    );
                  }
                  return const Dot();
                },
              ),
            );
          }
          return const Dot();
        },
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final Color? color;
  final double? radius;
  const Dot({super.key, this.color, this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: radius == null ? EdgeInsets.all(5) : null,
      height: radius ?? 5,
      width: radius ?? 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color ?? Colors.blueGrey,
      ),
    );
  }
}
