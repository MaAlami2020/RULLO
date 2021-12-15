PROGRAM rullo;
PROCEDURE Dimension;
//es una función que mostrará por pantalla las dimensiones diponibles para este juego
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
//la ayuda no está completamente finalizada porque habrá que indicarle al usuario que opción pulsar para interrumpir una partida 
BEGIN
  WRITELN('El juego consiste en que la suma de los numeros de cada fila o columna  debe ser igual al numero de la caja');
  WRITELN('usted debe clickar sobre un numero para excluirlo de la suma');

END;

PROCEDURE Tabla(VAR opcionDimension,opcionRango:char);
//en esta función se seleccionará el tamaño de la tabla del juego, esto se repetirá hasta que seleccione una opción válid; cuando la opción ya sea válida se seleccionará el rango 1-9 o 1-19 y al igual que antes se repetirá hasta que haya hecho la selección correcta
//por otra parte, en principio, he puesto estos parámetros de salida para usarlos en una nueva funciónn que llamaré IniciarTabla; pero no es definitivo, tengo que probarlo
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
//con esta función se muestra por pantalla las opciones disponibles antes de jugar, aparecerá nada más entrar en la app
BEGIN
  WRITELN('1.Obtener ayuda');
  WRITELN('2.Seleccionar la dimension');
  WRITELN('3.Leer ranking');
END;

PROCEDURE JuegoDelRullo;
//el usuario seleccionará una de las tres opciones del menu, esto se repetirá tantas veces hasta que el usuario seleccione una opción del menú, después será un case
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
  JuegoDelRullo;
READLN;
END. 
