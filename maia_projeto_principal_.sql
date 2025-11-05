CREATE TABLE UNIVERSOS (
  i_universos NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  descricao VARCHAR(200) NOT NULL
);

CREATE OR REPLACE TRIGGER trg_univ_nome BEFORE INSERT OR UPDATE
ON UNIVERSOS 
FOR EACH ROW 
DECLARE nomeUniv NUMBER;
BEGIN

SELECT COUNT(*) 
INTO nomeUniv 
FROM UNIVERSOS 
WHERE UPPER(nome) = UPPER(:NEW.nome)
AND (:NEW.i_universos IS NULL OR i_universos <> :NEW.i_universos);

IF nomeUniv > 0 THEN RAISE_APPLICATION_ERROR(-20001,'Erro: Já existe um universo cadastrado com esse nome.');
END IF;

END;
/ 

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE RPGs (
  i_rpg NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  i_universo INTEGER NOT NULL,
  FOREIGN KEY (i_universo) references UNIVERSOS(i_universos),
  maximoItens INTEGER NOT NULL,
  quantidadeItens INTEGER NOT NULL,
  maximoPontos INTEGER NOT NULL
);

CREATE OR REPLACE TRIGGER trg_rpg_nome BEFORE INSERT OR UPDATE
ON RPGS 
FOR EACH ROW 
DECLARE nomeRpg NUMBER;
BEGIN

SELECT COUNT(*) 
INTO nomeRpg 
FROM RPGS 
WHERE UPPER(nome) = UPPER(:NEW.nome)
AND (:NEW.i_rpg IS NULL OR i_rpg <> :NEW.i_rpg);

IF nomeRpg > 0 THEN RAISE_APPLICATION_ERROR(-20001,'Erro: Já existe um RPG cadastrado com esse nome.');
END IF;

END;
/

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE CLASSES (
  i_classe NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(65) NOT NULL,
  descricao VARCHAR(200) NOT NULL,
  i_rpg INTEGER NOT NULL,
  FOREIGN KEY (i_rpg) REFERENCES RPGS(i_rpg)
);

CREATE OR REPLACE TRIGGER trg_nomeClasse BEFORE INSERT OR UPDATE
ON CLASSES
FOR EACH ROW
DECLARE contemClasse NUMBER;
BEGIN

SELECT COUNT(*)
INTO contemClasse
FROM CLASSES
WHERE i_rpg = :NEW.i_rpg
AND nome = :NEW.nome;

IF contemClasse > 0 THEN
RAISE_APPLICATION_ERROR(-20001,'Erro: Esse RPG já possui essa classe.');
END IF;

END;
/
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE RACAS (
  i_raca NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(65) NOT NULL,
  descricao VARCHAR(200) NOT NULL,
  i_rpg INTEGER NOT NULL,
  FOREIGN KEY (i_rpg) REFERENCES RPGS(i_rpg)
);

CREATE OR REPLACE TRIGGER trg_nomeRaca BEFORE INSERT OR UPDATE
ON RACAS
FOR EACH ROW
DECLARE contemRaca NUMBER;
BEGIN

SELECT COUNT(*)
INTO contemRaca
FROM RACAS
WHERE i_rpg = :NEW.i_rpg
AND nome = :NEW.nome;

IF contemRaca > 0 THEN
RAISE_APPLICATION_ERROR(-20001,'Erro: Esse RPG já possui essa raça.');
END IF;

END;
/
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE LOCAIS (
  i_local NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(65) NOT NULL,
  i_rpg INTEGER NOT NULL,
  FOREIGN KEY (i_rpg) references RPGS(i_rpg)
);

CREATE OR REPLACE TRIGGER trg_locais_nome BEFORE INSERT OR UPDATE
ON LOCAIS 
FOR EACH ROW 
DECLARE nomeLocal NUMBER;
BEGIN

SELECT COUNT(*) 
INTO nomeLocal 
FROM LOCAIS 
WHERE UPPER(nome) = UPPER(:NEW.nome)
AND (:NEW.i_local IS NULL OR i_local <> :NEW.i_local);

IF nomeLocal > 0 THEN RAISE_APPLICATION_ERROR(-20001,'Erro: Esse RPG já possui um lugar com esse nome.');
END IF;

END;
/

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE AVENTUREIROS (
  i_aventureiros NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(65) NOT NULL,
  idade INTEGER NOT NULL,
  apelido VARCHAR(50) NOT NULL
);

CREATE OR REPLACE TRIGGER trg_verificaIdade BEFORE INSERT OR UPDATE
ON AVENTUREIROS 
FOR EACH ROW 
BEGIN 

IF :NEW.idade <= 17 THEN RAISE_APPLICATION_ERROR(-20001,'Jogos recomendados para maiores de 18 anos!');
END IF;

END;
/
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE PERSONAGENS (
  i_personagem NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  i_classe INTEGER NOT NULL,
  i_raca INTEGER NOT NULL,
  FOREIGN KEY (i_classe) REFERENCES CLASSES (i_classe),
  FOREIGN KEY (i_raca) REFERENCES RACAS (i_raca),
  idade INTEGER NOT NULL,
  i_aventureiro INTEGER NOT NULL,
  FOREIGN KEY (i_aventureiro) references AVENTUREIROS(i_aventureiros),
  i_rpg INTEGER NOT NULL,
  FOREIGN KEY (i_rpg) REFERENCES RPGS (i_rpg)
);

CREATE OR REPLACE TRIGGER trg_verificaPersonagem BEFORE INSERT OR UPDATE
ON PERSONAGENS 
FOR EACH ROW 
DECLARE personagem NUMBER;
verificaRaca NUMBER;
verificaClasse NUMBER;
BEGIN

SELECT COUNT(*) 
INTO personagem
FROM PERSONAGENS
WHERE i_aventureiro = :NEW.i_aventureiro
AND i_rpg = :NEW.i_rpg;

IF personagem > 0 THEN RAISE_APPLICATION_ERROR( -20001,'Erro: Você já possui personagem neste RPG.');
END IF;

SELECT COUNT(*) 
INTO verificaRaca
FROM RACAS
WHERE i_rpg = :NEW.i_rpg
AND i_raca = :NEW.i_raca;

IF verificaRaca < 0 THEN RAISE_APPLICATION_ERROR( -20001,'Erro: Essa raça não pertence a este RPG.');
END IF;


SELECT COUNT(*) 
INTO verificaClasse
FROM CLASSES
WHERE i_classe = :NEW.i_classe
AND i_rpg = :NEW.i_rpg;

IF verificaClasse < 0 THEN RAISE_APPLICATION_ERROR( -20001,'Erro: Essa classe não pertence a este RPG.');
END IF;

END;
/
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE FICHA (
  i_ficha NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  i_personagem INTEGER NOT NULL,
  nomePersonagem VARCHAR(50) NOT NULL,
  i_aventureiros INTEGER NOT NULL,
  i_rpg INTEGER NOT NULL,
  FOREIGN KEY (i_personagem) references PERSONAGENS(i_personagem),
  FOREIGN KEY (i_aventureiros) references AVENTUREIROS(i_aventureiros),
  FOREIGN KEY (i_rpg) references RPGS(i_rpg),
  i_classe INTEGER NOT NULL,
  i_raca INTEGER NOT NULL,
  FOREIGN KEY (i_classe) REFERENCES CLASSES (i_classe),
  FOREIGN KEY (i_raca) REFERENCES RACAS (i_raca),
  nomeClasse VARCHAR(50)NOT NULL,
  nomeRaca VARCHAR(50) NOT NULL
);

CREATE OR REPLACE TRIGGER trg_verificaFicha BEFORE INSERT OR UPDATE
ON FICHA 
FOR EACH ROW 
DECLARE v_ficha NUMBER;
v_i_classe NUMBER;
v_i_raca   NUMBER;
v_nome_personagem VARCHAR(50);
v_nome_classe VARCHAR(50);
v_nome_raca VARCHAR(50);
BEGIN

SELECT COUNT(*) 
INTO v_ficha
FROM FICHA
WHERE i_personagem = :NEW.i_personagem;

IF v_ficha > 0 THEN RAISE_APPLICATION_ERROR(-20001, 'Erro: Esse personagem já possui Ficha.');
END IF;

SELECT i_classe, i_raca
INTO v_i_classe, v_i_raca
FROM PERSONAGENS
WHERE i_personagem = :NEW.i_personagem;

IF v_i_classe != :NEW.i_classe THEN
RAISE_APPLICATION_ERROR(-20011, 'Erro: A classe da ficha deve ser a mesma do personagem.');
END IF;

IF v_i_raca != :NEW.i_raca THEN
RAISE_APPLICATION_ERROR(-20012, 'Erro: A raça da ficha deve ser a mesma do personagem.');
END IF;

SELECT nome INTO v_nome_personagem FROM PERSONAGENS WHERE i_personagem = :NEW.i_personagem;
:NEW.nomePersonagem := v_nome_personagem;

SELECT nome INTO v_nome_classe FROM CLASSES WHERE i_classe = :NEW.i_classe;
:NEW.nomeClasse := v_nome_classe;

SELECT nome INTO v_nome_raca FROM RACAS WHERE i_raca = :NEW.i_raca;
:NEW.nomeRaca := v_nome_raca;


END;
/

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE PERICIAS (
  i_pericias NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(65) NOT NULL,
  tipoPericia VARCHAR(50) NOT NULL,
  i_rpg INTEGER NOT NULL,
  FOREIGN KEY (i_rpg) references RPGS(i_rpg)
);

CREATE OR REPLACE TRIGGER trg_verificaPericia BEFORE INSERT OR UPDATE
ON PERICIAS 
FOR EACH ROW 
DECLARE nomePericia NUMBER;
BEGIN 

IF :NEW.tipoPericia NOT IN('Ação', 'Análise') THEN RAISE_APPLICATION_ERROR(-20001,'Erro: O tipo da perícia deve ser Ação ou Análise.');
END IF;

SELECT COUNT(*) 
INTO nomePericia
FROM  PERICIAS
WHERE  nome = :NEW.nome
AND i_rpg = :NEW.i_rpg;

IF nomePericia > 0 THEN RAISE_APPLICATION_ERROR( -20001, 'Erro: Essa perícia já está cadastrada neste RPG.');
END IF;

END;
/

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE ITENS (
  i_item NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(65) NOT NULL,
  tipoItem VARCHAR(30) NOT NULL,
  quantidade INTEGER NOT NULL,
  i_ficha INTEGER NOT NULL,
  FOREIGN KEY (i_ficha) references FICHA(i_ficha) 
);

CREATE OR REPLACE TRIGGER trg_verificaItem BEFORE INSERT  OR UPDATE
ON ITENS 
FOR EACH ROW 
DECLARE quantidadeMaxima NUMBER;
maximoInventario NUMBER;
itensInventario NUMBER;
BEGIN 

IF :NEW.tipoItem NOT IN('Consumivel', 'Equipamento') THEN RAISE_APPLICATION_ERROR(  -20001,  'Erro: O tipo da item deve ser Equipamento ou Consumível.');
END IF;

SELECT  quantidadeItens 
INTO quantidadeMaxima
FROM  RPGS
WHERE  i_rpg = ( SELECT i_rpg FROM FICHA WHERE i_ficha = :NEW.i_ficha);

IF :NEW.quantidade > quantidadeMaxima THEN RAISE_APPLICATION_ERROR(  -20001,  'Erro: Quantidade máxima deste item já preenchida.');
END IF;

SELECT  maximoItens 
INTO maximoInventario
FROM  RPGS
WHERE  i_rpg = (SELECT i_rpg FROM FICHA WHERE i_ficha = :NEW.i_ficha);

SELECT  COUNT(*) 
INTO itensInventario
FROM  ITENS
WHERE  i_ficha = :NEW.i_ficha;

IF itensInventario >= maximoInventario THEN RAISE_APPLICATION_ERROR(  -20001,  'Erro: Quantidade máxima de itens já preenchida.');
END IF;

END;
/ 

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE NPCS (
  i_npc NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(65) NOT NULL,
  i_raca INTEGER NOT NULL,
  i_rpg INTEGER NOT NULL,
  FOREIGN KEY (i_raca) REFERENCES RACAS(i_raca),
  FOREIGN KEY (i_rpg) REFERENCES RPGS(i_rpg),
  i_local INTEGER NOT NULL,
  FOREIGN KEY (i_local) REFERENCES LOCAIS (i_local),
  nomeLocal varchar(60)
);

CREATE OR REPLACE TRIGGER trg_verificaNpc BEFORE INSERT OR UPDATE
ON NPCS FOR EACH ROW 
DECLARE rpg NUMBER;
BEGIN

SELECT COUNT(*)
INTO rpg
FROM RACAS
WHERE i_raca = :NEW.i_raca
AND i_rpg = :NEW.i_rpg;

IF rpg <= 0 THEN RAISE_APPLICATION_ERROR(-20001, 'Erro: Essa raça não é desse RPG.');
END IF;

END;
/
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE pontosPericia (
  i_pontosPericia NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  i_pericia INTEGER NOT NULL,
  i_personagem INTEGER NOT NULL,
  i_ficha INTEGER NOT NULL,
  FOREIGN KEY (i_pericia) references PERICIAS(i_pericias),
  nomePericia varchar(60) NOT NULL,
  FOREIGN KEY (i_personagem) references PERSONAGENS(i_personagem),
  FOREIGN KEY (i_ficha) references FICHA(i_ficha),
  pontos INTEGER
);

CREATE OR REPLACE TRIGGER trg_verificaPontosPericia
BEFORE INSERT OR UPDATE ON pontosPericia
FOR EACH ROW
DECLARE
  v_i_personagem_ficha NUMBER;
  v_i_rpg_personagem   NUMBER;
  v_i_rpg_pericia      NUMBER;
  v_nomePericia     VARCHAR(60);
BEGIN
  
SELECT i_personagem
INTO v_i_personagem_ficha
FROM FICHA
WHERE i_ficha = :NEW.i_ficha;

IF v_i_personagem_ficha != :NEW.i_personagem THEN
RAISE_APPLICATION_ERROR(-20030, 'Erro: O personagem informado não corresponde ao personagem da ficha.');
END IF;

SELECT i_rpg
INTO v_i_rpg_personagem
FROM PERSONAGENS
WHERE i_personagem = :NEW.i_personagem;

SELECT i_rpg
INTO v_i_rpg_pericia
FROM PERICIAS
WHERE i_pericias = :NEW.i_pericia;

IF v_i_rpg_personagem != v_i_rpg_pericia THEN
RAISE_APPLICATION_ERROR( -20031,'Erro: A perícia e o personagem pertencem a RPGs diferentes.');
END IF;

SELECT nome INTO v_nomePericia FROM PERICIAS WHERE i_pericias = :NEW.i_pericia;
:NEW.nomePericia := v_nomePericia;

END;
/

-- adicionar trigger de pontos máximos 
