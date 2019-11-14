#!/usr/bin/python
# -*- coding: utf-8 -*-
'''
Projeto FUNASA
Cria formato para o arquivo input-forms.xml, referente a colecao e qual formuário deverá ser utilizado
Fabio Luis de Brito - 20191114
Execução:
    python cria_handle_colecao_formulario.py

'''
import requests

URL_t="http://rcfunasa.bvsalud.org/rest/collections?offset=0&limit=1000"

# Executado consulta
r_t = requests.get(URL_t)

# Armazenando conteudo em 'data_t'
data_t = r_t.json()

for item in data_t:
	name=item['name'].encode('utf-8')
	handle=item['handle']

	# Legislação - legi
	if name=='Normativos':
		texto='        <name-map collection-handle="' + handle + '" form-name="legi" />'

	if name=='Políticas, Planejamento, Gestão e Projetos' or name == 'Produção Científica':
		texto='        <name-map collection-handle="' + handle + '" form-name="pppp" />'

	if name=='Produção Educacional':
		texto='        <name-map collection-handle="' + handle + '" form-name="lom" />'

	if name=='Produção Informacional e/ou Multimídia':
		texto='        <name-map collection-handle="' + handle + '" form-name="multimedia" />'

	print texto

