#Include "Totvs.ch"

/*/{Protheus.doc} FFATA002
	Cria tabela de hist�rico de libera��es
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 28/07/2021
/*/
User Function FFATA002()

	If FWCodFil() != "030101"
		AxCadastro("Z07","Hist�rico de Libera��es")
	EndIf	
Return
