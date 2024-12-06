function Grafy()
    % Vytvorenie grafického okna
    fig = figure('Name', 'Parametre pre grafy', 'NumberTitle', 'off', ...
                 'Position', [100, 100, 400, 300], 'Resize', 'off');
    
    % Vstupné polia pre a, b, c
    uicontrol('Style', 'text', 'Position', [20, 240, 120, 20], 'String', 'a (pre y=ax^2+bx+c):');
    input_a = uicontrol('Style', 'edit', 'Position', [150, 240, 200, 20]);
    
    uicontrol('Style', 'text', 'Position', [20, 210, 120, 20], 'String', 'b (pre y=ax^2+bx+c):');
    input_b = uicontrol('Style', 'edit', 'Position', [150, 210, 200, 20]);
    
    uicontrol('Style', 'text', 'Position', [20, 180, 120, 20], 'String', 'c (pre y=ax^2+bx+c):');
    input_c = uicontrol('Style', 'edit', 'Position', [150, 180, 200, 20]);
    
    % Vstupné polia pre a0 a q
    uicontrol('Style', 'text', 'Position', [20, 150, 120, 20], 'String', 'a0 (geom. postupnosť):');
    input_a0 = uicontrol('Style', 'edit', 'Position', [150, 150, 200, 20]);
    
    uicontrol('Style', 'text', 'Position', [20, 120, 120, 20], 'String', 'q (geom. postupnosť):');
    input_q = uicontrol('Style', 'edit', 'Position', [150, 120, 200, 20]);
    
    % Tlačidlo pre spustenie výpočtu a vykreslenie grafov
    uicontrol('Style', 'pushbutton', 'Position', [100, 50, 200, 40], ...
              'String', 'Vykresliť grafy', ...
              'Callback', @(src, event) plotGraphs(input_a, input_b, input_c, input_a0, input_q));
end

function plotGraphs(input_a, input_b, input_c, input_a0, input_q)
    % Načítanie hodnôt z polí
    a = str2double(input_a.String);
    b = str2double(input_b.String);
    c = str2double(input_c.String);
    a0 = str2double(input_a0.String);
    q = str2double(input_q.String);
    
    % Kontrola správnosti vstupov
    if any(isnan([a, b, c, a0, q]))
        errordlg('Zadajte prosím platné číselné hodnoty.', 'Chyba vstupu');
        return;
    end
    
    % Výpočty
    x = -10:0.1:10;
    y = a * x.^2 + b * x + c;
    geomSeq = a0 * q.^(0:9);
    
    % Zobrazenie grafov
    figure('Name', 'Grafy', 'NumberTitle', 'off');
    
    % Graf kvadratickej funkcie
    subplot(2, 1, 1);
    plot(x, y, 'LineWidth', 2); grid on;
    title('Kvadratická funkcia: y = ax^2 + bx + c');
    xlabel('x'); ylabel('y');
    
    % Graf geometrickej postupnosti
    subplot(2, 1, 2);
    stem(0:9, geomSeq, 'filled');
    title('Prvých 10 členov geometrickej postupnosti');
    xlabel('n'); ylabel('a_n');
end

