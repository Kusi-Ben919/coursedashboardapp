import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemNavigator.pop()

// Main entry point for the Flutter application.
void main() {
  runApp(const CourseDashboardApp());
}

// CourseDashboardApp is the root widget of this application.
class CourseDashboardApp extends StatelessWidget {
  const CourseDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(), // The main screen with navigation
      debugShowCheckedModeBanner: false, // Hide the debug banner
    );
  }
}

// --- MainScreen with Bottom Navigation Bar ---
// This widget manages the bottom navigation and displays the current tab content.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Current selected tab index
  String _activeTabName = 'Home'; // Name of the actively displayed tab

  // List of widgets for each tab.
  late final List<Widget> _widgetOptions; // Use late to initialize in initState

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const HomeScreen(), // Index 0: Home
      const CoursesScreen(), // Index 1: Courses
      // Pass the callback to ProfileScreen
      ProfileScreen(
        onLogoutConfirmed: () async {
          final shouldExit = await _showExitConfirmationDialog();
          if (shouldExit == true) {
            // This will attempt to close the app or pop to the very first route.
            SystemNavigator.pop();
          }
        },
      ), // Index 2: Profile
    ];
  }


  // Callback function for when a navigation item is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Update active tab name based on index.
      if (index == 0) {
        _activeTabName = 'Home';
      } else if (index == 1) {
        _activeTabName = 'Courses';
      } else {
        _activeTabName = 'Profile';
      }
    });
  }

  // Function to show the exit confirmation dialog.
  Future<bool?> _showExitConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Exit'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // User selects No
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // User selects Yes
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: WillPopScope( // Handles Android back button press
        onWillPop: () async {
          final shouldExit = await _showExitConfirmationDialog();
          return shouldExit ?? false; // If dialog is dismissed, don't exit
        },
        child: Center(
          child: Column(
            children: [
              // Display the active tab name prominently.
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Active Tab: $_activeTabName',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              Expanded(
                child: _widgetOptions.elementAt(_selectedIndex), // Display selected tab's content
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Highlight the current tab
        selectedItemColor: Colors.deepPurple, // Color for selected icon/label
        unselectedItemColor: Colors.grey, // Color for unselected icons/labels
        onTap: _onItemTapped, // Callback for tap events
      ),
    );
  }
}

// --- Home Screen Content ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to your Dashboard!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            AnimatedActionButton(), // Animated "Enroll" button
          ],
        ),
      ),
    );
  }
}

// --- Courses Screen Content (Course List View & Dropdown) ---
class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String? _selectedCategory; // State for selected dropdown category

  // List of example courses
  final List<Map<String, dynamic>> _courses = [
    {
      'name': 'Introduction to Programming',
      'instructor': 'Dr. Alice Smith',
      'icon': Icons.code,
      'category': 'Technology'
    },
    {
      'name': 'Calculus I',
      'instructor': 'Prof. Bob Johnson',
      'icon': Icons.calculate,
      'category': 'Science'
    },
    {
      'name': 'Art History: Renaissance',
      'instructor': 'Ms. Carol White',
      'icon': Icons.palette,
      'category': 'Arts'
    },
    {
      'name': 'Digital Marketing Basics',
      'instructor': 'Mr. David Green',
      'icon': Icons.campaign,
      'category': 'Business'
    },
    {
      'name': 'Principles of Biology',
      'instructor': 'Dr. Emily Brown',
      'icon': Icons.biotech,
      'category': 'Science'
    },
  ];

  // List of course categories for the dropdown
  final List<String> _courseCategories = [
    'Science',
    'Arts',
    'Technology',
    'Business',
    'All' // Option to view all courses
  ];

  @override
  Widget build(BuildContext context) {
    // Filter courses based on selected category
    final List<Map<String, dynamic>> filteredCourses =
        _selectedCategory == null || _selectedCategory == 'All'
            ? _courses
            : _courses
                .where((course) => course['category'] == _selectedCategory)
                .toList();

    return Column(
      children: [
        // --- Course Selection Dropdown ---
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Select Course Category',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.category),
            ),
            value: _selectedCategory,
            hint: const Text('Filter by category'),
            items: _courseCategories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue;
              });
            },
          ),
        ),
        // Display the selected category dynamically.
        if (_selectedCategory != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Showing courses for: ${_selectedCategory!}',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ),
        const SizedBox(height: 10),

        // --- Course List View ---
        Expanded(
          child: ListView.builder(
            itemCount: filteredCourses.length,
            itemBuilder: (context, index) {
              final course = filteredCourses[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueGrey.shade100,
                    child: Icon(course['icon'], color: Colors.deepPurple),
                  ),
                  title: Text(
                    course['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    'Instructor: ${course['instructor']}',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tapped on ${course['name']}')),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// --- Profile Screen Content (Logout Button) ---
class ProfileScreen extends StatelessWidget {
  // Define a callback function that the parent will provide
  final VoidCallback onLogoutConfirmed;

  const ProfileScreen({super.key, required this.onLogoutConfirmed}); // Add to constructor

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your Profile Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: onLogoutConfirmed, // Call the callback when the button is pressed
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              'Logout',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 8,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Animated Action Button (Enroll in a course) ---
// This button grows in size when tapped using AnimatedContainer.
class AnimatedActionButton extends StatefulWidget {
  const AnimatedActionButton({super.key});

  @override
  State<AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<AnimatedActionButton> {
  double _size = 100.0; // Initial size
  bool _isTapped = false; // State to track tap

  void _handleTap() {
    setState(() {
      _isTapped = !_isTapped;
      _size = _isTapped ? 150.0 : 100.0; // Toggle size
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isTapped ? 'Enrolling...' : 'Tap to enroll')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Use GestureDetector for tap detection
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Animation duration
        curve: Curves.easeInOut, // Smooth animation curve
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: Colors.blueAccent.shade400,
          borderRadius: BorderRadius.circular(_size / 2), // Makes it circular
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.shade200.withOpacity(0.6),
              blurRadius: _size / 20,
              spreadRadius: _size / 50,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_task,
              color: Colors.white,
              size: _size / 3, // Icon size scales with container size
            ),
            Text(
              'Enroll in a course',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: _size / 8, // Text size scales
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
