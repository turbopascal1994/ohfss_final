clear;
tstep = 1e-14; % Шаг для расчёта НУШ

% Параметры кубита
w01 = 5.001*2*pi*1e9; % Частота 0-1
w12 = w01 - 0.2*2*pi*1e9; % Частота 1-2

% Параметры операции
wt = 25*2*pi*1e9; % Тактовая частота
w = 4*1e-12; % Длительность импульса
T = 2*pi/wt; % Период м/д импульсами
Theta = 0.001; % Угол поворота (до оптимизации)
CellsNumber = 120; % Количество ячеек в последовательности
Len = CellsNumber*T + w;

NeededAngle = 0.024; % Необходимый угол
AngleThreshold = 0.0005; % Допустимая погрешность по углу

StartSequence = [];
Angle = NewThetaOptimizer(w01, w12, w, T, tstep, StartSequence, Theta);

if abs(NeededAngle - Angle) == 0
    disp('Изменение длины последовательности ничего не даст');
    NewSequence = StartSequence;
else
    % Меняем длину последовательности, "подбираясь" к нужному углу
    disp('Теперь меняем длину последовательности M.')
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
disp(['Желаемый угол Th0 = ', num2str(NeededAngle)]);
disp(['Новый угол ThN = ', num2str(NewAngle)]);
disp('Конечная последовательность:');
WriteSequence(NewSequence);
disp(['Утечка F = ', int2str(NewF)]);
