// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:solvequation/widgets/gmail_auth.dart';

// class GoogleSignupButtonWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Container(
//         padding: EdgeInsets.all(4),
//         width: MediaQuery.of(context).size.width * 0.8,
//         child: OutlineButton.icon(
//           label: Text(
//             'Sign In With Google',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           shape: StadiumBorder(),
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           highlightedBorderColor: Colors.white,
//           borderSide: BorderSide(color: Colors.white),
//           textColor: Colors.white,
//           icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
//           onPressed: () {
//              Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => GmailAuth()));
//             // final provider =
//             //     Provider.of<GoogleSignInProvider>(context, listen: false);
//             // provider.login();
//             // 
//           },
//         ),
//       );
// }
