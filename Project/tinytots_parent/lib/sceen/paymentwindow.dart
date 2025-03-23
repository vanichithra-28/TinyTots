import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tinytots_parent/main.dart';

class Paymentwindow extends StatefulWidget {
  const Paymentwindow({super.key});

  @override
  State<Paymentwindow> createState() => _PaymentwindowState();
}

class _PaymentwindowState extends State<Paymentwindow> {
  final _formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';
  bool paymentSuccess = false;

  bool isValidCardNumber(String value) {
    return RegExp(r'^[0-9]{16}\$').hasMatch(value);
  }

  bool isValidExpiryDate(String value) {
    return RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})\$').hasMatch(value);
  }

  bool isValidCVV(String value) {
    return RegExp(r'^[0-9]{3,4}\$').hasMatch(value);
  }


  Future<void> processPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        paymentSuccess = true;
      });
      Future.delayed(Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Successful!')),
        );
        setState(() {
          paymentSuccess = false;
        });
      });
    }
    try {
      await supabase.from('tbl_payment').update(
        {'status': 1},
      ).eq('payment_id', 1);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf8f9fa),
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Color(0xFFffffff),
      ),
      body: Center(
        child: paymentSuccess
            ? Lottie.asset('assets/Animation.json', width: 600, height: 600, repeat: true,)
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Card Number'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => cardNumber = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter card number';
                          } else if (!isValidCardNumber(value)) {
                            return 'Enter a valid 16-digit card number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                        onChanged: (value) => expiryDate = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter expiry date';
                          } else if (!isValidExpiryDate(value)) {
                            return 'Enter a valid expiry date (MM/YY)';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'CVV'),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        onChanged: (value) => cvv = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter CVV';
                          } else if (!isValidCVV(value)) {
                            return 'Enter a valid 3 or 4-digit CVV';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: processPayment,
                          child: Text('Pay Now'),
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
