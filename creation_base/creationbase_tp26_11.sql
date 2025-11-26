-- ⚠️ Ce script doit être exécuté sur la base tp26_11
-- Connexion recommandée : 
-- docker exec -i local_pgdb psql -U admin -d tp26_11 -f /creationbase_tp26_11.sql

-- 1️⃣ Créer le schéma ecommerce s'il n'existe pas
CREATE SCHEMA IF NOT EXISTS ecommerce;

-- 2️⃣ Table catégories
CREATE TABLE IF NOT EXISTS ecommerce.categories (
    id_categorie SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- 3️⃣ Table produits
CREATE TABLE IF NOT EXISTS ecommerce.produits (
    id_produit SERIAL PRIMARY KEY,
    nom VARCHAR(150) NOT NULL,
    prix NUMERIC(10,2) NOT NULL CHECK (prix > 0),
    stock_disponible INT NOT NULL CHECK (stock_disponible >= 0),
    id_categorie INT NOT NULL REFERENCES ecommerce.categories(id_categorie) ON DELETE CASCADE
);

-- 4️⃣ Table clients
CREATE TABLE IF NOT EXISTS ecommerce.clients (
    id_clients SERIAL PRIMARY KEY,
    prenom VARCHAR(100) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 5️⃣ Table commandes
CREATE TABLE IF NOT EXISTS ecommerce.commandes (
    id_commande SERIAL PRIMARY KEY,
    id_clients INT NOT NULL REFERENCES ecommerce.clients(id_clients) ON DELETE CASCADE,
    date_commande TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    statut VARCHAR(20) NOT NULL CHECK (statut IN ('PENDING','PAID','SHIPPED','CANCELLED'))
);

-- 6️⃣ Table lignes de commande
CREATE TABLE IF NOT EXISTS ecommerce.detail_commandes (
    produit_commande_id SERIAL PRIMARY KEY,
    id_commande INT NOT NULL REFERENCES ecommerce.commandes(id_commande) ON DELETE CASCADE,
    id_produit INT NOT NULL REFERENCES ecommerce.produits(id_produit) ON DELETE CASCADE,
    quantite INT NOT NULL CHECK (quantite > 0),
    prix_unitaire NUMERIC(10,2) NOT NULL CHECK (prix_unitaire > 0)
);
