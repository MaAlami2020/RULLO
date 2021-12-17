PROGRAM Partida;
  USES crt;
  {Muestra los tipos de partidas y recoge la escogida}
  FUNCTION ElegirPartida:char;
    VAR c: char;
    BEGIN
      textcolor(lightred);
      REPEAT
        WRITELN('     5x5  6x6  7x7');
        WRITELN(' 1-9  A    B    C');
        WRITELN('1-19  D    E    F');
        WRITE('Escriba el tipo de partida que quiere jugar ');c:= readkey;
        CLRSCR;
      UNTIL(c='a') or (c='b') or (c='c') or (c='d') or (c='e') or (c='f');
      ElegirPartida:= UPCASE(c);
    END;

BEGIN
  WRITELN(ElegirPartida);
  READLN;
END.
