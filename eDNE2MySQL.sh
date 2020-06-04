#!/bin/bash
#eDNE2MySQL.sh
#rodar este script no mesmo diretório dos .txt do eDNE delimitado

banco="xxx_movedb"   <-- criar este banco no localhost antes de rodar este script!
tab_destino="newtab_cep"
lista="./lista_cep.txt"
lista_uf=AC,AL,AM,AP,BA,CE,DF,ES,GO,MA,MG,MS,MT,PA,PB,PE,PI,PR,RJ,RN,RO,RR,RS,SC,SE,SP,TO

OLDIFS=$IFS

#redireciona todas as saídas para o arquivo de log
#savelog -l ./eDNE2MySQL.log > /dev/null
#exec 2>&1 1>./eDNE2MySQL.log

echo $(realpath $0)
echo "["$(date)"] "- echo "Processamento iniciado"

#Troca todos os nomes de arquivos .txt (arquivos eDNE) para maiusculas
for f in *.[Tt][Xx][Tt]; do
    test -f "$f" && mv -n "$f" "${f^^}" 2> /dev/null
done


#Cria e Popula Tabelas do eDNE, em especial log_logradouro, log_localidade e log_grandes_usuarios
#
#Tabela LOG_FAIXA_UF
echo Criando e populando tabela LOG_FAIXA_UF
mysql -e "DROP TABLE IF EXISTS $banco.LOG_FAIXA_UF"
mysql -e "CREATE TABLE $banco.LOG_FAIXA_UF (
	UFE_SG CHAR(2) COLLATE utf8_general_ci,
	UFE_CEP_INI CHAR(8) COLLATE utf8_general_ci,
	UFE_CEP_FIM CHAR(8) COLLATE utf8_general_ci
	) COLLATE utf8_general_ci ENGINE=MyISAM"
mysql -e "LOAD DATA LOCAL INFILE './LOG_FAIXA_UF.TXT' INTO TABLE $banco.LOG_FAIXA_UF COLUMNS TERMINATED BY '@'"

#Tabela LOG_LOCALIDADE
echo Criando e populando tabela LOG_LOCALIDADE
mysql -e "DROP TABLE IF EXISTS $banco.LOG_LOCALIDADE"
mysql -e "CREATE TABLE $banco.LOG_LOCALIDADE (
	LOC_NU INT(8) PRIMARY KEY,
	UFE_SG CHAR(2) COLLATE utf8_general_ci,
	LOC_NO VARCHAR(72),
	CEP CHAR(8) COLLATE utf8_general_ci,
	LOC_IN_SIT CHAR(1) COLLATE utf8_general_ci,
	LOC_IN_TIPO_LOC CHAR(1) COLLATE utf8_general_ci,
	LOC_NU_SUB INT(8),
	LOC_NO_ABREV VARCHAR(36) COLLATE utf8_general_ci,
	MUN_NU CHAR(7) COLLATE utf8_general_ci
	) COLLATE utf8_general_ci ENGINE=MyISAM"
mysql -e "LOAD DATA LOCAL INFILE './LOG_LOCALIDADE.TXT' INTO TABLE $banco.LOG_LOCALIDADE COLUMNS TERMINATED BY '@'"

#Tabela LOG_VAR_LOC
echo Criando e populando tabela LOG_VAR_LOC
mysql -e "DROP TABLE IF EXISTS $banco.LOG_VAR_LOC"
mysql -e "CREATE TABLE $banco.LOG_VAR_LOC (
	LOC_NU INT(8) PRIMARY KEY,
	VAL_NU INT(8),
	VAL_TX VARCHAR(72) COLLATE utf8_general_ci
	) COLLATE utf8_general_ci ENGINE=MyISAM"
mysql -e "LOAD DATA LOCAL INFILE './LOG_VAR_LOC.TXT' INTO TABLE $banco.LOG_VAR_LOC COLUMNS TERMINATED BY '@'"

#Tabela LOG_FAIXA_LOCALIDADE
echo Criando e populando tabela LOG_FAIXA_LOCALIDADE
mysql -e "DROP TABLE IF EXISTS $banco.LOG_FAIXA_LOCALIDADE"
mysql -e "CREATE TABLE $banco.LOG_FAIXA_LOCALIDADE (
	LOC_NU INT(8) PRIMARY KEY,
	LOC_CEP_INI CHAR(8) COLLATE utf8_general_ci,
	LOC_CEP_FIM CHAR(8) COLLATE utf8_general_ci,
	LOC_TIPO_FAIXA CHAR(1) COLLATE utf8_general_ci
	) COLLATE utf8_general_ci ENGINE=MyISAM"
mysql -e "LOAD DATA LOCAL INFILE './LOG_FAIXA_LOCALIDADE.TXT' INTO TABLE $banco.LOG_FAIXA_LOCALIDADE COLUMNS TERMINATED BY '@'"

#Tabela LOG_BAIRRO
echo Criando e populando tabela LOG_BAIRRO
mysql -e "DROP TABLE IF EXISTS $banco.LOG_BAIRRO"
mysql -e "CREATE TABLE $banco.LOG_BAIRRO (
	BAI_NU INT(8) PRIMARY KEY,
	UFE_SG CHAR(2) COLLATE utf8_general_ci,
	LOC_NU INT(8),
	BAI_NO VARCHAR(72) COLLATE utf8_general_ci,
	BAI_NO_ABREV VARCHAR(36) COLLATE utf8_general_ci,
	INDEX Index2 (LOC_NU) USING BTREE
	) COLLATE utf8_general_ci ENGINE=MyISAM"
mysql -e "LOAD DATA LOCAL INFILE './LOG_BAIRRO.TXT' INTO TABLE $banco.LOG_BAIRRO COLUMNS TERMINATED BY '@'"

#Tabela LOG_VAR_BAI
echo Criando e populando tabela LOG_VAR_BAI
mysql -e "DROP TABLE IF EXISTS $banco.LOG_VAR_BAI"
mysql -e "CREATE TABLE $banco.LOG_VAR_BAI (
	BAI_NU INT(8) PRIMARY KEY,
	VDB_NU INT(8),
	VDB_TX VARCHAR(72) COLLATE utf8_general_ci
	) COLLATE utf8_general_ci ENGINE=MyISAM"
mysql -e "LOAD DATA LOCAL INFILE './LOG_VAR_BAI.TXT' INTO TABLE $banco.LOG_VAR_BAI COLUMNS TERMINATED BY '@'"

#Tabela LOG_FAIXA_BAIRRO
echo Criando e populando tabela LOG_FAIXA_BAIRRO
mysql -e "DROP TABLE IF EXISTS $banco.LOG_FAIXA_BAIRRO"
mysql -e "CREATE TABLE $banco.LOG_FAIXA_BAIRRO (
	BAI_NU INT(8) PRIMARY KEY,
	FCB_CEP_INI CHAR(8) COLLATE utf8_general_ci,
	FCB_CEP_FIM VARCHAR(8) COLLATE utf8_general_ci
	) COLLATE utf8_general_ci ENGINE=MyISAM"
mysql -e "LOAD DATA LOCAL INFILE './LOG_FAIXA_BAIRRO.TXT' INTO TABLE $banco.LOG_FAIXA_BAIRRO COLUMNS TERMINATED BY '@'"

#Tabela LOG_CPC
echo Criando e populando tabela LOG_CPC
mysql -e "DROP TABLE IF EXISTS $banco.LOG_CPC"
mysql -e "CREATE TABLE $banco.LOG_CPC (
	CPC_NU INT(8) PRIMARY KEY,
	UFE_SG CHAR(2) COLLATE utf8_general_ci,
	LOC_NU INT(8),
	CPC_NO VARCHAR(72) COLLATE utf8_general_ci,
	CPC_ENDERECO VARCHAR(100) COLLATE utf8_general_ci,
	CEP VARCHAR(8) COLLATE utf8_general_ci,
	INDEX Index2 (LOC_NU) USING BTREE
	) COLLATE utf8_general_ci ENGINE=MyISAM"
mysql -e "LOAD DATA LOCAL INFILE './LOG_CPC.TXT' INTO TABLE $banco.LOG_CPC COLUMNS TERMINATED BY '@'"

#Tabela LOG_FAIXA_CPC
echo Criando e populando tabela LOG_FAIXA_CPC
mysql -e "DROP TABLE IF EXISTS $banco.LOG_FAIXA_CPC"
mysql -e "CREATE TABLE $banco.LOG_FAIXA_CPC (
	CPC_NU INT(8) PRIMARY KEY,
	CPC_INICIAL VARCHAR(6) COLLATE utf8_general_ci,
	CPC_FINAL VARCHAR(6) COLLATE utf8_general_ci
	) COLLATE utf8_general_ci ENGINE=MyISAM"
mysql -e "LOAD DATA LOCAL INFILE './LOG_FAIXA_CPC.TXT' INTO TABLE $banco.LOG_FAIXA_CPC COLUMNS TERMINATED BY '@'"

##TabelaS LOG_LOGRADOURO_XX
IFS=","
for uf in $lista_uf; do 
	echo Criando e populando tabela LOG_LOGRADOURO_$uf
	mysql -e "DROP TABLE IF EXISTS $banco.LOG_LOGRADOURO_$uf"
	mysql -e "CREATE TABLE $banco.LOG_LOGRADOURO_$uf (
		LOG_NU INT(8) PRIMARY KEY,
		UFE_SG CHAR(2) COLLATE utf8_general_ci,
		LOC_NU INT(8),
		BAI_NU_INI INT(8),
		BAI_NU_FIM INT(8),
		LOG_NO VARCHAR(100) COLLATE utf8_general_ci,
		LOG_COMPLEMENTO VARCHAR(100) COLLATE utf8_general_ci,
		CEP CHAR(100) COLLATE utf8_general_ci,
		TLO_TX VARCHAR(36) COLLATE utf8_general_ci,
		LOG_STA_TLO CHAR(1) COLLATE utf8_general_ci,
		LOG_NO_ABREV VARCHAR(36) COLLATE utf8_general_ci,
		INDEX Index2 (LOC_NU) USING BTREE,
		INDEX Index3 (BAI_NU_INI) USING BTREE,
		INDEX Index4 (BAI_NU_FIM) USING BTREE
		) COLLATE utf8_general_ci ENGINE=MyISAM"
	mysql -e "LOAD DATA LOCAL INFILE "\'"./LOG_LOGRADOURO_$uf.TXT"\'" INTO TABLE $banco.LOG_LOGRADOURO_$uf COLUMNS TERMINATED BY '@'"
done

#Tabela LOG_VAR_LOG
echo Criando e populando tabela LOG_VAR_LOG
mysql -e "DROP TABLE IF EXISTS $banco.LOG_VAR_LOG"
mysql -e "CREATE TABLE $banco.LOG_VAR_LOG (
	LOG_NU INT(8) PRIMARY KEY,
	VLO_NU INT(8),
	TLO_TX VARCHAR(36) COLLATE utf8_general_ci,
	VLO_TX VARCHAR(150) COLLATE utf8_general_ci
	) COLLATE utf8_general_ci ENGINE=MyISAM"
mysql -e "LOAD DATA LOCAL INFILE './LOG_VAR_LOG.TXT' INTO TABLE $banco.LOG_VAR_LOG COLUMNS TERMINATED BY '@'"

#Tabela LOG_NUM_SEC
echo Criando e populando tabela LOG_NUM_SEC
mysql -e "DROP TABLE IF EXISTS $banco.LOG_NUM_SEC"
mysql -e "CREATE TABLE $banco.LOG_NUM_SEC (
	LOG_NU INT(8) PRIMARY KEY,
	SEC_NU_INI VARCHAR(10) COLLATE utf8_general_ci,
	SEC_NU_FIM VARCHAR(10) COLLATE utf8_general_ci,
	SEC_IN_LADO VARCHAR(1) COLLATE utf8_general_ci
	) COLLATE utf8_general_ci ENGINE=MyISAM"
mysql -e "LOAD DATA LOCAL INFILE './LOG_NUM_SEC.TXT' INTO TABLE $banco.LOG_NUM_SEC COLUMNS TERMINATED BY '@'"

#Tabela LOG_GRANDE_USUARIO
echo Criando e populando tabela LOG_GRANDE_USUARIO
mysql -e "DROP TABLE IF EXISTS $banco.LOG_GRANDE_USUARIO"
mysql -e "CREATE TABLE $banco.LOG_GRANDE_USUARIO (
	GRU_NU INT(8) PRIMARY KEY,
	UFE_SG CHAR(2) COLLATE utf8_general_ci,
	LOC_NU INT(8),
	BAI_NU INT(8),
	LOG_NU INT(8),
	GRU_NO VARCHAR(72) COLLATE utf8_general_ci,
	GRU_ENDERECO VARCHAR(100) COLLATE utf8_general_ci,
	CEP CHAR(8) COLLATE utf8_general_ci,
	GRU_NO_ABREV VARCHAR(36) COLLATE utf8_general_ci,
	INDEX Index2 (LOC_NU) USING BTREE,
	INDEX Index3 (BAI_NU) USING BTREE,
	INDEX Index4 (LOG_NU) USING BTREE
	) COLLATE utf8_general_ci ENGINE=MyISAM"
mysql -e "LOAD DATA LOCAL INFILE './LOG_GRANDE_USUARIO.TXT' INTO TABLE $banco.LOG_GRANDE_USUARIO COLUMNS TERMINATED BY '@'"

#Tabela LOG_UNID_OPER
echo Criando e populando tabela LOG_UNID_OPER
mysql -e "DROP TABLE IF EXISTS $banco.LOG_UNID_OPER"
mysql -e "CREATE TABLE $banco.LOG_UNID_OPER (
	UOP_NU INT(8) PRIMARY KEY,
	UFE_SG CHAR(2) COLLATE utf8_general_ci,
	LOC_NU INT(8),
	BAI_NU INT(8),
	LOG_NU INT(8),
	UOP_NO VARCHAR(100) COLLATE utf8_general_ci,
	UOP_ENDERECO VARCHAR(100) COLLATE utf8_general_ci,
	CEP CHAR(8) COLLATE utf8_general_ci,
	UOP_IN_CP CHAR(1) COLLATE utf8_general_ci,
	UOP_NO_ABREV VARCHAR(36) COLLATE utf8_general_ci,
	INDEX Index2 (LOC_NU) USING BTREE,
	INDEX Index3 (BAI_NU) USING BTREE,
	INDEX Index4 (LOG_NU) USING BTREE
	) COLLATE utf8_general_ci ENGINE=MyISAM"
mysql -e "LOAD DATA LOCAL INFILE './LOG_UNID_OPER.TXT' INTO TABLE $banco.LOG_UNID_OPER COLUMNS TERMINATED BY '@'"

#Tabela LOG_FAIXA_UOP
echo Criando e populando tabela LOG_FAIXA_UOP
mysql -e "DROP TABLE IF EXISTS $banco.LOG_FAIXA_UOP"
mysql -e "CREATE TABLE $banco.LOG_FAIXA_UOP (
	UOP_NU INT(8) PRIMARY KEY,
	FNC_INICIAL INT(8),
	FNC_FINAL INT(8)
	) COLLATE utf8_general_ci ENGINE=MyISAM"
mysql -e "LOAD DATA LOCAL INFILE './LOG_FAIXA_UOP.TXT' INTO TABLE $banco.LOG_FAIXA_UOP COLUMNS TERMINATED BY '@'"

#Tabela ECT_PAIS
echo Criando e populando tabela ECT_PAIS
mysql -e "DROP TABLE IF EXISTS $banco.ECT_PAIS"
mysql -e "CREATE TABLE $banco.ECT_PAIS (
	PAI_SG CHAR(2) PRIMARY KEY,
	PAI_SG_ALTERNATIVA CHAR(3) COLLATE utf8_general_ci,
	PAI_NO_PORTUGUES CHAR(72) COLLATE utf8_general_ci,
	PAI_NO_INGLES CHAR(72) COLLATE utf8_general_ci,
	PAI_NO_FRANCES CHAR(72) COLLATE utf8_general_ci,
	PAI_ABREVIATURA CHAR(36) COLLATE utf8_general_ci
	) COLLATE utf8_general_ci ENGINE=MyISAM"
mysql -e "LOAD DATA LOCAL INFILE './ECT_PAIS.TXT' INTO TABLE $banco.ECT_PAIS COLUMNS TERMINATED BY '@'"

#Cria tabela de destino
#Coluna OBS é temporária e deve ser eliminada após popular, ou usada (!=null) como flag para gerar a tabela de ceps a pesquisar 
echo "Criando tabela destino ($banco.$tab_destino)"
mysql -e "DROP TABLE IF EXISTS $banco.$tab_destino"
mysql -e "CREATE TABLE $banco.$tab_destino (
	ID INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	UF VARCHAR(2) NOT NULL COLLATE utf8_general_ci,
	CIDADE VARCHAR(80) NOT NULL COLLATE utf8_general_ci,
	BAIRRO VARCHAR(80) NULL COLLATE utf8_general_ci,
	LOGRADOURO VARCHAR(125) NULL COLLATE utf8_general_ci,
	CEP VARCHAR(8) NOT NULL COLLATE utf8_general_ci,
	GRU_NO VARCHAR(255) NULL DEFAULT NULL COLLATE utf8_general_ci,
	MSG_Correio VARCHAR(255) NULL DEFAULT NULL COLLATE utf8_general_ci,
	ERR_Correio VARCHAR(4) NULL DEFAULT NULL COLLATE utf8_general_ci,
	OBS VARCHAR(4) NULL DEFAULT NULL COLLATE utf8_general_ci,
	INDEX Index2 (CEP) USING BTREE,
	INDEX Index3 (CIDADE, UF) USING BTREE
	) COLLATE utf8_general_ci ENGINE=MyISAM"



#Popula tabela de destino
#

#LOG_LOCALIDADE (se OBS != NULL então deve pesquisar frete mais tarde)
echo '-Populando tabela destino com LOG_LOCALIDADE'
#
#1- CEP único para a localidade. DISTRITO (LOC_IN_SIT = '0' AND LOC_IN_TIPO_LOC = 'D')
#CIDADE (distrito) AS CIDADE. ex: 13775000  Caconde (Barrânia)
mysql -e "INSERT INTO $banco.$tab_destino (UF, OBS, CIDADE, CEP) SELECT UFE_SG AS UF, LOC_NU_SUB AS OBS, CONCAT((SELECT LOC_NO FROM $banco.LOG_LOCALIDADE WHERE $banco.LOG_LOCALIDADE.LOC_NU = OBS),' (', LOC_NO, ')') AS CIDADE, CEP FROM $banco.LOG_LOCALIDADE  WHERE (LOC_IN_SIT = '0' AND LOC_IN_TIPO_LOC = 'D')"

#2- CEP unico para a localidade. MUNICIPIO (LOC_IN_SIT = '0' AND LOC_IN_TIPO_LOC = 'M')
#não tem bairro. ex: 13770000
mysql -e "INSERT INTO $banco.$tab_destino (UF, OBS, CIDADE, CEP) SELECT UFE_SG AS UF, '0000' AS OBS, LOC_NO AS CIDADE, CEP FROM $banco.LOG_LOCALIDADE  WHERE (LOC_IN_SIT = '0' AND LOC_IN_TIPO_LOC = 'M')"

#3- CEP único para a localidade. POVOADO (LOC_IN_SIT = '0' AND LOC_IN_TIPO_LOC = 'P')
#CIDADE (povoado) AS CIDADE. ex: 11200000
mysql -e "INSERT INTO $banco.$tab_destino (UF, OBS, CIDADE, CEP) SELECT UFE_SG AS UF, LOC_NU_SUB AS OBS, CONCAT((SELECT LOC_NO FROM $banco.LOG_LOCALIDADE WHERE $banco.LOG_LOCALIDADE.LOC_NU = OBS),' (', LOC_NO, ')') AS CIDADE, CEP FROM $banco.LOG_LOCALIDADE  WHERE (LOC_IN_SIT = '0' AND LOC_IN_TIPO_LOC = 'P')"

#4- CEP por rua. MUNICIPIO (LOC_IN_SIT = '1' AND LOC_IN_TIPO_LOC = 'M')
#NÃO PRECISA CRIAR ESTES NA NEWTAB_CEP. SE CRIAR VAI TER DOIS CEPS IGUAIS NO BANCO (LOGRADOURO E LOOCALIDADE - ERRO!)
#DÁ PARA CRIAR A LISTA_CIDADES DESTES MAIS TARDE PESQUISANDO POR (LOC_IN_SIT = '1' AND LOC_IN_TIPO_LOC = 'M') E
#BUSCANDO O CEP NA PRÓPRIA TABNEW_CEP JÁ POPULADAS PELAS LOGRADOURO_XX
#Cidade e Bairro especificados. Busca primeia ocorrência de LOC_NU em LOG_LOGRADOURO_XX. ex: 09770420

#LOG_LOGRADOURO_XX
for uf in $lista_uf; do 
	echo '-Populando tabela destino com LOG_LOGRADOURO_'$uf
	mysql -e "INSERT INTO $banco.$tab_destino (UF, CIDADE, BAIRRO, LOGRADOURO, CEP) SELECT UFE_SG AS UF, (SELECT LOC_NO FROM $banco.LOG_LOCALIDADE WHERE $banco.LOG_LOGRADOURO_$uf.LOC_NU = $banco.LOG_LOCALIDADE.LOC_NU) AS CIDADE, (SELECT BAI_NO FROM $banco.LOG_BAIRRO WHERE $banco.LOG_LOGRADOURO_$uf.BAI_NU_INI = $banco.LOG_BAIRRO.BAI_NU) AS BAIRRO, CONCAT(TLO_TX,' ',LOG_NO,'  ',LOG_COMPLEMENTO) AS LOGRADOURO, CEP FROM $banco.LOG_LOGRADOURO_$uf"
done

#5 - CEP por rua. DISTRITO (LOC_IN_SIT = '2' AND LOC_IN_TIPO_LOC = 'D')
#6 - CEP por rua. POVOADO (LOC_IN_SIT = '2' AND LOC_IN_TIPO_LOC = 'P'). ex 29198112
#já inclusoS na base de ceps por rua. ex: 11200000


#LOG_GRANDE_USUARIO
echo '-Populando tabela destino com LOG_GRANDE_USUARIO'
mysql -e "INSERT INTO $banco.$tab_destino (UF, CIDADE, BAIRRO, LOGRADOURO, CEP, GRU_NO) SELECT UFE_SG AS UF, (SELECT LOC_NO FROM $banco.LOG_LOCALIDADE WHERE $banco.LOG_GRANDE_USUARIO.LOC_NU = $banco.LOG_LOCALIDADE.LOC_NU) AS CIDADE, (SELECT BAI_NO FROM $banco.LOG_BAIRRO WHERE $banco.LOG_GRANDE_USUARIO.BAI_NU = $banco.LOG_BAIRRO.BAI_NU) AS BAIRRO, GRU_ENDERECO AS LOGRADOURO, CEP,  GRU_NO AS GRU_NO FROM $banco.LOG_GRANDE_USUARIO"

#LOG_UNID_OPER
echo '-Populando tabela destino com LOG_UNID_OPER'
mysql -e "INSERT INTO $banco.$tab_destino (UF, CIDADE, BAIRRO, LOGRADOURO, CEP, GRU_NO) SELECT UFE_SG AS UF, (SELECT LOC_NO FROM $banco.LOG_LOCALIDADE WHERE $banco.LOG_UNID_OPER.LOC_NU = $banco.LOG_LOCALIDADE.LOC_NU) AS CIDADE, (SELECT BAI_NO FROM $banco.LOG_BAIRRO WHERE $banco.LOG_UNID_OPER.BAI_NU = $banco.LOG_BAIRRO.BAI_NU) AS BAIRRO, UOP_ENDERECO AS LOGRADOURO, CEP, UOP_NO AS GRU_NO FROM $banco.LOG_UNID_OPER"

#LOG_CPC
echo '-Populando tabela destino com LOG_CPC'
mysql -e "INSERT INTO $banco.$tab_destino (UF, CIDADE, LOGRADOURO, CEP) SELECT UFE_SG AS UF, (SELECT LOC_NO FROM $banco.LOG_LOCALIDADE WHERE $banco.LOG_CPC.LOC_NU = $banco.LOG_LOCALIDADE.LOC_NU) AS CIDADE, CPC_ENDERECO AS LOGRADOURO, CEP FROM $banco.LOG_CPC"

echo "["$(date)"] "- echo "Geração da Tabela destino terminado"
echo

#Para mostrar as tabelas e o número de registros
#mysql -e "use rcamo273_movedb; SELECT table_name, table_rows FROM information_schema.tables WHERE table_schema = 'rcamo273_movedb' AND table_type = 'BASE TABLE' ORDER BY table_name;"

IFS=$OLDIFS
exit 0
