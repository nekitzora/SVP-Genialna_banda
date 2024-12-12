function Matice()
    % Generovanie náhodnej matice A s párnym počtom prvkov
    while true
        m = randi([2, 10]); % Náhodný počet riadkov (min 2, max 10)
        n = randi([2, 10]); % Náhodný počet stĺpcov (min 2, max 10)
        if mod(m * n, 2) == 0 % Overenie: ak je počet prvkov párny, opustiť cyklus
            break;
        end
    end
    
    % Генерация матрицы A с случайными значениями (пока без интервала)
    A = randi([-100, 100], m, n); % Генерируем матрицу A в диапазоне от -100 до 100
    
    % Находим минимум и максимум значений в матрице A
    minVal = min(A(:));
    maxVal = max(A(:));
    
    % Запись интервала значений
    intervalStr = sprintf('Interval pre hodnoty matice A: [%d, %d]\n', minVal, maxVal);
    
    % Транспонирование матрицы A
    ATransposed = A';
    
    % Вычисление матрицы B = A * A'
    B = A * ATransposed;
    
    % Сохранение матриц в файл Matice.txt
    dataInputPath = 'DataInput';
    if ~exist(dataInputPath, 'dir')
        mkdir(dataInputPath);
    end
    maticeFile = fullfile(dataInputPath, 'Matice.txt');
    fileID = fopen(maticeFile, 'w');
    
    % Запись интервала значений
    fprintf(fileID, '%s', intervalStr);
    
    % Запись количества столбцов и строк
    fprintf(fileID, 'n (počet stĺpcov): %d\n', n);
    fprintf(fileID, 'm (počet riadkov): %d\n', m);
    
    % Запись значений матрицы A
    fprintf(fileID, '\nHodnoty matice A:\n');
    for i = 1:m
        fprintf(fileID, '%d ', A(i, :));
        fprintf(fileID, '\n');
    end
    
    % Запись транспонированной матрицы A
    fprintf(fileID, "\nHodnoty matice A' (transponovaná matica):\n");
    for i = 1:n
        fprintf(fileID, '%d ', ATransposed(i, :));
        fprintf(fileID, '\n');
    end
    
    % Запись матрицы B
    fprintf(fileID, "\nHodnoty matice B = A * A':\n");
    for i = 1:m
        fprintf(fileID, '%d ', B(i, :));
        fprintf(fileID, '\n');
    end
    
    fclose(fileID);
    
    % Вычисления свойств матрицы B
    matB = B; % Симулированное считывание
    hodnost = rank(matB);
    determinant = det(matB);
    if determinant ~= 0
        inverzna = inv(matB);
    else
        inverzna = 'Inverzná matica neexistuje';
    end
    
    % Сохранение результатов в файл MaticeVysledky.txt
    dataOutputPath = 'DataOutput';
    if ~exist(dataOutputPath, 'dir')
        mkdir(dataOutputPath);
    end
    vysledkyFile = fullfile(dataOutputPath, 'MaticeVysledky.txt');
    fileID = fopen(vysledkyFile, 'w');
    fprintf(fileID, 'Rang matice B: %d\n', hodnost);
    fprintf(fileID, 'Determinant matice B: %.f\n', determinant);
    if isnumeric(inverzna)
        if determinant == 0
            fprintf(fileID, 'Inverzná matica neexistuje\n');
        else
            fprintf(fileID, 'Inverzná matica B:\n');
            for i = 1:m
                fprintf(fileID, '%.5f ', inverzna(i, :));
                fprintf(fileID, '\n');
            end
        end
    else
        fprintf(fileID, '%s\n', inverzna);
    end
    fclose(fileID);
    
    % Отображение сообщения об успешной обработке
    msgbox('Spracovanie matíc bolo úspešné.', ' ', 'help');
end


