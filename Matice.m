function Matice()

    while true
        m = randi([2, 10]);
        n = randi([2, 10]);
        if mod(m * n, 2) == 0 
            break;
        end
    end
    
    A = randi([-100, 100], m, n);
    
    minVal = min(A(:));
    maxVal = max(A(:));
    
    intervalStr = sprintf('Interval pre hodnoty matice A: [%d, %d]\n', minVal, maxVal);
    
    ATransposed = A';
    
    B = A * ATransposed;
    
    dataInputPath = 'DataInput';

    if ~exist(dataInputPath, 'dir')
        mkdir(dataInputPath);
    end

    maticeFile = fullfile(dataInputPath, 'Matice.txt');
    fileID = fopen(maticeFile, 'w');
    
    fprintf(fileID, '%s', intervalStr);
    
    fprintf(fileID, 'n (počet stĺpcov): %d\n', n);
    fprintf(fileID, 'm (počet riadkov): %d\n', m);
    
    fprintf(fileID, '\nHodnoty matice A:\n');

    for i = 1:m
        fprintf(fileID, '%d ', A(i, :));
        fprintf(fileID, '\n');
    end
    
    fprintf(fileID, "\nHodnoty matice A' (transponovaná matica):\n");

    for i = 1:n
        fprintf(fileID, '%d ', ATransposed(i, :));
        fprintf(fileID, '\n');
    end
    
    fprintf(fileID, "\nHodnoty matice B = A * A':\n");

    for i = 1:m
        fprintf(fileID, '%d ', B(i, :));
        fprintf(fileID, '\n');
    end
    
    fclose(fileID);

    matB = B;
    hodnost = rank(matB);

    determinant = det(matB);

    inverzna = inv(matB);
    
    if 0.9 > determinant && determinant > -0.9
        inverzna = 'Inverzná matica neexistuje';
    end

    dataOutputPath = 'DataOutput';

    if ~exist(dataOutputPath, 'dir')
        mkdir(dataOutputPath);
    end

    vysledkyFile = fullfile(dataOutputPath, 'MaticeVysledky.txt');
    fileID = fopen(vysledkyFile, 'w');

    fprintf(fileID, 'Hodnosť matice B: %d\n', hodnost);
    fprintf(fileID, '\nDeterminant matice B: %.2f\n', determinant);

    if isnumeric(inverzna)

        if determinant == 0
            fprintf(fileID, 'Inverzná matica neexistuje\n');
        else
            fprintf(fileID, '\nInverzná matica B:\n');

            for i = 1:m
                fprintf(fileID, '%.5f ', inverzna(i, :));
                fprintf(fileID, '\n');
            end
        end
    else
        fprintf(fileID, '%s\n', inverzna);
    end

    fclose(fileID);

    msgbox('Spracovanie matíc bolo úspešné.', ' ', 'help');
    
end