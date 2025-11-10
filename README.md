# BookSwap - Application d'échange de livres

Application Flutter permettant aux étudiants d'échanger des manuels scolaires entre eux.

## 🔥 PROBLÈME FIRESTORE? LISEZ CECI!

### Erreur: "Error loading chats" ou "Error loading your listings"

**C'EST NORMAL!** Firestore nécessite des index pour fonctionner.

### ✅ Solution en 3 étapes (2 minutes)

1. **Lancez l'application**
   ```bash
   flutter run
   ```

2. **Allez dans l'onglet Settings (⚙️) > "Firestore Debug"**

3. **Cliquez sur "Run Firestore Tests"**
   - Les logs afficheront des liens Firebase
   - Cliquez sur ces liens pour créer automatiquement les index
   - Attendez 2-3 minutes que les index se créent
   - Redémarrez l'application

**C'est tout !** L'application fonctionnera parfaitement après.

## 🚀 Installation rapide

```bash
# 1. Installer les dépendances
flutter pub get

# 2. Lancer sur Android (recommandé pour Firebase)
flutter run

# 3. Créer un compte dans l'app
# 4. Utiliser "Firestore Debug" pour configurer les index
```

## Fonctionnalités

- Authentification sécurisée
- Parcourir les livres disponibles
- Publier des livres à échanger
- Chat en temps réel
- Système d'offres d'échange
- Gestion de profil
- Outil de debug Firestore intégré

##  Configuration Firebase (si besoin)

### Option 1: Via Firebase CLI
```bash
firebase login
firebase deploy --only firestore:indexes,firestore:rules
```

### Option 2: Utiliser l'écran de debug
Settings > Firestore Debug > Run Tests > Cliquer sur les liens

##  Structure

- `lib/screens/` - Écrans de l'app
- `lib/models/` - Modèles de données
- `lib/services/` - Services Firebase
- `lib/providers/` - État global (Riverpod)
- `lib/widgets/` - Composants réutilisables

##  Debug

Si l'app ne fonctionne pas:
1. Vérifiez que Firebase est configuré
2. Utilisez "Firestore Debug" dans Settings
3. Vérifiez les logs pour voir les erreurs exactes
4. Cliquez sur les liens d'index Firestore

##  Plus d'infos

Consultez `FIREBASE_SETUP.md` pour plus de détails sur la configuration Firebase.
