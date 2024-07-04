import 'package:flutter/material.dart';
import 'package:frontend/pages/forgot_password_page.dart';
import 'package:frontend/widgets/button_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/controllers/animation_controller.dart';

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

  final _firstnamekey = GlobalKey<FormState>();
  final _lastNamekey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _confirmPasswordKey = GlobalKey<FormState>();

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
                          child: register
                              ? Text(
                                  'Create an Account',
                                  style: GoogleFonts.poppins(
                                    color: isDarkMode
                                        ? Colors.white
                                        : const Color(0xff1D1617),
                                    fontSize: size.height * 0.025,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  'Welcome Back',
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
                      register
                          ? buildTextField(
                              "First Name",
                              Icons.person_outlined,
                              false,
                              size,
                              (valuename) {
                                if (valuename == null ||
                                    valuename.length <= 2) {
                                  buildSnackError(
                                    'Invalid name',
                                    context,
                                    size,
                                  );
                                  return '';
                                }
                                return null;
                              },
                              _firstnamekey,
                              0,
                              isDarkMode,
                            )
                          : Container(),
                      register
                          ? buildTextField(
                              "Last Name",
                              Icons.person_outlined,
                              false,
                              size,
                              (valuesurname) {
                                if (valuesurname == null ||
                                    valuesurname.length <= 2) {
                                  buildSnackError(
                                    'Invalid last name',
                                    context,
                                    size,
                                  );
                                  return '';
                                }
                                return null;
                              },
                              _lastNamekey,
                              1,
                              isDarkMode,
                            )
                          : Container(),
                      Form(
                        child: buildTextField(
                          "Email",
                          Icons.email_outlined,
                          false,
                          size,
                          (valuemail) {
                            if (valuemail == null || valuemail.length < 5) {
                              buildSnackError(
                                'Invalid email',
                                context,
                                size,
                              );
                              return '';
                            }
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(valuemail)) {
                              buildSnackError(
                                'Invalid email',
                                context,
                                size,
                              );
                              return '';
                            }
                            return null;
                          },
                          _emailKey,
                          2,
                          isDarkMode,
                        ),
                      ),
                      Form(
                        child: buildTextField(
                          "Password",
                          Icons.lock_outline,
                          true,
                          size,
                          (valuepassword) {
                            if (valuepassword == null ||
                                valuepassword.length < 6) {
                              buildSnackError(
                                'Invalid password',
                                context,
                                size,
                              );
                              return '';
                            }
                            return null;
                          },
                          _passwordKey,
                          3,
                          isDarkMode,
                        ),
                      ),
                      Form(
                        child: register
                            ? buildTextField(
                                "Confirm Password",
                                Icons.lock_outline,
                                true,
                                size,
                                (valuepassword) {
                                  if (valuepassword == null ||
                                      valuepassword != textfieldsStrings[3]) {
                                    buildSnackError(
                                      'Passwords must match',
                                      context,
                                      size,
                                    );
                                    return '';
                                  }
                                  return null;
                                },
                                _confirmPasswordKey,
                                4,
                                isDarkMode,
                              )
                            : Container(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.015,
                          vertical: size.height * 0.025,
                        ),
                        child: register
                            ? CheckboxListTile(
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
                                            // ignore: avoid_print
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
                                            // ignore: avoid_print
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
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: const Color(0xff7B6F72),
                                checkColor: Colors.white,
                              )
                            : Container(),
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
                        onPressed: () {
                          if (register) {
                            if (_firstnamekey.currentState!.validate() &&
                                _lastNamekey.currentState!.validate() &&
                                _emailKey.currentState!.validate() &&
                                _passwordKey.currentState!.validate() &&
                                _confirmPasswordKey.currentState!.validate() &&
                                checkedValue) {
                              AuthService().signUp(
                                textfieldsStrings[2],
                                textfieldsStrings[3],
                                context,
                                textfieldsStrings[0],
                                textfieldsStrings[1],
                              );
                            } else {
                              buildSnackError(
                                'Please fill all fields',
                                context,
                                size,
                              );
                            }
                          } else {
                            if (_emailKey.currentState!.validate() &&
                                _passwordKey.currentState!.validate()) {
                              AuthService().signIn(
                                textfieldsStrings[2],
                                textfieldsStrings[3],
                                context,
                              );
                            } else {
                              buildSnackError(
                                'Please fill all fields',
                                context,
                                size,
                              );
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
                              builder: (context) => const ForgotPasswordPage(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildTextField(
    String hintText,
    IconData icon,
    bool isPassword,
    Size size,
    String? Function(String?)? validate,
    Key key,
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
        child: Form(
          key: key,
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
      ),
    );
  }

  void buildSnackError(String text, BuildContext context, Size size) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: size.height * 0.02,
        ),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
