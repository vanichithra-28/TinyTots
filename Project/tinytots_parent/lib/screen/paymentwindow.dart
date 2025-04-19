import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'package:tinytots_parent/main.dart';

class Paymentwindow extends StatefulWidget {
  final int childId;
  const Paymentwindow({super.key, required this.childId, });

  @override
  _PaymentwindowState createState() => _PaymentwindowState();
}

class _PaymentwindowState extends State<Paymentwindow> {
  bool paymentSuccess = false;
  
  Future<void> checkout() async {
     setState(() {
      paymentSuccess = true;
    });

    try {
      await supabase.from('tbl_payment').update({
        'status': 1,
        'payment_method': 'Card',
        'payment_date': DateTime.now().toString(),
      }).eq('child_id', widget.childId);

      Future.delayed(Duration(seconds: 2), () {
        
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Successful!')),
        );
        setState(() {
          paymentSuccess = false;
        });
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Gateway'),
        backgroundColor: Color(0xfffffffff),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ Color(0xFFffffff),Color(0xff90e0ef)],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                onCreditCardWidgetChange: (creditCardBrand) {},
                isHolderNameVisible: true,
                enableFloatingCard: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CreditCardForm(
                        cardNumber: cardNumber,
                        expiryDate: expiryDate,
                        cardHolderName: cardHolderName,
                        cvvCode: cvvCode,
                        isHolderNameVisible: true,
                        onCreditCardModelChange: (creditCardModel) {
                          setState(() {
                            cardNumber = creditCardModel.cardNumber;
                            expiryDate = creditCardModel.expiryDate;
                            cardHolderName = creditCardModel.cardHolderName;
                            cvvCode = creditCardModel.cvvCode;
                            isCvvFocused = creditCardModel.isCvvFocused;
                          });
                        },
                        formKey: formKey,
                        cardNumberValidator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          if (value.length != 19) {
                            return 'Invalid card number';
                          }
                          return null;
                        },
                        expiryDateValidator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }

                          // Check if the input matches the MM/YY format
                          if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                            return 'Invalid expiry date format';
                          }

                          // Split the input into month and year
                          final List<String> parts = value.split('/');
                          final int month = int.tryParse(parts[0]) ?? 0;
                          final int year = int.tryParse(parts[1]) ?? 0;

                          // Get the current date
                          final DateTime now = DateTime.now();
                          final int currentYear =
                              now.year % 100; // Get last two digits of the year
                          final int currentMonth = now.month;

                          // Validate the month and year
                          if (month < 1 || month > 12) {
                            return 'Invalid month';
                          }

                          // Check if the year is in the past
                          if (year < currentYear ||
                              (year == currentYear && month < currentMonth)) {
                            return 'Card has expired';
                          }

                          return null; // Valid expiry date
                        },
                        cvvValidator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          if (value.length < 3) {
                            return 'Invalid CVV';
                          }
                          return null;
                        },
                        cardHolderValidator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                            return 'Invalid cardholder name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff023e8a),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                           checkout();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Please fill in all fields correctly!')),
                            );
                          }
                        },
                        child: Text(
                          'Pay Now',
                          style: TextStyle(fontSize: 18,color: Color(0xffffffff)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}