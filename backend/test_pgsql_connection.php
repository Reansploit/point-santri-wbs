<?php

try {
    $pdo = new PDO("pgsql:host=127.0.0.1;port=5432;dbname=qism_point", "postgres", "rex1");
    echo "PostgreSQL connected successfully!";
} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
}

