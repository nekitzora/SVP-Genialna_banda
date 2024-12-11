function Statistika()  

    clear all

    %folder = 'DataInput';
    fileName = 'SVP-Statistika.xlsx';
    %filePath = fullfile(folder, fileName);

    %if ~isfile(fileName)
    %   uialert(uifigure, 'Subor SVP-Statistika.xlsx neexestuje.', 'Chyba');
    %    return;
    target = "Nadmorská výška (m)";
    [~, firstRow] = xlsread(fileName, 'VstupneData', '1:1');
    found = -1;

    column = 'A';
    startRow = 2;
    for i = 1:length(firstRow)
        if strcmp(firstRow{i}, target)
            found = i;
            break;
        end
    end

    if found == -1
        disp('column not found');
        return;
    else
        column = char('A' + found - 1);
    end

    data = [];
    %counter = 0;

    i = startRow;

    while true
        cellAdress = sprintf('%s%d', column, i);
        num = xlsread(fileName, 'VstupneData', cellAdress);

        if isempty(num)
            break;
        end

        data = [data; num];

        i = i + 1;
        %counter = counter + 1;
    end


    xlswrite(fileName, {"Parametre"}, 'Charakteristiky', 'A1');
    xlswrite(fileName, {'Hodnota'}, 'Charakteristiky', 'B1');
    xlswrite(fileName, {'Aritmetický priemer'}, 'Charakteristiky', 'A2');
    xlswrite(fileName, {'Modus'}, 'Charakteristiky', 'A3');
    xlswrite(fileName, {'Medián'}, 'Charakteristiky', 'A4');
    xlswrite(fileName, {'Maximum'}, 'Charakteristiky', 'A5');
    xlswrite(fileName, {'Minimum'}, 'Charakteristiky', 'A6');
    xlswrite(fileName, {'Variačné rozpätie'}, 'Charakteristiky', 'A7');
    xlswrite(fileName, {'Rozptyl'}, 'Charakteristiky', 'A8');
    xlswrite(fileName, {'Smerodajná odchýlka'}, 'Charakteristiky', 'A9');

    n = length(data);
    xmin = min(data);
    xlswrite(fileName, xmin, 'Charakteristiky', 'B6');
    xmax = max(data);
    xlswrite(fileName, xmax, 'Charakteristiky', 'B5');
    R = xmax - xmin;
    xlswrite(fileName, R, 'Charakteristiky', 'B7');
    m = ceil(sqrt(n));
    h = ceil(R/m);

    a = zeros(1,m);
    b = zeros(1,m);
    x = zeros(1,m);
    ni = zeros(1,m);
    Ni = zeros(1,m);
    Fi = zeros(1, m);
    a(1) = xmin;
    for i = 1:m
        if i > 1
            a(i) = b(i-1);
        end
        b(i) = a(i) + h;
        x(i) = (a(i) + b(i)) / 2;
        ni(i) = sum(data >= a(i) & data < b(i)); % Абсолютная частота
        if i == m
            ni(i) = ni(i) + sum(data == b(i)); % Учитываем крайнее значение
        end
        fi(i) = ni(i) / n; % Относительная частота
    end
    Ni = cumsum(ni); % Кумулятивная частота
    Fi = cumsum(fi); % Кумулятивная относительная частота

    % Арифметическое среднее
    x_avg = 0;
    for i = 1:m
        x_avg = x_avg + ni(i) * x(i);
    end
    x_avg = x_avg / n;
    xlswrite(fileName, x_avg, 'Charakteristiky', 'B2');

    % Мода
    [~, modeIndex] = max(ni);
    a_o = a(modeIndex);
    d1 = (modeIndex > 1) * (ni(modeIndex) - ni(max(modeIndex - 1, 1)));
    d2 = (modeIndex < m) * (ni(modeIndex) - ni(min(modeIndex + 1, m)));
    mode_value = a_o + h * (d1 / (d1 + d2));
    xlswrite(fileName, mode_value, 'Charakteristiky', 'B3');

    % Медиана
    medianTarget = n / 2;
    medianIndex = find(Ni >= medianTarget, 1);
    a_e = a(medianIndex);
    N_prev = (medianIndex > 1) * Ni(medianIndex - 1);
    median_value = a_e + h * ((medianTarget - N_prev) / ni(medianIndex));
    xlswrite(fileName, median_value, 'Charakteristiky', 'B4');

    % Дисперсия(rozptyl)
    variance = 0;
    for i = 1:m
        variance = variance + ni(i) * (x(i) - x_avg)^2;
    end
    variance = variance / (n - 1);
    xlswrite(fileName, variance, 'Charakteristiky', 'B8');

    % Стандартное отклонение
    stddev = sqrt(variance);
    xlswrite(fileName, stddev, 'Charakteristiky', 'B9');

    %disp("Arifmeticky priemer: " + x_avg + " vs " + mean(data));
    %disp("Modus: " + mode_value + " vs " + mode(data));
    %disp("Median: " + median_value + " vs " + median(data));
    %disp("Rozptyl: " + variance + " vs " + var(data));
    %disp("Smerodajna odchylka: " + stddev + " vs " + std(data));

    
   
    end

    %data = readtable(filePath, 'Sheet', 'VstupneData');