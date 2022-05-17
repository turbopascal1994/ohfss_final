function FinalTheta = ...
    NewThetaOptimizer(w01, w12, w, T, tstep, InputSequence, UnOptTheta)

SmolStep = 0.0005; % ���, ���� ������ � ��������
BigStep = 0.005; % ���, ���� ������ �� ��������

PCrit = 0.01; % �������� �������� ��������
StepCrit = 0.15; % �������� ������ ����
P = 0;
Rot = 0.5; % �������� ������� ����������� ������
% ����� �������, ��� ��� ���������� ������� ����������� �����
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
