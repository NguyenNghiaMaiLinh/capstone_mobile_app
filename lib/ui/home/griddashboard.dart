// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:solvequation/routes.dart';

// class GridDashboard extends StatelessWidget {
//   Items item1 = new Items(
//       title: "Solver",
//       subtitle: "Solve equation in image",
//       link: Routes.math,
//       img: "assets/icons/fplash_icon.png");

//   Items item2 = new Items(
//     title: "History",
//     subtitle: "Images you saved",
//     link: Routes.history,
//     img: "assets/icons/exam.png",
//   );
//   // Items item3 = new Items(
//   //   title: "Other",
//   //   subtitle:
//   //       "Select your favorite social network and share our icons with your contacts",
//   //   link: "",
//   //   img: "assets/icons/think.png",
//   // );
//   // Items item4 = new Items(
//   //   title: "Other",
//   //   subtitle: "For more information read the Calculate",
//   //   link: "",
//   //   img: "assets/icons/calculating.png",
//   // );
//   @override
//   Widget build(BuildContext context) {
//     List<Items> myList = [item1, item2];

//     return Flexible(
//       child: GridView.count(
//           childAspectRatio: 1.0,
//           padding: EdgeInsets.only(left: 16, right: 16),
//           crossAxisCount: 2,
//           crossAxisSpacing: 18,
//           mainAxisSpacing: 18,
//           children: myList.map((data) {
//             return InkWell(
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.orangeAccent,
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Image.asset(
//                       data.img,
//                       width: 56,
//                       height: 56,
//                     ),
//                     SizedBox(
//                       height: 14,
//                     ),
//                     Text(
//                       data.title,
//                       style: GoogleFonts.openSans(
//                           textStyle: TextStyle(
//                               color: Colors.black87,
//                               fontSize: 20,
//                               fontWeight: FontWeight.w600)),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                       child: Text(
//                         data.subtitle,
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.openSans(
//                             textStyle: TextStyle(
//                           color: Colors.black54,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                         )),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 14,
//                     ),
//                   ],
//                 ),
//               ),
//               onTap: () {
//                 Navigator.of(context).pushReplacementNamed(data.link);
//               },
//             );
//           }).toList()),
//     );
//   }
// }

// class Items {
//   String title;
//   String subtitle;
//   String link;
//   String img;
//   Items({this.title, this.subtitle, this.link, this.img});
// }
