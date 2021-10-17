import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_demo/models/cart.dart';
import 'package:restaurant_demo/models/products_data.dart';
import 'package:provider/provider.dart';

class ProductTab extends StatefulWidget {
  List<CategoryDish> itemsList;
  ProductTab({Key? key, required this.itemsList}) : super(key: key);

  @override
  ProductTabState createState() => ProductTabState();
}

class ProductTabState extends State<ProductTab>
    with AutomaticKeepAliveClientMixin {
  // ignore: prefer_final_fields
  List<int> _counter = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    // ignore: prefer_const_constructors
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
            itemCount: widget.itemsList.length,
            itemBuilder: (context, item) {
              if (_counter.length < widget.itemsList.length) {
                _counter.add(0);
              }
              CategoryDish dish = widget.itemsList[item];
              return Column(
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
                          width: screenWidth * 0.67,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dish.dishName,
                                style: GoogleFonts.roboto(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              //price row
                              Row(
                                children: [
                                  Text(
                                    "INR " + dish.dishPrice.toString(),
                                    style: GoogleFonts.roboto(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  const Spacer(),
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
                              const SizedBox(
                                height: 10,
                              ),
                              //description text
                              Text(
                                dish.dishDescription,
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                //tem button

                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                height: 35.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                    color: Colors.green[800],
                                    borderRadius: BorderRadius.circular(20)),
                                child: Consumer<Cart>(
                                  builder: (context, cart, child) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        InkWell(
                                          child: const Icon(Icons.remove,
                                              color: Colors.white),
                                          onTap: () {
                                            if (_counter[item] > 0) {
                                              setState(() {
                                                _counter[item] -= 1;
                                                cart.removeCart(dish);
                                              });
                                            }
                                          },
                                        ),
                                        const Spacer(),
                                        Text(
                                            cart.dishCount(dish).toString() ==
                                                    "null"
                                                ? "0"
                                                : cart
                                                    .dishCount(dish)
                                                    .toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            )),
                                        const Spacer(),
                                        InkWell(
                                          child: const Icon(Icons.add,
                                              color: Colors.white),
                                          onTap: () {
                                            setState(() {
                                              _counter[item] += 1;
                                              cart.add(dish, _counter[item]);
                                            });
                                          },
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              //addon
                              dish.addonCat!.isNotEmpty
                                  ? Text(
                                      "Customizations available",
                                      style: GoogleFonts.roboto(
                                          fontSize: 14, color: Colors.red),
                                    )
                                  : Container(),

                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.network(
                          dish.dishImage,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                  const Divider(
                    height: 10,
                  )
                ],
              );
            }),
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
