PROGRAM rullo;
PROCEDURE Dimension;
BEGIN
  WRITELN('a. 5x5');
  WRITELN('b. 6x6');
  WRITELN('c. 7x7');
END;

PROCEDURE RangoDeCifras;
BEGIN
  WRITELN('a. 1-9');
  WRITELN('b. 1-19');
END;

PROCEDURE Ayuda;
BEGIN
  WRITELN('El juego consiste en que la suma de los numeros de cada fila o columna  debe ser igual al numero de la caja');
  WRITELN('usted debe clickar sobre un numero para excluirlo de la suma');

END;

PROCEDURE Tabla(VAR opcionDimension,opcionRango:char);
BEGIN

  REPEAT
    Dimension;
    WRITELN;
    WRITELN('Selecciona la dimension: a, b o c');
    READLN(opcionDimension);
    IF(opcionDimension<>'a')OR(opcionDimension<>'b')OR(opcionDimension<>'c')THEN
        WRITELN('seleccion erronea, pruebe otra vez');
  until(opcionDimension='a')OR(opcionDimension='b')OR(opcionDimension='c');

  REPEAT
    RangoDeCifras;
    WRITELN;
    WRITELN('Selecciona el rango de cifras: a o b');
    READLN(opcionRango);
    IF(opcionRango<>'a')OR(opcionRango>'b')THEN
        WRITELN('seleccion erronea, pruebe otra vez');
  until(opcionRango='a')OR(opcionRango='b');

END;

PROCEDURE Menu;
BEGIN
  WRITELN('1.Obtener ayuda');
  WRITELN('2.Seleccionar la dimension');
  WRITELN('3.Leer ranking');
END;

PROCEDURE JuegoDelRullo;
VAR
  opcionMenu:integer;
BEGIN

  WRITELN('! BIENVENIDO AL JUEGO DEL RULO ¡');
  WRITELN;
  WRITELN('MODO CLASICO');
  WRITELN;
  REPEAT
     Menu;
     WRITELN;
     WRITELN('seleccione una opcion del menu: 1, 2 o 3');
     READLN(opcionMenu);
     IF(opcionMenu<1)OR(opcionMenu>3)THEN
        WRITELN('seleccion erronea, pruebe otra vez');
  until(opcionMenu>=1)AND(opcionMenu<=3);
  CASE opcionMenu OF
     1:Ayuda;
     2:Tabla;
     3:Ranking;
  END;

END;

BEGIN
  RANDOMIZE;
READLN;
END. 
