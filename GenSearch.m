function [BestSequenceOverall, BestLeakOverall, BestAngleOverall] = ...
	GenSearch(w01, w12, w, T, tstep, InputString, StartTheta)
Gen = 1;
NewLeak = 0;
GoldLeak = 1;
BestSequence = '';
Theta = StartTheta;
disp('��������� ������������������');
WriteSequence(InputString);
while NewLeak < GoldLeak
    GenDisp = ['��������� N', num2str(Gen)];
    disp(GenDisp);
    if Gen > 1
        GoldLeak = NewLeak;
        InputString = BestSequence;
    end
    % ���������� ��� ��������� �������� ������ ������ �������� �� ������
    [SequencesArray, ~] = ChangingOneElement(InputString);
    [SequencesNumber,CellsNumber] = size(SequencesArray);
    FArray = zeros(SequencesNumber,1); % ������ ��� �������� F
    AnglesArray = zeros(SequencesNumber,1); % ������ ��� �������� �����
    %parfor j = 1:1:SequencesNumber
    for j = 1:1:SequencesNumber
        SignalString = SequencesArray(j,:); 
        % ������������ ����
        OptimizedTheta = ...
            NewThetaOptimizer(w01, w12, w, T, tstep,...
            SignalString, Theta);
        AnglesArray(j) = OptimizedTheta;
        disp(['������������������ N',num2str(j),' �� ', num2str(SequencesNumber)]);
        % C������ Fidelity
        FArray(j) = ...
            Fidelity(w01, w12, w, T, tstep,...
            SignalString, OptimizedTheta);
    end
    % ����� ������� ����� "������� �������������������
    [MinLeak, MinLeakN] = min(FArray);
    BestSequence = SequencesArray(MinLeakN,:);
    BestAngle = AnglesArray(MinLeakN,:);
    BestString = '';
    % ������� ������ ������������������
    for BestSeqElement = 1:1:CellsNumber
        NewElementSeq = num2str(BestSequence(BestSeqElement));
        BestString = append(BestString,NewElementSeq);
    end
    ResultDisp1 = append('����������� ������ � ������������������ ', BestString);
    disp(ResultDisp1);
    ResultDisp2 = append('F = ', num2str(MinLeak));
    disp(ResultDisp2);
    ResultDisp3 = append('���� Th = ', num2str(BestAngle));
    disp(ResultDisp3);
    NewLeak = MinLeak;
    if NewLeak < GoldLeak
        % ���� �� �������� ��������� ��������� �����, ��� �� ����������,
        % �� ������� ���
        BestLeakOverall = MinLeak;
        BestSequenceOverall = SequencesArray(MinLeakN,:);
        BestAngleOverall = AnglesArray(MinLeakN,:);
    end
    Gen = Gen + 1;
end
disp(['����� ����� ', num2str(Gen - 1), ' ���������']);
disp('����� ������ ������������������');
WriteSequence(BestSequenceOverall);
FinalDisp1 = append('F = ', num2str(BestLeakOverall));
disp(FinalDisp1);
FinalDisp2 = append('���� Th = ', num2str(BestAngleOverall));
disp(FinalDisp2);