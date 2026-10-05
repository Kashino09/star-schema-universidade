# ⭐ Desafio de Modelagem Dimensional — Star Schema (Professores)

## 📑 Índice
- Contexto
- Objetivos
- Fontes
- Modelo Relacional de Origem
- Decisões de Modelagem
- Modelo Dimensional (Star Schema)
- Como Reproduzir
- Arquivos
- Autor

# Contexto:
- Este projeto é a entrega do desafio de modelagem dimensional da trilha de Analista de Dados da [DIO](https://www.dio.me/). A partir do diagrama relacional de uma **Universidade**, foi criado um **esquema em estrela** com foco na análise dos **professores**.

# Objetivos:
- Criar a tabela **fato** com o contexto analisado (professor, disciplinas ministradas, cursos e departamento);
- Criar as tabelas **dimensão** com os detalhes desse contexto;
- Criar uma dimensão de **datas**, supondo acesso aos dados de oferta de disciplinas e cursos;
- Não refletir dados de alunos, conforme o enunciado.

# Fontes:
- Diagrama relacional fornecido no desafio, com as tabelas `Professor`, `Departamento`, `Disciplina`, `Curso`, `Disciplina & Curso`, `Aluno`, `Matriculado`, `Pré-requisitos` e `Pré-requisitos das disciplinas`.

# Modelo Relacional de Origem
- `Departamento` tem um professor coordenador e agrupa professores e cursos;
- `Disciplina` é ministrada por um professor e se liga a cursos pela tabela `Disciplina & Curso`;
- `Matriculado` liga alunos a disciplinas; `Pré-requisitos das disciplinas` liga disciplinas entre si.

# Decisões de Modelagem
- **Granularidade da fato:** uma linha por **oferta** (professor × disciplina × curso × data de oferta);
- **Dimensões:** professor, departamento, disciplina, curso e data. Todas usam chave substituta (`sk_`), com a chave de origem (`id_`) guardada para rastreio;
- **Alunos fora do modelo:** a tabela `Aluno` não entra. A tabela `Matriculado` vira apenas uma **métrica agregada** (`qtd_alunos_matriculados`) na fato, sem identificar nenhum aluno;
- **Pré-requisitos:** a tabela de pré-requisitos vira o atributo `qtd_prerequisitos` na dimensão de disciplina, evitando uma relação muitos-para-muitos no esquema em estrela;
- **Coordenador:** a relação professor × departamento vira o campo `id_professor_coordenador` na dimensão de departamento e o indicador `eh_coordenador` na dimensão de professor;
- **Datas supostas:** como o modelo relacional não tem datas, foi criada `dim_data`, supondo acesso à data de oferta das disciplinas e dos cursos. Atributos: dia, mês, nome do mês, trimestre, semestre e ano, o que permite análises em vários níveis de granularidade;
- **Atributos descritivos supostos:** `nome_professor`, `titulacao`, `regime_trabalho`, `nome_disciplina`, `carga_horaria` e `nome_curso` não existem no diagrama original e foram supostos, como o enunciado permite.

# Modelo Dimensional (Star Schema)

![Star Schema](star_schema_universidade.png)

| Tabela | Tipo | Conteúdo |
|---|---|---|
| `fato_professor_disciplina` | Fato | Chaves das 5 dimensões e métricas: `qtd_alunos_matriculados`, `carga_horaria_ministrada`, `qtd_ofertas` |
| `dim_professor` | Dimensão | Professor, titulação, regime de trabalho e indicador de coordenador |
| `dim_departamento` | Dimensão | Nome, campus e coordenador |
| `dim_disciplina` | Dimensão | Nome, carga horária e quantidade de pré-requisitos |
| `dim_curso` | Dimensão | Nome do curso |
| `dim_data` | Dimensão | Data de oferta e seus níveis (dia, mês, trimestre, semestre, ano) |

Todas as relações são **1:N**, da dimensão para a fato.

**Exemplos de perguntas que o modelo responde:**
- Quantas disciplinas cada professor ministrou por semestre?
- Qual a carga horária ministrada por departamento e campus?
- Quais professores atendem mais alunos matriculados?

# Como Reproduzir
1. Abra o `star_schema_universidade.sql` no **MySQL Workbench**, conectado ao servidor, e execute (⚡). Isso cria o schema `universidade_dw` com as 6 tabelas;
2. Para o diagrama, use o **dbdiagram.io**: cole o modelo das tabelas e das relações (uma relação 1:N de cada dimensão para a fato) e organize as tabelas com a fato ao centro;
3. Exporte em **Export > Export to PNG**.

# Arquivos

| Arquivo | Descrição |
|---|---|
| `star_schema_universidade.png` | Imagem do esquema em estrela, feita no [dbdiagram.io](https://dbdiagram.io/) |
| `star_schema_universidade.sql` | Script de criação das tabelas fato e dimensão (MySQL) |

# Autor
- Kelwin Paschoal
