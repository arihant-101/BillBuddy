import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'add_payment.dart';
import 'finance.dart';
import 'groups_screen.dart';
import 'friends_screen.dart';
import 'payment_history_screen.dart';
import 'payment_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'payment.dart';
import 'package:provider/provider.dart';
import 'about_us.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  bool _showTransactions = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    Provider.of<PaymentProvider>(context, listen: false)
        .getPaymentsFromFirestore();
    Provider.of<PaymentProvider>(context, listen: false)
        .addListener(_refreshDashboard);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    Provider.of<PaymentProvider>(context, listen: false)
        .removeListener(_refreshDashboard);
    super.dispose();
  }

  _refreshDashboard() {
    // Trigger a rebuild of the widget using setState
    setState(() {});
  }

  Widget _buildGradientCard(
    IconData icon,
    String title,
    String subtitle,
    Function() onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListTile(
              leading: Icon(
                icon,
                color: Colors.white,
                size: 36,
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton(
    IconData icon,
    String text,
    Function() onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.all(16.0),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          Text(text, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildAboutUsButton() {
    return Container(
      margin: EdgeInsets.only(right: 16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AboutUsScreen(),
          ));
        },
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 15, 104, 110),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
        child: Row(
          children: [
            Icon(Icons.info, color: Colors.white, size: 10),
            Text("About Us",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildLogOutButton() {
    return Container(
      margin: EdgeInsets.only(right: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          // Added async keyword
          await FirebaseAuth.instance.signOut(); // Ensure user is signed out
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
        },
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 15, 104, 110),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
        child: Row(
          children: [
            Icon(Icons.exit_to_app, color: Colors.white, size: 20),
            Text("Log Out",
                style: TextStyle(color: Colors.white, fontSize: 08)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the user's UID
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Get the list of payments from PaymentProvider
    List<Payment> payments = Provider.of<PaymentProvider>(context).payments;

    // Calculate the total amount the user owes and is owed
    double amountOwed = 0;
    double amountOwedToUser = 0;

    for (Payment payment in payments) {
      if (payment.paidBy == uid) {
        // User paid for others, so they owe this amount
        if (payment.peopleInvolved.keys.contains(uid)) {
          // User is also involved, subtract their share
          double userShare = payment.amount / payment.peopleInvolved.length;
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
      resultText = 'You get ₹0';
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 15, 104, 110),
          title: Row(
            children: [
              Text(
                'Bill Buddy',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              Spacer(), // Push "About Us" button to the right
              _buildAboutUsButton(), // "About Us" button
              _buildLogOutButton(), // "Log Out" button
            ],
          ),
          actions: [
            // Your other action buttons here (if any)
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/test4.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.0),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Center(
            // Center the avatar image
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 70, // Increase the radius for a larger avatar
                    backgroundImage: AssetImage('assets/logotest.png'),
                  ),
                  SizedBox(height: 20),
                  // Display the resultant amount directly on the dashboard
                  _buildGradientCard(
                    Icons.attach_money,
                    'Summary',
                    resultText, // Display the calculated result here
                    () {},
                  ),
                  SizedBox(height: 20),
                  // Remove the Finance button and replace it with a gradient card
                  _buildGradientCard(
                    Icons.bar_chart,
                    'Finance',
                    'Manage your finances',
                    () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FinancePage(),
                      ));
                    },
                  ),
                  SizedBox(height: 20),
                  // Add padding to move the "Transaction History" button up
                  SizedBox(height: 10),
                  _buildGradientCard(
                    Icons.history,
                    'Transaction History',
                    'View your transaction history',
                    () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PaymentHistoryScreen(),
                      ));
                    },
                  ),
                  SizedBox(height: 20),
                  if (_showTransactions) ...[
                    Text("Transactions in the last",
                        style: TextStyle(color: Colors.white)),
                    SizedBox(height: 10),
                    Container(
                      height: 180,
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.white,
                            margin: EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              title: Text("Group Name: Group $index",
                                  style: TextStyle(color: Colors.black)),
                              subtitle: Text("Amount: ₹${index * 100}",
                                  style: TextStyle(color: Colors.black)),
                              trailing: Text("Owed by: User ${index + 1}",
                                  style: TextStyle(color: Colors.black)),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Row of four buttons
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildGradientButton(
                  Icons.group,
                  'Groups',
                  () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GroupsScreen(),
                    ));
                  },
                ),
                _buildGradientButton(
                  Icons.add,
                  'Add Payment',
                  () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddPaymentScreen(),
                    ));
                  },
                ),
                _buildGradientButton(
                  Icons.person,
                  'Friends',
                  () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FriendsScreen(),
                    ));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: DashboardScreen()));
