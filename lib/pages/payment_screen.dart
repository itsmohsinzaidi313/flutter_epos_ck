// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pos_app/bloc/payment_bloc/payment_bloc.dart';
// import '../shared/app_theme.dart';
// import '../shared/config.dart';
// import 'package:google_fonts/google_fonts.dart';

// class PaymentScreen extends StatelessWidget {
//   final Color cashColor = Colors.grey, percentageColor = Colors.grey;
//   final List<String> paymentMethodList = ['Cash', 'Credit'];

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<PaymentBloc, PaymentState>(
//       listener: (context, state) {},
//       child: Scaffold(
//         backgroundColor: Colors.grey[200],
//         appBar: AppBar(
//           backgroundColor: AppTheme.appBarColor,
//           title: Text('Payment'),
//           elevation: 0,
//         ),
//         body: SingleChildScrollView(
//           child: Center(
//             child: Card(
//               elevation: 5,
//               margin: EdgeInsets.only(top: 10, bottom: 10),
//               child: Container(
//                 padding: EdgeInsets.all(15.0),
//                 decoration: BoxDecoration(
//                   // color: Colors.white,
//                   shape: BoxShape.rectangle,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 width: Config.getDeviceWidth(context) * 0.43,
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       // width: double.infinity,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.rectangle,
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.redAccent,
//                       ),
//                       child: Text(
//                         'Payment'.toUpperCase(),
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.ubuntuCondensed(
//                           color: Colors.white,
//                           fontSize: 30,
//                           fontWeight: FontWeight.w500,
//                           letterSpacing: 3.0,
//                           // backgroundColor: Colors.redAccent
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Text(
//                           'Net Amount: ',
//                           style: GoogleFonts.ubuntuCondensed(
//                             color: Colors.black,
//                             fontSize: 20,
//                             fontWeight: FontWeight.normal,
//                             backgroundColor: Colors.grey[200],
//                             letterSpacing: 1.0,
//                           ),
//                         ),
//                         Text(
//                           // model.map['due_amount'],
//                           'Rs. 0/=',
//                           style: GoogleFonts.ubuntuCondensed(
//                             color: Colors.grey[500],
//                             fontSize: 20,
//                             fontWeight: FontWeight.normal,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 15),
//                     Container(
//                       margin: EdgeInsets.only(
//                         top: 20,
//                       ),
//                       child: Card(
//                         color: Colors.grey[100],
//                         child: ListTile(
//                           leading: Icon(
//                             Icons.wallet_giftcard_rounded,
//                             color: Colors.yellow[800],
//                           ),
//                           title: TextField(
//                             keyboardType: TextInputType.number,
//                             decoration: InputDecoration(
//                               // suffixIcon: Icon(
//                               //   Icons.cancel,
//                               // ),
//                               border: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Colors.amberAccent, width: 1),
//                               ),
//                               hintText: 'Discount',
//                             ),
//                           ),
//                           trailing: Container(
//                             width: Config.getDeviceHeight(context) * 0.15,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Expanded(
//                                   child: IconButton(
//                                     icon: Icon(Icons.attach_money_outlined,
//                                         color: cashColor),
//                                     onPressed: () {},
//                                   ),
//                                 ),
//                                 Expanded(
//                                     child: VerticalDivider(
//                                   color: Colors.grey[400],
//                                 )),
//                                 Expanded(
//                                   child: IconButton(
//                                     icon: Text(
//                                       '%',
//                                       style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                           color: percentageColor),
//                                     ),
//                                     onPressed: () {},
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: double.infinity,
//                       child: Card(
//                         color: Colors.grey[100],
//                         child: BlocBuilder<PaymentBloc, PaymentState>(
//                           buildWhen: (previous, current) {
//                             if (current is CashPayment ||
//                                 current is CreditPayment) {
//                               return true;
//                             } else {
//                               return false;
//                             }
//                           },
//                           builder: (context, state) {
//                             String value;
//                             if (state is CashPayment)
//                               value = paymentMethodList[0];
//                             else if (state is CreditPayment)
//                               value = paymentMethodList[1];
//                             return DropdownButtonHideUnderline(
//                               child: DropdownButton<String>(
//                                 value: value,
//                                 isExpanded: true,
//                                 hint: Center(
//                                     child: Text("Select Your Payment Method")),
//                                 onChanged: (String payment) => passEvent(
//                                     context, PaymentModeChanged(mode: payment)),
//                                 items: paymentMethodList.map((String payment) {
//                                   return DropdownMenuItem<String>(
//                                     value: payment,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: <Widget>[
//                                         Icon(
//                                           Icons.style,
//                                           color: Colors.green,
//                                         ),
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         Text(
//                                           payment,
//                                           style: TextStyle(color: Colors.black),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     BlocBuilder<PaymentBloc, PaymentState>(
//                       buildWhen: (previous, current) {
//                         if (current is CashPayment ||
//                             current is CreditPayment) {
//                           return true;
//                         } else {
//                           return false;
//                         }
//                       },
//                       builder: (context, state) {
//                         return getWidget(state);
//                       },
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(vertical: 15),
//                       child: SizedBox(
//                         height: 50,
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           style: ButtonStyle(
//                             backgroundColor:
//                                 MaterialStateProperty.all(Colors.yellow[700]),
//                           ),
//                           onPressed: () {},
//                           child: Text(
//                             'SUBMIT',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w500,
//                               // fontStyle: FontStyle.italic,
//                               letterSpacing: 3.0,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget getWidget(PaymentState state) {
//     if (state is CreditPayment) {
//       return Container(
//         margin: EdgeInsets.only(
//           top: 20,
//         ),
//         child: Card(
//           color: Colors.grey[100],
//           child: ListTile(
//             leading: Icon(
//               Icons.credit_card,
//               color: Colors.yellow[700],
//             ),
//             title: TextField(
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.amberAccent, width: 1),
//                   ),
//                   hintText: 'Credit Number',
//                   errorText: null),
//             ),
//           ),
//         ),
//       );
//     } else if (state is CashPayment) {
//       return Container(
//         margin: EdgeInsets.only(
//           top: 20,
//         ),
//         child: Card(
//           color: Colors.grey[100],
//           child: ListTile(
//             leading: Icon(Icons.monetization_on, color: Colors.yellow[700]),
//             title: TextField(
//               keyboardType: TextInputType.number,
//               readOnly: true,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.amberAccent, width: 1),
//                 ),
//                 hintText: 'Amount',
//                 errorText: null,
//               ),
//             ),
//           ),
//         ),
//       );
//     } else {
//       return SizedBox(
//         height: 10,
//       );
//     }
//   }

//   void passEvent(BuildContext context, PaymentEvent event) =>
//       context.read<PaymentBloc>().add(event);
// }
