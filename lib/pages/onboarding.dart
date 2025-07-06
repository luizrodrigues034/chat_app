import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/shared_preferences_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset('images/onboard.png', fit: BoxFit.cover),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.40,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Enjoy the new experience of chating with global friends',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Connect people around the world for free',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromARGB(134, 255, 255, 255),
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      elevation: 10,
                      child: InkWell(
                        onTap: () async {
                          await AuthService().signInWithGoogleFirebase(context);
                        },
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 250, 250, 250),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/search.png',
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 20),
                              Text(
                                'Sign in with Google',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      elevation: 10,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 250, 250, 250),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign in with Email',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
