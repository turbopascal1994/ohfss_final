function AmpsArray = CreateAmpThresholds(w01, wt, w, M)
Tt = 2*pi/wt;
LenImp = (M - 1)*Tt + w;
StartA = 0.1;
EndA = 0.9;
StepA = 0.01;
AmpsArrayRAW = zeros(1,(EndA - StartA)/StepA + 1);
k = 1;
for AmpThreshold = StartA:StepA:EndA
    PulsesN = 0; % Счётчик импульсов
    if AmpThreshold == StartA
        PrevN = 0;
    end
    % Строим импульсы
    %M = floor(LenImp/(2*pi)*wt);
    i = 0;
    j = 0;
    b = w;
    while b <= LenImp
        a = i*Tt;
        b = i*Tt + w;
        % Положительные импульсы
        if sin(w01*a) >= AmpThreshold
            PulsesN = PulsesN + 1;
        end
        % Отрицательные импульсы
        if sin(w01*a) <= -AmpThreshold
            PulsesN = PulsesN + 1;
        end
        i = i + 1;
        j = j + 1;
    end
    if PulsesN ~= PrevN
        AmpsArrayRAW(k) = AmpThreshold;
        PrevN = PulsesN;
        k = k + 1;
    end
end
% Мы не знали, сколько всего получится различных значений, поэтому
% количество элементов массива было взято с запасом
% Сейчас, причешем готовый массив
TrueCount = 0;
for tt = 1:1:length(AmpsArrayRAW)
    if AmpsArrayRAW(tt) ~= 0
        TrueCount = TrueCount + 1;
    end
end
AmpsArray = zeros(1,TrueCount);
for tt = 1:1:length(AmpsArray)
    AmpsArray(tt) = AmpsArrayRAW(tt);    
end
end