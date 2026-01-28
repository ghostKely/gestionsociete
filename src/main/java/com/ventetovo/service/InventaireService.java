package com.ventetovo.service;

import com.ventetovo.entity.Inventaire;
import com.ventetovo.repository.InventaireRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class InventaireService {

    @Autowired
    private InventaireRepository inventaireRepository;

    public Inventaire saveInventaire(Inventaire inventaire) {
        return inventaireRepository.save(inventaire);
    }

    public List<Inventaire> getAllInventaires() {
        return inventaireRepository.findAllByOrderByDateInventaireDesc();
    }

    public List<Inventaire> getInventairesRecents(int limit) {
        return inventaireRepository.findTopNByOrderByDateInventaireDesc(limit);
    }

    public Inventaire getInventaireById(Integer id) {
        return inventaireRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Inventaire non trouvé"));
    }

    public void deleteInventaire(Integer id) {
        inventaireRepository.deleteById(id);
    }
}