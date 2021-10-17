import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_demo/models/cart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_demo/models/products_data.dart';
import 'package:restaurant_demo/utlis/constants.dart';

class CheckoutPage extends StatefulWidget {
  final bool isCartEmpty;

  const CheckoutPage({Key? key, required this.isCartEmpty}) : super(key: key);
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  HashMap<CategoryDish, int> cartItems = HashMap();
  List<CategoryDish> testList = [];
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          title: Text(
            "Order Summary",
            style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.grey),
          ),
        ),
        body: widget.isCartEmpty == true
            ? const Center(
                child: Text("No items"),
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 400,
                    child: Card(
                      margin: const EdgeInsets.all(15.0),
                      child: Consumer<Cart>(
                        builder: (context, cart, child) {
                          testList.clear();
                          testList.addAll(cart.itemList);
                          return buildCartItems(
                              cart.allCartItems, cart.totalPrice);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.058,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext builderContext) {
                                      _timer =
                                          Timer(const Duration(seconds: 3), () {
                                        Navigator.of(context).pop();
                                        Provider.of<Cart>(context,
                                                listen: false)
                                            .clearCart();
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            Constants.homeNavigate,
                                            (route) => false);
                                      });

                                      return const AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: Text('Confirmation'),
                                        content: SingleChildScrollView(
                                          child: Text(
                                              'Your Order has been placed successfully'),
                                        ),
                                      );
                                    }).then((val) {
                                  if (_timer.isActive) {
                                    _timer.cancel();
                                  }
                                });
                              },
                              child: Text("Place Order",
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.normal)),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green[900]!),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green[900]!),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))))),
                        ),
                      ),
                    ),
                  )
                ],
              ));
  }

  Widget buildCartItems(HashMap<CategoryDish, int> cartList, totalPrice) {
    List<CategoryDish> uniqueItemList = testList.toSet().toList();
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.green[900],
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              uniqueItemList.length.toString() +
                  " Dishes - " +
                  testList.length.toString() +
                  " Items",
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ListView.builder(
                itemCount: uniqueItemList.length,
                itemBuilder: (context, item) {
                  int? count1 = cartList[uniqueItemList[item]];
                  CategoryDish dish = uniqueItemList[item];
                  double itemPrice = dish.dishPrice * count1!;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            dish.dishType == 2
                                ? Image.asset(
                                    "assets/images/veg.png",
                                    fit: BoxFit.cover,
                                    width: 20,
                                    height: 20,
                                  )
                                : Image.asset(
                                    "assets/images/non_veg.png",
                                    fit: BoxFit.cover,
                                    width: 20,
                                    height: 20,
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: SizedBox(
                                width: screenWidth * 0.35,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //dishname
                                    Text(
                                      dish.dishName,
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    //price column
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "INR " + dish.dishPrice.toString(),
                                          style: GoogleFonts.roboto(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          dish.dishCalories.toStringAsFixed(0) +
                                              " Calories",
                                          style: GoogleFonts.roboto(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              height: 30.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                  color: Colors.green[900],
                                  borderRadius: BorderRadius.circular(20)),
                              child: Consumer<Cart>(
                                builder: (context, cart, child) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      InkWell(
                                        child: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        onTap: () {
                                          if (cartList[uniqueItemList[item]]! >
                                              0) {
                                            setState(() {
                                              cartList[uniqueItemList[item]] =
                                                  cartList[uniqueItemList[
                                                          item]]! -
                                                      1;
                                              cart.decrementItem(dish);
                                            });
                                          }
                                        },
                                      ),
                                      const Spacer(),
                                      Text(
                                          cartList[uniqueItemList[item]]
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          )),
                                      const Spacer(),
                                      InkWell(
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            cartList[uniqueItemList[item]] =
                                                cartList[
                                                        uniqueItemList[item]]! +
                                                    1;
                                            cart.incrementItem(dish);
                                          });
                                        },
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text("INR " + itemPrice.toString(),
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        const Divider(
                          height: 10,
                        )
                      ],
                    ),
                  );
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total Amount ",
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const Spacer(),
              Text("INR " + totalPrice.toStringAsFixed(2),
                  style: GoogleFonts.roboto(
                      color: Colors.green,
                      fontWeight: FontWeight.normal,
                      fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}
