import 'package:bill_buddy/screens/humans_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'payment_provider.dart'; // Import your PaymentProvider class
import 'payment.dart'; // Import your Payment class
import 'user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'breakup.dart';
import 'humans_provider.dart';
import 'settle_up.dart'; // Import your UserProvider class

class FinancePage extends StatefulWidget {
  @override
  _FinancePageState createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  String userName = '';
  String uid = ''; // Store the user's name

  @override
  void initState() {
    super.initState();

    Provider.of<PaymentProvider>(context, listen: false)
        .getPaymentsFromFirestore();
    _fetchUserName();
    // Listen for changes in the PaymentProvider
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

  // Function to fetch the user's name asynchronously
  Future<void> _fetchUserName() async {
    // Use await to get the user's name asynchronously
    userName =
        await Provider.of<UserProvider>(context, listen: false).getUserName();
    setState(() {});
    // Trigger a rebuild with the fetched user name
    uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // Get the list of payments from PaymentProvider
    List<Payment> payments = Provider.of<PaymentProvider>(context).payments;

    // Get the list of friends from FriendsProvider

    Map<String, String> humansmap = Provider.of<HumansProvider>(context).humans;

    List<String> humans =
        Provider.of<HumansProvider>(context).humans.keys.toList();

    // Create a map to store balances with friends
    Map<String, double> balances = {};

    // Initialize balances with each friend to zero
    for (String human in humans) {
      balances[human] = 0;
    }

    // Calculate the balances based on payments
    for (Payment payment in payments) {
      double share = payment.amount / payment.peopleInvolved.length;
      if (payment.paidBy == uid) {
        // User paid, so subtract the share from their balance
        for (String human in payment.peopleInvolved.keys) {
          if (human != uid) {
            balances[human] = (balances[human] ?? 0) - share;
          }
        }
      } else if (payment.peopleInvolved.keys.contains(uid)) {
        // User is one of the people involved, so add the share to their balance
        balances[payment.paidBy] = (balances[payment.paidBy] ?? 0) + share;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 92, 11, 212),
        title: Text("Finance", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Your Financial Balances',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: humans.length,
              itemBuilder: (context, index) {
                String human = humans[index];
                double balance = balances[human] ?? 0;
                String humanname = humansmap[humans[index]].toString();

                if (balance == 0) {
                  return Container();
                }

                String balanceText = balance >= 0
                    ? 'You owe $humanname ₹${balance.abs().toStringAsFixed(2)}'
                    : '$humanname owes you ₹${balance.abs().toStringAsFixed(2)}';

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/profile_picture.png'),
                      ),
                      title: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BreakupPage(
                                friendName: human,
                                amountOwed: balance,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          humanname,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        balanceText,
                        style: TextStyle(
                          color: balance >= 0 ? Colors.red : Colors.green,
                          fontSize: 16,
                        ),
                      ),
                      trailing: AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: balance >= 0
                            ? IconButton(
                                key: ValueKey<String>('payIcon'),
                                icon: Icon(
                                  Icons.payment,
                                  color: Colors.red,
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SettleUpPage(
                                        friendName: human,
                                        amountOwed: balance,
                                      ),
                                    ),
                                  ); // Redirect to settle_up.dart and pass necessary data
                                },
                              )
                            : IconButton(
                                key: ValueKey<String>('remindIcon'),
                                icon: Icon(
                                  Icons.warning,
                                  color: Colors.green,
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  // Implement pay functionality for negative balances
                                  // Show a dialog or perform an action
                                },
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: FinancePage(),
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
    ),
  );
}
