function Statistika()  

    folder = 'DataInput';
    fileName = 'SVP-Statistika.xlsx';
    filePath = fullfile(folder, fileName);

    if ~isfile(filePath)
        uialert(uifigure, 'Subor SVP-Statistika.xlsx neexestuje.', 'Chyba');
        return;
    end

    %data = readtable(filePath, 'Sheet', 'VstupneData');