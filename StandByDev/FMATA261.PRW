#Include "protheus.ch"
#Include "rwmake.ch"
#Include "tbiconn.ch"


User Function MyMata261()
Local aAuto := {}
Local aItem := {}
Local aLinha := {}
/*
    � necessario que:
    O parametro MV_LOCALIZ = S
    O produto com codigo PA001 tenha controle de endereco ativo
    O armazem padrao definido no produto deve ter 2 endere�os: ENDER01 e ENDER02
    Saldo inicial igual ou superior a 1
    E este saldo deve ser enderec�ado ao ENDER01
*/
Local aLista := {'PA001','PA001'} //Os produtos a serem utilizados
Local nX
Local nOpcAuto := 0
Local cDocumen := ""
Local lContinua := .T.

Private lMsErroAuto := .F.

PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "EST" TABLES "SB1", "SD3"

//
conout("Exemplo de inclus�o de movimenta��o multipla")

//Cabecalho a Incluir
cDocumen := GetSxeNum("SD3","D3_DOC")
aadd(aAuto,{cDocumen,dDataBase}) //Cabecalho

//Itens a Incluir
aItem := {}

for nX := 1 to len(aLista) step 2
    aLinha := {}
    //Origem
    SB1->(DbSeek(xFilial("SB1")+PadR(aLista[nX], tamsx3('D3_COD') [1])))
    aadd(aLinha,{"ITEM",'00'+cvaltochar(nX),Nil})
    aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //Cod Produto origem
    aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto origem
    aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida origem
    aadd(aLinha,{"D3_LOCAL", SB1->B1_LOCPAD, Nil}) //armazem origem
    aadd(aLinha,{"D3_LOCALIZ", PadR("ENDER01", tamsx3('D3_LOCALIZ') [1]),Nil}) //Informar endereço origem
    
    //Destino
    SB1->(DbSeek(xFilial("SB1")+PadR(aLista[nX+1], tamsx3('D3_COD') [1])))
    aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //cod produto destino
    aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto destino
    aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida destino
    aadd(aLinha,{"D3_LOCAL", SB1->B1_LOCPAD, Nil}) //armazem destino
    aadd(aLinha,{"D3_LOCALIZ", PadR("ENDER02", tamsx3('D3_LOCALIZ') [1]),Nil}) //Informar endereço destino
    
    aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
    aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote Origem
    aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
    aadd(aLinha,{"D3_DTVALID", '', Nil}) //data validade
    aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
    aadd(aLinha,{"D3_QUANT", 1, Nil}) //Quantidade
    aadd(aLinha,{"D3_QTSEGUM", 0, Nil}) //Seg unidade medida
    aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno
    aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ
    
    aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote destino
    aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino
    aadd(aLinha,{"D3_DTVALID", '', Nil}) //validade lote destino
    aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade
    
    aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
    aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino
    
    aAdd(aAuto,aLinha)

Next nX
nOpcAuto := 3 // Inclusao
MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)

if lMsErroAuto
    MostraErro()
    lContinua := .F.
else
    //
    conout("Inclus�o de movimenta��o multipla efetuada com sucesso")
    lContinua := .T.
EndIf

conout("Finalizado a inclus�o de movimenta��o multipla")

If lContinua

    //
    conout("Exemplo de estorno de movimenta��o multipla baseado na inclus�o do movimenta��o multipla anterior")

    lMsErroAuto := .F.
    for nX := 1 to len(aLista) step 2
    
        //-- Preenchimento dos campos
        aAuto := {}
        aadd(aAuto,{"D3_DOC", cDocumen, Nil})
        aadd(aAuto,{"D3_COD", aLista[nX], Nil})
        
        DbSelectArea("SD3")
        DbSetOrder(2)
        DbSeek(xFilial("SD3")+cDocumen+aLista[nX])
    
        //-- Teste de Estorno
        nOpcAuto := 6 // Estornar
        MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
        
        If lMsErroAuto
            MostraErro()
        Else
            conout("Estorno de movimenta��o multipla efetuada com sucesso")
        EndIf

    Next nX
    conout("Finalizado a estorno de movimenta��o multipla")
EndIf
RESET ENVIRONMENT

Return
