program Rullo;

CONST
  MIN=1;
  MAX=300;
TYPE
   TLimite=MIN..MAX;
   TCelda=RECORD
     visible:integer;
     sumable:integer;
     activado:boolean;
   end;

   TPartida=RECORD
      nombreJugador:String[40];
      puntuacion:integer;
      tipo:char;
   end;

   TTabla=ARRAY[TLimite,TLimite]OF TCelda;
   TArrayPartidas=ARRAY[TLimite]OF TPartida;
   TFicheroPartidas=FILE OF TPartida;

VAR
  tope:integer;

PROCEDURE ElegirPartida;
BEGIN
    //textcolor(lightred);

      WRITELN(' PARTIDAS DISPONIBLES ');
      WRITELN('     5x5  6x6  7x7');
      WRITELN(' 1-9  A    B    C');
      WRITELN('1-19  D    E    F');

END;

PROCEDURE Ayuda;
BEGIN

  WRITELN;
  WRITELN(' AYUDA ');
  WRITELN;
  WRITELN('El juego consiste en que la suma de los numeros de cada fila -numeros de la ultima columna de la derecha de la tabla- o columna -numeros de la primera fila, encima de la tabla-  debe ser igual al numero del sumatorio de filas o de columnas esperado.');
  WRITELN('usted debe seleccionar un numero para excluirlo de la suma hasta conseguir que la suma de los restantes numeros sean iguales a los del sumatorio.');
  WRITELN;
  WRITELN('Para seleccionar un numero, debe indicar el numero de fila y columna de la cifra que quiere activar o desactivar.');
  WRITELN;
  WRITE('Se  desactivara una cifra poniendose un 0 en la posicion indicada y se activara poniendose el valor original. ');
  WRITELN('Debe tener en cuenta que inicialennte todas las cifras estan activadas.');
  WRITELN;
  WRITE('Por ultimo, para poder abandonar una partida el tablero se debe haber inicializado; en ese caso podra seleccionar la opcion de salir');
  WRITELN;
  WRITELN;
  WRITELN('TECLEE CUALQUIER TECLA PARA VOLVER A INICIO');
  READLN;

END;

PROCEDURE ActualizarSumatorioFila(VAR tablaF:TTabla;i,aux,dim:integer);
VAR
  j:integer;
BEGIN

    FOR j:=MIN TO dim DO
      tablaF[i,j].sumable:=aux;

end;

PROCEDURE ActualizarSumatorioColumna(VAR tablaC:TTabla;j,aux,dim:integer);
VAR
  i:integer;
BEGIN

    FOR i:=MIN TO dim DO
      tablaC[i,j].sumable:=aux;

end;

FUNCTION VerificarSumatorioEsperadoNoNulo(tablaF,tablaC:TTabla;dim:integer):boolean;
VAR
  i,j:integer;
  filaNula,columnaNula:boolean;
BEGIN

   i:=MIN;j:=MIN;
   REPEAT
      IF(tablaF[i,MIN].sumable<>0)THEN BEGIN
          i:=i+1;
          filaNula:=FALSE;
      end
      ELSE IF(tablaF[i,MIN].sumable=0)THEN
          filaNula:=TRUE;
   until(i=succ(dim))OR(filaNula=TRUE);

    REPEAT
      IF(tablaC[MIN,j].sumable<>0)THEN BEGIN
          j:=j+1;
          columnaNula:=FALSE;
      end
      ELSE IF(tablaC[MIN,j].sumable=0)THEN
          columnaNula:=TRUE;
   until(i=succ(dim))OR(columnaNula=TRUE);

   VerificarSumatorioEsperadoNoNulo:=(NOT filaNula)AND(NOT columnaNula);

end;

PROCEDURE ActualizarFila(VAR tablaF_Bis:TTabla;fila,dim:integer);
VAR
  j,aux,suma:integer;
BEGIN

  suma:=0;
  FOR j:=MIN TO dim DO BEGIN
    aux:=tablaF_Bis[fila,j].visible;
    suma:=suma+aux;
  end;
  ActualizarSumatorioFila(tablaF_Bis,fila,suma,dim);

end;

PROCEDURE ActualizarColumna(VAR tablaC_Bis:TTabla;columna,dim:integer);
VAR
  i,aux,suma:integer;
BEGIN

  suma:=0;
  FOR i:=MIN TO dim DO BEGIN
    aux:=tablaC_Bis[i,columna].visible;
    suma:=suma+aux;
  end;
  ActualizarSumatorioColumna(tablaC_Bis,columna,suma,dim);

end;

PROCEDURE InicializarTablaResultado(VAR tablaF:TTabla;VAR tablaC:TTabla;dim,rango,posDesactivables:integer);
VAR
  i,j,cifraDesactivable,pos,aux,visible:integer;
BEGIN

  pos:=0;aux:=0;
  FOR i:=MIN TO dim DO BEGIN
    FOR j:=MIN TO dim DO BEGIN
      tablaF[i,j].visible:=RANDOM(rango)+1;
       tablaC[i,j].visible:=tablaF[i,j].visible;
       tablaF[i,j].activado:=TRUE;
       tablaC[i,j].activado:=TRUE;
    END;
  end;

  aux:=0;i:=MIN;j:=MIN;
  REPEAT
  cifraDesactivable:=RANDOM(rango)+1;
  WHILE(i<=dim)AND(pos<=posDesactivables)DO BEGIN

    WHILE(j<=dim)DO BEGIN
       IF(pos<=posDesactivables)AND(tablaF[i,j].visible=cifraDesactivable)THEN BEGIN
              tablaF[i,j].activado:=FALSE;
              tablaC[i,j].activado:=FALSE;
              pos:=pos+1;
       end
       ELSE IF(tablaF[i,j].visible<>cifraDesactivable)THEN BEGIN
          IF(tablaF[i,j].activado=TRUE)THEN BEGIN
             visible:=tablaF[i,j].visible;
             aux:=aux+visible;
          end;
       end;
       j:=j+1;
       cifraDesactivable:=RANDOM(rango)+1;
    END;{WHILE}

    ActualizarSumatorioFila(tablaF,i,aux,dim);
    aux:=0;
    cifraDesactivable:=RANDOM(rango)+1;
    i:=i+1;j:=1;
  end;
  i:=1;j:=1;
  until(pos>posDesactivables);

END;

PROCEDURE ActualizarTablaColumnas(VAR tablaC:TTabla;dim:integer);
VAR
  j,i,aux,visible:integer;

BEGIN

  aux:=0;j:=1;
  WHILE(j<=dim)DO BEGIN
    FOR i:=MIN TO dim DO BEGIN
       IF(tablaC[i,j].activado=TRUE)THEN BEGIN
             visible:=tablaC[i,j].visible;
             aux:=aux+visible;
       END;
    END;{FOR}
    ActualizarSumatorioColumna(tablaC,j,aux,dim);
    aux:=0;
    j:=j+1;
  END;{WHILE}

END;


PROCEDURE MostrarTabla(tablaF,tablaC,tablaF_Bis,tablaC_Bis:TTabla;dim:integer);
VAR
  i,j,k:integer;
BEGIN

  FOR j:=MIN TO dim DO
       WRITE(tablaC_Bis[1,j].sumable:5);
  WRITELN;
  WRITELN;

  FOR j:=MIN TO dim DO
       WRITE(tablaC[1,j].sumable:5);
  WRITELN;
  WRITELN;
  WRITELN;

  k:=1;
  FOR i:=MIN TO dim DO BEGIN
    FOR j:=MIN TO dim DO BEGIN
       WRITE(tablaF_Bis[i,j].visible:5);//rellena las columnas de una fila
    end;
    WRITE(tablaF[k,1].sumable:8);
    WRITE(tablaF_Bis[k,1].sumable:10);
    k:=k+1;
    WRITELN; //salta a la siguiente fila
  end;
  WRITELN;
  WRITELN;

END;

PROCEDURE Sumatorio(tablaF,tablaC:TTabla;dim:integer);
VAR
  i,j:integer;
BEGIN

  WRITE('SUMATORIO FILAS ESPERADO -penultima columna a la derecha de la tabla-: ');
  FOR i:=MIN TO dim DO
       WRITE(tablaF[i,1].sumable:2,', ');//rellena las columnas de una fila
  WRITELN;
  WRITELN;

  WRITE('SUMATORIO COLUMNAS ESPERADO -segunda fila situada encima de la  tabla-: ');
  FOR j:=MIN TO dim DO
       WRITE(tablaC[1,j].sumable:2,', ');
  WRITELN;
  WRITELN;

END;

PROCEDURE Activacion(VAR tablaF:TTabla;VAR tablaC:TTabla;dim:integer);
VAR
  i,j:integer;
BEGIN

  FOR i:=MIN TO dim DO BEGIN
    FOR j:=MIN TO dim DO BEGIN
       tablaF[i,j].activado:=TRUE;
       tablaC[i,j].activado:=TRUE;
    end;
  end;

end;

PROCEDURE DuplicarTablas(tablaF,tablaC:TTabla;VAR tablaF_Bis,tablaC_Bis:TTabla;dim:integer);
VAR
  i,j:integer;
BEGIN

  Activacion(tablaF,tablaC,dim);
  FOR i:=MIN TO dim DO BEGIN
    FOR j:=MIN TO dim  DO BEGIN
      tablaF_Bis[i,j].visible:=tablaF[i,j].visible;
      tablaF_Bis[i,j].activado:=tablaF[i,j].activado;
      tablaC_Bis[i,j].visible:=tablaC[i,j].visible;
      tablaC_Bis[i,j].activado:=tablaC[i,j].activado;
    end;
  end;

end;

PROCEDURE InicializarTablaPartida(VAR tablaF_Bis:TTabla;VAR tablaC_Bis:TTabla;dim:integer);
VAR
  i,j,fil,col,aux,suma:integer;
BEGIN

  suma:=0;
  FOR i:= MIN TO dim DO BEGIN
    FOR j:=MIN TO dim DO BEGIN
      aux:=tablaF_Bis[i,j].visible;
      suma:=suma+aux;
    end;
    ActualizarSumatorioFila(tablaF_Bis,i,suma,dim);
    suma:=0;
  end;

  suma:=0;col:=MIN;
  WHILE(col<=dim)DO BEGIN
    FOR fil:=MIN TO dim DO BEGIN
      aux:=tablaC_Bis[fil,col].visible;
      suma:=suma+aux;
    end;
    ActualizarSumatorioColumna(tablaC_Bis,col,suma,dim);
    suma:=0;
    col:=col+1;
  end;

end;

FUNCTION JuegoFinalizado(tablaF_Bis,tablaF,tablaC_Bis,tablaC:TTabla;dim:integer):boolean;
VAR
  aux,FilasIguales,ColumnasIguales:boolean;
  i,j:integer;
BEGIN

  FOR i:=MIN TO dim DO BEGIN
    FOR j:=MIN TO dim DO BEGIN
       IF(tablaF_Bis[i,j].sumable=tablaF[i,j].sumable)THEN
           aux:=TRUE
        ELSE IF(tablaF_Bis[i,j].sumable<>tablaF[i,j].sumable)THEN
           aux:=FALSE;
    end;
  end;

  FilasIguales:=aux;

  FOR i:=MIN TO dim DO BEGIN
    FOR j:=MIN TO dim DO BEGIN
       IF(tablaC_Bis[i,j].sumable=tablaC[i,j].sumable)THEN
           aux:=TRUE
        ELSE IF(tablaC_Bis[i,j].sumable<>tablaC[i,j].sumable)THEN
           aux:=FALSE;
    end;
  end;

  ColumnasIguales:=aux;

  JuegoFinalizado:=(FilasIguales)AND(ColumnasIguales);

end;

FUNCTION ExistePartidaEnFichero(VAR fich:TFicheroPartidas;VAR partida:TArrayPartidas;VAR tope:integer):boolean;
VAR
  partidaEnFichero:boolean;
  i:integer;
  ruta:String[100];
BEGIN

WRITELN('escriba la ruta de su fichero .bin  o .dat');
READLN(ruta);
ASSIGN(fich,ruta);
{$I-}
   RESET(fich);
{$I+}
IF(IORESULT=0)THEN BEGIN

  i:=0;
  REPEAT
    i:=i+1;
    IF(NOT EOF(fich))THEN
      READ(fich,partida[i]);
  UNTIL(NOT EOF(fich))OR(partida[tope].nombreJugador=partida[i].nombreJugador);
  IF(EOF(fich))AND(partida[tope].nombreJugador=partida[i].nombreJugador)THEN
      partidaEnFichero:=FALSE
  ELSE IF(NOT EOF(fich))AND(partida[tope].nombreJugador=partida[i].nombreJugador)THEN
      partidaEnFichero:=TRUE;

END
ELSE BEGIN
  WRITELN('FICHERO NO ENCONTRADO');
  REWRITE(fich);
END;
close(fich);

ExistePartidaEnFichero:=partidaEnFichero;

end;

FUNCTION PosicionPartidaEnFichero(VAR fich:TFicheroPartidas;VAR partida:TArrayPartidas;VAR tope:integer):integer;
VAR
  i:integer;
  ruta:String[100];
BEGIN

WRITELN('escriba la ruta de su fichero .bin  o .dat');
READLN(ruta);
 ASSIGN(fich,ruta);
{$I-}
   RESET(fich);
{$I+}
IF(IORESULT=0)THEN BEGIN

  i:=0;
  REPEAT
    i:=i+1;
    IF(NOT EOF(fich))THEN
      READ(fich,partida[i]);
  UNTIL(partida[tope].nombreJugador=partida[i].nombreJugador);
  IF(partida[tope].nombreJugador=partida[i].nombreJugador)THEN
    PosicionPartidaEnFichero:=FILEPOS(fich)-1;

END
ELSE BEGIN
  WRITELN('FICHERO NO ENCONTRADO');
  REWRITE(fich);
END;
close(fich);

end;

PROCEDURE SobreescribirFichero(VAR fich:TFicheroPartidas;VAR partida:TArrayPartidas;VAR tope:integer;posicion:longInt);
BEGIN

{$I-}
   RESET(fich);
{$I+}
IF(IORESULT=0)THEN BEGIN
  SEEK(fich,posicion);
   IF(partida[tope].nombreJugador=partida[posicion].nombreJugador)THEN BEGIN
      partida[tope].puntuacion:=partida[posicion].puntuacion;
      WRITE(fich,partida[tope]);
      WRITELN('PARTIDA GUARDADA');
   end
   ELSE
     WRITELN('ERROR DE ACTUALIZACION');

END
ELSE BEGIN
  WRITELN('FICHERO NO ENCONTRADO');
  REWRITE(fich);
END;
close(fich);

end;

PROCEDURE GuardarPartida(VAR fich:TFicheroPartidas;VAR partida:TArrayPartidas;VAR tope:integer;numMovimientos:integer;opcionPartida:char);
VAR
  pos:longInt;
  ruta:String[100];
BEGIN

  WRITELN('Escriba su nombre para guardar la partida');
  READLN(partida[tope].nombreJugador);
  partida[tope].puntuacion:=numMovimientos;
  partida[tope].tipo:=opcionPartida;

  WRITELN('escriba la ruta de su fichero .bin  o .dat');
  READLN(ruta);
  ASSIGN(fich,ruta);

  IF(NOT ExistePartidaEnFichero(fich,partida,tope))THEN BEGIN
     {$I-}
        RESET(fich);
     {$I+}
     IF(IORESULT=0)THEN BEGIN
        WRITE(fich,partida[tope]);
        WRITELN('PARTIDA GUARDADA');
     end
     ELSE BEGIN
       REWRITE(fich);
       WRITE(fich,partida[tope]);
     end;
     close(fich);
  end
  ELSE IF(ExistePartidaEnFichero(fich,partida,tope))THEN BEGIN
    pos:=PosicionPartidaEnFichero(fich,partida,tope);
    SobreescribirFichero(fich,partida,tope,pos);
  end;

end;

PROCEDURE OrdenarPartidas(VAR partida:TArrayPartidas;VAR tope:integer);
VAR
  i,j:integer;
  aux:TPartida;
BEGIN

  FOR i:=MIN TO pred(tope)DO BEGIN
    FOR j:=MIN TO tope-i DO BEGIN
      IF(partida[j].puntuacion>partida[j+1].puntuacion)THEN BEGIN
          aux:=partida[j+1];
          partida[j+1]:=partida[j];
          partida[j]:=aux;
      end;
    end;
  end;

end;

PROCEDURE Ranking(VAR partida:TArrayPartidas;VAR tope:integer);
VAR
  i:integer;
BEGIN

  IF(tope=0)THEN BEGIN
      WRITELN('ranking vacio');
      WRITELN;
  END
  ELSE BEGIN
     OrdenarPartidas(partida,tope);

     FOR i:=MIN TO tope DO BEGIN
        WRITELN('nombre del jugador: ',partida[i].nombreJugador);
        WRITELN('puntuacion: ',partida[i].puntuacion);
        WRITELN('tipo de partida: ',partida[i].tipo);
        WRITELN;
     end;
     WRITELN('PRESIONE CUALQUIER TECLA PARA VOLVER A INICIO');
     READLN;
  end;

END;

PROCEDURE JugarPartida(tablaF,tablaC:TTabla;VAR tablaF_Bis:TTabla;VAR tablaC_Bis:TTabla;dimension:integer;VAR tope:integer;VAR partida:TArrayPartidas;opcionPartida:char);
VAR
  fila,columna,numMovimientos:integer;
  opcion:string[5];
  fich:TFicheroPartidas;
BEGIN

   InicializarTablaPartida(tablaF_Bis,tablaC_Bis,dimension);

numMovimientos:=0;

REPEAT
  WRITELN('escriba -salir- si quiere abandonar la partida o teclee cualquier otra tecla si quiere continuar');
  READLN(opcion);
  IF(opcion='Salir')OR(opcion='SALIR')OR(opcion='salir')THEN BEGIN
     WRITELN('abandonando partida...');
     WRITELN;
  END
  ELSE IF(opcion<>'Salir')AND(opcion<>'SALIR')AND(opcion<>'salir')THEN BEGIN
     WRITELN('escriba la fila y columna de la cifra que quiere activar o desactivar');
     READLN(fila);
     READLN(columna);
  //cifra activada
     IF(tablaF_Bis[fila,columna].activado=TRUE)THEN BEGIN
        tablaF_Bis[fila,columna].visible:=0;
        tablaF_Bis[fila,columna].activado:=FALSE;//desactivar
        tablaC_Bis[fila,columna].visible:=0;
        tablaC_Bis[fila,columna].activado:=FALSE;
        ActualizarFila(tablaF_Bis,fila,dimension);
        ActualizarColumna(tablaC_Bis,columna,dimension);
        MostrarTabla(tablaF,tablaC,tablaF_Bis,tablaC_Bis,dimension);
        Sumatorio(tablaF,tablaC,dimension);
        numMovimientos:=numMovimientos+1;
     end
  //cifra desactivada
     ELSE IF(tablaF_Bis[fila,columna].activado=FALSE)THEN BEGIN
        tablaF_Bis[fila,columna].activado:=TRUE; //activar
        tablaC_Bis[fila,columna].activado:=TRUE;
        tablaF_Bis[fila,columna].visible:=tablaF[fila,columna].visible;
        tablaC_Bis[fila,columna].visible:=tablaC[fila,columna].visible;
        ActualizarFila(tablaF_Bis,fila,dimension);
        ActualizarColumna(tablaC_Bis,columna,dimension);
        MostrarTabla(tablaF,tablaC,tablaF_Bis,tablaC_Bis,dimension);
        Sumatorio(tablaF,tablaC,dimension);
        numMovimientos:=numMovimientos+1;
     end;
  end;
UNTIL(opcion='Salir')OR(opcion='SALIR')OR(opcion='salir')OR(JuegoFinalizado(tablaF_Bis,tablaF,tablaC_Bis,tablaC,dimension));
IF(JuegoFinalizado(tablaF_Bis,tablaF,tablaC_Bis,tablaC,dimension))THEN BEGIN
    WRITELN('enhorabuena!!!!');
    WRITELN('numero movimientos totales: ',numMovimientos);
    tope:=tope+1;
    GuardarPartida(fich,partida,tope,numMovimientos,opcionPartida);
END;

end;
PROCEDURE InicializarPartida(VAR tope:integer;VAR partida:TArrayPartidas;dimension,rango,posDesactivable:integer;opcionPartida:char);
VAR
  tablaF,tablaC,tablaF_Bis,tablaC_Bis:TTabla;
BEGIN

                InicializarTablaResultado(tablaF,tablaC,dimension,rango,posDesactivable);
                ActualizarTablaColumnas(tablaC,dimension);
                DuplicarTablas(tablaF,tablaC,tablaF_Bis,tablaC_Bis,dimension);
                InicializarTablaPartida(tablaF_Bis,tablaC_Bis,dimension);
                MostrarTabla(tablaF,tablaC,tablaF_Bis,tablaC_Bis,dimension);
                Sumatorio(tablaF,tablaC,dimension);
                JugarPartida(tablaF,tablaC,tablaF_Bis,tablaC_Bis,dimension,tope,partida,opcionPartida);
end;

PROCEDURE Juego(VAR tope:integer;VAR partida:TArrayPartidas);
VAR
  dimension,rango,posDesactivable:integer;
  opcionPartida:char;
BEGIN

     REPEAT
        ElegirPartida;
        WRITELN;
        WRITELN('Escriba el tipo de partida que quiere jugar -A, B, C, D, E o F- ');
        READLN(opcionPartida);
        opcionPartida:= UPCASE(opcionPartida);
        IF(opcionPartida<'A')AND(opcionPartida>'F')THEN BEGIN
           WRITELN('opcion erronea, intentelo de nuevo');
           WRITELN;
        end;
     UNTIL(opcionPartida>='A')AND(opcionPartida<='F');

    CASE opcionPartida OF
       'A','B','C':BEGIN
                rango:=9;
                IF(opcionPartida='A')THEN BEGIN
                        dimension:=5; posDesactivable:=10;
                END;
                IF(opcionPartida='B')THEN BEGIN
                       dimension:=6; posDesactivable:=12;
                END;
                IF(opcionPartida='C')THEN BEGIN
                dimension:=7; posDesactivable:=14;
                END;
            END;
       'D','E','F':BEGIN
               rango:=19;
               IF(opcionPartida='D')THEN BEGIN
                   dimension:=5; posDesactivable:=10;
               END;
               IF(opcionPartida='E')THEN BEGIN
                   dimension:=6; posDesactivable:=12;
               END;
               IF(opcionPartida='F')THEN BEGIN
                   dimension:=7; posDesactivable:=14;
               END;
          END;
    end;{CASE}
InicializarPartida(tope,partida,dimension,rango,posDesactivable,opcionPartida);

END;

PROCEDURE OpcionesDelMenu;
//con esta función se muestra por pantalla las opciones disponibles antes de jugar, aparecerá nada más entrar en la app
BEGIN

  WRITELN(' MENU ');
  WRITELN('1.Obtener ayuda');
  WRITELN('2.Elegir partida');
  WRITELN('3.Leer ranking');
  WRITELN('4.Salir');

END;

PROCEDURE MenuPrincipalDelJuego(VAR tope:integer);
//el usuario seleccionará una de las tres opciones del menu, esto se repetirá tantas veces hasta que el usuario seleccione una opción del menú, después será un case
VAR
  opcionMenu:integer;
  partida:TArrayPartidas;
BEGIN

  WRITELN('!!! BIENVENIDO AL JUEGO DEL RULO !!!');
  WRITELN;
  WRITELN(' MODO CLASICO ');
  WRITELN;
REPEAT

  REPEAT
     OpcionesDelMenu;
     WRITELN;
     WRITELN('seleccione una opcion del menu: 1, 2, 3 o 4');
     READLN(opcionMenu);
     IF(opcionMenu<1)OR(opcionMenu>4)THEN BEGIN
        WRITELN('seleccion erronea, pruebe otra vez');
        WRITELN;
     end;
  until(opcionMenu>=1)AND(opcionMenu<=4);

  CASE opcionMenu OF
     1:Ayuda;
     2:Juego(tope,partida);
     3:Ranking(partida,tope);
     4:WRITELN(' HASTA PRONTO! ');
  END;


until(opcionMenu=4);

END;

BEGIN

  RANDOMIZE;
  tope:=0;
  MenuPrincipalDelJuego(tope);

READLN;
END.
                                                                        
        
