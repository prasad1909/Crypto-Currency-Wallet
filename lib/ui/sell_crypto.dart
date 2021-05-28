import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SellCrypto extends StatefulWidget {
  @override
  _SellCryptoState createState() => _SellCryptoState();
  SellCrypto();
}

class _SellCryptoState extends State<SellCrypto> {
  String dropdownValue = 'bitcoin';
  final coinValue = TextEditingController();
  bool isVisible = false;
  bool isVisible2 = false;

  makeVisible() {
    setState(() {
      isVisible = true;
    });
  }

  makeInVisible() {
    setState(() {
      isVisible = false;
    });
  }

  makeVisible2() {
    setState(() {
      isVisible2 = true;
    });
  }

  makeInVisible2() {
    setState(() {
      isVisible2 = false;
    });
  }

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
              makeInVisible();
              makeInVisible2();
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
            child: TextFormField(
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
                        print('doesnt exist');
                        makeVisible();
                      } else {
                        makeInVisible();
                        if (snapshot.data()['amount'] <
                            double.parse(coinValue.text)) {
                          print('not possible');
                          makeVisible2();
                        } else if (snapshot.data()['amount'] ==
                            double.parse(coinValue.text)) {
                          documentReference.delete();
                          Navigator.pop(context);
                        } else {
                          double newvalue = snapshot.data()['amount'] -
                              double.parse(coinValue.text);
                          transaction
                              .update(documentReference, {'amount': newvalue});
                          Navigator.pop(context);
                        }
                      }
                    })
                    .then((value) => print("amount: $value"))
                    .catchError((error) => print("$error"));
              },
              child: Text('SELL'),
            ),
          ),
          Visibility(
            visible: isVisible,
            child: Padding(
                padding: EdgeInsets.fromLTRB(100, 15, 100, 15),
                child: Text('You don\'t own $dropdownValue',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold))),
          ),
          Visibility(
            visible: isVisible2,
            child: Padding(
                padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                child: Text(
                    'You don\'t own ${coinValue.text} of $dropdownValue. \nPlease select amount less or equal to of what you own.',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold))),
          ),
        ],
      ),
    ));
  }
}
