// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:tinytots_parent/main.dart';

// class Paymentwindow extends StatefulWidget {
//   final int childId;

//   const Paymentwindow({super.key, required this.childId});

//   @override
//   State<Paymentwindow> createState() => _PaymentwindowState();
// }

// class _PaymentwindowState extends State<Paymentwindow> {
//   final _formKey = GlobalKey<FormState>();
//   String cardNumber = '';
//   String expiryDate = '';
//   String cvv = '';
//   bool paymentSuccess = false;

//   Future<void> processPayment() async {
//     setState(() {
//       paymentSuccess = true;
//     });

//     try {
//       await supabase.from('tbl_payment').update({
//         'status': 1,
//         'payment_method': 'Card',
//         'payment_date': DateTime.now().toString(),
//       }).eq('child_id', widget.childId);

//       Future.delayed(Duration(seconds: 2), () {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Payment Successful!')),
//         );
//         setState(() {
//           paymentSuccess = false;
//         });
//       });
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFf8f9fa),
//       appBar: AppBar(
//         title: Text('Payment'),
//         backgroundColor: Color(0xFFffffff),
//       ),
//       body: Center(
//         child: paymentSuccess
//             ? Lottie.asset('assets/success.json', width: 600, height: 600, repeat: true)
//             : Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextFormField(
//                         decoration: InputDecoration(labelText: 'Card Number'),
//                         keyboardType: TextInputType.number,
//                         onChanged: (value) => cardNumber = value,
//                       ),
//                       TextFormField(
//                         keyboardType: TextInputType.text,
//                         decoration: InputDecoration(labelText: 'Expiry Date (MM/YY)'),
//                         onChanged: (value) => expiryDate = value,
//                       ),
//                       TextFormField(
//                         decoration: InputDecoration(labelText: 'CVV'),
//                         keyboardType: TextInputType.number,
//                         obscureText: true,
//                         onChanged: (value) => cvv = value,
//                       ),
//                       SizedBox(height: 20),
//                       Center(
//                         child: ElevatedButton(
//                           onPressed: processPayment,
//                           child: Text('Pay Now'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }
