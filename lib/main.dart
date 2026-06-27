import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const VangtiChaiApp());
}

// Root app widget
class VangtiChaiApp extends StatelessWidget {
  const VangtiChaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VangtiChai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const HomeScreen(),
    );
  }
}

// Home screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Current amount entered by user
  int amount = 0;

  // Available note denominations
  List<int> notes = [500, 100, 50, 20, 10, 5, 2, 1];

  // Count of each note
  List<int> counts = List.filled(8, 0);

  // Add a digit to the right of current amount
  void addDigit(int digit) {
    setState(() {
      if (amount < 999999999) {
        amount = amount * 10 + digit;
      }
      calculateNotes();
    });
  }

  // Clear everything
  void clearAmount() {
    setState(() {
      amount = 0;
      counts = List.filled(8, 0);
    });
  }

  // Greedy algorithm to calculate note counts
  void calculateNotes() {
    int remaining = amount;
    for (int i = 0; i < notes.length; i++) {
      counts[i] = remaining ~/ notes[i];
      remaining = remaining % notes[i];
    }
  }

  // Build the notes list (left side)
  Widget buildNotesList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(notes.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          child: Text(
            '${notes[index]}: ${counts[index]}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        );
      }),
    );
  }

  // Build a single keypad button
  Widget buildButton(String label) {
    bool isClear = label == 'CLEAR';

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () {
            if (isClear) {
              clearAmount();
            } else {
              addDigit(int.parse(label));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.black87,
            elevation: 1,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // Build the keypad (right side)
  Widget buildKeypad() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Row: 1 2 3
          Row(
            children: [
              buildButton('1'),
              buildButton('2'),
              buildButton('3'),
            ],
          ),
          // Row: 4 5 6
          Row(
            children: [
              buildButton('4'),
              buildButton('5'),
              buildButton('6'),
            ],
          ),
          // Row: 7 8 9
          Row(
            children: [
              buildButton('7'),
              buildButton('8'),
              buildButton('9'),
            ],
          ),
          // Row: 0 CLEAR
          Row(
            children: [
              buildButton('0'),
              buildButton('CLEAR'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Simple teal AppBar like faculty's UI
      appBar: AppBar(
        title: const Text('VangtiChai'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      backgroundColor: Colors.white,

      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            // ── Portrait layout ──
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount display
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      amount == 0 ? 'Taka:' : 'Taka: $amount',
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),

                // Notes list on left, keypad on right
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: notes list
                    Expanded(
                      child: buildNotesList(),
                    ),

                    // Right: keypad
                    Expanded(
                      child: buildKeypad(),
                    ),
                  ],
                ),
              ],
            );
          } else {
            // ── Landscape layout ──
            return Column(
              children: [
                // Amount display
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      amount == 0 ? 'Taka:' : 'Taka: $amount',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),

                // Notes in two columns on left, keypad on right
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left half: notes split into two sub-columns
                      Expanded(
                        child: Row(
                          children: [
                            // First 4 notes
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(4, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 16),
                                    child: Text(
                                      '${notes[index]}: ${counts[index]}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            // Last 4 notes
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(4, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 16),
                                    child: Text(
                                      '${notes[index + 4]}: ${counts[index + 4]}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Right: keypad
                      Expanded(
                        child: buildKeypad(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}