function F = ...
    FidelityOpt(w01, w12, w, T, tstep, SignalString, Theta)

CellsNumber = length(SignalString);
h = 1.054e-34; % ���������� ������
C1 = 1e-12; % ������� �� ������
F0 = 2.06e-15; % ����� ���������� ������
Id = [1 0 0; 0 1 0; 0 0 1];

% ���������� ������������������ � �������
V = F0/w; % ����������
Cc = Theta/(F0*sqrt(2*w01/(h*C1))); % ���� ������� 
Amp = Cc*V*sqrt(h*w01/(2*C1)); % ��������� ��������
    
% ��������� ������ � ������
H0 = [0 0 0; 0 h*w01 0; 0 0 h*w01+h*w12]; % ������������� ������������
[EigVec, EigVal] = eig(H0); % ������� �� � ��
[~, ind] = sort(diag(EigVal)); % ��������� ��
EigVals = EigVal(ind,ind);
EigVecs = EigVec(:,ind); % ��������� ��

WF1 = EigVec(:,1); % ��������� |0>
WF2 = EigVec(:,2); % ��������� |1>
WF3 = EigVec(:,3); % ��������� |2>

% ������ �.�.
% |z+> = [0 1 0]
% |z-> = [1 0 0]
% |x+> = [1/sqrt(2)  1/sqrt(2)  0]
% |x-> = [1/sqrt(2) -1/sqrt(2)  0]
% |y+> = [1/sqrt(2)  1i/sqrt(2) 0]
% |y-> = [1/sqrt(2) -1i/sqrt(2) 0]
InitStates = ...
   [1 0 1/sqrt(2) 1/sqrt(2) 1/sqrt(2) 1/sqrt(2);...
    0 1 1/sqrt(2) -1/sqrt(2) 1i/sqrt(2) -1i/sqrt(2);...
    0 0 0 0 0 0];

% ������� �������� ������ ��� ��������� �.�.
Leak1 = zeros(1,CellsNumber);
Leak2 = zeros(1,CellsNumber);
Leak3 = zeros(1,CellsNumber);
Leak4 = zeros(1,CellsNumber);
Leak5 = zeros(1,CellsNumber);
Leak6 = zeros(1,CellsNumber);

% �������������
Hmatrix = [0 -1 0; 1 0 -sqrt(2); 0 sqrt(2) 0]; % ����������� ������������
HrPlus = 1i*Amp*Hmatrix + H0;
HrMinus = -1i*Amp*Hmatrix + H0;
HrZero = H0;

% ���������� �������� �������� ��� ����� ����������� ���������
UPlusStep = UMatrix(HrPlus,tstep);
UMinusStep = UMatrix(HrMinus,tstep);
UZeroStep = UMatrix(HrZero,tstep);
UPlus = Id;
UMinus = Id;
UZero = Id;

for i = 1:1:(w/tstep)
    UPlus = UPlusStep*UPlus;
    UMinus = UMinusStep*UMinus;
    UZero = UZeroStep*UZero;
end

% ���������� �������� �������� ��� ����� �����
UTStep = UMatrix(HrZero,tstep);
UT = Id;

for i = 1:1:((T - w)/tstep)
    UT = UTStep*UT;
end
UTPlus = UT*UPlus;
UTMinus = UT*UMinus;
UTZero = UT*UZero;

for IS = 1:1:6
    Prob1 = zeros(1,CellsNumber);
    Prob2 = zeros(1,CellsNumber);
    Prob3 = zeros(1,CellsNumber);
    WF = InitStates(:,IS); % �� �������� �������
    for j = 1:1:CellsNumber
        switch SignalString(j)
            case 1
                U = UTPlus;
            case -1
                U = UTMinus;
            case 0
                U = UTZero;
        end
        WF = U*WF; % ��������� �������� �������� � ��
        % ������� ����������� ����������� �������
        Prob1(j) = abs(ctranspose(WF1)*WF)^2;
        Prob2(j) = abs(ctranspose(WF2)*WF)^2;
        Prob3(j) = abs(ctranspose(WF3)*WF)^2;
    end   
    switch IS
        case 1
            Leak1 = Prob3;
        case 2
            Leak2 = Prob3;
            RotateProb1 = Prob1;
            RotateProb2 = Prob2;
            RotateProb3 = Prob3;
        case 3
            Leak3 = Prob3;
        case 4
            Leak4 = Prob3;
        case 5
            Leak5 = Prob3;
        case 6
            Leak6 = Prob3;
    end
end
PR1 = Leak1(length(Leak1));
PR2 = Leak2(length(Leak2));
PR3 = Leak3(length(Leak3));
PR4 = Leak4(length(Leak4));
PR5 = Leak5(length(Leak5));
PR6 = Leak6(length(Leak6));
F = 1/6*(PR1 + PR2 + PR3 + PR4 + PR5 + PR6);
P0 = RotateProb1(length(RotateProb1));
P1 = RotateProb2(length(RotateProb2));
P2 = RotateProb3(length(RotateProb3));
%hold on;
%    plot(CellsNumber, RotateProb1, 'r', 'LineWidth', 1);
%    plot(CellsNumber, RotateProb2, 'b', 'LineWidth', 1);
%    plot(CellsNumber, RotateProb3, 'm', 'LineWidth', 1);
%    xlim([0,0.5e-8]);
%hold off;
disp('� ������������');
disp(['P0 = ', num2str(P0), ', P1 = ', num2str(P1), ', P2 = ', num2str(P2)]);
end