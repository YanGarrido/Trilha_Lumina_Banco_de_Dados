DROP DATABASE Lumina_Games;

-- Criação do banco de dados / explicar o IF NOT EXISTS depois
CREATE DATABASE IF NOT EXISTS Lumina_Games;

-- Explicar o por que temos que utilizar o USE
USE Lumina_Games;

-- Criação da primeira tabela explicando cada atributo
CREATE TABLE IF NOT EXISTS users(
-- Explicar o unsigned e auto_increment / como é a definição da nossa PRIMARY KEY
id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
-- explicar o número dentro do parentesis / tamanho do nosso texto 
name VARCHAR(120) NOT NULL,
-- explicar o unique -> os valores nesse campo nao podem ser repetidos / tem que ter apenas um
email VARCHAR(160) NOT NULL UNIQUE,
password VARCHAR(255) NOT NULL,
-- Explicar essa parte
create_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS categories(
id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(120) NOT NULL,
description VARCHAR(255),
create_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS 	games(
id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
title VARCHAR(150) NOT NULL,
description TEXT,
release_date DATE,
age_rating VARCHAR(10),
-- tipo de dados diferente
price DECIMAL(10,2),
-- ALTER TABLE PARA REMOVER O STOCK
stock INT DEFAULT 0,
cover_url VARCHAR(300),
create_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
-- Explicar essa parte
FULLTEXT KEY ft_games_title_desc (title, description)
);

CREATE TABLE IF NOT EXISTS game_categories(
game_id INT UNSIGNED NOT NULL,
category_id INT UNSIGNED NOT NULL,
PRIMARY KEY (game_id, category_id),
CONSTRAINT fk_gc_game FOREIGN KEY(game_id) REFERENCES games(id) ON DELETE CASCADE,
CONSTRAINT fk_gc_cat  FOREIGN KEY(category_id) REFERENCES categories(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS platforms(
id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS game_platforms(
game_id INT UNSIGNED NOT NULL,
platform_id INT UNSIGNED NOT NULL,
PRIMARY KEY (game_id, platform_id),
CONSTRAINT fk_gp_game FOREIGN KEY(game_id) REFERENCES games(id) ON DELETE CASCADE,
CONSTRAINT fk_gp_platform FOREIGN KEY(platform_id) REFERENCES platforms(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ratings(
id INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
user_id INT UNSIGNED NOT NULL,
game_id INT UNSIGNED NOT NULL,
score TINYINT UNSIGNED NOT NULL CHECK (score BETWEEN 1 AND 5),
comment TEXT,
create_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_r_user FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
CONSTRAINT fk_r_game FOREIGN KEY(game_id) REFERENCES games(id) ON DELETE CASCADE
);

CREATE TABLE developers(
  id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(120) NOT NULL
);

CREATE TABLE publishers(
  id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE game_developers(
  game_id INT UNSIGNED NOT NULL,
  developer_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (game_id, developer_id),
  CONSTRAINT fk_gd_game FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
  CONSTRAINT fk_gd_dev  FOREIGN KEY (developer_id) REFERENCES developers(id) ON DELETE CASCADE
);

CREATE TABLE game_publishers(
  game_id INT UNSIGNED NOT NULL,
  publisher_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (game_id, publisher_id),
  CONSTRAINT fk_gpbl_game FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
  CONSTRAINT fk_gpbl_pub  FOREIGN KEY (publisher_id) REFERENCES publishers(id) ON DELETE CASCADE
);