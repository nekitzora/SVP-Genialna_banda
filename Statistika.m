function Statistika()  
clear all;
% Проверка наличия файла
%filename = 'DataInput\SVP-Statistika67.xlsx';
filename = 'SVP-Statistika.xlsx';
if ~isfile(filename)
    disp('Súbor SVP-Statistika.xlsx nie je k dispozícii.');
    return;
end

    
% Чтение данных из листа 'VstupneData' с сохранением оригинальных имен столбцов
opts = detectImportOptions(filename, 'Sheet', 'VstupneData');
opts.VariableNamingRule = 'preserve';  % Используем оригинальные имена столбцов
data = readtable(filename, opts, 'Sheet', 'VstupneData');

% Фильтрация и сортировка данных для первой таблицы (города с населением >= 50 000)
cities_large = data(data.('Počet obyvateľov sídla') >= 50000, :);
cities_large_sorted = sortrows(cities_large, 'Počet obyvateľov sídla', 'descend');

% Фильтрация и сортировка данных для второй таблицы (города с населением < 1000)
cities_small = data(data.('Počet obyvateľov sídla') < 1000, :);
cities_small_sorted = sortrows(cities_small, 'Počet obyvateľov sídla', 'descend');

% Удаление ненужных столбцов
cities_large_sorted = removevars(cities_large_sorted, {'Priemerný mesačný úhrn zrážok', 'Priemerná mesačná teplota', 'Rozloha sídla', 'Najkratšia cestná vzdialenosť od Košíc'});
cities_small_sorted = removevars(cities_small_sorted, {'Priemerný mesačný úhrn zrážok', 'Priemerná mesačná teplota', 'Rozloha sídla', 'Najkratšia cestná vzdialenosť od Košíc'});

% Запись заголовков и первой таблицы в лист 'VystupneData'
header_large = {'Mesto s počtom obyvateľov > 50 000'};
writecell(header_large, filename, 'Sheet', 'VystupneData', 'Range', 'A1');
writetable(cities_large_sorted, filename, 'Sheet', 'VystupneData', 'Range', 'A2');

% Добавление пустой строки между таблицами
empty_row = cell(1, width(cities_large_sorted));  % Пустая строка
writecell(empty_row, filename, 'Sheet', 'VystupneData', 'Range', ['A' num2str(height(cities_large_sorted) + 2)]);

% Запись заголовков и второй таблицы в лист 'VystupneData'
header_small = {'Mesto s počtom obyvateľov < 1000'};
writecell(header_small, filename, 'Sheet', 'VystupneData', 'Range', ['A' num2str(height(cities_large_sorted) + height(empty_row) + 2)]);
writetable(cities_small_sorted, filename, 'Sheet', 'VystupneData', 'Range', ['A' num2str(height(cities_large_sorted) + height(empty_row) + 3)]);

% Запрос пользователя для выбора месяца и высоты
month = input('Zadajte mesiac (1-12): ');
height_limit = input('Zadajte nadmorskú výšku: ');

% Фильтрация данных по высоте
below_height = data.('Nadmorská výška sídla') < height_limit;
above_height = data.('Nadmorská výška sídla') > height_limit;

% Преобразование значений температуры и осадков для всех месяцев
temp_values = cellfun(@(x) str2double(strsplit(x, ',')), data.('Priemerná mesačná teplota'), 'UniformOutput', false);
precip_values = cellfun(@(x) str2double(strsplit(x, ',')), data.('Priemerný mesačný úhrn zrážok'), 'UniformOutput', false);

% Фильтрация данных для выбранного месяца
selected_month = month;  % Месяц, который выбрал пользователь

% Извлечение температур и осадков для выб % Извлечение температур и осадков для выбранного месяца
temp_for_month = cellfun(@(x) x(selected_month), temp_values);
precip_for_month = cellfun(@(x) x(selected_month), precip_values);

% Вычисление средней температуры и осадков для всех городов
avg_temp = mean(temp_for_month, 'omitnan');
avg_precip = mean(precip_for_month, 'omitnan');

% Результаты для выбранного месяца
results = {
    'Priemerná mesačná teplota pre vybraný mesiac:', avg_temp;
    'Priemerný mesačný úhrn zrážok pre vybraný mesiac:', avg_precip;
};

% Запись в Excel
writecell(results, filename, 'Sheet', 'VystupneData', ...
    'Range', ['A' num2str(height(cities_large_sorted) + height(cities_small_sorted) + 6)]);

disp('Údaje boli spracované a uložené.');




    %folder = 'DataInput';
    %filename = 'SVP-Statistika.xlsx';
    %filePath = fullfile(folder, filename);

    %if ~isfile(filename)
    %   uialert(uifigure, 'Subor SVP-Statistika.xlsx neexestuje.', 'Chyba');
    %    return;
    target = "Nadmorská výška (m)";
    [~, firstRow] = xlsread(filename, 'VstupneData', '1:1');
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
        num = xlsread(filename, 'VstupneData', cellAdress);

        if isempty(num)
            break;
        end

        data = [data; num];

        i = i + 1;
        %counter = counter + 1;
    end


    xlswrite(filename, {"Parametre"}, 'Charakteristiky', 'A1');
    xlswrite(filename, {'Hodnota'}, 'Charakteristiky', 'B1');
    xlswrite(filename, {'Aritmetický priemer'}, 'Charakteristiky', 'A2');
    xlswrite(filename, {'Modus'}, 'Charakteristiky', 'A3');
    xlswrite(filename, {'Medián'}, 'Charakteristiky', 'A4');
    xlswrite(filename, {'Maximum'}, 'Charakteristiky', 'A5');
    xlswrite(filename, {'Minimum'}, 'Charakteristiky', 'A6');
    xlswrite(filename, {'Variačné rozpätie'}, 'Charakteristiky', 'A7');
    xlswrite(filename, {'Rozptyl'}, 'Charakteristiky', 'A8');
    xlswrite(filename, {'Smerodajná odchýlka'}, 'Charakteristiky', 'A9');

    n = length(data);
    xmin = min(data);
    xlswrite(filename, xmin, 'Charakteristiky', 'B6');
    xmax = max(data);
    xlswrite(filename, xmax, 'Charakteristiky', 'B5');
    R = xmax - xmin;
    xlswrite(filename, R, 'Charakteristiky', 'B7');
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
    xlswrite(filename, x_avg, 'Charakteristiky', 'B2');

    % Мода
    [~, modeIndex] = max(ni);
    a_o = a(modeIndex);
    d1 = (modeIndex > 1) * (ni(modeIndex) - ni(max(modeIndex - 1, 1)));
    d2 = (modeIndex < m) * (ni(modeIndex) - ni(min(modeIndex + 1, m)));
    mode_value = a_o + h * (d1 / (d1 + d2));
    xlswrite(filename, mode_value, 'Charakteristiky', 'B3');

    % Медиана
    medianTarget = n / 2;
    medianIndex = find(Ni >= medianTarget, 1);
    a_e = a(medianIndex);
    N_prev = (medianIndex > 1) * Ni(medianIndex - 1);
    median_value = a_e + h * ((medianTarget - N_prev) / ni(medianIndex));
    xlswrite(filename, median_value, 'Charakteristiky', 'B4');

    % Дисперсия(rozptyl)
    variance = 0;
    for i = 1:m
        variance = variance + ni(i) * (x(i) - x_avg)^2;
    end
    variance = variance / (n - 1);
    xlswrite(filename, variance, 'Charakteristiky', 'B8');

    % Стандартное отклонение
    stddev = sqrt(variance);
    xlswrite(filename, stddev, 'Charakteristiky', 'B9');

    %disp("Arifmeticky priemer: " + x_avg + " vs " + mean(data));
    %disp("Modus: " + mode_value + " vs " + mode(data));
    %disp("Median: " + median_value + " vs " + median(data));
    %disp("Rozptyl: " + variance + " vs " + var(data));
    %disp("Smerodajna odchylka: " + stddev + " vs " + std(data));

    
   disp('Údaje boli spracované a uložené.');
    

end