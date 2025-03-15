import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyPlatoPal());
}

class MyPlatoPal extends StatelessWidget {
  const MyPlatoPal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFDFF4D7), Color(0xFFB2E59A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/MyPlatoPalLogo.png',
                  width: 100,
                  height: 100,
                ),
                Text(
                  'MyPlatoPal:\nGuide to Healthy Diet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Tap To Continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFB2E59A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/MyPlatoPalLogo.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 10),
              Text(
                'MyPlatoPal:\nGuide to Healthy Diet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
              SizedBox(height: 20),
              _buildTextField('Name'),
              _buildTextField('Password', obscureText: true),
              SizedBox(height: 20),

              // Log in
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
                child: Column(
                  children: [
                    Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[800],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              SizedBox(height: 10),

              //Sign Up
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAccountScreen()),
                  );
                },
                child: Column(
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[800],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.green[100],
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget buildButton(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {},
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signUp() async {
    if (!mounted) return; // Check if widget is still mounted
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Store user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      // Navigate only if widget is still mounted
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        print("Sign-up failed: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign-up failed: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFB2E59A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/MyPlatoPalLogo.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 10),
              Text(
                'MyPlatoPal:\nGuide to Healthy Diet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Create New Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 20),
              _buildTextInput('Name', controller: _nameController),
              _buildTextInput('Email', controller: _emailController),
              _buildTextInput('Password',
                  obscureText: true, controller: _passwordController),
              SizedBox(height: 20),
              _buildButton('Sign Up',
                  onPressed: _signUp), // Changed to onPressed
              SizedBox(height: 10),
              // Removed "Sign in Email" option as requested
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput(String label,
      {bool obscureText = false, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.green[100],
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, {required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed, // Correct parameter name
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green[800],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Settings"),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFB2E59A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: HomeContent(), // Wrap HomeContent with SafeArea
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 20.0), // Add padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center-align content
          children: [
            SizedBox(height: 20),
            Text(
              "Welcome to MyPlatoPal!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[900], // Match app theme
              ),
              textAlign: TextAlign.center, // Explicitly center the text
            ),
            SizedBox(height: 20), // Increased spacing for better separation
            // Image 1 with constrained width
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10), // Optional: Add rounded corners
              child: Image.asset(
                'images/Cropped-Home-Images/home_img1.jpg',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width *
                    0.9, // 90% of screen width
              ),
            ),
            SizedBox(height: 20), // Increased spacing
            // Image 2 with constrained width
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10), // Optional: Add rounded corners
              child: Image.asset(
                'images/Cropped-Home-Images/home_img2.jpg',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width *
                    0.9, // 90% of screen width
              ),
            ),
            SizedBox(height: 20), // Increased spacing
            // Image 3 with constrained width
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10), // Optional: Add rounded corners
              child: Image.asset(
                'images/Cropped-Home-Images/home_img3.jpg',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width *
                    0.9, // 90% of screen width
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFB2E59A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      // Use Flexible to prevent overflow
                      child: Text(
                        'MyPlatoPal: A Guide to\nHealthy Diet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 2), // Spacing between text and logo
                    Image.asset(
                      'images/MyPlatoPalLogo.png',
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
              ),
              // Search Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.green[300],
                    hintText: 'Food for diabetic person',
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(Icons.search, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: Colors.green[300]!, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: Colors.green[700]!, width: 2),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[900],
                      ),
                    ),
                    Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[800],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                    Container(), // Placeholder for additional content if needed
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFB2E59A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back Arrow
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.green[900]),
                    onPressed: () {
                      Navigator.pop(context); // Go back to previous screen
                    },
                  ),
                ),
              ),
              // Profile Section
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('images/profile.png'),
              ),
              SizedBox(height: 10),
              Text(
                'Rasyel',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
              Text(
                'View Profile',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green[800],
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 20),
              // Settings Menu
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildMenuItem(
                        'Notifications', Icons.notifications, context),
                    _buildMenuItem('General', Icons.settings, context),
                    _buildMenuItem('Saved', Icons.bookmark, context),
                    Divider(),
                    _buildMenuItem('Help Center', Icons.help, context),
                    _buildMenuItem(
                        'Terms of Service', Icons.description, context),
                    _buildMenuItem('Privacy Policy', Icons.lock, context),
                    _buildMenuItem('About', Icons.info, context),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.green[900]),
                      title: Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green[900],
                        ),
                      ),
                      onTap: () {
                        // Add logout logic here
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[900]),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.green[900],
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.green[900]),
      onTap: () {
        // Add navigation or action for each menu item
      },
    );
  }
}
