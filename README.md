optimization algorithm for single qubit gates using RSFQ pulses

Алгоритм:
main — файл запуска
CreateAmpThresholds — создание всех возможных значений лимитирующей амплитуды
CreateStartSCALLOP — создание стартовой последовательности для заданной лимитирующей амплитуды
Fidelity — расчёт фиделити на равномерной сетке с шагом tstep
FidelityOpt — оптимизированный расчёт фиделити на сетке
GenSearch — тело генетического алгоритма
NewThetaOptimizer — подбор нужного угла для выбранной последовательности для поворота на pi/2
RotateCheck — проверка угла поворота
Umatrix — расчёт матрицы эволюции для заданного гамильтониана 

Вспомогательные штуки:
CountFildelity — расчёт фиделити и вывод
WriteSequence — вывод последовательности
