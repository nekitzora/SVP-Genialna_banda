function Matice()
    % Generovanie náhodnej matice A
    m = randi([2, 10]); % Náhodný počet riadkov (min 2, max 10)
    n = randi([2, 10]); % Náhodný počet stĺpcov (min 2, max 10)
    a = -100 + (200) * rand; % Dolná hranica intervalu
    b = a + (100 - a) * rand; % Horná hranica intervalu
    A = randi([floor(a), floor(b)], m, n); % Náhodná matica A
    B = A * A'; % Matica B = A * A'
    
    % Uloženie matíc do súboru Matice.txt
    dataInputPath = 'DataInput';
    if ~exist(dataInputPath, 'dir')
        mkdir(dataInputPath);
    end
    maticeFile = fullfile(dataInputPath, 'Matice.txt');
    fileID = fopen(maticeFile, 'w');
    fprintf(fileID, 'Hodnoty matice A:\n');
    fprintf(fileID, '%d ', A');
    fprintf(fileID, '\n\nHodnoty matice B = A * A'':\n');
    fprintf(fileID, '%d ', B');
    fclose(fileID);
    
    % Načítanie matice B zo súboru
    matB = B; % Simulované načítanie
    
    % Výpočty vlastností matice B
    hodnost = rank(matB);
    determinant = det(matB);
    if determinant ~= 0
        inverzna = inv(matB);
    else
        inverzna = 'Inverzná matica neexistuje (determinant je 0)';
    end
    
    % Uloženie výsledkov do súboru MaticeVysledky.txt
    dataOutputPath = 'DataOutput';
    if ~exist(dataOutputPath, 'dir')
        mkdir(dataOutputPath);
    end
    vysledkyFile = fullfile(dataOutputPath, 'MaticeVysledky.txt');
    fileID = fopen(vysledkyFile, 'w');
    fprintf(fileID, 'Hodnosť matice B: %d\n', hodnost);
    fprintf(fileID, 'Determinant matice B: %.2f\n', determinant);
    if isnumeric(inverzna)
        fprintf(fileID, 'Inverzná matica B:\n');
        fprintf(fileID, '%.2f ', inverzna');
    else
        fprintf(fileID, '%s\n', inverzna);
    end
    fclose(fileID);
    
    % Zobrazenie správy o úspešnom spracovaní
    msgbox('Spracovanie matíc bolo úspešné.', ' ', 'help');
end

