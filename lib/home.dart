import 'package:doc_appointment/appointments.dart';
import 'package:doc_appointment/profile.dart';
import 'package:flutter/material.dart';
import 'package:auto_scroll_slider/auto_scroll_slider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Appointment App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        '/appointments': (context) => MyAppointments(),
        '/profile': (context) => MyProfile(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imageUrls = [
    'https://www.oneclickitsolution.com/blog/wp-content/uploads/2022/01/Cost-to-Develop-a-Doctor-Appointment-Booking-App.png',
    'https://play-lh.googleusercontent.com/sR6ayknJ186dbGDRKGP_0EWDlpWzy30GrxLZrn2d_4GMQizaDHDX1N5Vqw-7atMUCaA=w526-h296-rw',
    'https://codeit.us/storage/sl7WI2Lfcr1UjU2G3ElgkGABy3Z5mfwuu6N7qdlH.png',
    'https://www.scnsoft.com/blog-pictures/healthcare/doctor_apps-01_1.png',
    'https://www.quytech.com/blog/wp-content/uploads/2020/04/doctor-and-patient-video-consultation-app-1.png',
  ];

  List<String> doctorNames = [
    'Dr. Asthana',
    'Dr. Jha',
    'Dr. Vipul',
    'Dr. Monica',
    'Dr. Arti',
    'Dr. Pooja',
    'Dr. Vishal',
    'Dr. Anushka',
    'Dr. Kirty',
  ];

  String _searchText = '';
  int _selectedIndex = 0;

  void _onBottomNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add navigation logic here if needed
    // For example, Navigator.push or other page navigation methods
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredDoctors = doctorNames.where((name) {
      return name.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Search for doctors or specialties',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 250,
              child: AutoScrollSlider(
                length: imageUrls.length,
                scrollController: ScrollController(),
                scrollDirection: Axis.horizontal,
                duration: 25,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                    child: Image.network(
                      imageUrls[index],
                      height: 250,
                      width: 400,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Featured Doctors',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Column(
              children: filteredDoctors.map((doctor) {
                return buildDoctorCard(doctor, 'Cardiologist');
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavBarItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Card buildDoctorCard(String name, String specialty) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage("assets/doctor.jpg"),
        ),
        title: Text(name),
        subtitle: Text(specialty),
        trailing: ElevatedButton(
          onPressed: () {},
          child: Text('Book'),
        ),
      ),
    );
  }
}
