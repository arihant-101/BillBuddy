import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'payment.dart';
import 'payment_provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'humans_provider.dart';

class BreakupPage extends StatefulWidget {
  final String friendName;
  final double amountOwed;

  BreakupPage({required this.friendName, required this.amountOwed});

  @override
  _BreakupPageState createState() => _BreakupPageState();
}

class _BreakupPageState extends State<BreakupPage> {
  @override
  void initState() {
    super.initState();
    // Listen for changes in the PaymentProvider
    Provider.of<PaymentProvider>(context, listen: false)
        .getPaymentsFromFirestore();
    Provider.of<PaymentProvider>(context, listen: false)
        .addListener(_refreshPage);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    Provider.of<PaymentProvider>(context, listen: false)
        .removeListener(_refreshPage);
    super.dispose();
  }

  _refreshPage() {
    // Trigger a rebuild of the widget using setState
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Payment> payments =
        Provider.of<PaymentProvider>(context).payments;

    Map<String, String> humans = Provider.of<HumansProvider>(context).humans;

    Map<String, String> humansmap = Map.from(humans);

    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Breakup with ${humansmap[widget.friendName]}'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expenses with ${humansmap[widget.friendName]}:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index];
                // Check if the payment involves the friend
                if (payment.peopleInvolved.keys.contains(widget.friendName)) {
                  return PaymentDetailCard(payment: payment);
                }
                // Check if the payment was made by the friend for you
                if (payment.paidBy == widget.friendName &&
                    payment.peopleInvolved.keys.contains(uid)) {
                  return PaymentDetailCard(payment: payment);
                }
                return SizedBox
                    .shrink(); // Hide payments that don't involve the friend
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentDetailCard extends StatelessWidget {
  final Payment payment;

  PaymentDetailCard({required this.payment});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              payment.name,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Amount: \₹${(payment.amount / payment.peopleInvolved.length).toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.blue, // Customize text color
              ),
            ),
            // Add more payment details as needed
          ),
        ],
      ),
    );
  }
}
