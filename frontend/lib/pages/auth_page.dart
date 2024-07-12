import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/pages/forgot_password_page.dart';
import 'package:frontend/widgets/button_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/providers/auth_providers.dart';
import 'package:frontend/models/user_models.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  bool checkedValue = false;
  bool register = true;
  bool isLoading = false;
  List<String> textfieldsStrings = [
    "", // firstName
    "", // lastName
    "", // username
    "", // email
    "", // password
    "", // confirmPassword
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        leading: BackButton(
          color: isDarkMode ? Colors.white : const Color(0xff1D1617),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          'Hey there,',
                          style: GoogleFonts.poppins(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xff1D1617),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn().slideY(),
                        const SizedBox(height: 8),
                        Text(
                          register ? 'Create an Account' : 'Welcome Back',
                          style: GoogleFonts.poppins(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xff1D1617),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn().slideY(),
                        const SizedBox(height: 35),
                        if (register) ...[
                          buildTextField(
                              "First Name", Icons.person, false, constraints,
                              (valuename) {
                            if (valuename == null || valuename.length <= 2)
                              return 'Invalid name';
                            return null;
                          }, 0, isDarkMode),
                          const SizedBox(height: 15),
                          buildTextField(
                              "Last Name", Icons.person_2, false, constraints,
                              (valuesurname) {
                            if (valuesurname == null ||
                                valuesurname.length <= 2)
                              return 'Invalid last name';
                            return null;
                          }, 1, isDarkMode),
                          const SizedBox(height: 15),
                          buildTextField("Username", Icons.account_circle,
                              false, constraints, (valueUsername) {
                            if (valueUsername == null ||
                                valueUsername.length < 3)
                              return 'Username must be at least 3 characters long';
                            return null;
                          }, 2, isDarkMode),
                          const SizedBox(height: 15),
                        ],
                        buildTextField(
                            "Email", Icons.email_outlined, false, constraints,
                            (valuemail) {
                          if (valuemail == null ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(valuemail)) return 'Invalid email';
                          return null;
                        }, register ? 3 : 0, isDarkMode),
                        const SizedBox(height: 15),
                        buildTextField(
                            "Password", Icons.lock_outline, true, constraints,
                            (valuepassword) {
                          if (valuepassword == null || valuepassword.length < 6)
                            return 'Password must be at least 6 characters long';
                          return null;
                        }, register ? 4 : 1, isDarkMode),
                        if (register) ...[
                          const SizedBox(height: 15),
                          buildTextField("Confirm Password", Icons.lock_outline,
                              true, constraints, (valuepassword) {
                            if (valuepassword == null ||
                                valuepassword != textfieldsStrings[4])
                              return 'Passwords must match';
                            return null;
                          }, 5, isDarkMode),
                        ],
                        if (register)
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: checkedValue,
                                    onChanged: (newValue) {
                                      setState(() {
                                        checkedValue = newValue!;
                                      });
                                    },
                                    activeColor: const Color(0xff7B6F72),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "By creating an account, you agree to our Terms & Conditions",
                                    style: TextStyle(
                                      color: const Color(0xffADA4A5),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),
                        ButtonWidget(
                          text: register ? "Register" : "Login",
                          backColor: isDarkMode
                              ? [Colors.black, Colors.black]
                              : [
                                  const Color(0xff92A3FD),
                                  const Color(0xff9DCEFF)
                                ],
                          textColor: const [Colors.white, Colors.white],
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                final authNotifier =
                                    ref.read(authProvider.notifier);
                                User? user;
                                if (register) {
                                  if (checkedValue) {
                                    user = await authNotifier.signUp(
                                      textfieldsStrings[3], // email
                                      textfieldsStrings[4], // password
                                      textfieldsStrings[0], // firstName
                                      textfieldsStrings[1], // lastName
                                      textfieldsStrings[2], // username
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Please accept the terms and conditions')),
                                    );
                                    return;
                                  }
                                } else {
                                  user = await authNotifier.signIn(
                                    textfieldsStrings[0], // email
                                    textfieldsStrings[1], // password
                                  );
                                }
                                if (user != null) {
                                  ref.read(authStateProvider.notifier).state =
                                      true;
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                        )
                            .animate()
                            .fadeIn(duration: 300.ms)
                            .scale(delay: 300.ms),
                        if (isLoading)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Center(
                              child: CircularProgressIndicator()
                                  .animate()
                                  .fadeIn(duration: 300.ms)
                                  .scale(delay: 300.ms),
                            ),
                          ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              register
                                  ? "Already have an account? "
                                  : "Don't have an account? ",
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xff1D1617),
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  register = !register;
                                });
                              },
                              child: Text(
                                register ? "Login" : "Register",
                                style: TextStyle(
                                  color: const Color(0xffC58BF2),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (!register)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: const Color(0xffC58BF2),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTextField(
    String hintText,
    IconData icon,
    bool isPassword,
    BoxConstraints constraints,
    String? Function(String?)? validate,
    int index,
    bool isDarkMode,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff1D1D35) : const Color(0xffF7F8F8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        obscureText: isPassword,
        validator: validate,
        onChanged: (value) {
          textfieldsStrings[index] = value;
        },
        cursorColor: const Color(0xff7B6F72),
        style: TextStyle(
          color: isDarkMode ? Colors.white : const Color(0xff7B6F72),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.white70 : const Color(0xff7B6F72),
          ),
          prefixIcon: Icon(
            icon,
            color: isDarkMode ? Colors.white70 : const Color(0xff7B6F72),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
