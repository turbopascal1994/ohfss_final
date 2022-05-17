function FinalTheta = ...
    NewThetaOptimizer(w01, w12, w, T, tstep, InputSequence, UnOptTheta)

SmolStep = 0.0005; % Шаг, если близко к поворотк
BigStep = 0.005; % Шаг, если далеко от поворота

PCrit = 0.01; % Критерий точности поворота
StepCrit = 0.15; % Критерий выбора шага
P = 0;
Rot = 0.5; % Желаемый уровень населённости кубита
% Будем считать, что это невероятно простой градиентный спуск
Theta = UnOptTheta;
while abs(P - Rot) > PCrit
    P = RotateCheck(w01, w12, w, T, tstep, InputSequence, Theta);
    if abs(P - Rot) > PCrit
        if (abs(P - Rot) >= StepCrit) && (P > Rot)
            ThetaStep = BigStep;
        end
        if (abs(P - Rot) >= StepCrit) && (P < Rot)
            ThetaStep = -BigStep;        
        end
        if (abs(P - Rot) < StepCrit) && (P > Rot)
            ThetaStep = SmolStep;
        end
        if (abs(P - Rot) < StepCrit) && (P < Rot)
            ThetaStep = -SmolStep;
        end
    else
        ThetaStep = 0;
    end
    Theta = Theta + ThetaStep;            
end
FinalTheta = Theta;
disp(['Theta = ', num2str(FinalTheta)]);
end
