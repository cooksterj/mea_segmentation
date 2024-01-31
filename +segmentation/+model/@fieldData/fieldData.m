classdef fieldData
    % FIELDDATA field potential class.
    %   Using the field potential's voltage (fieldPotentialVoltage) and time measurements (fieldPotentialTime),
    %   the object's attributes will be calculated.
    %
    % Author:  Jonathan Cook
    % Created: 2018-08-24
    
    properties
        peakNum
        fieldPotentialVoltage  % Field potential voltage measurements relating to the peakNum.
        fieldPotentialTime     % Field potential time measurements relating to the peakNum.
        startTime              % Start time for the field potential.
        stopTime               % Stop time for the field potential.
        peakTime               % Time where the maximum voltage has been identified.
        peakVoltage            % Maximum voltage - also corresponds to the voltage at peakTime.
        absAmplitude           % Field potential amplitude.
        instantFrequency       % The instantaneous frequency with respect to the 'next' waveform.
        avgFrequency           % The average frequency with respect to the overall segmentation.
        slope                  % The slope of the field potential.
        cycleLength            % Elapsed time with respect to the 'next' waveform.
    end
    
    methods
        function obj = fieldData(peakNum, fieldPotentialTime, fieldPotentialVoltage, startTime, stopTime)
            % FIELDDATA Constructor
            %
            % INPUT:
            %     peakNum:                Peak number.
            %     fieldPotentialTime:     Field potential time.
            %     fieldPotentialVoltage:  Field potential voltage.
            %     startTime:              Start time for the field potential.
            %     stopTime                Stop time for the field potential.
            %
            % OUTPUT:
            %     Initialized fieldData object.
            
            if nargin > 0
                obj.peakNum = peakNum;
                obj.fieldPotentialVoltage = fieldPotentialVoltage;
                obj.fieldPotentialTime = fieldPotentialTime;
                obj.startTime = startTime;
                obj.stopTime = stopTime;
                
                cycleCalc = segmentation.functions.cycleCalculations_f;
                obj.peakTime = cycleCalc.cyclePeakTime(obj.fieldPotentialTime, obj.fieldPotentialVoltage);
                obj.peakVoltage = cycleCalc.cyclePeakVoltage(obj.fieldPotentialVoltage);
                minVoltage = cycleCalc.cycleMinVoltage(obj.fieldPotentialTime, obj.fieldPotentialVoltage, obj.peakTime);
                obj.absAmplitude = cycleCalc.cycleABSAmplitude(obj.peakVoltage, minVoltage);
            end
        end
    end
end
