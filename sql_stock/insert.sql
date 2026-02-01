-- 3. Insertion des fournisseurs
INSERT INTO fournisseur (nom, email, telephone) VALUES
('Grossiste A', 'contact@grossiste-a.mg', '020 12 345 67'),
('Grossiste B', 'info@grossiste-b.mg', '020 23 456 78'),
('Grossiste C', 'vente@grossiste-c.mg', '020 34 567 89');

-- 5. Insertion des prix pour chaque article et chaque fournisseur (type ACHAT)
-- Pour l'article 1 (Riz) - Prix d'achat
INSERT INTO prix (id_article, id_fournisseur, type, montant, date_prix) VALUES
(1, 1, 'ACHAT', 500, '2026-01-12'),  -- Grossiste A
(1, 2, 'ACHAT', 700, '2026-01-12'),  -- Grossiste B
(1, 3, 'ACHAT', 400, '2026-01-12');  -- Grossiste C

-- Pour l'article 2 (Sucre) - Prix d'achat
INSERT INTO prix (id_article, id_fournisseur, type, montant, date_prix) VALUES
(2, 1, 'ACHAT', 800, '2026-01-12'),  -- Grossiste A
(2, 2, 'ACHAT', 750, '2026-01-12'),  -- Grossiste B
(2, 3, 'ACHAT', 780, '2026-01-12');  -- Grossiste C

INSERT INTO prix (id_article, id_fournisseur, type, montant, date_prix) VALUES
(1, 1, 'VENTE', 1500, '2026-01-12'),  -- Grossiste A
(1, 2, 'VENTE', 2700, '2026-01-12'),  -- Grossiste B
(1, 3, 'VENTE', 4400, '2026-01-12');  -- Grossiste C

-- Pour l'article 2 (Sucre) - Prix de vente
INSERT INTO prix (id_article, id_fournisseur, type, montant, date_prix) VALUES
(2, 1, 'VENTE', 1200, '2026-01-12'),  -- Grossiste A
(2, 2, 'VENTE', 1500, '2026-01-12'),  -- Grossiste B
(2, 3, 'VENTE', 1800, '2026-01-12');  -- Grossiste C

UPDATE role SET nom_role = 'COMMERCIAL' WHERE id_role = 5;
UPDATE role SET nom_role = 'MAGASINIER' WHERE id_role = 4;
UPDATE role SET nom_role = 'ADMIN' WHERE id_role = 1;

INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, id_role) 
SELECT 'Rakoto', 'Jean', 'jean.rakoto@company.mg', 'jean', r.id_role
FROM role r WHERE r.nom_role = 'OPERATEUR';

INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, id_role)
SELECT 'Rasoa', 'Marie', 'marie.rasoa@company.mg', 'marie', r.id_role
FROM role r WHERE r.nom_role = 'SUPERVISEUR';

INSERT INTO depot (code_depot, nom_depot, id_site, adresse, responsable_id)
SELECT
    'DEP-ANT-01',
    'Dépôt Central Antananarivo',
    s.id_site,
    'Zone industrielle Antananarivo',
    u.id_utilisateur
FROM site s
JOIN utilisateur u ON u.email = 'magasinier@vente.com'
WHERE s.code_site = 'SITE-ANT-001';

INSERT INTO methode_article (id_article, id_methode)
VALUES (1, 2);

INSERT INTO methode_article (id_article, id_methode)
VALUES (2, 2);

--------------------------------------------------
INSERT INTO client (code_client, nom)
VALUES
('CLI-001', 'Client Test');

-- Insertion du Dépôt Central Antananarivo (existant dans votre script)
INSERT INTO depot (code_depot, nom_depot, id_site, adresse, responsable_id)
SELECT
    'DEP-ANT-02',
    'Dépôt Tanjombato',
    s.id_site,
    'Zone industrielle Antananarivo, Lot IVD 67',
    u.id_utilisateur
FROM site s
JOIN utilisateur u ON u.email = 'marie.rasoa@company.mg'
WHERE s.code_site = 'SITE-ANT-001';
