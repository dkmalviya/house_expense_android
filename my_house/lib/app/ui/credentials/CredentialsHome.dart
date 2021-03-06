import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myhouse/app/ui/credentials/MyCredentials.dart';

class CredentialsHome extends StatefulWidget {
  @override
  _CredentialsHomeState createState() => _CredentialsHomeState();
}

class _CredentialsHomeState extends State<CredentialsHome> {
  final LocalAuthentication auth = LocalAuthentication();
  bool isAuth = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkBiometric();
    _authenticateBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return isAuth
        ? MyCredentials()
        : Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: InkWell(
            onTap: () {
              _checkBiometric();
            },
            child: Container(
              height: 60,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.9,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 2.5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.fingerprint,
                    color: Colors.blueAccent,
                  ),
                  Text(
                    "Login with Fingerprint",
                    style: TextStyle(color: Colors.blueAccent),
                  )
                ],
              ),
            ),
          )),
    );
  }

  void _checkBiometric() async {
    // check for biometric availability

    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      print("error biome trics $e");
    }

    print("biometric is available: $canCheckBiometrics");

    // enumerate biometric technologies
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } catch (e) {
      print("error enumerate biometrics $e");
    }

    print("following biometrics are available");
    if (availableBiometrics.isNotEmpty) {
      availableBiometrics.forEach((ab) {
        print("\ttech: $ab");
      });
    } else {
      print("no biometrics are available");
    }

    // authenticate with biometrics

  }

  void _authenticateBiometric() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Touch your finger on the sensor to login',
          useErrorDialogs: true,
          stickyAuth: false,
          androidAuthStrings:
          AndroidAuthMessages(signInTitle: "Login to HomePage"));
    } catch (e) {
      print("error using biometric auth: $e");
    }
    setState(() {
      isAuth = authenticated ? true : false;
    });

    print("authenticated: $authenticated");
  }
}

