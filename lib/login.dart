import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txt1controller = TextEditingController();
  TextEditingController txt2controller = TextEditingController();
  bool a = true;

  signIn() async {
    print(txt1controller.text);
    print(txt2controller.text);
    UserCredential UserCred = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: txt1controller.text, password: txt2controller.text);
    final pref = await SharedPreferences.getInstance();
    await pref.setString('uid', UserCred.user!.uid);
  }

  signUp() async {
    print(txt1controller.text);
    print(txt2controller.text);
    UserCredential UserCred = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: txt1controller.text, password: txt2controller.text);
    final pref = await SharedPreferences.getInstance();
    await pref.setString('uid', UserCred.user!.uid);
  }

  Future<UserCredential> gSignIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    UserCredential userCred =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final pref = await SharedPreferences.getInstance();
    await pref.setString('uid', userCred.user!.uid);
    await pref.setString(
        'img',
        userCred.user!.photoURL ??
            'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.flaticon.com%2Ffree-icon%2Fprofile_1250689&psig=AOvVaw2V4zAKLrAHpwNWR_MFFoWC&ust=1667024274350000&source=images&cd=vfe&ved=0CAkQjRxqFwoTCKDZub-jgvsCFQAAAAAdAAAAABAE');
    return userCred;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 191, 255, 100),
      body: SingleChildScrollView(
        child: Center(
            child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blue, Colors.cyan])),
            ),
            Positioned(
                height: 700,
                bottom: 0,
                left: 0,
                child: Lottie.asset('assets/lottie/lottie1.json')),
            Positioned(
                top: 200,
                left: 50,
                child: Container(
                  height: 400,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 90, 8, 0),
                        child: TextField(
                          controller: txt1controller,
                          style: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 204, 255, 100),
                                      style: BorderStyle.solid,
                                      width: 2)),
                              labelText: 'username',
                              labelStyle: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 20, 8, 40),
                        child: TextField(
                          controller: txt2controller,
                          style: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      style: BorderStyle.solid,
                                      color: Color.fromRGBO(0, 204, 255, 100))),
                              labelText: 'password',
                              labelStyle: TextStyle(color: Colors.white)),
                        ),
                      ),
                      InkWell(
                        onTap: a ? signIn : signUp,
                        child: Container(
                            width: 190,
                            height: 40,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(0, 79, 152, 90),
                                  Color.fromRGBO(75, 156, 211, 90)
                                ])),
                            child: Center(
                              child: Text(
                                a ? 'Login' : 'SignUp',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      a
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: gSignIn,
                                    icon: const CircleAvatar(
                                      radius: 20,
                                      backgroundImage: AssetImage(
                                          'assets/lottie/Google.jpg'),
                                    ))
                              ],
                            )
                          : const SizedBox(
                              width: 0,
                              height: 0,
                            )
                    ],
                  ),
                )),
            Positioned(
                bottom: 20,
                left: 180,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (a == true) {
                        a = false;
                      } else {
                        a = true;
                      }
                    });
                  },
                  child: Text(
                    a ? 'SignUp?' : 'SignIn?',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ))
          ],
        )),
      ),
    );
  }
}
