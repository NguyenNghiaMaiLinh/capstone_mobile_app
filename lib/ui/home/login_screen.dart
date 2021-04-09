import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:solvequation/blocs/customer_service.dart';
import 'package:solvequation/data/customer.dart';
import 'package:solvequation/ui/home/home_screen.dart';
import 'package:solvequation/widgets/background_painter.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/login";
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginScreen> {
  bool _isLoggedIn = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();
  CustomerService _customerService = new CustomerService();
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  _loginWithGmail() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user == null) {
        _isLoggedIn = false;
        return;
      } else {
        final googleAuth = await user.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        _customerService.getUrl();
        Customer customer = new Customer(
            null, null, _auth.currentUser.uid, null, null, null, null, 1, true);
        _customerService.create(customer).then((value) => {
              if (value != null)
                {
                  setState(() {
                    _isLoggedIn = true;
                  })
                }
            });
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> handleLogin() async {
    final FacebookLoginResult result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        break;
      case FacebookLoginStatus.loggedIn:
        try {
          await loginWithfacebook(result);
        } catch (e) {
          print(e);
        }
        break;
    }
  }

  Future loginWithfacebook(FacebookLoginResult result) async {
    final FacebookAccessToken accessToken = result.accessToken;
    CustomerService _customerService = new CustomerService();

    if (accessToken != null) {
      AuthCredential credential =
          FacebookAuthProvider.credential(accessToken.token);
      var a = await _auth.signInWithCredential(credential);
      if (a.user != null) {
        _customerService.getUrl();
        Customer customer = new Customer(
            null, null, a.user?.uid, null, null, null, null, 1, true);
        _customerService.create(customer).then((value) => {
              if (value != null)
                {
                  setState(() {
                    _isLoggedIn = true;
                  })
                }
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: BackgroundPainter()),
          buildSignUp(context),
        ],
      );

  Widget buildSignUp(BuildContext context) =>
      (!_isLoggedIn) ? LoginWidget(context) : HomeScreen();

  Widget loginGmail(BuildContext context) => Container(
        padding: EdgeInsets.all(4),
        width: MediaQuery.of(context).size.width * 0.8,
        child: OutlineButton.icon(
          label: Text(
            'Sign In With Facebook',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          highlightedBorderColor: Colors.white,
          borderSide: BorderSide(color: Colors.white),
          textColor: Colors.white,
          icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
          onPressed: () async {
            handleLogin();
          },
        ),
      );
  Widget loginFacebook(BuildContext context) => Container(
        padding: EdgeInsets.all(4),
        width: MediaQuery.of(context).size.width * 0.8,
        child: OutlineButton.icon(
          label: Text(
            'Sign In With Google',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          highlightedBorderColor: Colors.white,
          borderSide: BorderSide(color: Colors.white),
          textColor: Colors.white,
          icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
          onPressed: () {
            _loginWithGmail();
            // final provider =
            //     Provider.of<GoogleSignInProvider>(context, listen: false);
            // provider.login();
            //
          },
        ),
      );

  Widget LoginWidget(BuildContext context) => Column(
        children: [
          Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: 250,
              child: Text(
                'Welcome Back To Solve Equation App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Spacer(),
          loginGmail(context),
          loginFacebook(context),
          Spacer(),
        ],
      );
}
