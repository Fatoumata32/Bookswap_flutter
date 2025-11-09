# Configuration Firebase pour BookSwap

## Problème actuel
Les erreurs "Error loading chats" et "Error loading your listings" sont causées par des index Firestore manquants.

## Solution

### Option 1: Déployer les index via Firebase CLI (Recommandé)

1. Installez Firebase CLI si ce n'est pas déjà fait:
```bash
npm install -g firebase-tools
```

2. Connectez-vous à Firebase:
```bash
firebase login
```

3. Initialisez Firebase dans votre projet (si pas déjà fait):
```bash
firebase init firestore
```

4. Déployez les index et les règles:
```bash
firebase deploy --only firestore:indexes
firebase deploy --only firestore:rules
```

### Option 2: Créer les index manuellement via la Console Firebase

1. Allez sur [Firebase Console](https://console.firebase.google.com/)
2. Sélectionnez votre projet BookSwap
3. Allez dans **Firestore Database** > **Indexes**
4. Cliquez sur **Create Index**

#### Index à créer:

**Index 1: Pour les listings utilisateur**
- Collection: `books`
- Champs:
  - `ownerId` (Ascending)
  - `createdAt` (Descending)
- Query scope: Collection

**Index 2: Pour les chats utilisateur**
- Collection: `chats`
- Champs:
  - `participantIds` (Array-contains)
  - `lastMessageTime` (Descending)
- Query scope: Collection

**Index 3: Pour les offres d'échange**
- Collection: `swapOffers`
- Champs:
  - `participantIds` (Array-contains)
  - `createdAt` (Descending)
- Query scope: Collection

### Option 3: Utiliser les liens d'erreur

Lorsque vous exécutez l'application, Firebase vous donnera des liens dans les logs d'erreur. Ces liens créeront automatiquement les index nécessaires pour vous.

1. Lancez l'application: `flutter run`
2. Naviguez vers "My Listings" et "Chats"
3. Dans les logs, cherchez des messages comme:
   ```
   The query requires an index. You can create it here: https://console.firebase.google.com/...
   ```
4. Cliquez sur ces liens pour créer les index automatiquement

## Règles de sécurité

Les règles de sécurité Firestore ont été créées dans `firestore.rules`. Pour les déployer:

```bash
firebase deploy --only firestore:rules
```

## Vérification

Une fois les index créés (peut prendre quelques minutes):
1. Redémarrez l'application
2. Les écrans "My Listings" et "Chats" devraient maintenant fonctionner correctement
3. Vous verrez "No listings yet" ou "No chats yet" au lieu d'erreurs

## Structure de la base de données

### Collections Firestore:

- **users**: Profils utilisateurs
- **books**: Annonces de livres
- **chats**: Conversations
  - **messages** (subcollection): Messages individuels
- **swapOffers**: Offres d'échange de livres

## Aide supplémentaire

Pour plus d'informations:
- [Documentation Firestore Indexes](https://firebase.google.com/docs/firestore/query-data/indexing)
- [Documentation Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
