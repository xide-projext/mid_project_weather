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

  List<int> generateTemperatures() {
    // Placeholder logic to generate random temperatures
    Random random = Random();
    List<int> temperatures =
        List.generate(7, (index) => random.nextInt(40) - 10);

    // Add a delay before updating the temperatures
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        temperatures = List.generate(7, (index) => random.nextInt(40) - 10);
      });
    });

    return temperatures;
  }

  List<String> generateDaysOfWeek() {
    // Placeholder logic to generate days of the week
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  }

  int getLowestTemperature() {
    if (temperatures.isNotEmpty) {
      return temperatures
          .reduce((value, element) => value < element ? value : element);
    }
    return 0;
  }

  int getHighestTemperature() {
    if (temperatures.isNotEmpty) {
      return temperatures
          .reduce((value, element) => value > element ? value : element);
    }
    return 0;
  }

  List<Widget> generateWeatherCards() {
    // Generate weather cards for each day
    return List.generate(7, (index) {
      String day = generateDaysOfWeek()[index];
      String condition = weatherConditions[index];
      int temperature = temperatures[index];
      int lowestTemperature = temperature - 5;
      int highestTemperature = temperature + 5;

      return AnimatedOpacity(
        opacity: temperature != null ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Container(
          width: 120,
          margin: EdgeInsets.symmetric(horizontal: 4),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300],
          ),
          child: Column(
            children: [
              Text(
                day,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              AnimatedOpacity(
                opacity: temperature != null ? 1.0 : 0.0,
                duration: Duration(
                    milliseconds: 1000), // Adjust the duration as desired
                child: Transform.rotate(
                  angle: temperature != null ? pi / 4 : 0.0,
                  child: Icon(
                    getWeatherIcon(condition),
                    size: 40,
                    color: Colors.orange,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$temperature°C',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'L: ${temperature - 5}°C',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'H: ${temperature + 5}°C',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  IconData getWeatherIcon(String condition) {
    // Map weather conditions to corresponding icons
    switch (condition) {
      case 'Sunny':
        return Icons.wb_sunny;
      case 'Cloudy':
        return Icons.wb_cloudy;
      case 'Rainy':
        return Icons.grain;
      case 'Snowy':
        return Icons.ac_unit;
      default:
        return Icons.wb_sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        actions: [
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Today\'s Weather',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              onChanged: (query) =>
                  searchLocations(query), // Pass the query as a parameter
              decoration: InputDecoration(
                labelText: 'Search location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Location: $location', // Display the entered location
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 15),
                    AnimatedOpacity(
                      opacity: temperatures.isNotEmpty ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: Text(
                        'Temperature: ${temperatures.isNotEmpty ? temperatures[0] : ''}°C',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Weather Condition: ${weatherConditions.isNotEmpty ? weatherConditions[0] : ''}',
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(
                      getWeatherIcon(weatherConditions.isNotEmpty
                          ? weatherConditions[0]
                          : ''),
                      size: 100,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Lowest: ${getLowestTemperature()}°C',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Highest: ${getHighestTemperature()}°C',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Precipitation: ${Random().nextInt(20)} mm',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Humidity: ${Random().nextInt(100)}%',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Wind: ${Random().nextInt(30)} m/s',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: generateWeatherCards(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // Replace this with your map widget implementation
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  'Map View',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle current location button press
                  },
                  child: Text('Show Current Location'),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                  // Handle search functionality
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle routing and directions button press
                  },
                  child: Text('Get Directions'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DisasterPage extends StatelessWidget {
  List<DisasterCase> disasterCases = [
    DisasterCase(
      name: 'Hurricane 1',
      description: 'A powerful hurricane with wind speeds of 150 mph.',
      imageUrl: 'assets/hurricane_xyz.jpg',
    ),
    DisasterCase(
      name: 'Tornado 1',
      description: 'A destructive tornado causing widespread damage.',
      imageUrl: 'assets/tornado_abc.jpg',
    ),
    DisasterCase(
      name: 'Earthquake 1',
      description: 'A major earthquake measuring 7.5 on the Richter scale.',
      imageUrl: 'assets/earthquake_pqr.jpg',
    ),
    DisasterCase(
      name: 'Hurricane 2',
      description: 'A powerful hurricane with wind speeds of 150 mph.',
      imageUrl: 'assets/hurricane_xyz.jpg',
    ),
    DisasterCase(
      name: 'Tornado 2',
      description: 'A destructive tornado causing widespread damage.',
      imageUrl: 'assets/tornado_abc.jpg',
    ),
    DisasterCase(
      name: 'Earthquake 2',
      description: 'A major earthquake measuring 7.5 on the Richter scale.',
      imageUrl: 'assets/earthquake_pqr.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disaster Page'),
      ),
      body: ListView.builder(
        itemCount: disasterCases.length,
        itemBuilder: (context, index) {
          DisasterCase caseItem = disasterCases[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () {
                  // Handle case item tap if needed
                },
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        caseItem.imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        caseItem.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(caseItem.description),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DisasterCase {
  final String name;
  final String description;
  final String imageUrl;

  DisasterCase({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}

class TemperaturePage extends StatelessWidget {
  List<String> locations = [
    'New York',
    'Seoul',
    'Cebu',
    'Amsterdam',
    'Rotterdam'
  ];
  List<int> temperatures = [25, 28, 23, 27, 24];
