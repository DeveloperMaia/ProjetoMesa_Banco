CREATE TABLE UNIVERSOS (
  i_universos NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  descricao VARCHAR(200) NOT NULL
);

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

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE CLASSES (
  i_classe NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(65) NOT NULL,
  descricao VARCHAR(200) NOT NULL,
  i_rpg INTEGER NOT NULL,
  FOREIGN KEY (i_rpg) REFERENCES RPGS(i_rpg)
);

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE RACAS (
  i_raca NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(65) NOT NULL,
  descricao VARCHAR(200) NOT NULL,
  i_rpg INTEGER NOT NULL,
  FOREIGN KEY (i_rpg) REFERENCES RPGS(i_rpg)
);

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE LOCAIS (
  i_local NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(65) NOT NULL,
  i_rpg INTEGER NOT NULL,
  FOREIGN KEY (i_rpg) references RPGS(i_rpg)
);

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE AVENTUREIROS (
  i_aventureiros NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(65) NOT NULL,
  idade INTEGER NOT NULL,
  apelido VARCHAR(50) NOT NULL
);

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

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

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

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE PERICIAS (
  i_pericias NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(65) NOT NULL,
  tipoPericia VARCHAR(50) NOT NULL,
  i_rpg INTEGER NOT NULL,
  FOREIGN KEY (i_rpg) references RPGS(i_rpg)
);

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE ITENS (
  i_item NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(65) NOT NULL,
  tipoItem VARCHAR(30) NOT NULL,
  quantidade INTEGER NOT NULL,
  i_ficha INTEGER NOT NULL,
  FOREIGN KEY (i_ficha) references FICHA(i_ficha) 
);

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

--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CREATE TABLE pontosPericia (
  i_pontosPericia NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  i_pericia INTEGER NOT NULL,
  i_personagem INTEGER NOT NULL,
  i_ficha INTEGER NOT NULL,
  FOREIGN KEY (i_pericia) references PERICIAS(i_pericias),
  nomePericia varchar(60) NOT NULL,
  FOREIGN KEY (i_personagem) references PERSONAGENS(i_personagem),
  FOREIGN KEY (i_ficha) references FICHA(i_ficha),
  pontos INTEGER NOT NULL
);



