package com.ventetovo.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "inventaire")
public class Inventaire {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_inventaire")
    private Integer idInventaire;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_inventaire")
    private Date dateInventaire;

    @Column(name = "id_article", nullable = false)
    private Integer idArticle;

    @Column(name = "nbre_article", nullable = false)
    private Integer nbreArticle;

    @Column(name = "commentaire", length = 500)
    private String commentaire;

    @Column(name = "id_utilisateur", nullable = false)
    private Integer idUtilisateur;

    // Relations optionnelles pour affichage
    @Transient // Ne pas persister, juste pour l'affichage
    private Article article;

    @Transient // Ne pas persister, juste pour l'affichage
    private Utilisateur utilisateur;

    // Constructeurs
    public Inventaire() {
        this.dateInventaire = new Date();
    }

    public Inventaire(Integer idArticle, Integer nbreArticle, Integer idUtilisateur) {
        this();
        this.idArticle = idArticle;
        this.nbreArticle = nbreArticle;
        this.idUtilisateur = idUtilisateur;
    }

    // Getters et Setters
    public Integer getIdInventaire() {
        return idInventaire;
    }

    public void setIdInventaire(Integer idInventaire) {
        this.idInventaire = idInventaire;
    }

    public Date getDateInventaire() {
        return dateInventaire;
    }

    public void setDateInventaire(Date dateInventaire) {
        this.dateInventaire = dateInventaire;
    }

    public Integer getIdArticle() {
        return idArticle;
    }

    public void setIdArticle(Integer idArticle) {
        this.idArticle = idArticle;
    }

    public Integer getNbreArticle() {
        return nbreArticle;
    }

    public void setNbreArticle(Integer nbreArticle) {
        this.nbreArticle = nbreArticle;
    }

    public String getCommentaire() {
        return commentaire;
    }

    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }

    public Integer getIdUtilisateur() {
        return idUtilisateur;
    }

    public void setIdUtilisateur(Integer idUtilisateur) {
        this.idUtilisateur = idUtilisateur;
    }

    public Article getArticle() {
        return article;
    }

    public void setArticle(Article article) {
        this.article = article;
    }

    public Utilisateur getUtilisateur() {
        return utilisateur;
    }

    public void setUtilisateur(Utilisateur utilisateur) {
        this.utilisateur = utilisateur;
    }
}