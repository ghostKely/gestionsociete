package com.ventetovo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ventetovo.entity.MethodeCalculStock;

@Repository
public interface MethodeCalculStockRepository extends JpaRepository<MethodeCalculStock, Integer> {
    
}


