
INSERT INTO UNIVERSOS (nome,descricao)
VALUES('The Witcher','Magia, Reis e Guerra.');
SELECT * FROM UNIVERSOS;

INSERT INTO RPGS (i_universo,maximoitens,maximopontos,nome,quantidadeitens)
VALUES(1,5,4,'The Witcher',5);
SELECT * FROM RPGS;

INSERT INTO AVENTUREIROS (nome,idade,apelido)
VALUES('Gabriel',25,'Maia');
SELECT * FROM AVENTUREIROS;

INSERT INTO CLASSES (descricao,i_rpg,nome)
VALUES('Bruxo de Kaer Morhen.',1,'Bruxo');
SELECT * FROM CLASSES;

INSERT INTO RACAS (descricao,i_rpg,nome)
VALUES('Uma linhagem obscura de Elfos, brutos e fortes em batalha.',1,'Orc');
SELECT * FROM RACAS;

INSERT INTO PERSONAGENS (i_aventureiro,i_classe,idade,i_raca,i_rpg,nome)
VALUES (1,1,42,1,1,'Azog');
SELECT * FROM Personagens;

INSERT INTO FICHA 
(i_personagem,i_aventureiros,i_rpg,i_classe,i_raca)
VALUES(4,1,1,1,1);
SELECT * FROM FICHA;
  
