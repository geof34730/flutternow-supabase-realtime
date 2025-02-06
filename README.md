# Chat Anonyme

Une application de chat anonyme construite avec Flutter et Supabase.

## Table des matières

- [Aperçu](#aperçu)
- [Fonctionnalités](#fonctionnalités)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Utilisation](#utilisation)
- [Configuration de Supabase](#configuration-de-supabase)
- [Contribuer](#contribuer)
- [Licence](#licence)

## Aperçu

Cette application permet aux utilisateurs d'envoyer et de recevoir des messages de manière anonyme. Elle utilise Flutter pour l'interface utilisateur et Supabase pour la gestion des données en temps réel.

## Fonctionnalités

- Envoi de messages en temps réel
- Réception de messages en temps réel
- Interface utilisateur simple et intuitive

## Prérequis

- Flutter SDK: [Installation Flutter](https://flutter.dev/docs/get-started/install)
- Compte Supabase: [Inscription Supabase](https://supabase.io/)

## Installation

1. Clonez ce dépôt :

   ```bash
   git clone https://github.com/votre-utilisateur/chat-anonyme.git
   cd chat-anonyme
   ```

2. Installez les dépendances :

   ```bash
   flutter pub get
   ```

3. Configurez votre projet Supabase (voir la section [Configuration de Supabase](#configuration-de-supabase)).

4. Exécutez l'application :

   ```bash
   flutter run
   ```

## Utilisation

- Lancez l'application sur un simulateur ou un appareil physique.
- Tapez votre message dans le champ de texte et appuyez sur le bouton d'envoi pour envoyer un message.

## Configuration de Supabase

1. Créez un projet sur [Supabase](https://supabase.io/).
2. Créez une table `messages` avec les colonnes suivantes :
    - `id`: `uuid`, clé primaire
    - `content`: `text`
    - `created_at`: `timestamp` avec la valeur par défaut `now()`
3. Activez les politiques de sécurité au niveau des lignes (RLS) et ajoutez une politique pour permettre l'insertion de messages par les utilisateurs authentifiés.
4. Configurez votre URL Supabase et votre clé d'API dans votre application Flutter.

## Contribuer

Les contributions sont les bienvenues ! Veuillez soumettre un pull request ou ouvrir une issue pour discuter des changements que vous souhaitez apporter.

## Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.
