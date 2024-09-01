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
    return Container();
    // return Row(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: List.generate(
    //     row + 1, //list is 0 indexed
    //     (index) {
    //       if (index == row)
    //         return Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: List.generate(
    //             col + 1,
    //             (index) {
    //               if (index == col)
    //                 return Row(
    //                   children: [
    //                     Container(
    //                       height: 10,
    //                       width: 10,
    //                       decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(10),
    //                           color: Colors.blue),
    //                     ),
    //                     if (hasChild)
    //                       Container(
    //                         height: 10,
    //                         width: 10,
    //                         decoration: BoxDecoration(
    //                             borderRadius: BorderRadius.circular(10),
    //                             color: Colors.grey),
    //                       )
    //                   ],
    //                 );
    //               return Container(
    //                 height: 10,
    //                 width: 10,
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(10),
    //                     color: Colors.grey),
    //               );
    //             },
    //           ),
    //         );
    //       return Container(
    //         height: 10,
    //         width: 10,
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(20),
    //           color: Colors.grey,
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
