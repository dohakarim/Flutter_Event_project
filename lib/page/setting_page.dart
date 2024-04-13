import 'package:flutter/material.dart';
import 'package:flutter_project1/sql_helper.dart';

// class SettingPage extends StatefulWidget {
//   const SettingPage({Key? key}) : super(key: key);

//   @override
//   State<SettingPage> createState() => _SettingPageState();
// }

// class _SettingPageState extends State<SettingPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Setting Page'),
//       ),
//       body: Center(
//         child: Text(
//           'Setting Screen',
//           style: TextStyle(fontSize: 40),
//         ),
//       ),
//     );
//   }
// }


// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // Remove the debug banner
//         debugShowCheckedModeBanner: false,
//         title: 'SQLITE',
//         theme: ThemeData(
//           primarySwatch: Colors.orange,
//         ),
//         home: const HomePage());
//   }
// }

class CreatEvent extends StatefulWidget {
  const CreatEvent({Key? key}) : super(key: key);

  @override
  _CreatEventForm createState() => _CreatEventForm();
}

class _CreatEventForm extends State<CreatEvent> {
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
      _isLoading = false; // Mettre isLoading à false une fois que les données sont récupérées
    });
  } catch (error) {
    // Gérer les erreurs éventuelles lors de la récupération des données
    debugPrint("Error fetching journals: $error");
    setState(() {
      _isLoading = false; // Mettre isLoading à false en cas d'erreur
    });
  }
}


  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
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
                decoration: const InputDecoration(hintText: 'Date de l\'événement'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _imageController,
                decoration: const InputDecoration(hintText: 'Image'),
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
              )

            ],
           ),
          ),
        ));
  }

// Insert a new journal to the database
  // Insertion d'un nouvel événement dans la base de données
// Insert a new journal to the database
// Insérer un nouvel événement dans la base de données
Future<void> _addItem() async {
  // Vérifier si les champs requis sont vides
  if (_titleController.text.isEmpty ) {
    // Afficher un message d'erreur ou une alerte à l'utilisateur
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
    _imageController.text
  );

  // Effacer les valeurs des contrôleurs après l'ajout d'un nouvel événement
  // _titleController.clear();
  // _descriptionController.clear();
  // _lieuController.clear();
  // _genreController.clear();
  // _dateEventController.clear();
  // _imageController.clear();

  // Rafraîchir la liste des événements après l'ajout d'un nouvel événement
  _refreshJournals();
}



// Update an existing item
// Mettre à jour un événement existant
Future<void> _updateItem(int id) async {
  await SQLHelper.updateItem(
    id,
    _titleController.text,
    _descriptionController.text,
    _lieuController.text,
    _genreController.text,
    _dateEventController.text,
    _imageController.text
  );
  // Effacez les valeurs des contrôleurs après la mise à jour de l'événement
  // _titleController.clear();
  // _descriptionController.clear();
  // _lieuController.clear();
  // _genreController.clear();
  // _dateEventController.clear();
  // _imageController.clear();
  // Rafraîchissez la liste des événements après la mise à jour de l'événement
  _refreshJournals();
}



  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('les événements '),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _journals.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_journals[index]['titre']),
             subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description),
              SizedBox(width: 5),
              Text(_journals[index]['description']),
            ],
          ),
          Row(
            children: [
              Icon(Icons.location_on),
              SizedBox(width: 5),
              Text(_journals[index]['lieu']),
            ],
          ),
          Row(
            children: [
              Icon(Icons.event_note),
              SizedBox(width: 5),
              Text(_journals[index]['type']),
            ],
          ),
          Row(
            children: [
              Icon(Icons.event),
              SizedBox(width: 5),
              Text(_journals[index]['date_evenement']),
            ],
          ),
          // Ajoutez d'autres champs ici selon vos besoins
        ],
      ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_journals[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_journals[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
