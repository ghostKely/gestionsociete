CREATE DATABASE vente_tovo;
\c vente_tovo;

CREATE TABLE role (
    id_role SERIAL PRIMARY KEY,
    nom_role VARCHAR(50) UNIQUE NOT NULL,
    niveau_validation INT DEFAULT 0 -- 0=operateur, 1=valideur N1, 2=valideur N2
);

-- Roles
INSERT INTO role (nom_role, niveau_validation) VALUES
('Admin', 2),
('Responsable Achats', 2),
('Acheteur', 1),
('Magasinier', 0),
('Commercial', 1),
('Responsable Ventes', 2);


CREATE TABLE utilisateur (
    id_utilisateur SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    id_role INT NOT NULL,
    actif BOOLEAN DEFAULT TRUE,
    
    CONSTRAINT fk_utilisateur_role FOREIGN KEY (id_role) REFERENCES role(id_role)
);

-- Utilisateurs
INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, id_role) VALUES
('ADMIN', 'Admin', 'admin@vente-tovo.mg', 'admin123', 1),
('RAKOTO', 'Jean', 'jean@vente-tovo.mg', 'pass123', 2),
('RABE', 'Marie', 'marie@vente-tovo.mg', 'pass123', 3),
('RANDRIA', 'Paul', 'paul@vente-tovo.mg', 'pass123', 4),
('RASOA', 'Sophie', 'sophie@vente-tovo.mg', 'pass123', 5)
('DODA', 'Jean', 'magasinier@vente.com', 'pass123', 4);

CREATE TABLE fournisseur (
    id_fournisseur SERIAL PRIMARY KEY,
    nom VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    telephone VARCHAR(20)
);

CREATE TABLE article (
    id_article SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    designation VARCHAR(200) NOT NULL
);

INSERT INTO article (code, designation)
VALUES
('ART-001', 'Ordinateur Portable Dell Latitude'),
('ART-002', 'Souris Optique USB Logitech');

CREATE TABLE prix (
    id_prix SERIAL PRIMARY KEY,
    id_article INT NOT NULL,
    id_fournisseur INT NOT NULL,
    type VARCHAR(10) NOT NULL,
    montant NUMERIC(15,2) NOT NULL,
    date_prix DATE NOT NULL,
    
    FOREIGN KEY (id_article) REFERENCES article(id_article),
    FOREIGN KEY (id_fournisseur) REFERENCES fournisseur(id_fournisseur)
);

-- Table achat_finance 
CREATE TABLE achat_finance (
    id_achat_finance SERIAL PRIMARY KEY,
    montant_seuil NUMERIC(15,2) NOT NULL DEFAULT 1000000.00,
    description VARCHAR(255),
    actif BOOLEAN DEFAULT TRUE,
    date_maj TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
    -- Données initiales
    INSERT INTO achat_finance (montant_seuil, description, actif) 
    VALUES (1000000.00, 'Seuil de validation par défaut - Montant au-dessus duquel une validation financière est requise', true);

-- Table pour les proformas
CREATE TABLE proforma (
    id_proforma SERIAL PRIMARY KEY,
    numero VARCHAR(50) UNIQUE NOT NULL,
    token_demande VARCHAR(64) NOT NULL, -- Token unique pour regrouper les proformas d'une même demande
    id_article INT NOT NULL,
    id_fournisseur INT NOT NULL,
    quantite INT NOT NULL,
    prix_unitaire NUMERIC(15,2) NOT NULL,
    montant_total NUMERIC(15,2) NOT NULL,
    date_proforma TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut VARCHAR(20) DEFAULT 'EN_ATTENTE' CHECK (statut IN ('EN_ATTENTE', 'SELECTIONNE', 'REJETE')),
    
    FOREIGN KEY (id_article) REFERENCES article(id_article),
    FOREIGN KEY (id_fournisseur) REFERENCES fournisseur(id_fournisseur)
);

-- Index pour optimiser les requêtes
CREATE INDEX idx_proforma_token ON proforma(token_demande);
CREATE INDEX idx_proforma_article ON proforma(id_article);
CREATE INDEX idx_proforma_fournisseur ON proforma(id_fournisseur);

-- table bon de commande
CREATE TABLE bon_commande (
    id_bon_commande SERIAL PRIMARY KEY,
    id_proforma INT NOT NULL,
    date_commande TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut VARCHAR(20) DEFAULT 'EN_COURS' CHECK (statut IN ('EN_COURS', 'LIVRE', 'ANNULE')),
    
    FOREIGN KEY (id_proforma) REFERENCES proforma(id_proforma)
);


-- Table Facture Fournisseur
CREATE TABLE facture_fournisseur (
    id_facture SERIAL PRIMARY KEY,
    numero_facture VARCHAR(50) UNIQUE NOT NULL,
    id_bon_commande INT NOT NULL,
    montant_total NUMERIC(15,2) NOT NULL,
    date_facture DATE NOT NULL,
    date_echeance DATE,
    statut VARCHAR(20) DEFAULT 'EN_ATTENTE' CHECK (statut IN ('EN_ATTENTE', 'REGLEE', 'EN_RETARD', 'ANNULEE')),
    
    FOREIGN KEY (id_bon_commande) REFERENCES bon_commande(id_bon_commande)
);

-- Table Bon de Livraison
CREATE TABLE bon_livraison (
    id_bon_livraison SERIAL PRIMARY KEY,
    numero_livraison VARCHAR(50) UNIQUE NOT NULL,
    id_bon_commande INT NOT NULL,
    date_livraison DATE NOT NULL,
    transporteur VARCHAR(100),
    numero_bon_transport VARCHAR(50),
    statut VARCHAR(20) DEFAULT 'EN_ATTENTE' CHECK (statut IN ('EN_ATTENTE', 'RECU', 'PARTIEL', 'ANNULE')),
    
    FOREIGN KEY (id_bon_commande) REFERENCES bon_commande(id_bon_commande)
);

-- Table Bon de Réception (lignes de livraison)
CREATE TABLE bon_reception (
    id_bon_reception SERIAL PRIMARY KEY,
    id_bon_livraison INT NOT NULL,
    id_article INT NOT NULL,
    quantite_commandee INT NOT NULL,
    quantite_recue INT NOT NULL,
    quantite_non_conforme INT DEFAULT 0,
    commentaire TEXT,
    date_reception TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_receptionnaire INT,
    
    FOREIGN KEY (id_bon_livraison) REFERENCES bon_livraison(id_bon_livraison) ON DELETE CASCADE,
    FOREIGN KEY (id_article) REFERENCES article(id_article),
    FOREIGN KEY (id_receptionnaire) REFERENCES utilisateur(id_utilisateur)
);

CREATE OR REPLACE VIEW v_utilisateur_role AS
SELECT 
    u.id_utilisateur,
    u.nom,
    u.prenom,
    u.email,
    u.mot_de_passe,
    u.actif,
    r.id_role,
    r.nom_role,
    r.niveau_validation
FROM utilisateur u
JOIN role r ON r.id_role = u.id_role;

-- FIN MODULE ACHAT

CREATE TABLE site (
    id_site SERIAL PRIMARY KEY,
    code_site VARCHAR(20) UNIQUE NOT NULL,
    nom_site VARCHAR(100) NOT NULL,
    adresse TEXT,
    entite_legale VARCHAR(150)
);

INSERT INTO site (code_site, nom_site, adresse, entite_legale)
VALUES ('SITE-ANT-001', 'Site Antananarivo Central', 'Antananarivo', 'ABC Madagascar');

CREATE TABLE depot (
    id_depot SERIAL PRIMARY KEY,
    code_depot VARCHAR(20) UNIQUE NOT NULL,
    nom_depot VARCHAR(100) NOT NULL,
    id_site INT REFERENCES site(id_site),
    adresse TEXT,
    responsable_id INT REFERENCES utilisateur(id_utilisateur)
);



CREATE TABLE bon_receptionstock (
    id_bon_reception SERIAL PRIMARY KEY,
    id_bon_livraison INT NOT NULL,
    id_article INT NOT NULL,
    quantite_commandee INT NOT NULL,
    quantite_recue INT NOT NULL,
    quantite_non_conforme INT DEFAULT 0,
    commentaire TEXT,
    date_reception TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_receptionnaire INT,
    id_depot INT NOT NULL,
    
    FOREIGN KEY (id_bon_livraison) REFERENCES bon_livraison(id_bon_livraison) ON DELETE CASCADE,
    FOREIGN KEY (id_article) REFERENCES article(id_article),
    FOREIGN KEY (id_receptionnaire) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY(id_depot) REFERENCES depot(id_depot)
);

CREATE TABLE methode_calcul_stock (
    id_methode SERIAL PRIMARY KEY,
    nom_methode VARCHAR(50) UNIQUE NOT NULL -- e.g., FIFO, LIFO, CMUP
);

INSERT INTO methode_calcul_stock (nom_methode)
VALUES ('LIFO');

INSERT INTO methode_calcul_stock (nom_methode)
VALUES ('CMUP');

INSERT INTO methode_calcul_stock (nom_methode)
VALUES ('FIFO');

CREATE TABLE methode_article(
    id_methode_article SERIAL PRIMARY KEY,
    id_article INT NOT NULL,
    id_methode INT NOT NULL,
    FOREIGN KEY (id_article) REFERENCES article(id_article),
    FOREIGN KEY (id_methode) REFERENCES methode_calcul_stock(id_methode)
);


CREATE OR REPLACE FUNCTION trg_set_article_methode()
RETURNS TRIGGER AS $$
BEGIN
    SELECT ma.id_methode_article
    INTO NEW.id_methode_article
    FROM methode_article ma
    WHERE ma.id_article = NEW.id_article;

    IF NEW.id_methode_article IS NULL THEN
        RAISE EXCEPTION
            'No stock calculation method defined for article id %',
            NEW.id_article;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE mouvement_stock(
    stock_id SERIAL PRIMARY KEY,
    id_article INT NOT NULL, 
    quantite_stock NUMERIC(15,3) NOT NULL,
    id_methode_article INT NOT NULL,
    prix_article NUMERIC(15,3) NOT NULL,
    id_depot INT NOT NULL,
    date_entree_stock TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    mouvement_type VARCHAR(20) NOT NULL DEFAULT 'ENTREE', -- e.g., ENTREE, SORTIE
    FOREIGN KEY (id_article) REFERENCES article(id_article),
    FOREIGN KEY (id_depot) REFERENCES depot(id_depot),
    FOREIGN KEY (id_methode_article) REFERENCES methode_article(id_methode_article)
);


CREATE TRIGGER before_insert_mouvement_stock
BEFORE INSERT ON mouvement_stock
FOR EACH ROW
EXECUTE FUNCTION trg_set_article_methode();

-- Trigger d'insertion dans le stock lors de la réception d'un bon de réception

CREATE OR REPLACE FUNCTION trg_insert_stock_after_reception()
RETURNS TRIGGER AS $$
DECLARE
    v_id_methode_article INT;
    v_prix_article NUMERIC(15,3);
BEGIN
    SELECT ma.id_methode_article
    INTO v_id_methode_article
    FROM methode_article ma
    WHERE ma.id_article = NEW.id_article;

    IF v_id_methode_article IS NULL THEN
        RAISE EXCEPTION
            'No stock calculation method defined for article id %',
            NEW.id_article;
    END IF;

    SELECT p.montant
    INTO v_prix_article
    FROM prix p
    WHERE p.id_article = NEW.id_article
      AND p.type = 'ACHAT'
    ORDER BY p.date_prix DESC
    LIMIT 1;

    IF v_prix_article IS NULL THEN
        RAISE EXCEPTION
            'No purchase price found for article id %',
            NEW.id_article;
    END IF;

    INSERT INTO mouvement_stock (
        id_article,
        quantite_stock,
        id_methode_article,
        prix_article,
        id_depot,
        date_entree_stock,
        mouvement_type
    )
    VALUES (
        NEW.id_article,
        NEW.quantite_recue,
        v_id_methode_article,
        v_prix_article,
        NEW.id_depot,
        CURRENT_TIMESTAMP,
        'ENTREE'
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_insert_bon_reception
AFTER INSERT ON bon_receptionstock
FOR EACH ROW
EXECUTE FUNCTION trg_insert_stock_after_reception();

CREATE TABLE lot_stock (
    id_lot SERIAL PRIMARY KEY,
    id_article INT NOT NULL,
    id_depot INT NOT NULL,
    quantite_restante NUMERIC(15,3) NOT NULL,
    prix_unitaire NUMERIC(15,3) NOT NULL,
    date_entree TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_article) REFERENCES article(id_article),
    FOREIGN KEY (id_depot) REFERENCES depot(id_depot)
);

CREATE TABLE mouvement_stock_calcul (
    id SERIAL PRIMARY KEY,
    id_depot INT NOT NULL,
    id_methode_article INT NOT NULL,
    id_article INT NOT NULL,
    quantite_article NUMERIC(15,3) NOT NULL,
    prix_total NUMERIC(15,3) NOT NULL,
    prix_par_methode NUMERIC(15,3) NOT NULL,
    date_mouvement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_depot) REFERENCES depot(id_depot),
    FOREIGN KEY (id_methode_article) REFERENCES methode_article(id_methode_article),
    FOREIGN KEY (id_article) REFERENCES article(id_article)
);

CREATE OR REPLACE FUNCTION fn_mouvement_stock()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    last_qty NUMERIC(15,3) := 0;
    last_total NUMERIC(15,3) := 0;
    last_pu NUMERIC(15,3) := 0;

    new_qty NUMERIC(15,3);
    new_total NUMERIC(15,3);
    new_pu NUMERIC(15,3);

    methode_nom TEXT;
    remaining_qty NUMERIC(15,3);
    lot RECORD;
BEGIN
    -- Méthode
    SELECT mcs.nom_methode
    INTO methode_nom
    FROM methode_article ma
    JOIN methode_calcul_stock mcs ON mcs.id_methode = ma.id_methode
    WHERE ma.id_methode_article = NEW.id_methode_article;

    -- Dernier état du stock
    SELECT quantite_article, prix_total, prix_par_methode
    INTO last_qty, last_total, last_pu
    FROM mouvement_stock_calcul
    WHERE id_article = NEW.id_article
      AND id_depot = NEW.id_depot
    ORDER BY id DESC
    LIMIT 1;

    IF NOT FOUND THEN
        last_qty := 0;
        last_total := 0;
        last_pu := 0;
    END IF;

    ------------------------------------------------------------------
    -- ENTREE
    ------------------------------------------------------------------
    IF NEW.mouvement_type = 'ENTREE' THEN
        new_qty := last_qty + NEW.quantite_stock;

        IF methode_nom = 'CMUP' THEN
            new_total := last_total + (NEW.quantite_stock * NEW.prix_article);
            new_pu := new_total / new_qty;
        ELSE
            -- FIFO / LIFO
            new_total := last_total + (NEW.quantite_stock * NEW.prix_article);
            new_pu := new_total / new_qty; -- only for valuation display
            INSERT INTO lot_stock(id_article, id_depot, quantite_restante, prix_unitaire)
            VALUES (NEW.id_article, NEW.id_depot, NEW.quantite_stock, NEW.prix_article);
        END IF;

    ------------------------------------------------------------------
    -- SORTIE
    ------------------------------------------------------------------
    ELSE
        IF last_qty < NEW.quantite_stock THEN
            RAISE EXCEPTION 'Stock insuffisant';
        END IF;

        new_qty := last_qty - NEW.quantite_stock;

        IF methode_nom = 'CMUP' THEN
            new_total := last_total - (NEW.quantite_stock * last_pu);
            new_pu := CASE WHEN new_qty = 0 THEN 0 ELSE new_total / new_qty END;

        ELSE
            remaining_qty := NEW.quantite_stock;
            new_total := last_total;

            FOR lot IN
                SELECT * FROM lot_stock
                WHERE id_article = NEW.id_article AND id_depot = NEW.id_depot
                ORDER BY date_entree
            LOOP
                EXIT WHEN remaining_qty <= 0;

                IF lot.quantite_restante <= remaining_qty THEN
                    remaining_qty := remaining_qty - lot.quantite_restante;
                    new_total := new_total - (lot.quantite_restante * lot.prix_unitaire);
                    DELETE FROM lot_stock WHERE id_lot = lot.id_lot;
                ELSE
                    UPDATE lot_stock
                    SET quantite_restante = quantite_restante - remaining_qty
                    WHERE id_lot = lot.id_lot;

                    new_total := new_total - (remaining_qty * lot.prix_unitaire);
                    remaining_qty := 0;
                END IF;
            END LOOP;

            new_pu := CASE WHEN new_qty = 0 THEN 0 ELSE new_total / new_qty END;
        END IF;
    END IF;

    ------------------------------------------------------------------
    -- INSERT SNAPSHOT
    ------------------------------------------------------------------
    INSERT INTO mouvement_stock_calcul(
        id_depot,
        id_methode_article,
        id_article,
        quantite_article,
        prix_total,
        prix_par_methode
    ) VALUES (
        NEW.id_depot,
        NEW.id_methode_article,
        NEW.id_article,
        new_qty,
        new_total,
        new_pu
    );

    RETURN NEW;
END;
$$;

-- Trigger sur mouvement_stock
CREATE TRIGGER trg_mouvement_stock
AFTER INSERT ON mouvement_stock
FOR EACH ROW
EXECUTE FUNCTION fn_mouvement_stock();

CREATE OR REPLACE VIEW vue_stock_actuel AS

/* =========================================================
   CMUP ARTICLES → last snapshot from mouvement_stock_calcul
   ========================================================= */
SELECT
    msc.id,
    msc.id_depot,
    msc.id_methode_article,
    msc.id_article,
    msc.quantite_article,
    msc.prix_total,
    msc.prix_par_methode,
    msc.date_mouvement
FROM mouvement_stock_calcul msc
JOIN (
    SELECT
        id_article,
        id_depot,
        MAX(id) AS max_id
    FROM mouvement_stock_calcul
    GROUP BY id_article, id_depot
) last_msc
    ON msc.id = last_msc.max_id
JOIN methode_article ma
    ON ma.id_methode_article = msc.id_methode_article
JOIN methode_calcul_stock mcs
    ON mcs.id_methode = ma.id_methode
WHERE mcs.nom_methode = 'CMUP'

UNION ALL

/* =========================================================
   FIFO / LIFO ARTICLES → one row per lot (NO aggregation)
   ========================================================= */
SELECT
    ls.id_lot AS id,
    ls.id_depot,
    ma.id_methode_article,
    ls.id_article,
    ls.quantite_restante AS quantite_article,
    (ls.quantite_restante * ls.prix_unitaire)::NUMERIC(15,3) AS prix_total,
    ls.prix_unitaire AS prix_par_methode,
    ls.date_entree AS date_mouvement
FROM lot_stock ls
JOIN methode_article ma
    ON ma.id_article = ls.id_article
JOIN methode_calcul_stock mcs
    ON mcs.id_methode = ma.id_methode
WHERE mcs.nom_methode IN ('FIFO', 'LIFO');

-- 1. Créer une fonction qui sera appelée par le trigger
CREATE OR REPLACE FUNCTION sync_bon_reception_to_stock()
RETURNS TRIGGER AS $$
DECLARE
    depot_central_id INTEGER;
BEGIN
    -- Récupérer l'ID du dépôt central (celui avec code_depot = 'DEP-ANT-01')
    SELECT id_depot INTO depot_central_id 
    FROM depot 
    WHERE code_depot = 'DEP-ANT-01';
    
    -- Insérer la même ligne dans bon_receptionstock avec l'ID du dépôt central
    INSERT INTO bon_receptionstock (
        id_bon_livraison,
        id_article,
        quantite_commandee,
        quantite_recue,
        quantite_non_conforme,
        commentaire,
        date_reception,
        id_receptionnaire,
        id_depot
    ) VALUES (
        NEW.id_bon_livraison,
        NEW.id_article,
        NEW.quantite_commandee,
        NEW.quantite_recue,
        NEW.quantite_non_conforme,
        NEW.commentaire,
        NEW.date_reception,
        NEW.id_receptionnaire,
        depot_central_id
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Créer le trigger qui s'exécute après chaque INSERT sur bon_reception
CREATE TRIGGER trg_sync_bon_reception_to_stock
AFTER INSERT ON bon_reception
FOR EACH ROW
EXECUTE FUNCTION sync_bon_reception_to_stock();


-- Table pour gérer les transferts entre dépôts
CREATE TABLE transfert_depot (
    id_transfert SERIAL PRIMARY KEY,
    numero_transfert VARCHAR(50) UNIQUE NOT NULL,
    id_article INT NOT NULL,
    id_depot_source INT NOT NULL,
    id_depot_destination INT NOT NULL,
    quantite INT NOT NULL CHECK (quantite > 0),
    commentaire TEXT,
    id_utilisateur INT NOT NULL,
    date_transfert TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut VARCHAR(20) DEFAULT 'EN_COURS' CHECK (statut IN ('EN_COURS', 'TERMINE', 'ANNULE')),
    
    FOREIGN KEY (id_article) REFERENCES article(id_article),
    FOREIGN KEY (id_depot_source) REFERENCES depot(id_depot),
    FOREIGN KEY (id_depot_destination) REFERENCES depot(id_depot),
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id_utilisateur),

    CONSTRAINT check_depots_differents CHECK (id_depot_source != id_depot_destination)
);
-- Ajouter une colonne référence dans mouvement_stock
ALTER TABLE mouvement_stock 
ADD COLUMN reference VARCHAR(100);

