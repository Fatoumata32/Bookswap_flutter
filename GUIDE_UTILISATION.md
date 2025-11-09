# 📖 Guide d'Utilisation - BookSwap

## 🚀 Démarrage Rapide avec Données d'Exemple

### Étape 1 : Lancer l'application

```bash
flutter run
```

### Étape 2 : Créer un compte

1. Lancez l'app
2. Remplissez le formulaire d'inscription :
   - Nom d'utilisateur
   - Email
   - Mot de passe (min. 6 caractères)
3. Cliquez sur "Sign Up"

### Étape 3 : Créer des données d'exemple

1. Allez dans **Settings** (⚙️ en bas à droite)
2. Cliquez sur **"Firestore Debug"**
3. Cliquez sur le bouton vert **"Create Sample Data"**
4. Attendez 2-3 secondes
5. Vous verrez : "✓ Created 3 sample books, ✓ Created 2 sample chats..."

### Étape 4 : Explorer l'application

#### 🏠 Home (Parcourir les livres)
- Vous verrez 3 livres disponibles :
  - Introduction to Algorithms
  - Clean Code
  - The Pragmatic Programmer
- Cliquez sur un livre pour voir les détails
- Cliquez "I'm Interested!" pour initier un échange

#### 📚 My Listings (Mes livres)
- Vos 3 livres apparaîtront ici
- Cliquez sur "+" pour ajouter un nouveau livre
- Prenez une photo ou choisissez depuis la galerie

#### 💬 Chats (Conversations)
- Vous verrez 2 conversations d'exemple :
  - **Demo User** - à propos de "Data Structures & Algorithms"
  - **Alice Martin** - à propos de "Introduction to Machine Learning"
- Cliquez sur une conversation pour voir l'historique complet
- Envoyez de nouveaux messages

#### ⚙️ Settings
- Voir votre profil
- Accéder au Firestore Debug
- Se déconnecter

## 📝 Exemples de Conversations Créées

### Conversation 1 : Demo User

```
Vous: Hi! I'm interested in your Data Structures book.
Demo User: Hello! Yes, it's still available. What book do you have for exchange?
Vous: I have Clean Code by Robert Martin. Are you interested?
Demo User: Yes! That sounds perfect. I've been wanting to read that book.
Vous: Great! When can we meet for the exchange?
Demo User: How about tomorrow at 2 PM at the library?
Vous: Perfect! See you there 👍
```

### Conversation 2 : Alice Martin

```
Vous: Hi Alice! Is your ML book still available?
Alice: Hi! Yes it is. What would you like to exchange it for?
Vous: I have "Python Crash Course". Interested?
Alice: That would be great! Is it in good condition?
Vous: Yes, barely used. Like new condition.
Alice: Perfect! Thanks for the info!
```

## 🆕 Ajouter Votre Propre Livre

1. Allez dans **My Listings**
2. Cliquez sur le bouton **"+"** (flottant en bas à droite)
3. Remplissez le formulaire :
   - **Titre** : ex. "Design Patterns"
   - **Auteur** : ex. "Gang of Four"
   - **Condition** : New, Like New, Good, ou Used
   - **Je cherche** : ex. "Any Java book"
   - **Photo** : Prenez ou choisissez une image
4. Cliquez **"Post Book"**
5. Votre livre apparaîtra dans Home pour tous les utilisateurs !

## 💬 Démarrer une Conversation

1. Parcourez les livres dans **Home**
2. Cliquez sur un livre qui vous intéresse
3. Cliquez **"I'm Interested!"**
4. Une conversation sera automatiquement créée
5. Allez dans **Chats** pour envoyer un message
6. Négociez l'échange avec le propriétaire

## 🔄 Proposer un Échange

1. Dans la conversation, discutez des détails
2. Proposez un de vos livres en échange
3. Convenez d'un lieu et d'une heure de rencontre
4. Effectuez l'échange en personne
5. (Future feature: système de confirmation d'échange)

## 🗑️ Effacer les Données d'Exemple

Si vous voulez repartir de zéro :

1. **Settings** → **Firestore Debug**
2. Cliquez sur le bouton rouge **"Clear Data"**
3. Confirmez la suppression
4. Toutes vos données seront effacées
5. Vous pouvez recréer des données d'exemple ou commencer à ajouter vos vrais livres

## 🐛 Résolution de Problèmes

### "Error loading chats" ou "Error loading listings"

**Solution** : Index Firestore manquants

1. **Settings** → **Firestore Debug**
2. Cliquez **"Run Firestore Tests"**
3. Regardez les logs pour les liens Firebase
4. Cliquez sur les liens pour créer les index
5. Attendez 2-3 minutes
6. Redémarrez l'app

### Les données d'exemple n'apparaissent pas

**Vérifiez** :
1. Que vous êtes connecté
2. Que la création a réussi (message ✓)
3. Attendez quelques secondes et rafraîchissez
4. Vérifiez les index Firestore

### Impossible de télécharger une photo

**Solutions** :
- Accordez les permissions caméra/galerie à l'app
- Sur Android : Settings → Apps → BookSwap → Permissions
- Redémarrez l'app après avoir accordé les permissions

## 🎯 Fonctionnalités Principales

### ✅ Implémentées
- [x] Authentification complète
- [x] Parcourir tous les livres disponibles
- [x] Publier ses propres livres
- [x] Chat en temps réel
- [x] Proposer des échanges
- [x] Voir ses conversations
- [x] Données d'exemple pour tester
- [x] Outil de debug Firestore

### 🔜 À venir
- [ ] Notifications push pour nouveaux messages
- [ ] Système de confirmation d'échange
- [ ] Historique des échanges
- [ ] Système de notation des utilisateurs
- [ ] Recherche et filtres avancés
- [ ] Géolocalisation des livres
- [ ] Upload multiple d'images
- [ ] Modifier/supprimer un livre publié

## 💡 Conseils d'Utilisation

1. **Sécurité** : Rencontrez-vous dans des lieux publics
2. **Photos** : Prenez des photos claires de vos livres
3. **Description** : Soyez honnête sur l'état du livre
4. **Communication** : Répondez rapidement aux messages
5. **Respect** : Annulez poliment si l'échange ne vous convient plus

## 📊 Statistiques de Données d'Exemple

Quand vous créez des données d'exemple, voici ce qui est ajouté :

- **3 livres** dans votre collection
- **2 utilisateurs démo** créés
- **2 conversations** avec historique complet
- **13 messages** au total dans les 2 conversations
- **1 livre supplémentaire** d'un utilisateur démo (visible dans Home)

## 🔐 Confidentialité

- Vos données sont stockées sur Firebase Firestore
- Seuls vous et vos contacts de chat peuvent voir vos conversations
- Vos livres sont visibles par tous les utilisateurs de l'app
- Aucune donnée n'est partagée avec des tiers

---

**Besoin d'aide ?**
- Consultez `README.md` pour l'installation
- Consultez `POURQUOI_FIRESTORE_NE_FONCTIONNE_PAS.md` pour les problèmes Firestore
- Utilisez l'écran "Firestore Debug" pour diagnostiquer les problèmes
