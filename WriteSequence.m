function WriteSequence(InputSequence)
N = length(InputSequence);
Sequence = '';
for i = 1:1:N
	if InputSequence(i) == 1
        NewElement = '1';
    end
	if InputSequence(i) == 0
        NewElement = '0';
    end
	if InputSequence(i) == -1
        NewElement = '-1';
    end
	Sequence = append(Sequence,NewElement);
end
disp(Sequence);
end