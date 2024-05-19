import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ims/pages/login_or_register_page.dart';
import 'package:ims/pages/login_page.dart';
import 'home_page.dart';

class  AuthPage extends StatelessWidget{
  const AuthPage({super.key});
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          //user logged in
          if(snapshot.hasData){
            return HomePage();
          }
          //user not loged in
          else{
            // ignore: prefer_const_constructors
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}