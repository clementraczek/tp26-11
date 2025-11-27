
INSERT INTO ecommerce.categories (name, description) VALUES
  ('Électronique',       'Produits high-tech et accessoires'),
  ('Maison & Cuisine',   'Électroménager et ustensiles'),
  ('Sport & Loisirs',    'Articles de sport et plein air'),
  ('Beauté & Santé',     'Produits de beauté, hygiène, bien-être'),
  ('Jeux & Jouets',      'Jouets pour enfants et adultes');



INSERT INTO ecommerce.produits (nom, prix, stock_disponible, id_categorie) VALUES
  ('Casque Bluetooth X1000',        79.99,  50,  (SELECT id_categorie FROM ecommerce.categories WHERE name='Électronique')),
  ('Souris Gamer Pro RGB',          49.90, 120,  (SELECT id_categorie FROM ecommerce.categories WHERE name='Électronique')),
  ('Bouilloire Inox 1.7L',          29.99,  80,  (SELECT id_categorie FROM ecommerce.categories WHERE name='Maison & Cuisine')),
  ('Aspirateur Cyclonix 3000',     129.00,  40,  (SELECT id_categorie FROM ecommerce.categories WHERE name='Maison & Cuisine')),
  ('Tapis de Yoga Comfort+',        19.99, 150,  (SELECT id_categorie FROM ecommerce.categories WHERE name='Sport & Loisirs')),
  ('Haltères 5kg (paire)',          24.99,  70,  (SELECT id_categorie FROM ecommerce.categories WHERE name='Sport & Loisirs')),
  ('Crème hydratante BioSkin',      15.90, 200,  (SELECT id_categorie FROM ecommerce.categories WHERE name='Beauté & Santé')),
  ('Gel douche FreshEnergy',         4.99, 300,  (SELECT id_categorie FROM ecommerce.categories WHERE name='Beauté & Santé')),
  ('Puzzle 1000 pièces "Montagne"', 12.99,  95,  (SELECT id_categorie FROM ecommerce.categories WHERE name='Jeux & Jouets')),
  ('Jeu de société "Galaxy Quest"', 29.90,  60,  (SELECT id_categorie FROM ecommerce.categories WHERE name='Jeux & Jouets'));


INSERT INTO ecommerce.clients (prenom, nom, email, date_creation) VALUES
  ('Alice',  'Martin',    'alice.martin@mail.com',    '2024-01-10 14:32'),
  ('Bob',    'Dupont',    'bob.dupont@mail.com',      '2024-02-05 09:10'),
  ('Chloé',  'Bernard',   'chloe.bernard@mail.com',   '2024-03-12 17:22'),
  ('David',  'Robert',    'david.robert@mail.com',    '2024-01-29 11:45'),
  ('Emma',   'Leroy',     'emma.leroy@mail.com',      '2024-03-02 08:55'),
  ('Félix',  'Petit',     'felix.petit@mail.com',     '2024-02-18 16:40'),
  ('Hugo',   'Roussel',   'hugo.roussel@mail.com',    '2024-03-20 19:05'),
  ('Inès',   'Moreau',    'ines.moreau@mail.com',     '2024-01-17 10:15'),
  ('Julien', 'Fontaine',  'julien.fontaine@mail.com', '2024-01-23 13:55'),
  ('Katia',  'Garnier',   'katia.garnier@mail.com',   '2024-03-15 12:00');



INSERT INTO ecommerce.commandes (id_clients, date_commande, statut) VALUES
  ((SELECT id_clients FROM ecommerce.clients WHERE email='alice.martin@mail.com'),    '2024-03-01 10:20', 'PAID'),
  ((SELECT id_clients FROM ecommerce.clients WHERE email='bob.dupont@mail.com'),      '2024-03-04 09:12', 'SHIPPED'),
  ((SELECT id_clients FROM ecommerce.clients WHERE email='chloe.bernard@mail.com'),   '2024-03-08 15:02', 'PAID'),
  ((SELECT id_clients FROM ecommerce.clients WHERE email='david.robert@mail.com'),    '2024-03-09 11:45', 'CANCELLED'),
  ((SELECT id_clients FROM ecommerce.clients WHERE email='emma.leroy@mail.com'),      '2024-03-10 08:10', 'PAID'),
  ((SELECT id_clients FROM ecommerce.clients WHERE email='felix.petit@mail.com'),     '2024-03-11 13:50', 'PENDING'),
  ((SELECT id_clients FROM ecommerce.clients WHERE email='hugo.roussel@mail.com'),    '2024-03-15 19:30', 'SHIPPED'),
  ((SELECT id_clients FROM ecommerce.clients WHERE email='ines.moreau@mail.com'),     '2024-03-16 10:00', 'PAID'),
  ((SELECT id_clients FROM ecommerce.clients WHERE email='julien.fontaine@mail.com'), '2024-03-18 14:22', 'PAID'),
  ((SELECT id_clients FROM ecommerce.clients WHERE email='katia.garnier@mail.com'),   '2024-03-20 18:00', 'PENDING');




INSERT INTO ecommerce.detail_commandes (id_commande, id_produit, quantite, prix_unitaire) VALUES
  ((SELECT id_commande FROM ecommerce.commandes c JOIN ecommerce.clients cl ON c.id_clients=cl.id_clients 
      WHERE cl.email='alice.martin@mail.com' AND c.date_commande='2024-03-01 10:20'),
   (SELECT id_produit FROM ecommerce.produits WHERE nom='Casque Bluetooth X1000'), 1, 79.99),
   
  ((SELECT id_commande FROM ecommerce.commandes c JOIN ecommerce.clients cl ON c.id_clients=cl.id_clients 
      WHERE cl.email='alice.martin@mail.com' AND c.date_commande='2024-03-01 10:20'),
   (SELECT id_produit FROM ecommerce.produits WHERE nom='Puzzle 1000 pièces "Montagne"'), 2, 12.99),
   
  ((SELECT id_commande FROM ecommerce.commandes c JOIN ecommerce.clients cl ON c.id_clients=cl.id_clients 
      WHERE cl.email='bob.dupont@mail.com' AND c.date_commande='2024-03-04 09:12'),
   (SELECT id_produit FROM ecommerce.produits WHERE nom='Tapis de Yoga Comfort+'), 1, 19.99),
   
  ((SELECT id_commande FROM ecommerce.commandes c JOIN ecommerce.clients cl ON c.id_clients=cl.id_clients 
      WHERE cl.email='chloe.bernard@mail.com' AND c.date_commande='2024-03-08 15:02'),
   (SELECT id_produit FROM ecommerce.produits WHERE nom='Bouilloire Inox 1.7L'), 1, 29.99),
   
  ((SELECT id_commande FROM ecommerce.commandes c JOIN ecommerce.clients cl ON c.id_clients=cl.id_clients 
      WHERE cl.email='chloe.bernard@mail.com' AND c.date_commande='2024-03-08 15:02'),
   (SELECT id_produit FROM ecommerce.produits WHERE nom='Gel douche FreshEnergy'), 3, 4.99),
   
  ((SELECT id_commande FROM ecommerce.commandes c JOIN ecommerce.clients cl ON c.id_clients=cl.id_clients 
      WHERE cl.email='david.robert@mail.com' AND c.date_commande='2024-03-09 11:45'),
   (SELECT id_produit FROM ecommerce.produits WHERE nom='Haltères 5kg (paire)'), 1, 24.99),
   
  ((SELECT id_commande FROM ecommerce.commandes c JOIN ecommerce.clients cl ON c.id_clients=cl.id_clients 
      WHERE cl.email='emma.leroy@mail.com' AND c.date_commande='2024-03-10 08:10'),
   (SELECT id_produit FROM ecommerce.produits WHERE nom='Crème hydratante BioSkin'), 2, 15.90),
   
  ((SELECT id_commande FROM ecommerce.commandes c JOIN ecommerce.clients cl ON c.id_clients=cl.id_clients 
      WHERE cl.email='julien.fontaine@mail.com' AND c.date_commande='2024-03-18 14:22'),
   (SELECT id_produit FROM ecommerce.produits WHERE nom='Jeu de société "Galaxy Quest"'), 1, 29.90),
   
  ((SELECT id_commande FROM ecommerce.commandes c JOIN ecommerce.clients cl ON c.id_clients=cl.id_clients 
      WHERE cl.email='katia.garnier@mail.com' AND c.date_commande='2024-03-20 18:00'),
   (SELECT id_produit FROM ecommerce.produits WHERE nom='Souris Gamer Pro RGB'), 1, 49.90),
   
  ((SELECT id_commande FROM ecommerce.commandes c JOIN ecommerce.clients cl ON c.id_clients=cl.id_clients 
      WHERE cl.email='katia.garnier@mail.com' AND c.date_commande='2024-03-20 18:00'),
   (SELECT id_produit FROM ecommerce.produits WHERE nom='Gel douche FreshEnergy'), 2, 4.99);
