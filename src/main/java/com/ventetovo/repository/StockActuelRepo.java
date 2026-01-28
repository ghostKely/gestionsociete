package com.ventetovo.repository;

import com.ventetovo.entity.StockActuel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StockActuelRepo extends JpaRepository<StockActuel, Integer> {

}
