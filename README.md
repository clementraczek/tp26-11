SuperShop Analytics est un projet pédagogique complet permettant d’explorer un cas réel d’analyse e-commerce avec PostgreSQL.

Il couvre la conception d’un schéma relationnel complet (catégories, produits, clients, commandes).

Un jeu de données réaliste est fourni et inséré via SQL.


Un script Python génère automatiquement un rapport synthétique (rapport\_supershop.txt) basé sur les résultats SQL.



Guide de lancement de l’application SuperShop



1\. Aller dans le dossier du projet



Avant toute commande Docker, ouvrez un terminal PowerShell et

placez‑vous dans :



&nbsp;   C:\\Users\\Administrateur\\tp26-11



Ce dossier contient le fichier docker-compose.yml et toute la structure

du projet.



------------------------------------------------------------------------



2\. Lancer l’application



Exécuter :



&nbsp;   docker compose up --build



Cela va : - démarrer PostgreSQL - appliquer les scripts SQL - lancer le

container Python pour générer le rapport - lancer Adminer



------------------------------------------------------------------------



3\. Arrêter et nettoyer l’environnement



&nbsp;   docker compose down -v





