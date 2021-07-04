class AirtimeRecipient {
  AirtimeRecipient({required this.amount, required this.phoneNo, this.currency = 'KES'});
  String phoneNo;
  String currency;
  double amount;

  Map<String, String> asMap(){
    return {
      'phoneNumber': phoneNo,
      'amount': '$currency $amount'
    };
  }
}