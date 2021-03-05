program play2048;

uses 
    sysutils,
    crt;

type
    Col = Array[1..4] of Integer;
    B = Array[1..4] of Col;

var
    board: B;
    game: Boolean;
    boardString: String;
    move: Char;
    score: Integer;


function clearScreen(t: Integer): Boolean;
var 
    i: Integer;
begin
    for i := 1 to t do writeln();
end;


function printBoard(board: B): B;
var
    r, c, l, i: Integer;
    p, ls, line: String;


begin
    clearScreen(32);
    // Get Longest Number's Length
    l := 0;
    for r := 1 to 4 do
        for c := 1 to 4 do
            begin
                Str(board[r][c], ls);
                if Length(ls) > l then l := Length(ls);
            end;

    writeln('***2048***     Score: ', score);

    for r := 1 to 4 do
    begin
        line := '';
        for c := 1 to 4 do
        begin
            if board[r][c] = 0 then p := ' ' else Str(board[r][c], p);
            for i := 1 to (l - Length(p)) do line := line + ' ';
            line := line + p;
            if c <> 4 then line := line + ' | ';
        end;
        writeln(line);
    end;
end;

function boardToString(board: B): String;
var
    r, c: Integer;
    result: String;
begin
    result := '';
    for r := 1 to 4 do
        for c := 1 to 4 do
            result := result + IntToStr(board[r][c]);
    boardToString := result;

end;

function boardFull(board: B): Boolean;
var
    r, c: Integer;
    check: Boolean;

begin
    check := true;
    for r := 1 to 4 do
        for c := 1 to 4 do
            if board[r][c] = 0 then check := false;
    boardFull := check;
end;

function generateNumber(board: B): B;
var
    rr, rc, rand: Integer;
    done: Boolean;

begin
    // randomize
    rand := Random(4);
    if rand >= 3 then rand := 4 else rand := 2;
    while boardFull(board) = false do
    begin
        rr := random(4) + 1;
        rc := random(4) + 1;
        if board[rr][rc] = 0 then 
            begin
                board[rr][rc] := rand;
                done := true;
                break;
            end;
    end;
    generateNumber := board;
end;

function slide(row: Col): Col;
var
    // r, c: Integer;
    counter, i: Integer;
    newRow: Col;
begin

    for i := 1 to 4 do
        newRow[i] := 0;

    counter := 1;
    for i := 1 to 4 do
        if row[i] <> 0 then 
        begin
            newRow[counter] := row[i];
            counter := counter + 1;
        end;
    slide := newRow;
end;

function combine(row: Col): Col;
var
    counter, i: Integer;
    newRow: Col;
begin
    for i := 1 to 4 do
        newRow[i] := 0;

    for i := 1 to 3 do
        begin
            if row[i] = row[i+1] then
            begin
                row[i] := row[i] + row[i+1];
                row[i+1] := 0;
                score := score + row[i];
            end;
        end;
    combine := row;
end;

function rotateBoard(board: B): B;
var
    newBoard: B;
    r, c: Integer;
begin

    for r := 1 to 4 do
        for c := 1 to 4 do
            newBoard[r][c] := board[c][5-r];
    rotateBoard := newBoard;
end;

function checkPossibleMove(board: B): Boolean;
var
    possible: Boolean;
    boardString: String;
    i, j: Integer;
begin
    possible := false;

    for i := 1 to 4 do 
        begin
            board := rotateBoard(board);
            boardString := boardToString(board);
            for j := 1 to 4 do 
                begin
                    board[j] := combine(board[j]);                    
                end;
            if boardString <> boardToString(board) then
                begin
                    possible := true;
                    break;
                end;
        end;
    checkPossibleMove := possible;
end;

function slideBoard(board: B; rotation: Integer): B;
var
    r, c: Integer;

begin
    // writeln('Sliding Board with rotation: ', rotation);
    rotation := rotation div 90;
    for c := 1 to rotation do board := rotateBoard(board);
    // writeln('Rotated ', rotation);
    for r := 1 to 4 do
        begin
            board[r] := slide(board[r]);
            board[r] := combine(board[r]);
            board[r] := slide(board[r]);

        end;

    for c := 1 to (4 - rotation) do board := rotateBoard(board);
    // writeln('Rotated ', (4 - rotation));



    slideBoard := board;
end;



begin
    randomize;
    // Board [ Row ] [ Col ]
    // Initialise Board
    board := generateNumber(board);
    board := generateNumber(board);
    printBoard(board);
    game := true;

    while (boardFull(board) = false) or checkPossibleMove(board) do
    begin
        boardString := boardToString(board);
        writeln();
        write('Your Move (Use w a s d): ');
        // readln(move);
        move := readkey();
        writeln('Move: ', move);
        if move = 'w' then board := slideBoard(board, 90) else   
        if move = 'a' then board := slideBoard(board, 0) else 
        if move = 's' then board := slideBoard(board, 270) else  
        if move = 'd' then board := slideBoard(board, 180);



        if boardString <> boardToString(board) then board := generateNumber(board);
        printBoard(board);
    end;
    writeln('Game End');
    writeln('Your Score Was ', score);
end.
