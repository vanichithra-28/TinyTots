import 'package:flutter/material.dart';
import 'package:tinytots_parent/sceen/paymentwindow.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Color(0xFFffffff),
      ),
      backgroundColor: Color(0xFFf8f9fa),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(height: 680,
            width: 365,
            decoration: BoxDecoration(color: const Color(0xFFffffff), boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
                
              )
            ]),
            child: Column(
              children: [
                Text('display payment details here'),
                ElevatedButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Paymentwindow()));
              }, child:Text('Proceed Payment')),
              ],
            ),),
      ),
    );
  }
}