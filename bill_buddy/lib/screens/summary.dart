import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'payment_provider.dart';
import 'payment.dart';
import 'user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      // Retrieve the user's name asynchronously
      future: Provider.of<UserProvider>(context, listen: false).getUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the result, you can show a loading indicator or return a blank widget
          return CircularProgressIndicator(); // Replace with your loading indicator widget
        } else if (snapshot.hasError) {
          // Handle any errors that occurred during the Future execution
          return Text('Error: ${snapshot.error}');
        } else {
          // The Future is complete, you can access the user's name here
          String userName = snapshot.data!;
          String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

          // Get the list of payments from PaymentProvider
          List<Payment> payments =
              Provider.of<PaymentProvider>(context).payments;

          // Calculate the total amount the user owes and is owed
          double amountOwed = 0;
          double amountOwedToUser = 0;

          for (Payment payment in payments) {
            if (payment.paidBy == uid) {
              // User paid for others, so they owe this amount
              if (payment.peopleInvolved.keys.contains(uid)) {
                // User is also involved, subtract their share
                double userShare =
                    payment.amount / payment.peopleInvolved.length;
                amountOwedToUser += payment.amount - userShare;
              } else {
                // User paid but not involved, they are owed the entire amount
                amountOwedToUser += payment.amount;
              }
            } else if (payment.peopleInvolved.keys.contains(uid)) {
              // User is one of the people involved, but not the payer
              // They are owed this amount
              double userShare = payment.amount / payment.peopleInvolved.length;
              amountOwed += userShare;
            }
          }

          // Calculate the single resultant amount (owe/get)
          double resultantAmount = amountOwedToUser - amountOwed;

          // Determine the text to display based on the resultant amount
          String resultText;
          if (resultantAmount < 0) {
            resultText = 'You owe ₹${resultantAmount.abs().toStringAsFixed(2)}';
          } else if (resultantAmount > 0) {
            resultText = 'You get ₹${resultantAmount.toStringAsFixed(2)}';
          } else {
            resultText = 'No balances to settle up.';
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Settle Up'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    resultText,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
