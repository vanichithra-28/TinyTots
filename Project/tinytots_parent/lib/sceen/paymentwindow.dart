import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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

  void processPayment() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf8f9fa),
      appBar: AppBar(title: Text('Payment'),backgroundColor: Color(0xFFffffff),),
      body: Center(
        child: paymentSuccess
            ? Lottie.asset('assets/Animation.json', width: 600,height: 600, repeat: true,)
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
                        validator: (value) =>
                            value!.isEmpty ? 'Enter card number' : null,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                        onChanged: (value) => expiryDate = value,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter expiry date' : null,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'CVV'),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        onChanged: (value) => cvv = value,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter CVV' : null,
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
