import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'humans_provider.dart';
import 'payment.dart';
import 'payment_provider.dart';

class SettleUpPage extends StatelessWidget {
  final String friendName;
  final double amountOwed;

  SettleUpPage({required this.friendName, required this.amountOwed});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final String uid = auth.currentUser?.uid ?? '';
    Map<String, String> humansmap = Provider.of<HumansProvider>(context).humans;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 92, 11, 212),
        title: Text("Settle Up", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Settle Up with ${humansmap[friendName]}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'You owe',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '₹${amountOwed.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'to ${humansmap[friendName]}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Create a "Settle up" payment
                  final Payment settleUpPayment = Payment(
                    name: 'Settle up',
                    amount: amountOwed,
                    description:
                        '${humansmap[uid]} settled up with ${humansmap[friendName]}',
                    paidBy: uid,
                    groupName: 'nullvalueaddedhere',
                    peopleInvolved: {friendName: humansmap[friendName] ?? ''},
                  );

                  // Add the payment using the PaymentProvider
                  final paymentProvider =
                      Provider.of<PaymentProvider>(context, listen: false);
                  await paymentProvider.addPayment(settleUpPayment);

                  // Close the SettleUpPage
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  primary: Colors.green, // Change the button color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Change the button shape
                  ),
                ),
                child: Text(
                  'Settle Up',
                  style: TextStyle(
                    fontSize: 18, // Change the font size
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Change the text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: SettleUpPage(
        friendName: 'FriendName', // Replace with your friend's name
        amountOwed: 50.0, // Replace with the amount owed
      ),
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 92, 11, 212),
        appBarTheme: AppBarTheme(
          color: Color.fromARGB(255, 92, 11, 212),
        ),
      ),
    ),
  );
}
