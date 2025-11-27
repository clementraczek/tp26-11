description
# tp26-11
bgfbgb

docker file python : 
FROM python:3.11

WORKDIR /app

COPY reporting.py .

RUN pip install psycopg[binary]

CMD ["python", "reporting.py"]

scripy_python : 

import psycopg

DSN = "dbname=tp26_11 user=admin password=admin host=localhost port=5432"


with psycopg.connect(DSN) as conn:
    with conn.cursor() as cur:

        # --- 1. Chiffre d’affaires total ---
        cur.execute("""
            SELECT SUM(quantite * prix_unitaire)
            FROM ecommerce.detail_commandes;
        """)
        ca_total = cur.fetchone()[0]

        # --- 2. Panier moyen ---
        cur.execute("""
            SELECT AVG(t.total_commande)
            FROM (
                SELECT SUM(quantite * prix_unitaire) AS total_commande
                FROM ecommerce.detail_commandes
                GROUP BY id_commande
            ) AS t;
        """)
        panier_moyen = cur.fetchone()[0]

        # --- 3. Article le plus commandé ---
        cur.execute("""
            SELECT p.nom, SUM(oi.quantite) AS total_qte
            FROM ecommerce.produits AS p
            JOIN ecommerce.detail_commandes AS oi
                ON p.id_produit = oi.id_produit
            GROUP BY p.nom
            ORDER BY total_qte DESC
            LIMIT 1;
        """)
        article_top, qte_top = cur.fetchone()

        # --- 4. Top 3 clients par dépense ---
        cur.execute("""
            SELECT c.prenom, c.nom, SUM(oi.quantite * oi.prix_unitaire) AS total
            FROM ecommerce.clients AS c
            JOIN ecommerce.commandes AS o
                ON c.id_clients = o.id_clients
            JOIN ecommerce.detail_commandes AS oi
                ON o.id_commande = oi.id_commande
            GROUP BY c.id_clients, c.prenom, c.nom
            ORDER BY total DESC
            LIMIT 3;
        """)
        top3_clients = cur.fetchall()

        # --- 5. Chiffre d’affaires par catégorie ---
        cur.execute("""
            SELECT cat.name, SUM(oi.quantite * oi.prix_unitaire) AS ca
            FROM ecommerce.categories AS cat
            JOIN ecommerce.produits AS p
                ON cat.id_categorie = p.id_categorie
            JOIN ecommerce.detail_commandes AS oi
                ON p.id_produit = oi.id_produit
            GROUP BY cat.name
            ORDER BY ca DESC;
        """)
        ca_par_categorie = cur.fetchall()

# --- Génération du rapport texte ---
with open("rapport/rapport_supershop.txt", "w", encoding="utf-8") as f:
    f.write("=== Rapport supershop ===\n\n")

    f.write(f"1. Chiffre d’affaires total : {ca_total:.2f} €\n\n")
    f.write(f"2. Panier moyen : {panier_moyen:.2f} €\n\n")
    f.write(f"3. Article le plus commandé : {article_top} ({qte_top} ventes)\n\n")

    f.write("4. Top 3 clients par montant dépensé :\n")
    for prenom, nom, total in top3_clients:
        f.write(f"   - {prenom} {nom} : {total:.2f} €\n")
    f.write("\n")

    f.write("5. Chiffre d’affaires par catégorie :\n")
    for cat, montant in ca_par_categorie:
        f.write(f"   - {cat} : {montant:.2f} €\n")

print("Fichier 'rapport_supershop.txt' généré avec succès.")

docker compose : 
version: "3.9"

services:
  postgres:
    image: postgres:16
    container_name: supershop_db

    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: admin
      POSTGRES_DB: tp26_11
    ports:
      - "5432:5432"
    volumes:
      - ./data:/var/lib/postgresql/data
      - ./creationbase.sql:/docker-entrypoint-initdb.d/01_creationbase.sql
      - ./alimentation.sql:/docker-entrypoint-initdb.d/02_alimentation.sql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U admin -d tp26_11"]
      interval: 5s
      timeout: 3s
      retries: 10

  python-report:
    build: ./app_python
    container_name: report_generator
    depends_on:
      postgres:
        condition: service_healthy
    volumes:
      - ./rapport:/app/rapport
    environment:
      DSN: "dbname=tp26_11 user=admin password=admin host=postgres port=5432"

  adminer:
    image: adminer
    container_name: adminer_supershop
    ports:
      - "8080:8080"
    depends_on:
      - postgres
