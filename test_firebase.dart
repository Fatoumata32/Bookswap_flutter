// Script de test pour vérifier la connexion Firebase
// et ajouter des données de test dans Firestore

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  print('🚀 Démarrage du test Firebase...\n');

  // Initialiser Firebase
  try {
    await Firebase.initializeApp();
    print('✅ Firebase initialisé avec succès!\n');
  } catch (e) {
    print('❌ Erreur lors de l\'initialisation de Firebase: $e');
    return;
  }

  final firestore = FirebaseFirestore.instance;

  // Test 1: Ajouter des livres de test
  print('📚 Test 1: Ajout de livres de test...');
  try {
    // Livre 1
    final book1 = await firestore.collection('books').add({
      'title': 'Introduction à la Programmation',
      'author': 'Jean Dupont',
      'condition': 'Like New',
      'swapFor': 'Livre sur Python ou JavaScript',
      'imageUrl': 'https://via.placeholder.com/300x400?text=Programmation',
      'ownerId': 'test_user_1',
      'ownerName': 'Marie Martin',
      'createdAt': Timestamp.now(),
      'status': 'available',
    });
    print('  ✅ Livre 1 ajouté avec ID: ${book1.id}');

    // Livre 2
    final book2 = await firestore.collection('books').add({
      'title': 'Mathématiques Avancées',
      'author': 'Pierre Durant',
      'condition': 'Good',
      'swapFor': 'Livre de physique niveau licence',
      'imageUrl': 'https://via.placeholder.com/300x400?text=Maths',
      'ownerId': 'test_user_2',
      'ownerName': 'Ahmed Diallo',
      'createdAt': Timestamp.now(),
      'status': 'available',
    });
    print('  ✅ Livre 2 ajouté avec ID: ${book2.id}');

    // Livre 3
    final book3 = await firestore.collection('books').add({
      'title': 'Histoire de l\'Afrique',
      'author': 'Fatou Ndiaye',
      'condition': 'New',
      'swapFor': 'Livre d\'histoire ou géographie',
      'imageUrl': 'https://via.placeholder.com/300x400?text=Histoire',
      'ownerId': 'test_user_3',
      'ownerName': 'Issa Sow',
      'createdAt': Timestamp.now(),
      'status': 'available',
    });
    print('  ✅ Livre 3 ajouté avec ID: ${book3.id}\n');

    print('✅ Tous les livres ont été ajoutés avec succès!\n');
  } catch (e) {
    print('❌ Erreur lors de l\'ajout des livres: $e\n');
  }

  // Test 2: Ajouter un utilisateur de test
  print('👤 Test 2: Ajout d\'un utilisateur de test...');
  try {
    final user = await firestore.collection('users').add({
      'displayName': 'Test User',
      'email': 'test@bookswap.com',
      'photoUrl': 'https://via.placeholder.com/150',
      'bio': 'Étudiant passionné de lecture',
      'createdAt': Timestamp.now(),
    });
    print('  ✅ Utilisateur ajouté avec ID: ${user.id}\n');
  } catch (e) {
    print('❌ Erreur lors de l\'ajout de l\'utilisateur: $e\n');
  }

  // Test 3: Lire les données pour vérifier
  print('📖 Test 3: Lecture des livres depuis Firestore...');
  try {
    final snapshot = await firestore
        .collection('books')
        .orderBy('createdAt', descending: true)
        .limit(5)
        .get();

    print('  📊 Nombre de livres trouvés: ${snapshot.docs.length}');
    for (var doc in snapshot.docs) {
      final data = doc.data();
      print('  - ${data['title']} par ${data['author']} (${data['condition']})');
    }
    print('\n✅ Lecture réussie!\n');
  } catch (e) {
    print('❌ Erreur lors de la lecture: $e\n');
  }

  // Test 4: Statistiques de la base de données
  print('📊 Test 4: Statistiques de la base de données...');
  try {
    final booksCount = await firestore.collection('books').count().get();
    final usersCount = await firestore.collection('users').count().get();

    print('  📚 Total de livres: ${booksCount.count}');
    print('  👥 Total d\'utilisateurs: ${usersCount.count}');
    print('\n✅ Tests terminés avec succès! 🎉\n');
  } catch (e) {
    print('❌ Erreur lors de la récupération des statistiques: $e\n');
  }

  print('🏁 Fin du script de test.');
}
