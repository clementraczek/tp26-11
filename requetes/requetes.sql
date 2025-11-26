-------3
--1
SELECT *
FROM ecommerce.clients
ORDER BY date_creation ASC;

--2
SELECT nom, prix_unitaire
FROM ecommerce.produits
ORDER BY prix_unitaire DESC;

--3
SELECT *
FROM ecommerce.commandes
WHERE date_commande BETWEEN '2024-03-01' AND '2024-03-15'
ORDER BY date_commande;

--4
SELECT p.*, c.name AS categorie
FROM ecommerce.produits p
JOIN ecommerce.categories c 
    ON p.id_categorie = c.id_categorie
WHERE p.prix > 50;

--5
SELECT p.*, c.name AS categorie
FROM ecommerce.produits AS p
JOIN ecommerce.categories AS c
ON p.id_categorie = c.id_categorie
WHERE c.name = 'Électronique';

-------4

--1
SELECT p.*, c.name AS categorie
FROM ecommerce.produits AS p
JOIN ecommerce.categories AS c
ON p.id_categorie = c.id_categorie

--2
SELECT o.*, c.nom AS nom, c.prenom as prenom
FROM ecommerce.commandes AS o
JOIN ecommerce.clients AS c
ON o.id_clients = c.id_clients;

--3
SELECT
    c.nom AS client_nom,
    c.prenom AS client_prenom,
    p.nom AS produit,
    oi.quantite AS quantite,
    oi.prix_unitaire AS prix_unitaire
FROM ecommerce.detail_commandes AS oi
JOIN ecommerce.commandes AS o
    ON oi.id_commande = o.id_commande
JOIN ecommerce.clients AS c
    ON o.id_clients = c.id_clients
JOIN ecommerce.produits AS p
    ON oi.id_produit = p.id_produit
ORDER BY c.nom, o.id_commande;

--4
SELECT *
FROM ecommerce.commandes
WHERE statut='PAID' or statut ='SHIPPED';


-------5

--1

SELECT
    o.date_commande AS date_commande,
    c.nom AS client_nom,
    c.prenom AS client_prenom,
    p.nom AS produit,
    oi.quantite AS quantite,
    oi.prix_unitaire AS prix_unitaire,
    (oi.quantite * oi.prix_unitaire) AS total_ligne
FROM ecommerce.commandes AS o
JOIN ecommerce.clients AS c
    ON o.id_clients = c.id_clients
JOIN ecommerce.detail_commandes AS oi
    ON oi.id_commande = o.id_commande
JOIN ecommerce.produits AS p
    ON oi.id_produit = p.id_produit
ORDER BY o.date_commande, c.nom, p.nom;

--2
SELECT
    o.id_commande AS id_commande,
    c.nom AS client_nom,
    c.prenom AS client_prenom,
    SUM(oi.quantite * oi.prix_unitaire) AS montant_total
FROM ecommerce.commandes AS o
JOIN ecommerce.clients AS c
    ON o.id_clients = c.id_clients
JOIN ecommerce.detail_commandes AS oi
    ON oi.produit_commande_id = o.id_commande
GROUP BY o.id_commande, c.nom, c.prenom
ORDER BY o.id_commande;

--3
SELECT
    o.date_commande AS date_commande,
    c.nom AS client_nom,
    c.prenom AS client_prenom,
    p.nom AS produit,
    oi.quantite AS quantite,
    oi.prix_unitaire AS prix_unitaire,
    (oi.quantite * oi.prix_unitaire) AS total_ligne
FROM ecommerce.commandes AS o
JOIN ecommerce.clients AS c
    ON o.id_clients = c.id_clients
JOIN ecommerce.detail_commandes AS oi
    ON oi.id_commande = o.id_commande
JOIN ecommerce.produits AS p
    ON oi.id_produit = p.id_produit
WHERE (oi.quantite * oi.prix_unitaire) > 100
ORDER BY o.date_commande, c.nom, p.nom;

--4
SELECT
    cat.name AS categorie,
    SUM(oi.quantite * oi.prix_unitaire) AS chiffre_affaires
FROM ecommerce.categories AS cat
JOIN ecommerce.produits AS p
    ON p.id_categorie = cat.id_categorie
JOIN ecommerce.detail_commandes AS oi
    ON oi.id_produit = p.id_produit
JOIN ecommerce.commandes AS o
    ON o.id_commande = oi.id_commande  
GROUP BY cat.name
ORDER BY chiffre_affaires DESC;

------6

--1
SELECT DISTINCT p.*
FROM ecommerce.produits AS p
JOIN ecommerce.detail_commandes AS oi
    ON oi.id_produit = p.id_produit;

--2

SELECT p.*
FROM ecommerce.produits AS p
LEFT JOIN ecommerce.detail_commandes AS oi
    ON oi.id_produit = p.id_produit
WHERE oi.id_produit IS NULL;

--3

SELECT
    c.id_clients,
    c.nom,
    c.prenom,
    SUM(oi.quantite * oi.prix_unitaire) AS total_depense
FROM ecommerce.clients AS c
JOIN ecommerce.commandes AS o
    ON o.id_clients = c.id_clients
JOIN ecommerce.detail_commandes AS oi
    ON oi.id_commande = o.id_commande
GROUP BY c.id_clients, c.nom, c.prenom
ORDER BY total_depense DESC
LIMIT 1;

--4
SELECT
    p.id_produit,
    p.nom AS produit,
    SUM(oi.quantite) AS quantite_totale
FROM ecommerce.produits AS p
JOIN ecommerce.detail_commandes AS oi
    ON oi.id_produit = p.id_produit
GROUP BY p.id_produit, p.nom
ORDER BY quantite_totale DESC
LIMIT 3;

--5
SELECT
    o.id_commande,
    o.date_commande,
    c.nom AS client_nom,
    c.prenom AS client_prenom,
    SUM(oi.quantite * oi.prix_unitaire) AS total_commande
FROM ecommerce.commandes AS o
JOIN ecommerce.clients AS c
    ON c.id_clients = o.id_clients
JOIN ecommerce.detail_commandes AS oi
    ON oi.id_commande = o.id_commande
GROUP BY o.id_commande, o.date_commande, c.nom, c.prenom
HAVING SUM(oi.quantite * oi.prix_unitaire) >
       (
           SELECT AVG(t.total)
           FROM (
               SELECT SUM(oi2.quantite * oi2.prix_unitaire) AS total
               FROM ecommerce.commandes AS o2
               JOIN ecommerce.detail_commandes AS oi2
                   ON oi2.id_commande = o2.id_commande
               GROUP BY o2.id_commande
           ) AS t
       )
ORDER BY total_commande DESC;


-----------7

--1

SELECT 
    ROUND(SUM(oi.quantite * oi.prix_unitaire), 2) AS chiffre_affaires_total
FROM ecommerce.commandes AS o
JOIN ecommerce.detail_commandes AS oi
    ON oi.id_commande = o.id_commande
WHERE o.statut <> 'CANCELLED';

--2
SELECT 
    ROUND(AVG(total_commande), 2) AS panier_moyen
FROM (
    SELECT 
        o.id_commande,
        SUM(oi.quantite * oi.prix_unitaire) AS total_commande
    FROM ecommerce.commandes AS o
    JOIN ecommerce.detail_commandes AS oi
        ON oi.id_commande = o.id_commande
    GROUP BY o.id_commande
) AS t;

--3
SELECT
    cat.id_categorie,
    cat.name AS categorie,
    SUM(oi.quantite) AS quantite_totale
FROM ecommerce.categories AS cat
JOIN ecommerce.produits AS p
    ON p.id_categorie = cat.id_categorie
JOIN ecommerce.detail_commandes AS oi
    ON oi.id_produit = p.id_produit
GROUP BY cat.id_categorie, cat.name
ORDER BY quantite_totale DESC;

--4
SELECT 
    TO_CHAR(o.date_commande, 'YYYY-MM') AS mois,
    ROUND(SUM(oi.quantite * oi.prix_unitaire)::numeric, 2) AS chiffre_affaires
FROM ecommerce.commandes AS o
JOIN ecommerce.detail_commandes AS oi
    ON oi.id_commande = o.id_commande
GROUP BY TO_CHAR(o.date_commande, 'YYYY-MM')
ORDER BY mois;

-------8

--1
SELECT
    o.id_commande,
    CONCAT(c.prenom, ' ', c.nom) AS client,
    o.date_commande,
    CASE 
        WHEN o.statut = 'PAID'      THEN 'Payée'
        WHEN o.statut = 'SHIPPED'   THEN 'Expédiée'
        WHEN o.statut = 'PENDING'   THEN 'En attente'
        WHEN o.statut = 'CANCELLED' THEN 'Annulée'
        ELSE 'Statut inconnu'
    END AS statut_fr
FROM ecommerce.commandes AS o
JOIN ecommerce.clients AS c
    ON o.id_clients = c.id_clients
ORDER BY o.date_commande, o.id_commande;

--2
SELECT
    c.prenom,
    c.nom,
    ROUND(SUM(oi.quantite * oi.prix_unitaire)::numeric, 2) AS total_depense,
CASE
WHEN SUM(oi.quantite * oi.prix_unitaire) < 100 
THEN 'Bronze'
WHEN SUM(oi.quantite * oi.prix_unitaire) BETWEEN 100 AND 300
THEN 'Argent'
WHEN SUM(oi.quantite * oi.prix_unitaire) > 300
THEN 'Or'
END AS segment
FROM ecommerce.clients AS c
JOIN ecommerce.commandes AS o
    ON o.id_clients = c.id_clients
JOIN ecommerce.detail_commandes AS oi
    ON oi.id_commande = o.id_commande
GROUP BY c.id_clients, c.prenom, c.nom
ORDER BY total_depense DESC;
