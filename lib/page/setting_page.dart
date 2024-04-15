import 'dart:io';
import 'package:flutter/foundation.dart';
// Importez 'dart:io' pour utiliser File
import 'package:flutter/material.dart';
import 'package:flutter_project1/sql_helper.dart';
import 'package:image_picker/image_picker.dart'; // Importez le package ImagePicker

class CreatEvent extends StatefulWidget {
  const CreatEvent({Key? key}) : super(key: key);

  @override
  _CreatEventForm createState() => _CreatEventForm();
}

//types

class _CreatEventForm extends State<CreatEvent> {
  File? _imageFile;

  get index => null;

  // Méthode pour choisir une image à partir de la galerie ou de l'appareil photo
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile =
            File(pickedFile.path); // Stockez le fichier image sélectionné
      });
    }
  }

  // All journals
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    setState(() {
      _isLoading = true; // Mettre isLoading à true au début du chargement
    });

    try {
      final data = await SQLHelper.getItems();
      setState(() {
        _journals = data;
        _isLoading =
            false; // Mettre isLoading à false une fois que les données sont récupérées
      });
    } catch (error) {
      // Gérer les erreurs éventuelles lors de la récupération des données
      debugPrint("Error fetching journals: $error");
      setState(() {
        _isLoading = false; // Mettre isLoading à false en cas d'erreur
      });
    }
  }

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Déplacez le code de défilement automatique ici
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 10),
        curve: Curves.linear,
      );
    });

    _refreshJournals(); // Loading the diary when the app starts
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // Assurez-vous de disposer du contrôleur lorsqu'il n'est plus utilisé
    super.dispose();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _lieuController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _dateEventController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['titre'];
      _descriptionController.text = existingJournal['description'];
      _lieuController.text = existingJournal['lieu'];
      _genreController.text = existingJournal['type'];
      _dateEventController.text = existingJournal['date_evenement'];
      _imageController.text = existingJournal['image'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            // this will prevent the soft keyboard from covering the text fields
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Titre'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _lieuController,
                decoration: const InputDecoration(hintText: 'Lieu'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _genreController,
                decoration: const InputDecoration(hintText: 'Genre'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _dateEventController,
                decoration:
                    const InputDecoration(hintText: 'Date de l\'événement'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _imageController,
                decoration: const InputDecoration(hintText: 'Image'),
              ),
              if (_imageFile != null)
                Image.file(
                  File(_imageFile!.path),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Sélectionner une image'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Save new journal
                  if (id == null) {
                    await _addItem();
                  }

                  if (id != null) {
                    await _updateItem(id);
                  }

                  // Clear the text fields
                  _titleController.clear();
                  _descriptionController.clear();
                  _lieuController.clear();
                  _genreController.clear();
                  _dateEventController.clear();
                  _imageController.clear();

                  // Close the bottom sheet
                  Navigator.of(context).pop();

                  // Refresh the journal list after adding or updating an event
                  _refreshJournals();
                },
                child: Text(id == null ? 'Create New' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Insert a new journal to the database
  Future<void> _addItem() async {
    // Vérifier si les champs requis sont vides
    if (_titleController.text.isEmpty) {
      // Ici, je vais simplement imprimer un message dans la console
      print('Veuillez remplir tous les champs obligatoires.');
      return; // Sortir de la méthode sans ajouter l'événement
    }

    // Ajoutez l'événement à la base de données
    await SQLHelper.createItem(
      _titleController.text,
      _descriptionController.text,
      _lieuController.text,
      _genreController.text,
      _dateEventController.text,
      _imageController.text,
    );

    _refreshJournals();
  }

  // Update an existing item
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
      id,
      _titleController.text,
      _descriptionController.text,
      _lieuController.text,
      _genreController.text,
      _dateEventController.text,
      _imageController.text,
    );

    _refreshJournals();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully deleted a journal!'),
      ),
    );
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Les événements'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 50, // Hauteur de la liste horizontale
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    itemCount: _journals.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 237, 242, 240),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9),
                            child: ElevatedButton(
                              onPressed: () {
                                // Action à effectuer lors du clic sur le bouton
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .greenAccent, // Couleur de fond du bouton
                                foregroundColor: Color.fromARGB(
                                    255, 26, 125, 206), // Couleur du texte
                                elevation: 10,
                                 // Élévation du bouton
                              ),
                              child: Text(
                                _journals[index]['type'],
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                    height:
                        20), // Espacement entre la liste horizontale et la liste verticale des événements
                Expanded(
                  child: ListView.builder(
                    itemCount: _journals.length,
                    itemBuilder: (context, index) => Card(
                      color: Color.fromARGB(
                          190, 144, 238, 249), // Couleur de fond de la carte
                      elevation: 3, // Élévation de la carte
                      margin:
                          const EdgeInsets.all(10), // Marge autour de la carte
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            15), // Bord arrondi de la carte
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Section pour afficher l'image
                          Container(
                            height: 100, // Hauteur de la section de l'image
                            // decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.vertical(top: Radius.circular(15)), // Ajoutez la bordure arrondie seulement en haut
                            //           ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(
                                      15)), // Bord arrondi seulement en haut
                              image: DecorationImage(
                                image: _journals[index]['image'] != null
                                    ? AssetImage(_journals[index]['image'])
                                    : AssetImage(
                                        'assets/FirstPage1.png'), // Utilisez le chemin de l'image du modèle de données s'il n'est pas null, sinon utilisez une image de substitution                        fit: BoxFit.cover, // Remplissage de l'image pour couvrir toute la zone
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          //  child: _journals[index]['image'] != null
                          //       ? Image.file(
                          //           File(_journals[index]['image']), // Utilisez le fichier image du modèle de données s'il n'est pas null
                          //           width: double.infinity,

                          //           fit: BoxFit.cover,
                          //         )
                          //   : Container(), // Widget vide si aucune image n'est présente
                          // ),
                          // Divider pour séparer l'image et le texte
                          Divider(
                            thickness: 2, // Épaisseur du Divider
                            color: const Color.fromARGB(
                                41, 0, 0, 0), // Couleur du Divider
                          ),
                          // Section pour afficher les détails de l'événement
                          ListTile(
                            title: Text(
                              _journals[index]['titre'],
                              style: TextStyle(
                                fontSize: 18, // Taille de la police du titre
                                fontWeight:
                                    FontWeight.bold, // Gras pour le titre
                                color: Color.fromARGB(255, 22, 85,
                                    195), // Couleur du texte du titre
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.description),
                                    SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        _journals[index]['description'],
                                        style: TextStyle(
                                          fontSize:
                                              14, // Taille de la police du sous-titre
                                          color: Colors
                                              .black87, // Couleur du texte du sous-titre
                                        ),
                                        overflow: TextOverflow
                                            .ellipsis, // Gérer le débordement du texte
                                        maxLines:
                                            100, // Limiter le nombre de lignes affichées
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.location_on),
                                    SizedBox(width: 5),
                                    Text(
                                      _journals[index]['lieu'],
                                      style: TextStyle(
                                        fontSize:
                                            14, // Taille de la police du sous-titre
                                        color: Colors
                                            .black87, // Couleur du texte du sous-titre
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.event_note),
                                    SizedBox(width: 5),
                                    Text(
                                      _journals[index]['type'],
                                      style: TextStyle(
                                        fontSize:
                                            14, // Taille de la police du sous-titre
                                        color: Colors
                                            .black87, // Couleur du texte du sous-titre
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.event),
                                    SizedBox(width: 5),
                                    Text(
                                      _journals[index]['date_evenement'],
                                      style: TextStyle(
                                        fontSize:
                                            14, // Taille de la police du sous-titre
                                        color: Colors
                                            .black87, // Couleur du texte du sous-titre
                                      ),
                                    ),
                                  ],
                                ),
                                // Ajoutez d'autres champs ici selon vos besoins
                              ],
                            ),
                          ),
                          // Section pour afficher les icônes de modification et de suppression
                          Divider(
                            thickness: 1, // Épaisseur du Divider
                            color: const Color.fromARGB(
                                45, 0, 0, 0), // Couleur du Divider
                          ),

                          Padding(
                            padding: EdgeInsets.all(
                                0), // Espacement autour des icônes
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Alignement des icônes sur les bords
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      size: 35), // Taille de l'icône
                                  onPressed: () =>
                                      _showForm(_journals[index]['id']),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      size: 35), // Taille de l'icône
                                  onPressed: () =>
                                      _deleteItem(_journals[index]['id']),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
