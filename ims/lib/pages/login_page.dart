import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' show AlertDialog, BuildContext, Center, CircularProgressIndicator, Colors, Column, EdgeInsets, FontWeight, GestureDetector, Icon, Icons, MainAxisAlignment, MainAxisSize, Navigator, Padding, Row, SafeArea, Scaffold, SingleChildScrollView, SizedBox, State, StatefulWidget, Text, TextAlign, TextButton, TextEditingController, TextStyle, Widget, showDialog;
import 'package:ims/components/my_button.dart';
import 'package:ims/components/my_textfield.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Function to validate email
  bool validateEmail(String email) {
    return EmailValidator.validate(email);
  }

  // Function to sign in the user with email and password
  void signUserIn() async {
    // Validate email
    if (!validateEmail(emailController.text)) {
      // Show error dialog if email is invalid
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Invalid Email'),
            content: const Text('Please enter a valid email address.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Show a loading dialog
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Sign in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Dismiss the loading dialog
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Dismiss the loading dialog
      Navigator.pop(context);
      // Show an error dialog if login fails
      showIncorrectEmailOrPasswordMessage();
    }
  }

  // Function to show error dialog for incorrect email or password
  void showIncorrectEmailOrPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.error, color: Colors.red, size: 50),
              SizedBox(height: 10),
              Text('Incorrect email or password. Please try again.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to handle "Forgot Password" action
  void handleForgotPassword() async {
    if (emailController.text.isEmpty) {
      // Show dialog if email is empty
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Email Required'),
            content: const Text('Please enter your email to reset password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
      // Show success dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Reset Email Sent'),
            content: const Text('A password reset email has been sent to your email address.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // Show error dialog if password reset fails
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Reset Email Failed'),
            content: Text(e.message ?? 'An error occurred while sending the reset email.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Icon(Icons.lock, size: 100),
                  const SizedBox(height: 50),
                  Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  MyTextField(controller: emailController, hintText: 'Email', obscureText: false),
                  const SizedBox(height: 20), // Increased space between email field and password field
                  MyTextField(controller: passwordController, hintText: 'Password', obscureText: true),
                  const SizedBox(height: 20), // Increased space between password field and "Forgot Password" link
                  // "Forgot Password?" link
                  GestureDetector(
                    onTap: handleForgotPassword,
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 20), // Increased space between "Forgot Password" link and sign-in button
                  // Button to sign in with email and password
                  MyButton(onTap: signUserIn, text: 'Sign In'),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a member?', style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text('Register now', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
