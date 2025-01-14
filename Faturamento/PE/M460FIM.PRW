// Bibliotecas necess�rias
#Include 'TOTVS.ch'

/*/{Protheus.doc} M460FIM
    Ponto de entrada utilizado para atualizar o status do pedido ap�s o faturamento
    @type function
    @version 12.1.25
    @author Jonas Machado
    @since 26/07/2021
/*/
User Function M460FIM()
    Local aArea := GetArea() // Armazena a �rea atual
	// Processa apenas se n�o for a filial 030101
    If (FwCodFil() != '030101')
        DbSelectArea("SC5")
        DbSeek(FwXFilial("SC5") + SC9->C9_PEDIDO)
        If Found()
            RecLock("SC5",.F.)
                If EMPTY(SC5->C5_NOTA)
                    SC5->C5_BLQ     := ''
                    SC5->C5_LIBEROK := ''
                    SC5->C5_BXSTATU := 'A'
                    SC5->C5_FSSTBI := 'PARCIAL'
                Else
                    SC5->C5_BLQ     := ''
                    SC5->C5_BXSTATU := ''
                    SC5->C5_LIBEROK := 'E'
                    SC5->C5_FSSTBI := 'ENCERRADO'
                EndIf
            MsUnlock()
        EndIf
        DbcloseArea()
        RestArea(aArea)
    EndIf

    // //Atualiza o status do pedido se, e somente se, a libera��o passe verdadeira
    // If lLiber
    //     DbSelectArea("QRYSC9")
    //     DbGoTop()
    //     //Percorre os pedidos encontrados na Sc9 e verifica se � de cliente com t�tulos em aberto (FFATVATR) ou se ele j� foi liberado anteriormente
    //     While QRYSC9->(!EOF())
    //         //Verifica se o alias est� aberto e o fecha caso esteja
    //         If Select("cAliasSc6") > 0
    //             DbSelectArea("cAliasSc6")
    //             cAliasSc6->(DbCloseArea())
    //         EndIf

    //         //Percorre os itens da Sc6 para verificar com qual status ir� salvar na Sc5
    //         BEGINSQL ALIAS "cAliasSc6"
    //             SELECT	DISTINCT
    //                 C6_NUM AS PEDC6,
    //                 C6_ITEM AS ITEM6,
    //                 C6_QTDVEN AS VEN,
    //                 C6_QTDENT AS ENT
    //             FROM
    //                 %TABLE:SC6% C6
    //             WHERE
    //                 C6_BLQ	<> 'R' AND 
    //                 C6_FILIAL	= %XFILIAL:SC6% AND 
    //                 C6_NUM	= %EXP:QRYSC9->PEDIDO% AND 
    //                 %NOTDEL%
    //         ENDSQL

    //         //Percorre os itens do pedido de venda
    //         While !cAliasSc6->(EOF())
    //             //Se a quantidade de venda for exatamente igual ao faturado o pedido fica encerrado
    //             If cAliasSc6->VEN == cAliasSc6->ENT .And. cAliasSc6->ITEM6 == cAliasSc6->ITEM6
    //                 DbSelectArea("SC5")
    //                 DbSetOrder(1)
    //                 DbSeek(FwXFilial("SC5") + cAliasSc6->PEDC6)
    //                 If Found()
    //                     RecLock("SC5", .F.)
    //                         SC5->C5_FSSTBI := 'ENCERRADO'
    //                         SC5->C5_BLQ     := ''
    //                         SC5->C5_BXSTATU := ''
    //                         SC5->C5_LIBEROK := 'E'
    //                     MsUnlock()
    //                 EndIf
    //                 //Se a quantidade de venda for maior que a entregue e a entregue for maior que 0, pedido fica parcial
    //             ElseIf (cAliasSc6->VEN > cAliasSc6->ENT .And. cAliasSc6->ENT > 0)
    //                 DbSelectArea("SC5")
    //                 DbSetOrder(1)
    //                 DbSeek(FwXFilial("SC5") + cAliasSc6->PEDC6)
    //                 If Found()
    //                     RecLock("SC5", .F.)
    //                         SC5->C5_FSSTBI := 'PARCIAL'
    //                         SC5->C5_BLQ     := ''
    //                         SC5->C5_BXSTATU := 'A'
    //                         SC5->C5_LIBEROK := ''
    //                         EXIT
    //                     MsUnlock()
    //                 EndIf
    //             EndIf
    //             //Pr�ximo item da Sc6
    //             cAliasSc6->(DbSkip())
    //         End
    //         //Fecha a �rea cAliasSc6
    //         cAliasSc6->(DbCloseArea())
    //         //Vai para o pr�ximo registro da QRYSC9
    //         QRYSC9->(DbSkip())
    //     End
    //     //Fecha a �rea da QRYSC9
    //     QRYSC9->(dbCloseArea())
    // EndIf
	// Restaura a �rea de trabalho anterior
	RestArea(aArea)
Return (NIL)
