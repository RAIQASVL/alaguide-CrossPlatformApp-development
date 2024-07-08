import 'package:flutter/material.dart';
import 'package:frontend/pages/forgot_password_page.dart';
import 'package:frontend/widgets/button_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/auth_service.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  bool checkedValue = false;
  bool register = true;
  List<String> textfieldsStrings = [
    "", // firstName
    "", // lastName
    "", // email
    "", // password
    "", // confirmPassword
  ];

  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
            color: isDarkMode ? Colors.white : const Color(0xff1D1617)),
      ),
      body: Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xff151f2c) : Colors.white,
          ),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.02),
                          child: Align(
                            child: Text(
                              'Hey there,',
                              style: GoogleFonts.poppins(
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xff1D1617),
                                fontSize: size.height * 0.02,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.015),
                          child: Align(
                            child: Text(
                              register ? 'Create an Account' : 'Welcome Back',
                              style: GoogleFonts.poppins(
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xff1D1617),
                                fontSize: size.height * 0.025,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                        ),
                        if (register) ...[
                          buildTextField(
                            "First Name",
                            Icons.person_outlined,
                            false,
                            size,
                            (valuename) {
                              if (valuename == null || valuename.length <= 2) {
                                return 'Invalid name';
                              }
                              return null;
                            },
                            0,
                            isDarkMode,
                          ),
                          buildTextField(
                            "Last Name",
                            Icons.person_outlined,
                            false,
                            size,
                            (valuesurname) {
                              if (valuesurname == null ||
                                  valuesurname.length <= 2) {
                                return 'Invalid last name';
                              }
                              return null;
                            },
                            1,
                            isDarkMode,
                          ),
                        ],
                        buildTextField(
                          "Email",
                          Icons.email_outlined,
                          false,
                          size,
                          (valuemail) {
                            if (valuemail == null || valuemail.length < 5) {
                              return 'Invalid email';
                            }
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(valuemail)) {
                              return 'Invalid email';
                            }
                            return null;
                          },
                          2,
                          isDarkMode,
                        ),
                        buildTextField(
                          "Password",
                          Icons.lock_outline,
                          true,
                          size,
                          (valuepassword) {
                            if (valuepassword == null ||
                                valuepassword.length < 6) {
                              return 'Invalid password';
                            }
                            return null;
                          },
                          3,
                          isDarkMode,
                        ),
                        if (register)
                          buildTextField(
                            "Confirm Password",
                            Icons.lock_outline,
                            true,
                            size,
                            (valuepassword) {
                              if (valuepassword == null ||
                                  valuepassword != textfieldsStrings[3]) {
                                return 'Passwords must match';
                              }
                              return null;
                            },
                            4,
                            isDarkMode,
                          ),
                        if (register)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.015,
                              vertical: size.height * 0.025,
                            ),
                            child: CheckboxListTile(
                              title: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "By creating an account, you agree to our ",
                                      style: TextStyle(
                                        color: const Color(0xffADA4A5),
                                        fontSize: size.height * 0.015,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: InkWell(
                                        onTap: () {
                                          print('Conditions of Use');
                                        },
                                        child: Text(
                                          "Conditions of Use",
                                          style: TextStyle(
                                            color: const Color(0xffADA4A5),
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: size.height * 0.015,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: " and ",
                                      style: TextStyle(
                                        color: const Color(0xffADA4A5),
                                        fontSize: size.height * 0.015,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: InkWell(
                                        onTap: () {
                                          print('Privacy Notice');
                                        },
                                        child: Text(
                                          "Privacy Notice",
                                          style: TextStyle(
                                            color: const Color(0xffADA4A5),
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: size.height * 0.015,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              value: checkedValue,
                              onChanged: (newValue) {
                                setState(() {
                                  checkedValue = newValue!;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: const Color(0xff7B6F72),
                              checkColor: Colors.white,
                            ),
                          ),
                        ButtonWidget(
                          text: register ? "Register" : "Login",
                          backColor: isDarkMode
                              ? [Colors.black, Colors.black]
                              : [
                                  const Color(0xff92A3FD),
                                  const Color(0xff9DCEFF)
                                ],
                          textColor: const [
                            Colors.white,
                            Colors.white,
                          ],
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (register) {
                                if (checkedValue) {
                                  final user = await _authService.signUp(
                                    textfieldsStrings[2],
                                    textfieldsStrings[3],
                                    textfieldsStrings[0],
                                    textfieldsStrings[1],
                                    context,
                                  );
                                  if (user != null) {
                                    ref.read(authStateProvider.notifier).state =
                                        true;
                                    ref
                                        .read(authProvider.notifier)
                                        .setUser(user);
                                    Navigator.pushReplacementNamed(
                                        context, '/home');
                                  }
                                } else {
                                  buildSnackError(
                                    'Please accept the terms and conditions',
                                    context,
                                    size,
                                  );
                                }
                              } else {
                                final user = await _authService.signIn(
                                  textfieldsStrings[2],
                                  textfieldsStrings[3],
                                  context,
                                );
                                if (user != null) {
                                  ref.read(authStateProvider.notifier).state =
                                      true;
                                  ref.read(authProvider.notifier).setUser(user);
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                }
                              }
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.02,
                          ),
                          child: Row(
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
                                  fontSize: size.height * 0.015,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    register = !register;
                                  });
                                },
                                child: Text(
                                  register ? "Login" : "Register",
                                  style: TextStyle(
                                    color: const Color(0xffC58BF2),
                                    fontSize: size.height * 0.015,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
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
                              fontSize: size.height * 0.015,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String hintText,
    IconData icon,
    bool isPassword,
    Size size,
    String? Function(String?)? validate,
    int index,
    bool isDarkMode,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.1,
        vertical: size.height * 0.01,
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xff1D1D35) : const Color(0xffF7F8F8),
          borderRadius: BorderRadius.circular(20),
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
              color: isDarkMode ? Colors.white : const Color(0xff7B6F72),
            ),
            prefixIcon: Icon(
              icon,
              color: isDarkMode ? Colors.white : const Color(0xff7B6F72),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  void buildSnackError(String text, BuildContext context, Size size) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black,
        content: SizedBox(
          height: size.height * 0.02,
          child: Center(
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
