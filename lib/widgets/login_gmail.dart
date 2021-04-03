// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:solvequation/blocs/customer_service.dart';
// import 'package:solvequation/data/customer.dart';
// import 'package:solvequation/provider/google_sign_in.dart';
// import 'package:solvequation/ui/home/home.dart';
// import 'package:solvequation/widgets/background_painter.dart';
// import 'package:solvequation/widgets/login_screen.dart';

// class LoginScreen extends StatelessWidget {
//   static const String routeName = "/login";
//   final user = FirebaseAuth.instance.currentUser;
//   bool check = false;
//   CustomerService _customerService = new CustomerService();
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         body: ChangeNotifierProvider(
//           create: (context) => GoogleSignInProvider(),
//           child: StreamBuilder(
//             stream: FirebaseAuth.instance.authStateChanges(),
//             builder: (context, snapshot) {
//               final provider = Provider.of<GoogleSignInProvider>(context);
              
//               if (provider.isSigningIn) {
//                 return buildLoading();
//               } else if (snapshot.hasData) {
//                 Customer customer = new Customer(
//                     null,
//                     null,
//                     user?.uid,
//                     null,
//                     null,
//                     null,
//                     null,
//                     1,
//                     true);
//                 _customerService.create(customer);
//                 return HomeScreen();
//               } else {
//                 return LoginScreen();
//               }
//             },
//           ),
//         ),
//       );

//   Widget buildLoading() => Stack(
//         fit: StackFit.expand,
//         children: [
//           CustomPaint(painter: BackgroundPainter()),
//           Center(child: CircularProgressIndicator()),
//         ],
//       );
// }
