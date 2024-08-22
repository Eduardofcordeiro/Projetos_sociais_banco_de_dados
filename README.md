# Projetos_sociais_banco_de_dados
Descrição: Projeto de banco de dados de cunho cadastral com visão para projetos sociais de cunho beneficiário

*Informações técnicas sobre o banco de dados:*

-- O banco de dados está dividido em 5 tabelas:
• beneficiario- Apresenta os dados do beneficiario;
• endereco- Apresenta dados de endereço do beneficiario;
• dependentes- Apresenta os dados dos dependentes;
• beneficios- Apresenta os dados dos benefícios;
• beneficiariobeneficios- Apresenta dados de qual beneficiario está ligado a qual benefício além de controlar o inicio e término do pagamento de algum benefício, além de também mostrar o valor total a ser pago.

-- o Banco de dados apresenta 2 triggers relevantes. Um deles tem a função de fazer o cálculo automático do número de dependentes de cada beneficiário (faz uma busca na tabela dependentes e conta quantas vezes o cpf do responsável aparece) e o outro trigger é para o cálculo automático do valor total pago a um beneficiário (ele multiplicará os valores de 'numerodedependentes' e 'valorextrapagopordependente', após isso ele somará o resultado com 'valorbasepago' e adicionará o resultado em 'valortotalpago')
-- O banco de dados apresenta 2 funções de busca para melhor navegação pelo banco de dados:
• buscar_endereco_beneficiario()- busca os dados de endereço completo do beneficiario;
• buscar_beneficios_ativos()- Traz um resumo das informações mais importantes do banco de dados.

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

