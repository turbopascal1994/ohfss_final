function [OutputSeqArray, OutputStringsArray] = ChangingOneElement(InputSequence)

% Запишем и выведем входную последовательность
InpSeqString = '';
CellsNumber = length(InputSequence);
for InpSeqElement = 1:1:CellsNumber
    NewElementSeq = num2str(InputSequence(InpSeqElement));
    InpSeqString = append(InpSeqString,NewElementSeq);
end
% Количество возможных последовательностей
NumberOfSequences = 2*CellsNumber;
% Массив для хранения последовательностей
SequencesArray = zeros(NumberOfSequences,CellsNumber);
% Массив для хранения строк
StringsArray = strings(NumberOfSequences,1);

StartSequence = InputSequence;
SequenceN = 1;
for i = 1:1:CellsNumber
InputSequence = StartSequence;
    switch InputSequence(i)
    case -1
        % -1 -> 1
        InputSequence(i) = 1;
        SequencesArray(SequenceN,:) = InputSequence;
        for ii = 1:1:CellsNumber
            NewElementSeq = num2str(InputSequence(ii));
            StringsArray(SequenceN) = append(StringsArray(SequenceN),NewElementSeq);
        end
        SequenceN = SequenceN + 1;
        % -1 -> 0
        InputSequence(i) = 0;
        SequencesArray(SequenceN,:) = InputSequence;
        for ii = 1:1:CellsNumber
            NewElementSeq = num2str(InputSequence(ii));
            StringsArray(SequenceN) = append(StringsArray(SequenceN),NewElementSeq);
        end
        SequenceN = SequenceN + 1;        
    case 1
        % 1 -> -1
        InputSequence(i) = -1;
        SequencesArray(SequenceN,:) = InputSequence;
        for ii = 1:1:CellsNumber
            NewElementSeq = num2str(InputSequence(ii));
            StringsArray(SequenceN) = append(StringsArray(SequenceN),NewElementSeq);
        end
        SequenceN = SequenceN + 1;
        % 1 -> 0
        InputSequence(i) = 0;
        SequencesArray(SequenceN,:) = InputSequence;
        for ii = 1:1:CellsNumber
            NewElementSeq = num2str(InputSequence(ii));
            StringsArray(SequenceN) = append(StringsArray(SequenceN),NewElementSeq);
        end
        SequenceN = SequenceN + 1;
    case 0
        % 0 -> -1
        InputSequence(i) = -1;
        SequencesArray(SequenceN,:) = InputSequence;
        for ii = 1:1:CellsNumber
            NewElementSeq = num2str(InputSequence(ii));
            StringsArray(SequenceN) = append(StringsArray(SequenceN),NewElementSeq);
        end
        SequenceN = SequenceN + 1;
        % 0 -> 1
        InputSequence(i) = 1;
        SequencesArray(SequenceN,:) = InputSequence;
        for ii = 1:1:CellsNumber
            NewElementSeq = num2str(InputSequence(ii));
            StringsArray(SequenceN) = append(StringsArray(SequenceN),NewElementSeq);
        end
        SequenceN = SequenceN + 1;
    end
end
OutputSeqArray = SequencesArray;
OutputStringsArray = StringsArray;
end

