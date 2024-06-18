import 'package:agro_care_web/colors.dart';
import 'package:agro_care_web/providers/agri_data_provider.dart';
import 'package:agro_care_web/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late MyAuthProvider authProvider;
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  bool tryingSignIn = false;

  void onClickNext(BuildContext context, bool showError) {
    if (tryingSignIn) return;
    String user = _controller1.text.trim();
    String pass = _controller2.text;

    if (user.isEmpty || pass.isEmpty) {
      if (showError) {
        showSnackBar("Please enter your Information Correctly!", context);
      }
      return;
    }

    setState(() {
      tryingSignIn = true;
    });

    authProvider.trySignIn(user, pass).then((res) {
      // after sign in try
      if (res == Status.AUTH_SUCCESS) {
        updateCredentials();
        Navigator.popAndPushNamed(context, "dashBoardPage");
      } else if (res == Status.AUTH_FAILED) {
        setState(() {
          tryingSignIn = false;
        });
        showSnackBar("Opps. Something didn't go as planned!", context);
      }
    });
  }

  void updateCredentials() {
    authProvider.initialize();
    context.read<AgriDataProvider>().updateCredential(authProvider.email);
  }

  @override
  void initState() {
    super.initState();
    authProvider = context.read<MyAuthProvider>();
    if (authProvider.isLoggedIn()) {
      Navigator.pushReplacementNamed(context, "dashBoardPage");
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Hero(
              tag: "top_bar",
              child: Container(
                decoration: const BoxDecoration(
                  color: bgSplash,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icon_128.png",
                      width: 86,
                    ),
                    const SizedBox(height: 10),
                    const Material(
                      type: MaterialType.transparency,
                      child: Text(
                        'Agro Care',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Material(
                      type: MaterialType.transparency,
                      child: Text(
                        'Admin Panel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(minWidth: 350, maxWidth: 450),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 45),
                    const Text(
                      'Log In',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF09041B),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: TextFormField(
                        controller: _controller1,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          hintText: "Username",
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF72A847)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          icon: Icon(
                            Icons.person_outline_outlined,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: TextFormField(
                        controller: _controller2,
                        obscureText: true,
                        obscuringCharacter: 'x',
                        onFieldSubmitted: (value) {
                          onClickNext(context, false);
                        },
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "Password",
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF72A847)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          icon: Icon(
                            Icons.lock_open_rounded,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.only(top: 16, bottom: 32),
                      child: Center(
                        child: tryingSignIn
                            ? const CircularProgressIndicator(color: bgSplash)
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF569033),
                                  shadowColor:
                                      const Color.fromARGB(255, 38, 38, 38),
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 38, vertical: 14),
                                ),
                                onPressed: () {
                                  onClickNext(context, true);
                                },
                                child: tryingSignIn
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        'Next',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSnackBar(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }
}
