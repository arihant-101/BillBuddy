import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'group.dart'; // Import GroupModel
import 'payment.dart'; // Import Payment
import 'payment_provider.dart'; // Import PaymentProvider
import 'user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'friends_provider.dart';

class GroupFinanceScreen extends StatelessWidget {
  final List<GroupModel> groups;

  GroupFinanceScreen({required this.groups});

  @override
  Widget build(BuildContext context) {
    // Get the user's name (you may need to retrieve this from your authentication system)
    String userName = Provider.of<UserProvider>(context, listen: false)
        .getUserName()
        .toString(); // Replace with the actual user's name

    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    Map<String, String> friends =
        Provider.of<FriendsProvider>(context, listen: false).friends;

    Map<String, String> friendsmap = Map.from(friends);

    // Get the list of payments from PaymentProvider
    List<Payment> payments = Provider.of<PaymentProvider>(context).payments;

    // Create a map to store balances with group members
    Map<String, double> groupBalances = {};

    // Initialize balances with each group member to zero
    for (GroupModel group in groups) {
      for (String member in group.members.keys) {
        groupBalances[member] = 0;
      }
    }

    // Calculate the balances based on group payments
    for (Payment payment in payments) {
      if (groups.any((group) => group.name == payment.groupName)) {
        double share = payment.amount / payment.peopleInvolved.length;
        if (payment.paidBy == uid) {
          // User paid, so subtract the share from other group members
          for (String member in payment.peopleInvolved.keys) {
            if (member != uid) {
              groupBalances[member] = (groupBalances[member] ?? 0) - share;
            }
          }
        } else if (payment.peopleInvolved.keys.contains(userName)) {
          // User is one of the people involved, so add the share to the payer's balance
          groupBalances[payment.paidBy] =
              (groupBalances[payment.paidBy] ?? 0) + share;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 92, 11, 212),
        title: Text("Group Finance", style: TextStyle(color: Colors.white)),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/abstract_image.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color: Colors.red,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 80,
                          height: 40,
                          child: Center(
                              child: Text("BACK",
                                  style: TextStyle(color: Colors.white))),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Group Financial Balances',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                // Display balances with group members
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: groupBalances.length,
                  itemBuilder: (context, index) {
                    String member =
                        friendsmap[groupBalances.keys.elementAt(index)]
                            .toString();
                    double balance = groupBalances[member] ?? 0;

                    // Skip members with a balance of 0
                    if (balance == 0) {
                      return Container();
                    }

                    String balanceText = balance >= 0
                        ? 'You owe $member ₹${balance.abs().toStringAsFixed(2)}'
                        : '$member owes you ₹${balance.abs().toStringAsFixed(2)}';

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/profile_picture.png'),
                        ),
                        title: Text(member),
                        subtitle: Text(
                          balanceText,
                          style: TextStyle(
                              color: balance >= 0 ? Colors.green : Colors.red),
                        ),
                        trailing: TextButton(
                          onPressed: () {
                            if (balance >= 0) {
                              // Implement remind functionality for positive balances
                            } else {
                              // Implement pay functionality for negative balances
                            }
                          },
                          child: Text(
                            balance >= 0 ? "Pay Now" : "Remind Them",
                            style: TextStyle(
                                color:
                                    balance >= 0 ? Colors.red : Colors.green),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  color: Colors.yellow,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      "THAT'S ALL",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
