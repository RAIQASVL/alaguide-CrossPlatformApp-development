import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/auth_providers.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/widgets/button_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.05),
                _buildTitle(isDarkMode, size),
                SizedBox(height: size.height * 0.02),
                _buildInstructions(isDarkMode, size),
                SizedBox(height: size.height * 0.03),
                _buildEmailField(isDarkMode, size),
                SizedBox(height: size.height * 0.03),
                _buildSendButton(isDarkMode, size),
                if (isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Center(
                      child: const CircularProgressIndicator()
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .scale(delay: 300.ms),
                    ),
                  ),
                SizedBox(height: size.height * 0.08),
                _buildLogo(isDarkMode, size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(bool isDarkMode, Size size) {
    return Text(
      'Reset password',
      style: GoogleFonts.poppins(
        color: isDarkMode ? Colors.white : const Color(0xff1D1617),
        fontSize: size.height * 0.035,
        fontWeight: FontWeight.bold,
      ),
    ).animate().fadeIn().slideY();
  }

  Widget _buildInstructions(bool isDarkMode, Size size) {
    return Text(
      "Forgot your password? That's okay, it happens to everyone!\nPlease provide your email to reset your password.",
      style: GoogleFonts.poppins(
        color: isDarkMode ? Colors.white54 : Colors.black54,
        fontSize: size.height * 0.02,
      ),
    ).animate().fadeIn().slideY();
  }

  Widget _buildEmailField(bool isDarkMode, Size size) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff1D1D35) : const Color(0xffF7F8F8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        controller: _emailController,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.white70 : const Color(0xff7B6F72),
          ),
          prefixIcon: Icon(
            Icons.email_outlined,
            color: isDarkMode ? Colors.white70 : const Color(0xff7B6F72),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
    ).animate().fadeIn().slideY();
  }

  Widget _buildSendButton(bool isDarkMode, Size size) {
    return ButtonWidget(
      text: 'Send Instruction',
      backColor: isDarkMode
          ? [Colors.black, Colors.black]
          : [const Color(0xff92A3FD), const Color(0xff9DCEFF)],
      textColor: const [Colors.white, Colors.white],
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          setState(() {
            isLoading = true;
          });
          try {
            await ref
                .read(authProvider.notifier)
                .resetPassword(_emailController.text);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Password reset email sent. Please check your inbox.'),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to send reset email: ${e.toString()}'),
              ),
            );
          } finally {
            setState(() {
              isLoading = false;
            });
          }
        }
      },
    ).animate().fadeIn(duration: 300.ms).scale(delay: 300.ms);
  }

  Widget _buildLogo(bool isDarkMode, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Login',
          style: GoogleFonts.poppins(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: size.height * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '+',
          style: GoogleFonts.poppins(
            color: const Color(0xff3b22a1),
            fontSize: size.height * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms).slideY();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
