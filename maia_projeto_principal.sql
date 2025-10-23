CREATE TABLE UNIVERSOS (
i_universos NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
nome varchar(50)
);

CREATE TABLE RPGs (
i_rpg NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
nome varchar(50),
i_universo integer,
foreign key (i_universo) references UNIVERSOS(i_universos)
);

CREATE TABLE AVENTUREIROS (
i_aventureiros NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
nome varchar(65),
idade integer,
apelido varchar(50)
);

CREATE OR REPLACE TRIGGER trg_verificaIdade
BEFORE INSERT OR UPDATE ON AVENTUREIROS
FOR EACH ROW
BEGIN
IF :NEW.idade <= 17 THEN
RAISE_APPLICATION_ERROR(-20001, 'Jogos recomendados para maiores de 18 anos!');
END IF;
END;
/

CREATE TABLE PERICIAS (
i_pericias NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
nome varchar(65),
tipo varchar(50),
CONSTRAINT ck_tipoPericia CHECK (tipo in ('Ação','Analise'))
);

/* Caso precise mudar a constraint
ALTER TABLE PERICIAS DROP CONSTRAINT ck_tipoPericia;
ALTER TABLE PERICIAS
ADD CONSTRAINT ck_tipoPericia CHECK (tipo IN ('Ação','Analise','Diálogo'));
*/
