import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'group.dart' as GroupPackage;
import 'payment.dart'; // Import the Payment class
import 'payment_provider.dart'; // Import the PaymentProvider

class AddGroupPaymentScreen extends StatefulWidget {
  final GroupPackage.GroupModel group;

  AddGroupPaymentScreen({required this.group});

  @override
  _AddGroupPaymentScreenState createState() => _AddGroupPaymentScreenState();
}

class _AddGroupPaymentScreenState extends State<AddGroupPaymentScreen> {
  // Sample list of people names
  List<String> people = [];
  Map<String, dynamic> peoplemap = {};

  // Create a Set to store selected people
  Map<String, String> selectedPeople = Map<String, String>();

  // Text controllers for the payment name, description, and amount
  TextEditingController paymentNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  // Dropdown menu variables
  String selectedPerson = ''; // Initialize without a default value

  // Confirmation message
  String confirmationMessage = '';

  @override
  void initState() {
    super.initState();
    // Initialize the people list with the group members
    people = widget.group.members.keys.toList();
    peoplemap = widget.group.members;
    // If 'people' is not empty, set the 'selectedPerson' to the first person in the list
    if (people.isNotEmpty) {
      selectedPerson = people.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Group Payment'),
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
              items: people.map((person) {
                return DropdownMenuItem(
                  child: Text(peoplemap[person].toString()),
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
            Text('Select Members Involved:'),
            Expanded(
              child: ListView(
                children: people.map((person) {
                  return CheckboxListTile(
                    title: Text(peoplemap[person].toString()),
                    value: selectedPeople.keys.contains(person),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value != null) {
                          if (value) {
                            selectedPeople[person] = peoplemap[person];
                          } else {
                            selectedPeople.remove(person);
                          }
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement logic to save the group payment with name, description, amount, and selected members
                String paymentName = paymentNameController.text;
                String description = descriptionController.text;
                double amount = double.tryParse(amountController.text) ?? 0.0;

                if (paymentName.isNotEmpty && amount > 0) {
                  // If payment name and amount are valid
                  setState(() {
                    confirmationMessage =
                        'Payment Name: $paymentName\nDescription: $description\nAmount: $amount\nSelected Members: $selectedPeople';

                    // Create a Payment object
                    Payment payment = Payment(
                      name: paymentName,
                      amount: amount,
                      description: description,
                      paidBy: selectedPerson,
                      peopleInvolved: selectedPeople,
                      groupName: widget.group.name,
                    );

                    // Use the PaymentProvider to add the payment
                    Provider.of<PaymentProvider>(context, listen: false)
                        .addPayment(payment);

                    // Show the success popup
                    _showSuccessPopup(context);
                  });
                } else {
                  // Show an error message if fields are not filled correctly
                  setState(() {
                    confirmationMessage =
                        'Please fill in all fields correctly.';
                  });
                }
              },
              child: Text('Add Payment'),
            ),
            SizedBox(height: 16.0),
            Text(
              confirmationMessage,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show a success popup
  // Function to show a success popup
  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Added Successfully'),
          content: Text('Your payment has been added successfully.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Close the popup
                Navigator.of(context).pop();
                // Redirect to the groups screen
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
