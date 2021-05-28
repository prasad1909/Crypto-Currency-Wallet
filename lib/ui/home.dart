import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_currency/api/api_call.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double bitcoin = 0.0;
  double ethereum = 0.0;
  double tether = 0.0;
  double dogecoin = 0.0;
  double bitcoins = 0.0;
  @override
  void initState() {
    getValues();
  }

  getValues() async {
    bitcoin = await getAmount('bitcoin');
    dogecoin = await getAmount('dogecoin');
    tether = await getAmount('tether');
    ethereum = await getAmount('ethereum');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double getFinalAmt(String id, double amt) {
      if (id == 'bitcoin') {
        bitcoins = amt;
        return double.parse((bitcoin * amt).toStringAsFixed(2));
      } else if (id == 'dogecoin') {
        return double.parse((dogecoin * amt).toStringAsFixed(2));
      } else if (id == 'tether') {
        return double.parse((tether * amt).toStringAsFixed(2));
      } else if (id == 'ethereum') {
        return double.parse((ethereum * amt).toStringAsFixed(2));
      }
      return 0.0;
    }

    return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.purpleAccent),
          child: Center(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .collection('coins')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              if (snapshot.data.docs.length > 0) {
                return new ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  document.id.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  document.data()['amount'].toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                                Text(
                                  '₹ ' +
                                      getFinalAmt(document.id,
                                              document.data()['amount'])
                                          .toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent),
                                ),
                              ],
                            )));
                  }).toList(),
                );
              } else {
                return Text(
                  'You Don\'t have any CryptoCurrency.\nAdd CryptoCurrency using the add button.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                );
              }
            },
          )),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/add');
              },
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              child: Icon(Icons.delete),
              backgroundColor: Colors.red,
              onPressed: () {
                Navigator.pushNamed(context, '/sell');
              },
            )
          ],
        ));
  }
}
