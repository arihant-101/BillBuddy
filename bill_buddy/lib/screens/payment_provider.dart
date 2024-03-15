import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'payment.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentProvider with ChangeNotifier {
  List<Payment> _payments = [];

  List<Payment> get payments => _payments;

  PaymentProvider() {
    getPaymentsFromFirestore();
  }

  Future<void> getPaymentsFromFirestore() async {
    try {
      final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('payments').get();

      final List<Payment> loadedPayments = [];

      for (final DocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        final Map<String, dynamic> data =
            document.data() as Map<String, dynamic>;

        final List<String> peopleInvolvedUids = List<String>.from(
            (data['peopleInvolved'] as Map<String, dynamic>).keys);

        if (peopleInvolvedUids.contains(uid) || data['paidBy'] == uid) {
          final Payment payment = Payment(
            name: data['name'] as String,
            amount: data['amount'] as double,
            description: data['description'] as String,
            paidBy: data['paidBy'] as String,
            peopleInvolved: Map<String, String>.from(
                data['peopleInvolved'] as Map<String, dynamic>),
            groupName: data['groupName'] as String,
          );

          loadedPayments.add(payment);
        }
      }

      _payments = loadedPayments;
      notifyListeners();
    } catch (e) {
      // Handle errors here
      print('Error retrieving payments from Firestore: $e');
    }
  }

  Future<void> addPayment(Payment payment) async {
    try {
      await FirebaseFirestore.instance.collection('payments').add({
        'name': payment.name,
        'amount': payment.amount,
        'description': payment.description,
        'paidBy': payment.paidBy,
        'peopleInvolved': payment.peopleInvolved,
        'groupName': payment.groupName,
      });

      // Optionally, you can update the local list of payments if the Firestore addition is successful.
      _payments.add(payment);
      notifyListeners();
    } catch (e) {
      // Handle errors here
      print('Error adding payment to Firestore: $e');
    }
  }
}
