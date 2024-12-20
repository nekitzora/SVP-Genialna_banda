function Statistika()

    filename = 'DataInput\SVP-Statistika.xlsx';
    
    
    if ~exist(filename)
        uiwait(errordlg('Súbor SVP-Statistika.xlsx nie je k dispozícii.', 'Chyba suboru'));
        return;
    end
    requiredSheets = {'ZakladneInfo', 'VstupneData', 'VystupneData', 'Charakteristiky'};
    [~, sheets] = xlsfinfo(filename);

    missingSheets = setdiff(requiredSheets, sheets);

    if ~isempty(missingSheets)
        uiwait(errordlg(['Súbor neobsahuje nasledujúce potrebné listy: ', strjoin(missingSheets, ', ')], 'Chyba suboru'));
        return;
    end

    writetable(table(), filename, 'Sheet', 'VystupneData', 'WriteMode', 'overwrite');
    writetable(table(), filename, 'Sheet', 'ZakladneInfo', 'WriteMode', 'overwrite');
    writetable(table(), filename, 'Sheet', 'Charakteristiky', 'WriteMode', 'overwrite');

%HAROK ZAKLADNEINFO

    menuData = {
        'Názov tímu', 'Genialna banda'; 
        'Project Manager', 'Zorochev Mykyta';
        'Developer', 'Vandenko Roman';
        'Tester', 'Shevchuk Rostyslav';
        'Data Analyser', 'Churilov Bohdan';
        'Rok', 2024;
        'Verzia programu', '3.0';
        'Popis programu', 'Program na analýzu dát a generovanie štatistík o mestách a obciach.';
        'Dátum vytvorenia', '08.12.2024'
    };

    writecell(menuData, filename, 'Sheet', 'ZakladneInfo', 'Range', 'A1');

%HAROK VYSTUPNEDATA

    app = uifigure('Name', 'Statistika', 'Position', [100, 100, 400, 300]);

    uilabel(app, 'Position', [20, 240, 100, 22], 'Text', 'Mesiac:');
    monthField = uispinner(app, 'Position', [150, 240, 100, 22], 'Limits', [1, 12], 'Value', 1);

    uilabel(app, 'Position', [20, 200, 150, 22], 'Text', 'Nadmorská výška:');
    heightField = uieditfield(app, 'numeric', 'Position', [150, 200, 100, 22]);

    uilabel(app, 'Position', [20, 160, 200, 22], 'Text', 'Maximálna vzdialenosť:');
    distanceField = uieditfield(app, 'numeric', 'Position', [150, 160, 100, 22]);

    uButton = uibutton(app, 'Position', [150, 60, 100, 30], 'Text', 'Potvrdiť', 'ButtonPushedFcn', @(btn, event) onButtonClick(app, filename, monthField, heightField, distanceField));

    function onButtonClick(app, filename, monthField, heightField, distanceField)

        month = monthField.Value;
        height_limit = heightField.Value;
        distance_limit = distanceField.Value;

        if isempty(height_limit) || isnan(height_limit) || height_limit <= 0
            msgbox('Zadajte platnú hodnotu pre Nadmorsku výška.', 'Chyba', 'error');
            return;
        end

        if isempty(distance_limit) || isnan(distance_limit) || distance_limit <= 0
            msgbox('Zadajte platnú hodnotu pre Maximálnu vzdialenosť.', 'Chyba', 'error');
            return;
        end

        opts = detectImportOptions(filename, 'Sheet', 'VstupneData');
        opts.VariableNamingRule = 'preserve';
        data = readtable(filename, opts, 'Sheet', 'VstupneData');

        requiredColumns = {
            'Poradové číslo', 'Názov sídla', 'Typ sídla', ...
            'Kraj', 'Štát', 'Počet obyvateľov sídla', 'Rozloha sídla', ...
            'Nadmorská výška sídla','Priemerná mesačná teplota', ...
            'Priemerný mesačný úhrn zrážok','Najkratšia cestná vzdialenosť od Košíc'
        };

        missingColumns = setdiff(requiredColumns, data.Properties.VariableNames);

        if ~isempty(missingColumns)
            uialert(app, ['Chýbajúce stĺpce: ', strjoin(missingColumns, ', ')], 'Chyba');
            return;
        end

        cities_large = data(data.('Počet obyvateľov sídla') >= 50000, :);
        cities_large_sorted = sortrows(cities_large, 'Počet obyvateľov sídla', 'descend');

        cities_small = data(data.('Počet obyvateľov sídla') < 1000, :);
        cities_small_sorted = sortrows(cities_small, 'Počet obyvateľov sídla', 'descend');

        columns_to_remove = {'Priemerný mesačný úhrn zrážok', 'Priemerná mesačná teplota', 'Rozloha sídla', 'Najkratšia cestná vzdialenosť od Košíc', 'Nadmorská výška sídla'};

        cities_large_sorted = removevars(cities_large_sorted, columns_to_remove);
        cities_small_sorted = removevars(cities_small_sorted, columns_to_remove);

        writecell({'S počtom obyvateľov > 50 000'}, filename, 'Sheet', 'VystupneData', 'Range', 'A1');
        writetable(cities_large_sorted, filename, 'Sheet', 'VystupneData', 'Range', 'A2');

        writecell({'S počtom obyvateľov < 1000'}, filename, 'Sheet', 'VystupneData', 'Range', ['A' num2str(height(cities_large_sorted) + 4)]);
        writetable(cities_small_sorted, filename, 'Sheet', 'VystupneData', 'Range', ['A' num2str(height(cities_large_sorted) + 5)]);

        below_height = data(data.('Nadmorská výška sídla') < height_limit, :);
        above_height = data(data.('Nadmorská výška sídla') > height_limit, :);

        temp_values = cellfun(@(x) str2double(strsplit(x, ',')), data.('Priemerná mesačná teplota'), 'UniformOutput', false);
        precip_values = cellfun(@(x) str2double(strsplit(x, ',')), data.('Priemerný mesačný úhrn zrážok'), 'UniformOutput', false);

        temp_for_month = cellfun(@(x) x(month), temp_values);
        precip_for_month = cellfun(@(x) x(month), precip_values);

        avg_temp_below = mean(temp_for_month(below_height.('Typ sídla') == "Mesto"), 'omitnan');
        avg_precip_below = mean(precip_for_month(below_height.('Typ sídla') == "Mesto"), 'omitnan');

        avg_temp_above = mean(temp_for_month(above_height.('Typ sídla') == "Obec"), 'omitnan');
        avg_precip_above = mean(precip_for_month(above_height.('Typ sídla') == "Obec"), 'omitnan');

        results_temp_precip = {
            'Výsledky pre vybraný mesiac a výšku:', '';
            'Priemerná teplota v mestách s výškou menšou ako zvolená:', avg_temp_below;
            'Priemerný úhrn zrážok v mestách s výškou menšou ako zvolená:', avg_precip_below;
            'Priemerná teplota v obciach s väčšou výškou ako zvolená:', avg_temp_above;
            'Priemerný úhrn zrážok v obciach s väčšou výškou ako zvolená:', avg_precip_above;
        };
        
        writecell(results_temp_precip, filename, 'Sheet', 'VystupneData', 'Range', ['A' num2str(height(cities_large_sorted) + height(cities_small_sorted) + 10)]);

        if ~isempty(distance_limit)
            nearby_places = data(data.('Najkratšia cestná vzdialenosť od Košíc') < distance_limit, :);

            columns_to_remove_distance = {'Priemerný mesačný úhrn zrážok', 'Priemerná mesačná teplota', 'Rozloha sídla', 'Nadmorská výška sídla', 'Počet obyvateľov sídla'};
            nearby_places = removevars(nearby_places, columns_to_remove_distance);

            currentRow = height(cities_large_sorted) + height(cities_small_sorted) + 16;

            writecell({'Sídla do zvolenej vzdialenosti'}, filename, 'Sheet', 'VystupneData', 'Range', ['A' num2str(currentRow)]);

            writetable(nearby_places, filename, 'Sheet', 'VystupneData', 'Range', ['A' num2str(currentRow + 1)]);
        end

%HAROK СHARAKTERSTIKA

        target = "Nadmorská výška sídla";

        [~, firstRow] = xlsread(filename, 'VstupneData', '1:1');

        found = -1;
        column = 'A';
    
        for i = 1:length(firstRow)

            if strcmp(firstRow{i}, target)
                found = i;
                break;
            end
        end

        %if found == -1
        %    uialert(app, 'Column "Nadmorská výška sídla" not found.', 'Charakteristika');
        %    return;
        %else
            column = char('A' + found - 1);
        %end

        data = [];
        %counter = 0;
        startRow = 2;

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

        menuData2 = {
            'Parametre', 'Hodnota';
            'Aritmetický priemer', '';
            'Modus', '';
            'Medián', '';
            'Maximum', '';
            'Minimum', '';
            'Variačné rozpätie', ''; 
            'Rozptyl', '';
            'Smerodajná odchýlka', '';
        };

        writecell(menuData2, filename, 'Sheet', 'Charakteristiky', 'Range', 'A1');

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

        msgbox('Údaje boli spracované a uložené.', ' ', 'help');

        close(app);

    end
end