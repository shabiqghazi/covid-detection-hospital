import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: screenHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      "Cough Detection (Hospital)",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.signika(
                        textStyle: const TextStyle(
                          color: Color(0xff01b399),
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  // Image.asset('images/login.jpg'),
                  SizedBox(
                    width: screenWidth * 0.8,
                    height: screenWidth * 0.8,
                    child: Image.asset('images/logo.png'),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Bagi rumah sakit yang mendaftar, silahkan hubungi no. berikut",
                              style: GoogleFonts.signika(
                                textStyle: const TextStyle(
                                  color: Color(0xff01b399),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "08123456789",
                              style: GoogleFonts.signika(
                                textStyle: const TextStyle(
                                  color: Color(0xff01b399),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            )
                          ])),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sudah punya akun?",
                          style: TextStyle(
                              color: Color.fromARGB(255, 110, 110, 110)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/login');
                          },
                          child: Text(
                            "Masuk Disini!",
                            style: TextStyle(
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
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
