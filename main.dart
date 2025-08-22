import 'package:flutter/material.dart';

// The main entry point of the Flutter application.
void main() {
  runApp(const MyApp());
}

// MyApp is a StatelessWidget that sets up the MaterialApp.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Title of the application.
      title: 'Student Info Manager',
      // Define the theme for the application.
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Set the initial route to the LoginScreen.
      initialRoute: '/login', // <--- Changed initial route to login
      routes: {
        '/': (context) => const WelcomeDashboard(userName: 'Guest'), // Default if navigated directly, but we'll use arguments
        '/login': (context) => const LoginScreen(),   // Login screen
      },
      // Hide the debug banner in the top-right corner.
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- Welcome Dashboard Screen ---
// This screen displays user information, a notification button, and a student counter.
class WelcomeDashboard extends StatefulWidget {
  // Add a final field to receive the user's name
  final String userName;

  const WelcomeDashboard({super.key, required this.userName}); // <--- Updated constructor

  @override
  State<WelcomeDashboard> createState() => _WelcomeDashboardState();
}

class _WelcomeDashboardState extends State<WelcomeDashboard> {
  // State variable to track the number of enrolled students.
  int _studentCount = 0;

  // Method to increase the student count.
  void _incrementStudentCount() {
    setState(() {
      _studentCount++;
    });
  }

  // Method to decrease the student count.
  void _decrementStudentCount() {
    setState(() {
      if (_studentCount > 0) { // Prevent negative counts
        _studentCount--;
      }
    });
  }

  // Method to display a SnackBar with a welcome message.
  void _showWelcomeSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hello, ${widget.userName}! Welcome to the Student Information Manager 👋'), // <--- Use the passed name here
        duration: const Duration(seconds: 3), // How long the snackbar is visible
        backgroundColor: Colors.blueGrey,
        behavior: SnackBarBehavior.floating, // Makes it float above content
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView( // Allows scrolling if content overflows
        padding: const EdgeInsets.all(20.0), // Padding around the entire content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center children horizontally
          children: [
            // --- Profile Picture Display ---
            const Text(
              'Your Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  'https://bestinau.com.au/wp-content/uploads/2019/01/free-images.jpg', // Online image URL (placeholder)
                  fit: BoxFit.cover, // Ensures the image covers the circular space
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.account_circle, size: 150, color: Colors.grey); // Fallback icon
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),

            // --- Home Screen: Display Name, Course, University ---
            Align(
              alignment: Alignment.center, // Center text horizontally
              child: Column(
                children: [ // Removed const here because widget.userName is not a compile-time constant
                  Text(
                    'Welcome, ${widget.userName}!', // <--- Use the passed name here
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900, // Extra bold for prominence
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10), // Spacing between lines
                  const Text(
                    'Course: Mobile Application Development', // Your Course
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'University: University Of Energy and Natural Resources', // Your University
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // --- Interactive Notification: Show Alert Button ---
            ElevatedButton.icon(
              onPressed: _showWelcomeSnackbar, // Call the method to show snackbar
              icon: const Icon(Icons.notifications_active, color: Colors.white),
              label: const Text(
                'Show Welcome Alert',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Button background color
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25), // Rounded corners
                ),
                elevation: 8, // Shadow for the button
              ),
            ),
            const SizedBox(height: 40),

            // --- Student Counter ---
            const Text(
              'Enrolled Students',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the buttons and count
              children: [
                // Minus button
                FloatingActionButton(
                  onPressed: _decrementStudentCount,
                  heroTag: 'decrementBtn', // Unique tag for multiple FloatingActionButtons
                  mini: true, // Make it a small button
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
                const SizedBox(width: 20),
                // Display current student count prominently
                Text(
                  '$_studentCount',
                  style: const TextStyle(
                    fontSize: 48, // Large font size
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(width: 20),
                // Plus button
                FloatingActionButton(
                  onPressed: _incrementStudentCount,
                  heroTag: 'incrementBtn', // Unique tag
                  mini: true, // Make it a small button
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- Student Login Form Screen ---
// This screen contains name, email and password fields with validation.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // GlobalKey for the Form widget to validate all fields at once.
  final _formKey = GlobalKey<FormState>();
  // TextEditingControllers to get text from input fields.
  final TextEditingController _nameController = TextEditingController(); // <--- New: Name Controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Method to handle login submission and validation.
  void _login() {
    // Validate all fields in the form.
    if (_formKey.currentState!.validate()) {
      // If validation passes, show a success message and navigate
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Successful for ${_nameController.text}!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to the WelcomeDashboard and pass the user's name
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomeDashboard(userName: _nameController.text), // <--- Pass the name
        ),
      );
    } else {
      // If validation fails, a message will be displayed by the TextFormField's validator.
      print('Login Failed: Please fix the errors.');
    }
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is removed from the widget tree.
    _nameController.dispose(); // <--- Dispose the new controller
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0), // Padding around the login form
        child: Form(
          key: _formKey, // Assign the GlobalKey to the Form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
            children: [
              const SizedBox(height: 50),
              // --- Your Name Field --- <--- New field
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  hintText: 'Enter your full name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.blueGrey, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.deepPurple, width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.red, width: 2.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25), // Spacing between fields

              // --- Email Field ---
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress, // Optimized for email input
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.blueGrey, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.deepPurple, width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.red, width: 2.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                validator: (value) {
                  // Email validation: check for '@'
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email (must contain @)';
                  }
                  return null; // Return null if the input is valid
                },
              ),
              const SizedBox(height: 25), // Spacing between fields

              // --- Password Field ---
              TextFormField(
                controller: _passwordController,
                obscureText: true, // Hide password input
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.blueGrey, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.deepPurple, width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.red, width: 2.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                validator: (value) {
                  // Password validation: check for minimum 6 characters
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // --- Login Button ---
              ElevatedButton(
                onPressed: _login, // Call the login method when pressed
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10, // Add shadow for depth
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
