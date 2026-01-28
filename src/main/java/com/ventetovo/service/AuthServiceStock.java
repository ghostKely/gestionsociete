package com.ventetovo.service;

import org.springframework.stereotype.Service;

import com.ventetovo.entity.Utilisateur;
import com.ventetovo.repository.UtilisateurRepo;

@Service
public class AuthServiceStock {

    private final UtilisateurRepo utilisateurRepository;

    public AuthServiceStock(UtilisateurRepo utilisateurRepository) {
        this.utilisateurRepository = utilisateurRepository;
    }

    public Utilisateur login(String username, String password) {

        // username = email
        return utilisateurRepository
                .findActiveUserWithRole(username, password)
                .orElse(null);
    }

}
