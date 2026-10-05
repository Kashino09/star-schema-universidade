-- Star Schema: análise de Professores (Universidade)
-- Execute no MySQL Workbench e use Database > Reverse Engineer para gerar o diagrama EER.
DROP SCHEMA IF EXISTS universidade_dw;
CREATE SCHEMA universidade_dw DEFAULT CHARACTER SET utf8mb4;
USE universidade_dw;

CREATE TABLE dim_professor (
  sk_professor INT NOT NULL AUTO_INCREMENT,
  id_professor INT NOT NULL,
  nome_professor VARCHAR(100),
  titulacao VARCHAR(45),
  regime_trabalho VARCHAR(45),
  eh_coordenador TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (sk_professor)
);

CREATE TABLE dim_departamento (
  sk_departamento INT NOT NULL AUTO_INCREMENT,
  id_departamento INT NOT NULL,
  nome VARCHAR(45) NOT NULL,
  campus VARCHAR(45) NOT NULL,
  id_professor_coordenador INT,
  PRIMARY KEY (sk_departamento)
);

CREATE TABLE dim_disciplina (
  sk_disciplina INT NOT NULL AUTO_INCREMENT,
  id_disciplina INT NOT NULL,
  nome_disciplina VARCHAR(100),
  carga_horaria INT,
  qtd_prerequisitos INT NOT NULL DEFAULT 0,
  PRIMARY KEY (sk_disciplina)
);

CREATE TABLE dim_curso (
  sk_curso INT NOT NULL AUTO_INCREMENT,
  id_curso INT NOT NULL,
  nome_curso VARCHAR(100),
  PRIMARY KEY (sk_curso)
);

CREATE TABLE dim_data (
  sk_data INT NOT NULL,            -- formato AAAAMMDD
  data DATE NOT NULL,
  dia TINYINT NOT NULL,
  mes TINYINT NOT NULL,
  nome_mes VARCHAR(15) NOT NULL,
  trimestre TINYINT NOT NULL,
  semestre TINYINT NOT NULL,
  ano SMALLINT NOT NULL,
  PRIMARY KEY (sk_data)
);

CREATE TABLE fato_professor_disciplina (
  sk_professor INT NOT NULL,
  sk_departamento INT NOT NULL,
  sk_disciplina INT NOT NULL,
  sk_curso INT NOT NULL,
  sk_data_oferta INT NOT NULL,
  qtd_alunos_matriculados INT NOT NULL DEFAULT 0,
  carga_horaria_ministrada INT NOT NULL DEFAULT 0,
  qtd_ofertas INT NOT NULL DEFAULT 1,
  PRIMARY KEY (sk_professor, sk_disciplina, sk_curso, sk_data_oferta),
  CONSTRAINT fk_fato_professor FOREIGN KEY (sk_professor) REFERENCES dim_professor (sk_professor),
  CONSTRAINT fk_fato_departamento FOREIGN KEY (sk_departamento) REFERENCES dim_departamento (sk_departamento),
  CONSTRAINT fk_fato_disciplina FOREIGN KEY (sk_disciplina) REFERENCES dim_disciplina (sk_disciplina),
  CONSTRAINT fk_fato_curso FOREIGN KEY (sk_curso) REFERENCES dim_curso (sk_curso),
  CONSTRAINT fk_fato_data FOREIGN KEY (sk_data_oferta) REFERENCES dim_data (sk_data)
);
