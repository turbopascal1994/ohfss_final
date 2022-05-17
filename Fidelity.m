function F = ...
    Fidelity(w01, w12, w, T, Len, tstep, SignalString, Theta)

CellsNumber = length(SignalString);
Id = [1 0 0; 0 1 0; 0 0 1]; % Единичная матрица
h = 1.054e-34; % Постоянная Планка
C1 = 1e-12; % Емкость из статьи
F0 = 2.06e-15; % Квант магнитного потока

dt = 0:tstep:Len-tstep;

% Превращаем последовательность в импульс
V = F0/w; % Напряжение
Cc = Theta/(F0*sqrt(2*w01/(h*C1))); % Тоже емкость 
Amp = Cc*V*sqrt(h*w01/(2*C1)); % Амплитуда импульса

y = zeros(1,length(dt));
k = 1;
while k <= CellsNumber
	a = (k-1)*T;
    b = (k-1)*T + w;
	y = y + SignalString(k)*Amp*(dt >= a & dt <= b);
	k = k + 1;
end
imp = y;
    
% Применяем сигнал к кубиту
H0 = [0 0 0; 0 h*w01 0; 0 0 h*w01+h*w12]; % Невозмущенный гамильтониан
[EigVec, EigVal] = eig(H0); % Находим СЗ и СФ
[~, ind] = sort(diag(EigVal)); % Сортируем СФ
EigVals = EigVal(ind,ind);
EigVecs = EigVec(:,ind); % Сортируем СЗ

WF1 = EigVec(:,1); % Состояние |0>
WF2 = EigVec(:,2); % Состояние |1>
WF3 = EigVec(:,3); % Состояние |2>

% Массив н.у.
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

% Массивы хранения утечки при различных н.у.
Leak1 = zeros(1,length(dt));
Leak2 = zeros(1,length(dt));
Leak3 = zeros(1,length(dt));
Leak4 = zeros(1,length(dt));
Leak5 = zeros(1,length(dt));
Leak6 = zeros(1,length(dt));

for IS = 1:1:6
    % Возмущенный гамильтониан
    Hmatrix = [0 -1 0; 1 0 -sqrt(2); 0 sqrt(2) 0];
    Prob1 = zeros(1,length(dt));
    Prob2 = zeros(1,length(dt));
    Prob3 = zeros(1,length(dt));
    WF = InitStates(:,IS); % НУ волновой функции

    % Решаем НУШ с шагом tstep по схеме Кэли
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
        WF = U*WF; % Применяем оператор эволюции к ВФ
        % Считаем вероятности населённости уровней
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
hold on;
    plot(dt,RotateProb1,'r', 'LineWidth', 1);
    plot(dt,RotateProb2,'b', 'LineWidth', 1);
    plot(dt,RotateProb3,'m', 'LineWidth', 1);
    xlim([0,0.5e-8]);
hold off;
disp(['P0 = ', num2str(P0), ', P1 = ', num2str(P1), ', P2 = ', num2str(P2)]);
end