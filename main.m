clear;
tstep = 1e-14; % ��� ��� ������� ���

% ��������� ������
w01 = 5.001*2*pi*1e9; % ������� 0-1
w12 = w01 - 0.2*2*pi*1e9; % ������� 1-2

% ��������� ��������
wt = 25*2*pi*1e9; % �������� �������
w = 4*1e-12; % ������������ ��������
T = 2*pi/wt; % ������ �/� ����������
Theta = 0.001; % ���� �������� (�� �����������)
CellsNumber = 120; % ���������� ����� � ������������������
Len = (CellsNumber - 1)*T + w;

NeededAngle = 0.024; % ����������� ����
AngleThreshold = 0.0005; % ���������� ����������� �� ����

StartSequence = [];
Angle = NewThetaOptimizer(w01, w12, w, T, tstep, StartSequence, Theta);

if abs(NeededAngle - Angle) == 0
    disp('��������� ����� ������������������ ������ �� ����');
    NewSequence = StartSequence;
else
    % ������ ����� ������������������, "����������" � ������� ����
    disp('������ ������ ����� ������������������ M.')
    if Angle < (NeededAngle + AngleThreshold)
        while Angle ~= (NeededAngle + AngleThreshold)
            CellsNumber = CellsNumber - 1;
            disp(['M = ', num2str(CellsNumber)]);
            SignalString = CreateStartSCALLOP(w01, wt, w, CellsNumber, NewAmp);
            [NewSequence, NewF, NewAngle] = GenSearch(w01, w12, w, T, tstep,...
            SignalString, NewTheta);
            if (NewAngle == NeededAngle) && (NewF < 1e-4)
                break
            end
        end
    elseif NewAngle > (NeededAngle - AngleThreshold)
        while NewAngle ~= (NeededAngle - AngleThreshold)
            CellsNumber = CellsNumber + 1;
            disp(['M = ', num2str(CellsNumber)]);
            SignalString = CreateStartSCALLOP(w01, wt, w, CellsNumber, NewAmp);
            [NewSequence, NewF, NewAngle] = GenSearch(w01, w12, w, T, tstep,...
            SignalString, NewTheta);
            if (NewAngle == NeededAngle) && (NewF < 1e-4)
                break
            end
        end
    end
end
disp(['�������� ���� Th0 = ', num2str(NeededAngle)]);
disp(['����� ���� ThN = ', num2str(NewAngle)]);
disp('�������� ������������������:');
WriteSequence(NewSequence);
disp(['������ F = ', int2str(NewF)]);