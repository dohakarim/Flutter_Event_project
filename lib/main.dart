import 'package:flutter/material.dart';
import 'home_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Premier milieu avec l'image au centre
          Padding(
            padding: EdgeInsets.only(bottom: 20.0), // Ajout d'un espace sous l'image
            child: Image.asset(
              'assets/FirstPage1.png', // Remplacez 'your_image.png' par le chemin de votre image
              width: 500, // Ajustez la largeur de l'image selon vos besoins
              height: 500, // Ajustez la hauteur de l'image selon vos besoins
              // Assurez-vous d'avoir ajouté votre image dans le dossier 'assets' de votre projet
            ),
          ),
          // Deuxième milieu avec le texte "Welcome" et le bouton "Get Started"
          Column(
            children: [
              Text(
                'Welcome ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8), // Espacement entre les deux textes
              Text(
                'to our app',
                style: TextStyle(
                  fontSize: 18, // Taille de police plus petite pour le deuxième texte
                  color: Colors.grey, // Couleur de texte différente pour le deuxième texte
                ),
              ),
              SizedBox(height: 18), // Ajout d'un espace entre le texte et le bouton
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondPage()),
                  );
                },
                icon: Icon(Icons.arrow_forward), // Icône de flèche vers la droite
                label: Text('Get Started'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 26, 125, 206), 
                  backgroundColor: Colors.greenAccent, // Couleur du texte
                  elevation: 10, // Ombre du bouton
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Bordures du bouton arrondies
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Espacement du bouton
                  textStyle: TextStyle(fontSize: 20), // Style du texte du bouton
                  shadowColor: Colors.blue.withOpacity(0.5), // Couleur de l'ombre du bouton
                  alignment: Alignment.center, // Alignement du contenu du bouton
                  visualDensity: VisualDensity.adaptivePlatformDensity, // Densité visuelle du bouton
                  side: BorderSide(color: Colors.blue, width: 2), // Bordure autour du bouton
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deuxième Page'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Bienvenue à la deuxième page !'),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              icon: Icon(Icons.arrow_forward), // Icône de flèche vers la droite
              label: Text('Get Started'),
             style: ElevatedButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 26, 125, 206), 
                  backgroundColor: Colors.greenAccent, // Couleur du texte
                  elevation: 10, // Ombre du bouton
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Bordures du bouton arrondies
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Espacement du bouton
                  textStyle: TextStyle(fontSize: 20), // Style du texte du bouton
                  shadowColor: Colors.blue.withOpacity(0.5), // Couleur de l'ombre du bouton
                  alignment: Alignment.center, // Alignement du contenu du bouton
                  visualDensity: VisualDensity.adaptivePlatformDensity, // Densité visuelle du bouton
                  side: BorderSide(color: Colors.blue, width: 2), // Bordure autour du bouton
                ),
              ),
          ],
        ),
      ),
    );
  }
}
