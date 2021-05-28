import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final password2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                    child: Text('Register', style: TextStyle(fontSize: 30)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18, 50, 18, 0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill out this field';
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Username',
                          labelStyle: TextStyle(color: Colors.white)),
                      style: TextStyle(color: Colors.white),
                    ),
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
                    padding: EdgeInsets.fromLTRB(18, 25, 18, 0),
                    child: TextFormField(
                      validator: (value) {
                        if (value != password.text) {
                          return 'Passwords don\'t match';
                        }
                      },
                      controller: password2,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confirm Password',
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
                              final user = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: email.text,
                                      password: password.text);
                              Navigator.pushNamed(context, '/home');
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        child: Text('Register'),
                      )),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(25, 50, 10, 5),
                        child: Text('Already Have an Account? ',
                            style: TextStyle(fontSize: 20)),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 50, 10, 5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text('Login',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue.shade900,
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
