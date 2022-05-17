function NewSequence = CreateStartSCALLOP(w01, wt, w, M, AmpThreshold)
Tt = 2*pi/wt;
LenImp = (M - 1)*Tt;
% Строим импульсы
b = w;
%M = floor(LenImp/(2*pi)*wt);
NewSequence = zeros(1,M);
SequenceString = '';
NewSeqElement = '';
i = 0;
j = 0;
while b <= LenImp
    iSeq = 0;
    a = i*Tt;
    b = i*Tt + w;
    % Положительные импульсы
    if sin(w01*a) >= AmpThreshold
        NewSequence(1,(j+1)) = 1;
        NewSeqElement = '1';
        iSeq = 1;
    end
    % Отрицательные импульсы
    if sin(w01*a) <= -AmpThreshold
        NewSequence(1,(j+1)) = -1;
        NewSeqElement = '-1';
        iSeq = 1;
    end
    % Нули
    if iSeq == 0
        NewSequence(1,(j+1)) = 0;
        NewSeqElement = '0';
    end
    SequenceString = append(SequenceString,NewSeqElement);
    i = i + 1;
    j = j + 1;
end
%disp('Стартовая последовательность: ');
%disp(SequenceString);
end

