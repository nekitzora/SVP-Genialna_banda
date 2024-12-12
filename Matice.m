function Matice()
    % Генерування випадкової матриці A з парною кількістю елементів
    while true
        m = randi([2, 10]); % Випадкова кількість рядків (мін 2, макс 10)
        n = randi([2, 10]); % Випадкова кількість стовпців (мін 2, макс 10)
        if mod(m * n, 2) == 0 % Перевірка: якщо кількість елементів парна, вийти з циклу
            break;
        end
    end
    
    % Генерування меж інтервалу
    a = -100 + (200) * rand; % Нижня межа інтервалу
    b = a + (100 - a) * rand; % Верхня межа інтервалу
    
    % Створення випадкової матриці A
    A = randi([floor(a), floor(b)], m, n);
    
    % Транспонування матриці A
    ATransposed = A';
    
    % Обчислення матриці B = A * A'
    B = A * ATransposed;
    % Uloženie matíc do súboru Matice.txt
    dataInputPath = 'DataInput';
    if ~exist(dataInputPath, 'dir')
        mkdir(dataInputPath);
    end
    maticeFile = fullfile(dataInputPath, 'Matice.txt');
    fileID = fopen(maticeFile, 'w');
    %
    fprintf(fileID, 'n:\n');
    fprintf(fileID, '%d ', n');
    %
    fprintf(fileID, 'm:\n');
    fprintf(fileID, '%d ', m');
    %
    fprintf(fileID, 'Hodnoty matice A:\n');
    fprintf(fileID, '%d ', A');
    %%%%%%%%%%%%%%%%%%%%%%%%
    fprintf(fileID, '\nHodnoty matice A*:\n');
    fprintf(fileID, '%d ', ATransposed');
    %%%%%%%%%%%%%%%%%%%%%%%%
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
        if determinant == 0
            fprintf(fileID, 'Inverzna Matica neexistuje');
        else
            fprintf(fileID, 'Inverzná matica B:\n');
            fprintf(fileID, '%.5f ', inverzna');
        end
    else
        fprintf(fileID, '%s\n', inverzna);
    end
    fclose(fileID);
    
    % Zobrazenie správy o úspešnom spracovaní
    msgbox('Spracovanie matíc bolo úspešné.', ' ', 'help');
end
