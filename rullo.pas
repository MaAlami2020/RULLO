PROGRAM rullo;
CONST
  MIN=1;
  MAX=7;
TYPE
   TLimite=MIN..MAX;
   TCelda=RECORD
     visible:integer;
     sumable:integer;
     activado:boolean;
   end;

   TTabla=ARRAY[TLimite,TLimite]OF TCelda;

PROCEDURE DimensionesDisponibles;
//es una función que mostrará por pantalla las dimensiones diponibles para este juego
BEGIN
  WRITELN(' DIMENSIONES DISPONIBLES');
  WRITELN('a. 5x5');
  WRITELN('b. 6x6');
  WRITELN('c. 7x7');
END;

PROCEDURE RangoDeCifrasDisponibles;
BEGIN
  WRITELN(' RANGO DE CIFRAS DISPONIBLES');
  WRITELN('a. 1-9');
  WRITELN('b. 1-19');
END;

PROCEDURE Ayuda;
//la ayuda no está completamente finalizada porque habrá que indicarle al usuario que opción pulsar para interrumpir una partida
BEGIN

  WRITELN('El juego consiste en que la suma de los numeros de cada fila o columna  debe ser igual al numero de la caja');
  WRITELN('usted debe clickar sobre un numero para excluirlo de la suma');

END;

FUNCTION VerificarDimension(opcionDimension:char):boolean;
BEGIN

  IF(opcionDimension=chr(65))OR(opcionDimension=chr(66))OR(opcionDimension=chr(67))THEN
     VerificarDimension:=TRUE
  ELSE
     VerificarDimension:=FALSE;

END;

FUNCTION SeleccionarDimension(opcionDimension:char):char;
BEGIN

  REPEAT
    DimensionesDisponibles;
    WRITELN;
    WRITELN('Selecciona la dimension: a, b o c');
    READLN(opcionDimension);
    opcionDimension:=UPCASE(opcionDimension);
    IF NOT VerificarDimension(opcionDimension) THEN
        WRITELN('seleccion erronea, pruebe otra vez');
  until(opcionDimension=chr(65))OR(opcionDimension=chr(66))OR(opcionDimension=chr(67));

  SeleccionarDimension:=opcionDimension;

END;

FUNCTION VerificarRango(opcionRango:char):boolean;
BEGIN

  IF(opcionRango=chr(65))OR(opcionRango=chr(66))THEN
     VerificarRango:=TRUE
  ELSE
     VerificarRango:=FALSE;

END;

FUNCTION SeleccionarRango(opcionRango:char):char;
BEGIN

  REPEAT
    RangoDeCifrasDisponibles;
    WRITELN;
    WRITELN('Selecciona el rango de cifras: a o b');
    READLN(opcionRango);
    opcionRango:=UPCASE(opcionRango);
    IF NOT VerificarRango(opcionRango) THEN BEGIN
        WRITELN('seleccion erronea, pruebe otra vez');
        WRITELN;
    end;
  until(opcionRango=chr(65))OR(opcionRango=chr(66));

  SeleccionarRango:=opcionRango;

END;


PROCEDURE InicializarTabla(VAR tabla:TTabla;dim,rango:integer);
VAR
  i,j:integer;
BEGIN

  FOR i:=MIN TO dim DO BEGIN
    FOR j:=MIN TO dim DO
    //el random pone los valores o del 1 al 9 o del 1 al 19
       tabla[i,j].visible:=RANDOM(rango)+1;
       tabla[i,j].sumable:=RANDOM(rango)+1;
      // tabla[i,j].activado:=boolean;
  end;

END;

PROCEDURE MostrarTabla(tabla:TTabla;dim:integer);
VAR
  i,j:integer;
BEGIN

  FOR i:=MIN TO dim DO BEGIN
    FOR j:=MIN TO dim DO BEGIN
       WRITE(tabla[i,j].visible:5);
    end;
    WRITELN;
  end;

END;

PROCEDURE Jugar(VAR tabla:TTabla);
VAR
  opcionDimension,opcionRango:char;
  valorDim,valorRango:integer;
BEGIN
//en esta función se llamara a 2 funciones, una que devolvera el tamaño de la tabla del juego, esto se repetirá hasta que seleccione una opción válida; cuando la opción ya sea válida se llamará a la funcion para obtener el rango 1-9 o 1-19 y al igual que antes se repetirá hasta que haya hecho la selección correcta
//cuando se salga de cada una de las funciones se almacenara el valor que devuelve en variable locales "opcionDimension" y "opcionRango"
    opcionDimension:=SeleccionarDimension(opcionDimension);
    opcionRango:=SeleccionarRango(opcionRango);
    CASE opcionRango OF
       'A':BEGIN
//si se selecciono 'a' o 'A' de dimension y 'a' o 'A' de rango se inicializza la tabla de celdas con valores aleatorios (falta revisar)
            IF(opcionDimension='A')THEN BEGIN
                valorDim:=5;valorRango:=9;
                InicializarTabla(tabla,valorDim,valorRango);
                MostrarTabla(tabla,valorDim);
            END;
            IF(opcionDimension='B')THEN BEGIN
                valorDim:=6;valorRango:=9;
                InicializarTabla(tabla,valorDim,valorRango);
                MostrarTabla(tabla,valorDim);
            END;
            IF(opcionDimension='C')THEN BEGIN
                valorDim:=7;valorRango:=9;
                InicializarTabla(tabla,valorDim,valorRango);
                MostrarTabla(tabla,valorDim);
            END;
        END;
        'B':BEGIN
            IF(opcionDimension='A')THEN BEGIN
                valorDim:=5;valorRango:=19;
                InicializarTabla(tabla,valorDim,valorRango);
                MostrarTabla(tabla,valorDim);
            END;
            IF(opcionDimension='B')THEN BEGIN
                valorDim:=6;valorRango:=19;
                InicializarTabla(tabla,valorDim,valorRango);
                MostrarTabla(tabla,valorDim);
            END;
            IF(opcionDimension='C')THEN BEGIN
                valorDim:=7;valorRango:=19;
                InicializarTabla(tabla,valorDim,valorRango);
                MostrarTabla(tabla,valorDim);
            END;
        END;
    end;{CASE}

END;

PROCEDURE Menu;
//con esta función se muestra por pantalla las opciones disponibles antes de jugar, aparecerá nada más entrar en la app
BEGIN
  WRITELN(' MENU ');
  WRITELN('1.Obtener ayuda');
  WRITELN('2.Seleccionar la dimension');
  WRITELN('3.Leer ranking');
  WRITELN('4.Salir');
END;

PROCEDURE JuegoDelRullo;
//el usuario seleccionará una de las tres opciones del menu, esto se repetirá tantas veces hasta que el usuario seleccione una opción del menú, después será un case
VAR
  opcionMenu:integer;
  tabla:TTabla;
BEGIN

  WRITELN('!!! BIENVENIDO AL JUEGO DEL RULO !!!');
  WRITELN;
  WRITELN(' MODO CLASICO ');
  WRITELN;

  REPEAT
     Menu;
     WRITELN;
     WRITELN('seleccione una opcion del menu: 1, 2 o 3');
     READLN(opcionMenu);
     IF(opcionMenu<1)OR(opcionMenu>3)THEN BEGIN
        WRITELN('seleccion erronea, pruebe otra vez');
        WRITELN;
     end;
  until(opcionMenu>=1)AND(opcionMenu<=3);

  CASE opcionMenu OF
     1:Ayuda;
     2:Jugar(tabla);
    // 3:Ranking;
    // 4:WRITELN('HASTA PRONTO!');
  END;

END;

BEGIN
  RANDOMIZE;
//he declarado como variable local dentro del procedure JuegoDelRullo a 'tabla' en vez de pasarlo como parametro porque he considerado que fuera del subprograma su valor no interesa
  JuegoDelRullo;
READLN;
END.  
