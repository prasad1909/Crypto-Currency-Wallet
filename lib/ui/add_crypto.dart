import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddCrypto extends StatefulWidget {
  @override
  _AddCryptoState createState() => _AddCryptoState();
}

class _AddCryptoState extends State<AddCrypto> {
  String dropdownValue = 'bitcoin';
  final coinValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: dropdownValue,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['bitcoin', 'ethereum', 'tether', 'dogecoin']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(125, 15, 125, 15),
            child: TextField(
              controller: coinValue,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Amount',
                  labelStyle: TextStyle(color: Colors.purple)),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(125, 0, 125, 15),
            child: ElevatedButton(
              onPressed: () {
                DocumentReference documentReference = FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .collection('coins')
                    .doc(dropdownValue);

                FirebaseFirestore.instance
                    .runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documentReference);

                      if (!snapshot.exists) {
                        transaction.set(documentReference,
                            {'amount': double.parse(coinValue.text)});
                      } else {
                        double newvalue = snapshot.data()['amount'] +
                            double.parse(coinValue.text);
                        transaction
                            .update(documentReference, {'amount': newvalue});
                      }
                    })
                    .then((value) => print("amount: $value"))
                    .catchError((error) => print("$error"));
                Navigator.pop(context);
              },
              child: Text('ADD'),
            ),
          )
        ],
      ),
    ));
  }
}
