//Bibliotecas
#Include "Totvs.ch"

/*/{Protheus.doc} A410Cons
    Ponto de entrada para incluir mais bot�es nas rotinas de usu�rio no pedido de vendas
    @type function
    @version 12.1.25
    @author Jonas Machado
    @since 15/12/2021
    @return array, aBotoes
/*/
User Function A410Cons()

    Local aArea     := GetArea() //Captura a �rea
    Local aBotoes   := {}        //Array de retorno dos bot�es a serem adicionados

    //Se for inclus�o de novo pedido
    If INCLUI
        aAdd(aBotoes,{"Importa SA", {||U_IMPSA()}, "Importa SA","Importa SA"} )
    EndIf

    RestArea(aArea)

Return(aBotoes)
