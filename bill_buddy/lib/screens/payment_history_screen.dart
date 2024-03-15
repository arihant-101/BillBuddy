import 'package:bill_buddy/screens/humans_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'payment.dart';
import 'payment_provider.dart';
import 'user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentHistoryScreen extends StatefulWidget {
  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  late List<Payment> payments;

  @override
  void initState() {
    super.initState();

    Provider.of<PaymentProvider>(context, listen: false)
        .getPaymentsFromFirestore();

    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);
    payments = paymentProvider.payments;

    // Listen for changes in the PaymentProvider
    paymentProvider.addListener(_refreshPayments);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    Provider.of<PaymentProvider>(context, listen: false)
        .removeListener(_refreshPayments);
    super.dispose();
  }

  _refreshPayments() {
    setState(() {
      payments = Provider.of<PaymentProvider>(context, listen: false).payments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Provider.of<UserProvider>(context, listen: false).getUserName(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final String userName = snapshot.data ?? '';
          return _buildPaymentHistory(context, userName);
        } else {
          return CircularProgressIndicator(); // or any loading indicator
        }
      },
    );
  }

  Widget _buildPaymentHistory(BuildContext context, String userName) {
    Map<String, String> humans = Provider.of<HumansProvider>(context).humans;
    Map<String, String> humansmap = Map.from(humans);

    final userProvider = Provider.of<UserProvider>(context);
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    humansmap[uid] = userName;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History'),
      ),
      body: ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2.0,
              child: ExpansionTile(
                title: Text(payment.name),
                subtitle: Text('Amount: ₹${payment.amount.toStringAsFixed(2)}'),
                children: [
                  if (payment.groupName !=
                      'nullvalueaddedhere') // Add this condition
                    ListTile(
                      title: Text('Group Name: ${payment.groupName}'),
                    ),
                  ListTile(
                    title: Text('Description: ${payment.description}'),
                  ),
                  ListTile(
                    title: Text('Paid by: ${humansmap[payment.paidBy]}'),
                  ),
                  ListTile(
                    title: Text(
                        'People Involved: ${payment.peopleInvolved.values.join(', ')}'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
