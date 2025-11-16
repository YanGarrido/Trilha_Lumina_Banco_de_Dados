USE lumina_games;

ALTER TABLE games DROP COLUMN stock;
-- ADD COLUMN / ALTER COLUMN

-- Inserts iniciais para a aula
-- 1. inserindo categorias
INSERT INTO categories (name, description) VALUES
('Ação', 'Jogos de ação'),
('RPG', 'Jogos de interpretação de papéis'),
('Esportes', 'Jogos de esportes');

-- 2. Inserindo um jogo
INSERT INTO games (title, description, release_date, age_rating, price, stock)
VALUES ( 'The Witcher 3: Wild Hunt', 'RPG em mundo aberto com Geralt de Rivia.', '2015-05-19', '18+', 99.90, 10);

-- 3. Atualizando um registro
UPDATE games
SET price = 79.90
WHERE title = 'The Witcher 3: Wild Hunt';

-- 4. Removendo um registro
DELETE FROM games
WHERE title = 'The Witcher 3: Wild Hunt';

-- SELECT BASICO
-- 1. Buscar todos os jogos
SELECT * FROM games;

-- 2. Buscar apenas algumas colunas
SELECT title, price FROM games;

-- 3. Filtros com WHERE:
SELECT title, price
FROM games
WHERE price > 100.00;

-- 4. Usando BETWEEN
SELECT title, price
FROM games
WHERE price BETWEEN 50 AND 100;

-- 5. Verificando NULL
SELECT title
FROM games
WHERE release_date IS NULL;

-- 6. Ordenando resultados
SELECT title, price
FROM games
ORDER BY price DESC;

-- 7. Limitando quantidade:
SELECT title, price
FROM games
ORDER BY price ASC
LIMIT 5;

-- 8. Busca por padrão com LIKE:
SELECT id, title
FROM games
WHERE title LIKE '%RED%';

-- JOINS e AGREGAÇÕES
-- JOINS
-- 1. Avaliações + jogos:
SELECT 
    	g.title,
    	r.score,
    	r.comment,
    	r.create_at
-- Renomeação de campos
FROM ratings r
JOIN games g ON g.id = r.game_id;

-- 2.Avaliações + jogos + usuários:
SELECT 
     u.name  AS usuario,
     g.title AS jogo,
     r.score AS nota,
     r.comment AS comentario
FROM ratings r
JOIN users u ON u.id = r.user_id
JOIN games g ON g.id = r.game_id
ORDER BY r.create_at DESC;

-- 3.Jogos + categorias (N:N):
SELECT 
    	g.title,
    	c.name AS categoria
FROM games g
JOIN game_categories gc ON gc.game_id = g.id
JOIN categories c       ON c.id = gc.category_id
ORDER BY g.title, c.name;
-- INNER JOIN -> retorna apenas os jogos que possuem categorias
SELECT 
    g.title AS jogo,
    c.name AS categoria
FROM games g
INNER JOIN game_categories gc ON gc.game_id = g.id
INNER JOIN categories c       ON c.id = gc.category_id;

-- LEFT / RIGHT JOIN -> todos os registros da tabela da esquerda/direita , mesmo que não exista correspondência na tabela da direita/esquerda.
SELECT 
    g.title AS jogo,
    c.name AS categoria
FROM games g
LEFT JOIN game_categories gc ON gc.game_id = g.id
LEFT JOIN categories c       ON c.id = gc.category_id;


-- Agregações
-- 1. Contar registros:
SELECT COUNT(*) AS total_jogos
FROM games;

-- 2.Média de notas por jogo:
SELECT 
     g.id,
     g.title,
     AVG(r.score) AS media_nota,
     COUNT(r.id)  AS qtd_avaliacoes
    	FROM games g
JOIN ratings r ON r.game_id = g.id
GROUP BY g.id, g.title
ORDER BY media_nota DESC;

-- 3. HAVING para filtrar grupos:
SELECT 
    	g.id,
    	g.title,
    	AVG(r.score) AS media_nota,
    	COUNT(r.id)  AS qtd_avaliacoes
FROM games g
JOIN ratings r ON r.game_id = g.id
GROUP BY g.id, g.title
HAVING media_nota >= 4
   	AND qtd_avaliacoes <= 10
ORDER BY media_nota DESC;

-- VIEWS
-- 1. VIEW com informações de jogos + categorias
CREATE VIEW vw_games_developers AS
SELECT 
    g.id,
    g.title,
    d.name AS developers
FROM games g
JOIN game_developers gd ON gd.game_id = g.id
JOIN developers d       ON d.id = gd.developer_id;

SELECT * FROM vw_games_developers;

-- 2. VIEW para avaliações completas (jogo + usuário + nota)
CREATE VIEW vw_ratings_full AS
SELECT 
    u.name  AS usuario,
    g.title AS jogo,
    r.score AS nota,
    r.comment AS comentario,
    r.create_at
FROM ratings r
JOIN users u ON u.id = r.user_id
JOIN games g ON g.id = r.game_id;









	