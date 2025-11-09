# 🔥 Guide: Créer les Index Firestore

## Méthode 1 : VIA FIREBASE CLI (La plus rapide - 2 minutes)

### Étape 1 : Installer Firebase CLI

```bash
npm install -g firebase-tools
```

### Étape 2 : Se connecter

```bash
firebase login
```

### Étape 3 : Initialiser (si pas déjà fait)

```bash
cd C:\Users\PC\Documents\bookswap\Bookswap_flutter
firebase init firestore
```

Quand il demande :
- "What file should be used for Firestore Rules?" → Appuyez sur Entrée (il utilisera firestore.rules)
- "What file should be used for Firestore indexes?" → Appuyez sur Entrée (il utilisera firestore.indexes.json)
- "File firestore.rules already exists. Do you want to overwrite?" → **N** (Non)
- "File firestore.indexes.json already exists. Do you want to overwrite?" → **N** (Non)

### Étape 4 : Déployer les index

```bash
firebase deploy --only firestore:indexes
```

Vous verrez :
```
✓ Deploying indexes...
✓ Deploy complete!
```

### Étape 5 : Attendre

⏳ **Attendez 2-5 minutes** que Firebase construise les index.

Vous pouvez vérifier l'état sur :
https://console.firebase.google.com/project/VOTRE-PROJET/firestore/indexes

---

## Méthode 2 : VIA FIREBASE CONSOLE (Manuelle - 5 minutes)

### Étape 1 : Aller sur Firebase Console

https://console.firebase.google.com/

→ Sélectionnez votre projet **BookSwap**
→ Cliquez sur **Firestore Database** dans le menu de gauche
→ Cliquez sur l'onglet **Indexes** en haut

### Étape 2 : Créer les 3 index

#### Index 1 : Books (Pour "My Listings")

Cliquez sur **"Create Index"**

- **Collection ID** : `books`
- **Fields** :
  - Champ 1 : `ownerId` → **Ascending**
  - Champ 2 : `createdAt` → **Descending**
- **Query scope** : Collection
- Cliquez **Create**

#### Index 2 : Chats (Pour "Chats")

Cliquez sur **"Create Index"**

- **Collection ID** : `chats`
- **Fields** :
  - Champ 1 : `participantIds` → **Arrays**
  - Champ 2 : `lastMessageTime` → **Descending**
- **Query scope** : Collection
- Cliquez **Create**

#### Index 3 : SwapOffers (Pour les offres d'échange)

Cliquez sur **"Create Index"**

- **Collection ID** : `swapOffers`
- **Fields** :
  - Champ 1 : `participantIds` → **Arrays**
  - Champ 2 : `createdAt` → **Descending**
- **Query scope** : Collection
- Cliquez **Create**

### Étape 3 : Attendre

⏳ **Attendez 2-5 minutes** que les 3 index se construisent.

Vous verrez le statut changer :
- 🟡 **Building** → En cours de construction
- 🟢 **Enabled** → Prêt à utiliser !

---

## Méthode 3 : VIA L'APPLICATION (Automatique - 1 minute)

### Étape 1 : Lancer l'app

```bash
flutter run
```

### Étape 2 : Aller dans Firestore Debug

**Settings** (⚙️) → **Firestore Debug**

### Étape 3 : Run Tests

Cliquez sur **"Run Firestore Tests"**

### Étape 4 : Regarder les logs

Dans la console, vous verrez des messages comme :

```
✗ ERROR querying user books:
  The query requires an index. You can create it here:
  https://console.firebase.google.com/v1/r/project/votre-projet/firestore/indexes?create_composite=...
```

### Étape 5 : Cliquer sur les liens

**CTRL + Clic** sur chaque lien qui apparaît dans les logs.

Cela ouvrira Firebase Console avec **l'index déjà pré-configuré** !

Cliquez juste sur **"Create"** pour chaque index.

### Étape 6 : Attendre

⏳ **2-5 minutes** pour que les index se construisent.

---

## ✅ Vérifier que les index fonctionnent

### Option A : Via l'app

1. Attendez 3-5 minutes après création des index
2. Redémarrez l'app : `flutter run`
3. **Settings** → **Firestore Debug** → **"Run Firestore Tests"**
4. Vous devriez voir :
   ```
   ✓ Books collection accessible
   ✓ User books query successful
   ✓ Chats query successful
   ```

### Option B : Via Firebase Console

https://console.firebase.google.com/project/VOTRE-PROJET/firestore/indexes

Tous les index doivent afficher : 🟢 **Enabled**

---

## 🎯 Résumé

**Vous avez besoin de 3 index :**

| Collection | Champ 1 | Champ 2 | État |
|------------|---------|---------|------|
| books | ownerId (ASC) | createdAt (DESC) | ❓ |
| chats | participantIds (ARRAY) | lastMessageTime (DESC) | ❓ |
| swapOffers | participantIds (ARRAY) | createdAt (DESC) | ❓ |

**Une fois créés :**
- ⏳ Attendez 2-5 minutes
- 🔄 Redémarrez l'app
- ✅ L'app fonctionnera parfaitement !

---

## 🆘 Problèmes ?

### "Command not found: firebase"

Installez Node.js puis :
```bash
npm install -g firebase-tools
```

### "Permission denied"

Sur Windows, exécutez PowerShell en tant qu'administrateur.

### "No project found"

Assurez-vous d'être dans le bon dossier :
```bash
cd C:\Users\PC\Documents\bookswap\Bookswap_flutter
```

### Les index ne se créent pas

1. Vérifiez que vous êtes sur le bon projet Firebase
2. Vérifiez votre connexion internet
3. Attendez plus longtemps (parfois ça prend 10 minutes)

---

## 📞 Support

Si vous êtes bloqué, utilisez l'écran **Firestore Debug** dans l'app pour obtenir les liens directs !
