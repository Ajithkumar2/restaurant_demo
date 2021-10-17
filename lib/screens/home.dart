import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_demo/models/cart.dart';
import 'package:restaurant_demo/models/products_data.dart';
import 'package:restaurant_demo/screens/checkout.dart';
import 'package:restaurant_demo/screens/products_tab.dart';
import 'package:restaurant_demo/service/firebase_service.dart';
import 'package:restaurant_demo/utlis/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_demo/utlis/network_utils.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  User? user = FirebaseAuth.instance.currentUser;
  List<Tab> tabsList = [];
  List<List<CategoryDish>> categoryList = [];
  List<TableMenuList> mainList = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    mainList = await ApiService.getProducts();
    for (var item in mainList) {
      tabsList.add(Tab(
        child: Center(
          child: Text(
            item.menuCategory,
            style: GoogleFonts.roboto(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ));
      categoryList.add(item.categoryDishes);
    }
    setState(() {
      _tabController = TabController(length: tabsList.length, vsync: this);
      //_tabPageSelector = TabPageSelector(controller: _tabController);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return dynamicTabView();
  }

  Widget dynamicTabView() {
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    double screenHeight = queryData.size.height;
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Colors.green,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: user!.photoURL == null
                          ? const CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  AssetImage("assets/images/profile.png"),
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(user!.photoURL!),
                              radius: 30,
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    user!.email == null ? Container() : Text(user!.email!),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(user!.uid),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.login_outlined,
                  size: 30,
                ),
                title: const Text('Log out'),
                onTap: () async {
                  FirebaseService service = FirebaseService();
                  await service.signOutFromGoogle();
                  Provider.of<Cart>(context, listen: false).clearCart();
                  Navigator.pushReplacementNamed(
                      context, Constants.signInNavigate);
                },
              ),
            ],
          ),
        ),
        appBar: mainList.isEmpty
            ? AppBar(
                backgroundColor: Colors.white,
                title: Text("loading"),
              )
            : AppBar(
                iconTheme: const IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
                actions: [_shoppingCartBadge()],
                bottom: TabBar(
                  indicatorColor: Colors.red,
                  isScrollable: true,
                  tabs: tabsList,
                  labelColor: Colors.red,
                  unselectedLabelColor: Colors.grey,
                  controller: _tabController,
                ),
              ),
        body: mainList.isEmpty
            ? buildProgressIndicator()
            : DefaultTabController(
                length: mainList.length,
                child: TabBarView(
                    controller: _tabController,
                    children:
                        List<Widget>.generate(tabsList.length, (int index) {
                      return ProductTab(itemsList: categoryList[index]);
                    })),
              ),
      ),
    );
  }

  Widget buildProgressIndicator() {
    return Align(
      heightFactor: 15,
      alignment: Alignment.center,
      child: CupertinoActivityIndicator(
        animating: true,
        radius: MediaQuery.of(context).size.width * 5 / 100,
      ),
    );
  }

  Widget _shoppingCartBadge() {
    return Consumer<Cart>(builder: (context, cart, child) {
      return Badge(
        position: BadgePosition.topEnd(top: 0, end: 3),
        animationDuration: Duration(milliseconds: 300),
        animationType: BadgeAnimationType.slide,
        badgeContent: Text(
          cart.count.toString(),
          style: TextStyle(color: Colors.white),
        ),
        child: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              bool check = cart.count == 0 ? true : false;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                            isCartEmpty: check,
                          )));
            }),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
