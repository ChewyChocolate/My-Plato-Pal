import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For formatting dates

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyPlatoPal());
}

class MyPlatoPal extends StatelessWidget {
  const MyPlatoPal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Ensure Scaffold background is transparent
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        child: Container(
          width: double.infinity, // Ensure Container fills the entire width
          height: double.infinity, // Ensure Container fills the entire height
          decoration: const BoxDecoration(
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
                const SizedBox(height: 20),
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    if (!mounted) return;
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        print("Login failed: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Ensure Scaffold background is transparent
      body: Container(
        width: double.infinity, // Ensure Container fills the entire width
        height: double.infinity, // Ensure Container fills the entire height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFB2E59A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/MyPlatoPalLogo.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 10),
                Text(
                  'MyPlatoPal:\nGuide to Healthy Diet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField('Email', controller: _emailController),
                _buildTextField('Password',
                    obscureText: true, controller: _passwordController),
                const SizedBox(height: 20),
                _buildButton('Log In', onPressed: _login),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateAccountScreen()),
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
                      const SizedBox(height: 5),
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
      ),
    );
  }

  Widget _buildTextField(String label,
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
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: const Center(
          child: Text(
            'Log In',
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
    if (!mounted) return;
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
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
      backgroundColor:
          Colors.transparent, // Ensure Scaffold background is transparent
      body: Container(
        width: double.infinity, // Ensure Container fills the entire width
        height: double.infinity, // Ensure Container fills the entire height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFB2E59A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/MyPlatoPalLogo.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 10),
                Text(
                  'MyPlatoPal:\nGuide to Healthy Diet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Create New Account',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextInput('Name', controller: _nameController),
                _buildTextInput('Email', controller: _emailController),
                _buildTextInput('Password',
                    obscureText: true, controller: _passwordController),
                const SizedBox(height: 20),
                _buildButton('Sign Up', onPressed: _signUp),
                const SizedBox(height: 10),
              ],
            ),
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
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: const Center(
          child: Text(
            'Sign Up',
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
    const SearchScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Ensure Scaffold background is transparent
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Settings"),
        ],
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _selectedCondition;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  final Map<String, List<bool>> _isSavedMap = {};

  Future<void> _loadSavedFoods(String condition, List<String> foodsToEat,
      List<String> foodsToAvoid) async {
    if (user == null) return;
    final savedFoodsSnapshot = await _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('saved_foods')
        .get();

    final savedFoods =
        savedFoodsSnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _isSavedMap[condition] =
          List<bool>.filled(foodsToEat.length + foodsToAvoid.length, false);
      for (int i = 0; i < foodsToEat.length; i++) {
        _isSavedMap[condition]![i] = savedFoods.any((food) =>
            food['food'] == foodsToEat[i] &&
            food['condition'] == condition &&
            food['category'] == 'Foods to Eat - $condition');
      }
      for (int i = 0; i < foodsToAvoid.length; i++) {
        _isSavedMap[condition]![foodsToEat.length + i] = savedFoods.any(
            (food) =>
                food['food'] == foodsToAvoid[i] &&
                food['condition'] == condition &&
                food['category'] == 'Foods to Avoid - $condition');
      }
    });
  }

  Future<void> _saveFood(
      String food, String condition, String category, int index) async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to save foods')),
      );
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('saved_foods')
          .doc('${condition}_${category}_$food')
          .set({
        'food': food,
        'condition': condition,
        'category': category,
        'savedAt': Timestamp.now(),
      });

      setState(() {
        _isSavedMap[condition]![index] = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$food saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving food: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ensure Container fills the entire width
      height: double.infinity, // Ensure Container fills the entire height
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFDFF4D7), Color(0xFFB2E59A)],
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
                children: [
                  Image.asset(
                    'images/MyPlatoPalLogo.png',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Health Condition List',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            // Health Condition List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('health_conditions')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Error loading conditions',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No conditions found',
                        style: TextStyle(color: Colors.black87),
                      ),
                    );
                  }

                  final conditions = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: conditions.length,
                    itemBuilder: (context, index) {
                      final conditionData =
                          conditions[index].data() as Map<String, dynamic>;
                      final conditionName = conditionData['name'] as String;
                      final imageUrl = conditionData['imageUrl'] as String;
                      final foodsToEat =
                          List<String>.from(conditionData['foodsToEat'] ?? []);
                      final foodsToAvoid = List<String>.from(
                          conditionData['foodsToAvoid'] ?? []);

                      // Load saved foods for this condition
                      if (!_isSavedMap.containsKey(conditionName)) {
                        _loadSavedFoods(
                            conditionName, foodsToEat, foodsToAvoid);
                      }

                      return _buildConditionItem(
                        context,
                        conditionName,
                        imageUrl,
                        foodsToEat,
                        foodsToAvoid,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionItem(
    BuildContext context,
    String condition,
    String imageUrl,
    List<String> foodsToEat,
    List<String> foodsToAvoid,
  ) {
    final isSelected = _selectedCondition == condition;
    final savedStates = _isSavedMap[condition] ??
        List<bool>.filled(foodsToEat.length + foodsToAvoid.length, false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedCondition = isSelected ? null : condition;
              });
            },
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  condition.toUpperCase(),
                  style: TextStyle(
                    fontSize: isSelected ? 40 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isSelected) ...[
            const SizedBox(height: 10),
            ExpansionTile(
              title: const Text(
                'Foods to Eat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              children: foodsToEat.asMap().entries.map((entry) {
                final index = entry.key;
                final food = entry.value;
                final isSaved = savedStates[index];
                return ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(food, style: const TextStyle(fontSize: 16)),
                  trailing: IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? Colors.green : Colors.grey,
                    ),
                    onPressed: () {
                      if (!isSaved) {
                        _saveFood(food, condition, 'Foods to Eat - $condition',
                            index);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
            ExpansionTile(
              title: const Text(
                'Foods to Avoid',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              children: foodsToAvoid.asMap().entries.map((entry) {
                final index = entry.key;
                final food = entry.value;
                final savedIndex = foodsToEat.length + index;
                final isSaved = savedStates[savedIndex];
                return ListTile(
                  leading: const Icon(Icons.cancel, color: Colors.red),
                  title: Text(food, style: const TextStyle(fontSize: 16)),
                  trailing: IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? Colors.green : Colors.grey,
                    ),
                    onPressed: () {
                      if (!isSaved) {
                        _saveFood(food, condition,
                            'Foods to Avoid - $condition', savedIndex);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ensure Container fills the entire width
      height: double.infinity, // Ensure Container fills the entire height
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFDFF4D7), Color(0xFFB2E59A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage('images/default_profile.png'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<DocumentSnapshot>(
                      future:
                          _firestore.collection('users').doc(user?.uid).get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Text(
                            'Error',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          );
                        }
                        final data =
                            snapshot.data?.data() as Map<String, dynamic>?;
                        final userName = data?['name'] ?? 'User';
                        final userEmail = data?['email'] ?? 'No email';
                        return Column(
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              userEmail,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()),
                        );
                      },
                      child: const Text(
                        'View Profile',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Settings Menu
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(
                    'General',
                    Icons.settings,
                    context,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GeneralScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    'Saved',
                    Icons.bookmark,
                    context,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SavedScreen()),
                      );
                    },
                  ),
                  const Divider(),
                  _buildMenuItem(
                    'Help Center',
                    Icons.help,
                    context,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HelpCenterScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    'Terms of Service',
                    Icons.description,
                    context,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TermsOfServiceScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    'Privacy Policy',
                    Icons.lock,
                    context,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    'About',
                    Icons.info,
                    context,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutScreen()),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.green[900]),
                    title: Text(
                      'Log out',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[900],
                      ),
                    ),
                    onTap: _logout,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, BuildContext context,
      {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[900]),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.green,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.green[900]),
      onTap: onTap,
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user!.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        _nameController.text = data['name'] ?? 'User';
      }
    }
  }

  Future<void> _updateName() async {
    if (user == null) return;
    try {
      await _firestore.collection('users').doc(user!.uid).update({
        'name': _nameController.text.trim(),
      });
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating name: $e')),
      );
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Ensure Scaffold background is transparent
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        width: double.infinity, // Ensure Container fills the entire width
        height: double.infinity, // Ensure Container fills the entire height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDFF4D7), Color(0xFFB2E59A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<DocumentSnapshot>(
            future: _firestore.collection('users').doc(user?.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading profile'));
              }
              final data = snapshot.data?.data() as Map<String, dynamic>?;
              final userName = data?['name'] ?? 'User';
              final userEmail = data?['email'] ?? 'No email';
              final createdAt = data?['createdAt'] as Timestamp?;
              final joinDate = createdAt != null
                  ? DateFormat('MMMM d, yyyy').format(createdAt.toDate())
                  : 'Unknown';

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('images/default_profile.png'),
                    ),
                    const SizedBox(height: 20),
                    _isEditing
                        ? TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )
                        : Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                    const SizedBox(height: 10),
                    _isEditing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: _updateName,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[700],
                                ),
                                child: const Text('Save'),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isEditing = false;
                                    _nameController.text = userName;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),
                                child: const Text('Cancel'),
                              ),
                            ],
                          )
                        : ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                            ),
                            child: const Text('Edit Name'),
                          ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Account Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Email: $userEmail',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Joined: $joinDate',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class GeneralScreen extends StatefulWidget {
  const GeneralScreen({super.key});

  @override
  _GeneralScreenState createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Ensure Scaffold background is transparent
      appBar: AppBar(
        title: const Text('General Settings'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        width: double.infinity, // Ensure Container fills the entire width
        height: double.infinity, // Ensure Container fills the entire height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDFF4D7), Color(0xFFB2E59A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            SwitchListTile(
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                });
                // TODO: Implement dark mode toggle
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Dark mode toggle coming soon!')),
                );
              },
              activeColor: Colors.green,
            ),
            SwitchListTile(
              title: const Text(
                'Enable Notifications',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                // TODO: Implement notification settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Notification settings coming soon!')),
                );
              },
              activeColor: Colors.green,
            ),
            ListTile(
              title: const Text(
                'Language',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              trailing: DropdownButton<String>(
                value: _selectedLanguage,
                items: <String>['English', 'Spanish', 'French']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                  // TODO: Implement language change
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Language change coming soon!')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor:
            Colors.transparent, // Ensure Scaffold background is transparent
        appBar: AppBar(
          title: const Text('Saved'),
          backgroundColor: Colors.green[700],
        ),
        body: Container(
          width: double.infinity, // Ensure Container fills the entire width
          height: double.infinity, // Ensure Container fills the entire height
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFDFF4D7), Color(0xFFB2E59A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Center(child: Text('Please log in to view saved foods')),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          Colors.transparent, // Ensure Scaffold background is transparent
      appBar: AppBar(
        title: const Text('Saved Foods'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        width: double.infinity, // Ensure Container fills the entire width
        height: double.infinity, // Ensure Container fills the entire height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDFF4D7), Color(0xFFB2E59A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('saved_foods')
              .orderBy('savedAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading saved foods'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No saved foods found'));
            }

            final savedFoods = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: savedFoods.length,
              itemBuilder: (context, index) {
                final foodData =
                    savedFoods[index].data() as Map<String, dynamic>;
                final food = foodData['food'] as String;
                final condition = foodData['condition'] as String;
                final category = foodData['category'] as String;

                return ListTile(
                  title: Text(food, style: const TextStyle(fontSize: 18)),
                  subtitle: Text('$category ($condition)'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('saved_foods')
                          .doc(savedFoods[index].id)
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$food removed from saved')),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Ensure Scaffold background is transparent
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        width: double.infinity, // Ensure Container fills the entire width
        height: double.infinity, // Ensure Container fills the entire height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDFF4D7), Color(0xFFB2E59A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const [
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            ExpansionTile(
              title: Text(
                'How do I save a food item?',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'To save a food item, go to the Search tab, select a health condition, expand the "Foods to Eat" or "Foods to Avoid" list, and tap the bookmark icon next to the food item.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'How can I edit my profile?',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Go to the Settings tab, tap "View Profile", and then tap "Edit Name" to update your name.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'How do I contact support?',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'You can contact support by emailing us at support@myplatopal.com. We’ll get back to you within 24-48 hours.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Ensure Scaffold background is transparent
      appBar: AppBar(
        title: const Text('Terms of Service'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        width: double.infinity, // Ensure Container fills the entire width
        height: double.infinity, // Ensure Container fills the entire height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDFF4D7), Color(0xFFB2E59A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Application means the software program provided by the Company downloaded by You on any electronic device, named NGL.\n\n'
                'Device means any device that can access the Service such as a computer, a cellphone or a digital tablet.\n\n',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'Acknowledgment\n',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 55, 134, 72),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'These are the Terms and Conditions governing the use of this Service and the agreement that operates between You and the Company. These Terms and Conditions set out the rights and obligations of all users regarding the use of the Service.\n\n'
                'Your access to and use of the Service is conditioned on Your acceptance of and compliance with these Terms and Conditions. These Terms and Conditions apply to all visitors, users and others who access or use the Service.\n\n'
                'By accessing or using the Service You agree to be bound by these Terms and Conditions. If You disagree with any part of these Terms and Conditions then You may not access the Service.\n\n'
                'You represent that you are over the age of 18. The Company does not permit those under 18 to use the Service.\n\n'
                'Your access to and use of the Service is also conditioned on Your acceptance of and compliance with the Privacy Policy of the Company. Our Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your personal information when You use the Application and tells You about Your privacy rights and how the law protects You. Please read Our Privacy Policy carefully before using Our Service\n\n',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Ensure Scaffold background is transparent
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        width: double.infinity, // Ensure Container fills the entire width
        height: double.infinity, // Ensure Container fills the entire height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDFF4D7), Color(0xFFB2E59A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'This Privacy Policy describes the privacy practices of MyplatoPal: guide to a healthy diet and how we handle personal health care that we collect through our application or services (collectively, the “Services”).\n\n',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'Personal information',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'We collect information about you from a variety of sources, and the type of information we collect depends on how you interact with our Services – such as whether you visit our app or download the MyplatoPal: guide to a healthy diet app.\n\n',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'Other information that we may collect which is not specifically listed here, but which we will use in accordance with this Privacy Policy or as otherwise disclosed at the time of collection.\n\n',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Ensure Scaffold background is transparent
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        width: double.infinity, // Ensure Container fills the entire width
        height: double.infinity, // Ensure Container fills the entire height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDFF4D7), Color(0xFFB2E59A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'images/MyPlatoPalLogo.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 10),
              const Text(
                'MyPlatoPal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              const Text(
                'MyPlatoPal is your guide to a healthy diet, providing personalized food recommendations based on your health conditions. Our mission is to help you make informed dietary choices to improve your well-being.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              const Text(
                'Developed by:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'MyPlatoPal Team',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              const Text(
                'Contact Us:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Email: support@myplatopal.com\n'
                'Website: www.myplatopal.com',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
