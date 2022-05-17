function [BestSequenceOverall, BestLeakOverall, BestAngleOverall] = ...
	GenSearch(w01, w12, w, T, tstep, InputString, StartTheta)
Gen = 1;
NewLeak = 0;
GoldLeak = 1;
BestSequence = '';
Theta = StartTheta;
disp('Стартовая последовательность');
WriteSequence(InputString);
while NewLeak < GoldLeak
    GenDisp = ['Поколение N', num2str(Gen)];
    disp(GenDisp);
    if Gen > 1
        GoldLeak = NewLeak;
        InputString = BestSequence;
    end
    % Перебираем все возможные варианты замены одного элемента на другой
    [SequencesArray, ~] = ChangingOneElement(InputString);
    [SequencesNumber,CellsNumber] = size(SequencesArray);
    FArray = zeros(SequencesNumber,1); % Массив для хранения F
    AnglesArray = zeros(SequencesNumber,1); % Массив для хранения углов
    %parfor j = 1:1:SequencesNumber
    for j = 1:1:SequencesNumber
        SignalString = SequencesArray(j,:); 
        % Оптимизируем угол
        OptimizedTheta = ...
            NewThetaOptimizer(w01, w12, w, T, tstep,...
            SignalString, Theta);
        AnglesArray(j) = OptimizedTheta;
        disp(['Последовательность N',num2str(j),' из ', num2str(SequencesNumber)]);
        % Cчитаем Fidelity
        FArray(j) = ...
            Fidelity(w01, w12, w, T, tstep,...
            SignalString, OptimizedTheta);
    end
    % Найдём минимум среди "удачных последовательностей
    [MinLeak, MinLeakN] = min(FArray);
    BestSequence = SequencesArray(MinLeakN,:);
    BestAngle = AnglesArray(MinLeakN,:);
    BestString = '';
    % Запишем лучшую последовательность
    for BestSeqElement = 1:1:CellsNumber
        NewElementSeq = num2str(BestSequence(BestSeqElement));
        BestString = append(BestString,NewElementSeq);
    end
    ResultDisp1 = append('Минимальная утечка у последовательности ', BestString);
    disp(ResultDisp1);
    ResultDisp2 = append('F = ', num2str(MinLeak));
    disp(ResultDisp2);
    ResultDisp3 = append('Угол Th = ', num2str(BestAngle));
    disp(ResultDisp3);
    NewLeak = MinLeak;
    if NewLeak < GoldLeak
        % Если на нынешнем поколении результат лучше, чем на предыдущем,
        % то запишем его
        BestLeakOverall = MinLeak;
        BestSequenceOverall = SequencesArray(MinLeakN,:);
        BestAngleOverall = AnglesArray(MinLeakN,:);
    end
    Gen = Gen + 1;
end
disp(['Поиск занял ', num2str(Gen - 1), ' поколений']);
disp('Самая лучшая последовательность');
WriteSequence(BestSequenceOverall);
FinalDisp1 = append('F = ', num2str(BestLeakOverall));
disp(FinalDisp1);
FinalDisp2 = append('Угол Th = ', num2str(BestAngleOverall));
disp(FinalDisp2);