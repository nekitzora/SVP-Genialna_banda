function Grafy()

    prompts = {
        'Zadajte parameter a (pre kvadratickú funkciu):', ...
        'Zadajte parameter b (pre kvadratickú funkciu):', ...
        'Zadajte parameter c (pre kvadratickú funkciu):', ...
        'Zadajte parameter a0 (prvý člen geometrickej postupnosti):', ...
        'Zadajte parameter q (kvocient geometrickej postupnosti):'
    };

    defaults = {'', '', '', '', ''}; 
    
    while true
        answer = inputdlg(prompts, 'Zadajte parametre', 1, defaults);
        
        if isempty(answer)
            return; 
        end
        
        a = str2double(answer{1});
        b = str2double(answer{2});
        c = str2double(answer{3});
        a0 = str2double(answer{4});
        q = str2double(answer{5});
        
        if all(~isnan([a, b, c, a0, q]))
            break;
        else
            uiwait(errordlg('Prosím zadajte platné čísla!', 'Chyba vstupu'));
        end
    end

    sums = calculate(a0, q);
    
    x = linspace(-50, 50, 1000);
    y = a*x.^2 + b*x + c;

    figure;
    subplot(1,2,1); 
    plot(x, y);
    title('Graf kvadratickej funkcie');
    xlabel('x');
    ylabel('y');
    
    n = 10;
    geometricSeq = a0 * q.^(0:n-1);
    subplot(1,2,2);
    stem(0:n-1, geometricSeq, 'filled');
    title('Prvých 10 členov geometrickej postupnosti');
    xlabel('n');
    ylabel('a_n');
    
    save(sums);
end

function sums = calculate(a0, q)

    sums = struct();
    
    sums.first10 = sum(a0 * q.^(0:9));
    sums.first50 = sum(a0 * q.^(0:49));
    sums.first100 = sum(a0 * q.^(0:99));
    sums.first1000 = sum(a0 * q.^(0:999));
    sums.first10000 = sum(a0 * q.^(0:9999));
    sums.first100000 = sum(a0 * q.^(0:99999));
    sums.first1000000 = sum(a0 * q.^(0:999999));
    
    while true

        promptM = {'Zadajte m1 (začiatok rozsahu):', 'Zadajte m2 (konec rozsahu):'};
        answerM = inputdlg(promptM, 'Zadajte rozsah členov', 1, {'', ''});
        
        if isempty(answerM)
            sums.range = NaN;
            break;
        end
        
        m1 = str2double(answerM{1});
        m2 = str2double(answerM{2});
        
        if ~isnan(m1) && ~isnan(m2) && m1 < m2 && m1 >= 0 && m2 >= 0
            break; 
        else
            uiwait(errordlg('Prosím zadajte platné hodnoty pre m1 a m2!', 'Chyba vstupu'));
        end
    end
    
    if ~isnan(m1) && ~isnan(m2)
        sums.range = sum(a0 * q.^(m1:m2-1)); 
    else
        sums.range = NaN;
    end
    
    if abs(q) < 1
        sums.infiniteSum = a0 / (1 - q);
    else
        sums.infiniteSum = NaN; 
    end
end

function save(sums)

    filename = 'DataOutput/VystupPostupnisti.txt';
    if ~exist('DataOutput', 'dir')
        mkdir('DataOutput');
    end
    
    fileID = fopen(filename, 'w');
    
    fprintf(fileID, 'Súčet prvých 10 členov: %.f\n', sums.first10);
    fprintf(fileID, 'Súčet prvých 50 členov: %.f\n', sums.first50);
    fprintf(fileID, 'Súčet prvých 100 členov: %.f\n', sums.first100);
    fprintf(fileID, 'Súčet prvých 1000 členov: %.f\n', sums.first1000);
    fprintf(fileID, 'Súčet prvých 10000 členov: %.f\n', sums.first10000);
    fprintf(fileID, 'Súčet prvých 100000 členov: %.f\n', sums.first100000);
    fprintf(fileID, 'Súčet prvých 1000000 členов: %.f\n', sums.first1000000);
    
    fprintf(fileID, 'Súčet členov od am1 po am2: %f\n', sums.range);
    
    if ~isnan(sums.infiniteSum)
        fprintf(fileID, 'Súčet S = P∞ (ak |q| < 1): %.f\n', sums.infiniteSum);
    else
        fprintf(fileID, 'Súčet S = P∞ neexistuje pre |q| >= 1.\n');
    end
    
    fclose(fileID);
    msgbox('Výsledky boli uložené do súboru VystupPostupnisti.txt.', ' ', 'help');
    
end
