import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.purpleAccent,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(18, 50, 18, 0),
                    child: Text('Login', style: TextStyle(fontSize: 30)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18, 25, 18, 0),
                    child: TextFormField(
                      validator: (value) {
                        if (!EmailValidator.validate(value)) {
                          return 'Please Enter Valid Email';
                        }
                      },
                      controller: email,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Email',
                          labelStyle: TextStyle(color: Colors.white)),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18, 25, 18, 0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill out this field';
                        }
                      },
                      controller: password,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Password',
                          labelStyle: TextStyle(color: Colors.white)),
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(138, 25, 18, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState.validate()) {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email.text,
                                      password: password.text);
                              Navigator.pushNamed(context, '/home');
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                              }
                            }
                          }
                        },
                        child: Text('Login'),
                      )),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(25, 50, 10, 5),
                        child: Text('Don\'t Have an Account? ',
                            style: TextStyle(fontSize: 20)),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 50, 10, 5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text('Register',
                              style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontSize: 20,
                                  decoration: TextDecoration.underline)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )));
  }
}
