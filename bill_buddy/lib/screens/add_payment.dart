import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'friends_provider.dart';
import 'payment_provider.dart';
import 'payment.dart';
import 'user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPaymentScreen extends StatefulWidget {
  @override
  _AddPaymentScreenState createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  Map<String, String> paylistmap = {};
  Map<String, String> paylistmapc = {};
  String selectedPerson = '';
  Map<String, String> selectedPeople = {};

  TextEditingController paymentNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Use async/await to fetch the username and load friends
    _initializeData();
  }

  Future<void> _initializeData() async {
    final userName =
        await Provider.of<UserProvider>(context, listen: false).getUserName();

    // Load friends data
    await Provider.of<FriendsProvider>(context, listen: false).loadFriends();

    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    setState(() {
      paylistmapc =
          Provider.of<FriendsProvider>(context, listen: false).friends;
      paylistmap = Map.from(paylistmapc);

      if (userName != null &&
          userName.isNotEmpty &&
          !paylistmap.containsKey(uid)) {
        paylistmap[uid] = userName;
      }

      if (paylistmap.isNotEmpty) {
        selectedPerson = paylistmap.keys.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: paymentNameController,
              decoration: InputDecoration(labelText: 'Payment Name'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            Text('Select Person Who Paid:'),
            DropdownButton<String>(
              value: selectedPerson,
              items: paylistmap.keys.map((person) {
                return DropdownMenuItem(
                  child: Text(paylistmap[person].toString()),
                  value: person,
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedPerson = newValue;
                  });
                }
              },
            ),
            SizedBox(height: 16.0),
            Text('Select People Involved:'),
            // Rest of your code for selecting people involved...
            Expanded(
              child: ListView(
                children: paylistmap.keys.map((person) {
                  return CheckboxListTile(
                    title: Text(paylistmap[person].toString()),
                    value: selectedPeople.keys.contains(person),
                    onChanged: (bool? value) {
                      if (value != null) {
                        setState(() {
                          if (value) {
                            selectedPeople[person] =
                                paylistmap[person].toString();
                          } else {
                            selectedPeople.remove(person);
                          }
                        });
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final currentUserUid =
                    FirebaseAuth.instance.currentUser?.uid ?? '';
                // Check if the user is part of the selected people

                final isCurrentUserSelected =
                    selectedPeople.containsKey(currentUserUid);
                final isPayingUserCurrentUser =
                    selectedPerson == currentUserUid;
                // Check if the user is part of the selected people
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                if (!isCurrentUserSelected && !isPayingUserCurrentUser) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Cannot Add Expense'),
                        content: Text(
                            'You cannot add an expense that does not involve yourself, unless it\'s in a group.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Continue with adding the payment
                  String paymentName = paymentNameController.text;
                  String description = descriptionController.text;
                  double amount = double.tryParse(amountController.text) ?? 0.0;

                  Payment payment = Payment(
                    name: paymentName,
                    amount: amount,
                    description: description,
                    paidBy: selectedPerson,
                    peopleInvolved: selectedPeople,
                    groupName: 'nullvalueaddedhere',
                  );

                  Provider.of<PaymentProvider>(context, listen: false)
                      .addPayment(payment);

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Payment Added Successfully'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Add Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
