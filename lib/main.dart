import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MoodModel(),
      child: MyApp(),
    ),
  );
}

// Mood Model - The "Brain" of our app
class MoodModel with ChangeNotifier {

  String _currentMood = 'images/sad_charizard.jpeg';
  String get currentMood => _currentMood;

  Color _backgroundColor = Colors.yellow.shade100;
  Color get backgroundColor => _backgroundColor;

  Map<String, int> get moodCounts => _moodCounts;
  
  Map<String, int> _moodCounts = {
    'Happy': 0,
    'Sad': 0,
    'Excited': 0,
  };

  void setHappy() {
    _currentMood = 'images/happy_squirtle.webp';
    _moodCounts['Happy'] = _moodCounts['Happy']! + 1;
    _backgroundColor = Colors.yellow.shade100;
    notifyListeners();
  }

  void setSad() {
    _currentMood = 'images/sad_charizard.jpeg';
    _moodCounts['Sad'] = _moodCounts['Sad']! + 1;
    _backgroundColor = Colors.blueGrey;
    notifyListeners();
  }

  void setExcited() {
    _currentMood = 'images/excited_gengar.webp';
    _moodCounts['Excited'] = _moodCounts['Excited']! + 1;
    _backgroundColor = Colors.lightGreen.shade100;
    notifyListeners();
  }

  void setRandomMood(){
    int randomNumber = Random().nextInt(3);

    switch(randomNumber){
      case 0:
        setHappy();
        break;
      case 1:
        setSad();
        break;
      case 2:
        setExcited();
        break;
      default:
        setHappy();
    }
  }
}

// Main App Widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Toggle Challenge',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

// Home Page
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Mood Toggle Challenge', style: TextStyle(color: Colors.white, ),),
            backgroundColor: const Color.fromARGB(255, 83, 0, 0),
            centerTitle: true,
          ),
          body: Container(
            color: moodModel.backgroundColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('How are you feeling?', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 30),
                  MoodDisplay(),
                  SizedBox(height: 50),
                  MoodButtons(),
                  SizedBox(height: 20),
                  RandomMoodButton(),
                  SizedBox(height: 30),
                  MoodCounter(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Widget that displays the current mood
class MoodDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Image.asset(
          moodModel.currentMood, 
          width: 350,  // Reduced from 550 to avoid overflow
          height: 200, // Made it square for better proportions
          fit: BoxFit.contain, // Added to maintain aspect ratio
        );
      },
    );
  }
}

// Widget with buttons to change the mood
class MoodButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setHappy();
          },
          child: Text('Happy 😊'),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setSad();
          },
          child: Text('Sad 😢'),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setExcited();
          },
          child: Text('Excited 🎉'),
        ),
      ],
    );
  }
}

class MoodCounter extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Card(
          color: const Color.fromARGB(255, 81, 0, 0),
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              
              children: [
                Text(
                 'Mood Counter',
                 style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold, 
                  color: Colors.white
                 ), 
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCounterItem('😊', 'Happy', moodModel.moodCounts['Happy']!),
                    _buildCounterItem('😢', 'Sad', moodModel.moodCounts['Sad']!),
                    _buildCounterItem('🎉', 'Excited', moodModel.moodCounts['Excited']!),
                  ],
                  
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCounterItem(String emoji, String mood, int count) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 30)),
        SizedBox(height: 5),
        Text(
          mood,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class RandomMoodButton extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.pink],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3), // FIXED: Changed from 30 to 0.3
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton( // FIXED: Added ElevatedButton wrapper
        onPressed: () {
          Provider.of<MoodModel>(context, listen: false).setRandomMood();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🤪',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(width: 10),
            Text(
              'Random Mood!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Text(
              '🎲',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}