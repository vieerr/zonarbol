CREATE DATABASE IF NOT EXISTS `zonarbol`;
USE `zonarbol`;

-- Tabla de zonas forestales
CREATE TABLE IF NOT EXISTS `forest_zones` (
    `zone_id` INT AUTO_INCREMENT PRIMARY KEY,
    `zone_name` VARCHAR(255) NOT NULL UNIQUE COMMENT 'Nombre único de la zona',
    `province` VARCHAR(255) NOT NULL,
    `canton` VARCHAR(255) NOT NULL,
    `total_area_hectares` DECIMAL(12,2) NOT NULL CHECK (`total_area_hectares` > 0),
    `forest_type` VARCHAR(255) NOT NULL COMMENT 'Clasificación de vegetación',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `state` ENUM('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    INDEX `location_idx` (`province`, `canton`)
) COMMENT='Áreas forestales registradas';

-- Tabla de especies de árboles
CREATE TABLE IF NOT EXISTS `tree_species` (
    `species_id` INT AUTO_INCREMENT PRIMARY KEY,
    `scientific_name` VARCHAR(255) NOT NULL UNIQUE,
    `common_name` VARCHAR(255),
    `family` VARCHAR(100),
    `average_lifespan` INT CHECK (`average_lifespan` > 0),
    `conservation_status` ENUM(
        'Critically Endangered',  
        'Endangered',             
        'Vulnerable',             
        'Near Threatened',       
        'Least Concern',          
        'Data Deficient',        
        'Not Evaluated'          
    ) DEFAULT 'Not Evaluated' COMMENT 'Estado según la Lista Roja de la UICN',
    `first_registered` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) COMMENT='Registro de especies botánicas';

-- Tabla de actividades de conservación
CREATE TABLE IF NOT EXISTS `conservation_activities` (
    `activity_id` INT AUTO_INCREMENT PRIMARY KEY,
    `zone_id` INT NOT NULL,
    `activity_type` VARCHAR(255) NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE COMMENT 'NULL para actividades en curso',
    `description` TEXT NOT NULL,
    `responsible_entity` VARCHAR(255),
    `estimated_budget` DECIMAL(14,2) CHECK (`estimated_budget` >= 0),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `state` ENUM('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    FOREIGN KEY (`zone_id`) 
        REFERENCES `forest_zones`(`zone_id`) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT `valid_dates` CHECK (`end_date` IS NULL OR `end_date` >= `start_date`)
) COMMENT='Seguimiento de iniciativas de conservación';

-- Tabla relación Actividad-Especie
CREATE TABLE IF NOT EXISTS `activity_species` (
    `activity_id` INT NOT NULL,
    `species_id` INT NOT NULL,
    `quantity_affected` INT CHECK (`quantity_affected` > 0),
    PRIMARY KEY (`activity_id`, `species_id`),
    FOREIGN KEY (`activity_id`) 
        REFERENCES `conservation_activities`(`activity_id`) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (`species_id`) 
        REFERENCES `tree_species`(`species_id`) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
) COMMENT='Especies afectadas por actividades';

-- Tabla relación Zona-Especie
CREATE TABLE IF NOT EXISTS `zone_species` (
    `zone_id` INT NOT NULL,
    `species_id` INT NOT NULL,
    `population_estimate` INT CHECK (`population_estimate` > 0),
    PRIMARY KEY (`zone_id`, `species_id`),
    FOREIGN KEY (`zone_id`) 
        REFERENCES `forest_zones`(`zone_id`) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (`species_id`) 
        REFERENCES `tree_species`(`species_id`) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
) COMMENT='Distribución de especies en zonas';

-- Tabla Roles
CREATE TABLE IF NOT EXISTS `roles` (
  `role_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `role_name` VARCHAR(255) NOT NULL
) COMMENT='Registro de roles';

-- Tabla Users
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_name` VARCHAR(255) NOT NULL UNIQUE,
  `user_password` VARCHAR(255) NOT NULL,
  `role_id` INT NOT NULL,
  FOREIGN KEY (`role_id`) 
        REFERENCES `roles`(`role_id`) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
) COMMENT='Registro de usuarios';

-- Inserciones
INSERT INTO forest_zones (zone_name, province, canton, total_area_hectares, forest_type)
VALUES
('Reserva Azuay Norte', 'Azuay', 'Cuenca', 12500.50, 'Bosque Húmedo Montano'),
('Bosque Andino Girón', 'Azuay', 'Girón', 8950.75, 'Bosque Siempreverde'),
('Zona Protegida de Loja', 'Loja', 'Saraguro', 10700.00, 'Bosque Seco Interandino'),
('Reserva El Oro', 'El Oro', 'Zaruma', 6420.30, 'Bosque Nublado'),
('Selva Santa Cruz', 'Galápagos', 'Santa Cruz', 3100.00, 'Bosque Seco Tropical');


INSERT INTO tree_species (scientific_name, common_name, family, average_lifespan, conservation_status)
VALUES
('Cedrela odorata', 'Cedro', 'Meliaceae', 80, 'Vulnerable'),
('Tabebuia chrysantha', 'Guayacán', 'Bignoniaceae', 100, 'Least Concern'),
('Swietenia macrophylla', 'Caoba', 'Meliaceae', 120, 'Endangered'),
('Oreopanax ecuadorensis', 'Cucharillo', 'Araliaceae', 60, 'Near Threatened'),
('Podocarpus oleifolius', 'Romerillo', 'Podocarpaceae', 150, 'Least Concern');


INSERT INTO conservation_activities (zone_id, activity_type, start_date, end_date, description, responsible_entity, estimated_budget)
VALUES
(1, 'Reforestación con especies nativas', '2024-02-01', '2024-08-15', 'Reforestación intensiva con Cedro y Guayacán en áreas degradadas', 'Ministerio del Ambiente', 150000.00),
(2, 'Monitoreo de fauna y flora', '2024-05-10', NULL, 'Seguimiento de biodiversidad como parte del plan de conservación', 'Fundación Andina', 50000.00),
(3, 'Control de especies invasoras', '2023-11-20', '2024-03-10', 'Eliminación de especies invasoras para proteger la Caoba', 'Conservación Internacional', 78000.00),
(4, 'Educación ambiental', '2024-06-01', NULL, 'Capacitaciones a comunidades locales sobre importancia del bosque', 'EcoBosque ONG', 25000.00),
(5, 'Mantenimiento de senderos ecológicos', '2024-01-05', '2024-04-25', 'Renovación de infraestructura ecológica en la zona protegida', 'Gobierno Autónomo', 36000.00);


INSERT INTO activity_species (activity_id, species_id, quantity_affected)
VALUES
(1, 1, 200),
(1, 2, 150),
(2, 4, 50),
(3, 3, 80),
(4, 5, 20),
(5, 2, 30);


INSERT INTO zone_species (zone_id, species_id, population_estimate)
VALUES
(1, 1, 1200),
(1, 2, 950),
(2, 2, 400),
(2, 4, 300),
(3, 3, 500),
(4, 5, 700),
(5, 2, 320),
(5, 5, 150);


INSERT INTO roles (role_id, role_name) VALUES
(1, 'Administrador'),
(2, 'Observador');
(3, 'Editor');
(4, 'Depurador');
(5, 'Grabador');


INSERT INTO users (user_id, user_name, user_password, role_id) VALUES
(1, 'admin', 'nnEor72DtqzSXIrvqLqnIg==', 1),
(2, 'observador', 'BmQdkniS9/KFj8FHon79oA==', 2);
(3, 'editor', 'BmQdkniS9/KFj8FHon79oA==', 3);
(4, 'depurador', 'BmQdkniS9/KFj8FHon79oA==', 4);
(5, 'grabador', 'BmQdkniS9/KFj8FHon79oA==', 5);