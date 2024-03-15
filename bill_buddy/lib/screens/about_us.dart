import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AboutUsScreen(),
      theme: ThemeData(
        primaryColor: Color(0xFF1E88E5),
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Text color is white for contrast
          ),
        ),
      ),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Founders'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: founders.map((founder) {
          final index = founders.indexOf(founder);
          final delay = Duration(
              milliseconds: index * 250); // Delay for staggered animations

          return AnimatedPositioned(
            duration: Duration(seconds: 1),
            curve: Curves.easeInOutCubic,
            left: 20.0,
            right: 20.0,
            top: index * 150.0,
            child: FounderCard(founder, delay),
          );
        }).toList(),
      ),
    );
  }
}

class FounderInfo {
  final String name;
  final String image;

  FounderInfo({
    required this.name,
    required this.image,
  });
}

class FounderCard extends StatelessWidget {
  final FounderInfo founderInfo;
  final Duration delay;

  FounderCard(this.founderInfo, this.delay);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(seconds: 1),
      curve: Curves.easeInOutCubic,
      opacity: 1,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  founderInfo.image,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                founderInfo.name,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final List<FounderInfo> founders = [
  FounderInfo(
    name: 'Aakansh Thakur',
    image: 'assets/aakansh.png',
  ),
  FounderInfo(
    name: 'Arihant Bharadwaj',
    image: 'assets/arihant.png',
  ),
  FounderInfo(
    name: 'Dhruv Sharma',
    image: 'assets/dhruv.png',
  ),
  FounderInfo(
    name: 'Ritwik Tripathi',
    image: 'assets/ritwik.png',
  ),
  FounderInfo(
    name: 'Shreyas Tiwary',
    image: 'assets/shreyas.png',
  ),
];
