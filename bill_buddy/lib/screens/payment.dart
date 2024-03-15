class Payment {
  final String name;
  final double amount;
  final String description;
  final String paidBy;
  final Map<String, String> peopleInvolved;
  final String groupName; // Add a field for the group name

  Payment({
    required this.name,
    required this.amount,
    required this.description,
    required this.paidBy,
    required this.peopleInvolved,
    required this.groupName, // Include the group name in the constructor
  });
}
