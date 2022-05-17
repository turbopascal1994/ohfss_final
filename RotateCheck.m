function P1 = RotateCheck(w01, w12, w, T, tstep, ...
    SignalString, Theta)

CellsNumber = length(SignalString);
Id = [1 0 0; 0 1 0; 0 0 1]; % ��������� �������
h = 1.054e-34; % ���������� ������
C1 = 1e-12; % ������� �� ������
F0 = 2.06e-15; % ����� ���������� ������

dt = 0:tstep:Len-tstep;

% ���������� ������������������ � �������
V = F0/w; % ����������
Cc = Theta/(F0*sqrt(2*w01/(h*C1))); % ���� ������� 
Amp = Cc*V*sqrt(h*w01/(2*C1)); % ��������� ��������

y = zeros(1,length(dt));
k = 1;
while k <= CellsNumber
	a = (k-1)*T;
    b = (k-1)*T + w;
	y = y + SignalString(k)*Amp*(dt >= a & dt <= b);
	k = k + 1;
end
imp = y;

% ��������� ������ � ������
H0 = [0 0 0; 0 h*w01 0; 0 0 h*w01+h*w12]; % ������������� ������������
[EigVec, EigVal] = eig(H0); % ������� �� � ��
[~, ind] = sort(diag(EigVal)); % ��������� ��
EigVals = EigVal(ind,ind);
EigVecs = EigVec(:,ind); % ��������� ��

WF1 = EigVec(:,1); % ��������� |0>
WF2 = EigVec(:,2); % ��������� |1>
WF3 = EigVec(:,3); % ��������� |2>
WF1c = ctranspose(WF1);
WF2c = ctranspose(WF2);
WF3c = ctranspose(WF3);

% ����������� ������������
Hmatrix = [0 -1 0; 1 0 -sqrt(2); 0 sqrt(2) 0];
Prob1 = zeros(1,length(dt));
Prob2 = zeros(1,length(dt));
Prob3 = zeros(1,length(dt));
WF = WF1; % �� �������� �������

% ������ ��� � ����� tstep �� ����� ����
HrPlus = 1i*Amp*Hmatrix + H0;
HrMinus = -1i*Amp*Hmatrix + H0;
HrZero = H0;
    
UPlus = (Id - 1i*HrPlus*tstep/(2*h))/(Id + 1i*HrPlus*tstep/(2*h));
UMinus = (Id - 1i*HrMinus*tstep/(2*h))/(Id + 1i*HrMinus*tstep/(2*h));
UZero = (Id - 1i*HrZero*tstep/(2*h))/(Id + 1i*HrZero*tstep/(2*h));
    
for j = 1:1:length(dt)
    switch imp(j)
        case Amp
            U = UPlus;
        case -Amp
            U = UMinus;
        case 0
            U = UZero;
    end
	WF = U*WF; % ��������� �������� �������� � ��
	% ������� ����������� ����������� �������
	Prob1(j) = abs(WF1c*WF)^2;
	Prob2(j) = abs(WF2c*WF)^2;
	Prob3(j) = abs(WF3c*WF)^2;
end
P1 = Prob1(length(Prob1));

