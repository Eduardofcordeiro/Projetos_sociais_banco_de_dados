# Projetos_sociais_banco_de_dados
Descrição: Projeto de banco de dados de cunho cadastral com visão para projetos sociais de cunho beneficiário


*Seguem alguns comandos para melhor navegação pelo banco de dados:*

-- Resumo de todas as informações importantes do banco de dados.

select * from buscar_beneficios_ativos()

-- Busca os dados de endereço dos beneficiarios.

select * from buscar_endereco_beneficiario()

-- Mostra todos os elementos da tabela beneficiario.

  select * from beneficiario

-- Mostra todos os elementos da tabela endereco.
  
  select * from endereco

-- Mostra todos os elementos da tabela dependentes.
  
  select * from dependentes

-- Mostra todos os elementos da tabela beneficios.
  
  select * from beneficios

-- Mostra todos os elementos da tabela beneficiariobeneficios.
  
  select * from beneficiariobeneficios

