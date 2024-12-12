function Statistika()  
% Проверка наличия файла
filename = 'DataInput\SVP-Statistika67.xlsx';
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

end