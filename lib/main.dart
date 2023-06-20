import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

void main() {
  runApp(WeatherApp());
}

class MyFormWidget extends StatefulWidget {
  @override
  _MyFormWidgetState createState() => _MyFormWidgetState();
}

class _MyFormWidgetState extends State<MyFormWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Widget'),
      ),
      body: Column(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _animation.value,
                child: child,
              );
            },
            child: TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Enter Text',
              ),
              onChanged: (value) {
                if (_animationController.isDismissed) {
                  _animationController.forward();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    WeatherHomePage(),
    MapPage(),
    DisasterPage(),
    TemperaturePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
//         scaffoldBackgroundColor: Colors.yellow,
      ),
      home: Scaffold(
        backgroundColor: Colors.yellow,
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black, // <-- This works for fixed
          selectedItemColor: Colors.greenAccent,
          unselectedItemColor: Colors.grey,

          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 0) {
              Navigator.of(context).pushNamed('/home');
            } else if (index == 1) {
              Navigator.of(context).pushNamed('/map');
            } else if (index == 2) {
              Navigator.of(context).pushNamed('/disaster');
            } else if (index == 3) {
              Navigator.of(context).pushNamed('/temperature');
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.warning),
              label: 'Disaster',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.thermostat),
              label: 'Temperature',
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  int _currentIndex = 0;
  String searchQuery = '';
  String location = '';
  List<String> weatherConditions = [];
  List<int> temperatures = [];

  final List<Widget> _pages = [
    WeatherHomePage(),
    MapPage(),
    DisasterPage(),
    TemperaturePage(),
  ];

  @override
  void initState() {
    super.initState();
    // Generate placeholder weather data
    weatherConditions = generateWeatherConditions();
    temperatures = generateTemperatures();
  }

  void searchLocations(String query) {
    setState(() {
      searchQuery = query;
      location = query;
      weatherConditions = generateWeatherConditions();
      generateTemperatures(); // Call the modified method here
    });
  }

  List<String> generateWeatherConditions() {
    // Placeholder logic to generate random weather conditions
    List<String> conditions = ['Sunny', 'Cloudy', 'Rainy', 'Snowy'];
    Random random = Random();
    return List.generate(
        7, (index) => conditions[random.nextInt(conditions.length)]);
  }
