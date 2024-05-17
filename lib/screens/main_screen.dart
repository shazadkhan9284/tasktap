import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../work_field/construction_labour.dart';
import '../work_field/event_setup_labour.dart';
import '../work_field/genral_labour.dart';
import '../work_field/warehouse_labour.dart';
import 'account_screen.dart';
import 'orders_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Manpower Services',
    home: MainScreen(),
  ));
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exitConfirmed = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit Confirmation'),
            content: Text('Are you sure you want to exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        );

        if (exitConfirmed == null || !exitConfirmed) {
          // User canceled exit or clicked "No"
          return false; // Do not allow the app to exit
        } else {
          // User confirmed exit
          SystemNavigator.pop(); // Exit the app
          return true; // Allow the app to exit
        }
      },


      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20), // Add space at the top
              Container(
                height: 200, // Adjust height as needed
                child: SlideWidget(), // Slide widget added here
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: [
                    CategoryCard(
                      title: 'General Labour',
                      description:
                      'Tasks such as moving furniture, loading/unloading trucks, and cleaning.',
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => genralLabourPage()));
                      },
                    ),
                    CategoryCard(
                      title: 'Construction Labour',
                      description:
                      'Tasks specific to construction sites such as carrying materials and site clean-up.',
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => ConstructionLabourPage()));
                      },
                    ),
                    CategoryCard(
                      title: 'Warehouse Labour',
                      description:
                      'Tasks related to warehouse operations such as packing, sorting & management.',
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => WharehouseLabourPage()));
                      },
                    ),
                    CategoryCard(
                      title: 'Event Setup/Breakdown',
                      description:
                      'Tasks involved in setting up and breaking down events.',
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => eventSetupLabourPage()));
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 0), // Add space between text and image
              Stack(
                children: [
                  Image.asset(
                    "images/btg4.png",
                    height: 190.0,
                    width: 410,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Color(0xff928883), // Set your desired background color
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // Align icons evenly
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.home_outlined, color: Colors.black),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (c) => MainScreen()));
                    },
                  ),
                  Text(
                    'Home',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.watch_later_outlined, color: Colors.black),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (c) => OrdersPage()));
                    },
                  ),
                  Text(
                    'Orders',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.account_circle_outlined, color: Colors.black),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (c) => AccountScreen()));
                    },
                  ),
                  Text(
                    'Account',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xff928883),
      ),
    );
  }
}

class SlideWidget extends StatefulWidget {
  @override
  _SlideWidgetState createState() => _SlideWidgetState();
}

class _SlideWidgetState extends State<SlideWidget>
    with AutomaticKeepAliveClientMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0), // Set border radius
      child: Container(
        height: 200, // Adjust height as needed
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            SlideItem(image: "images/sl1.png"),
            SlideItem(image: "images/sl2.png"),
            SlideItem(image: "images/sl3.png"),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SlideItem extends StatelessWidget {
  final String image;

  const SlideItem({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final Function onPressed;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.description,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: () => onPressed(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                child: Text(
                  description,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2, // Set the maximum number of lines you desire
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}