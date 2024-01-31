classdef apdData
    % APDDATA Action potential duration class.
    %   Using the action potential's voltage (actionPotentialVoltage) and time
    %   measurements (actionPotentialTime), the object attributes will be calculated.
    %   Within each apdData object, there is peakData object that contains the
    %   repolarization information.
    %
    % Author:  Jonathan Cook
    % Created: 2018-07-24
    
    properties
        peakNum                 % Number of the peak - unique to the particular segmentation.
        actionPotentialVoltage  % All voltage potentials for the waveform - that has been smoothed.
        actionPotentialTime     % All time values for the waveform.
        startTime               % Start time for the action potential.
        stopTime                % End time for the action potential.
        peakTime                % Time where the maxima voltage is identified.
        peakVoltage             % Maximum voltage - also corresponds to the voltage at peakTime.
        absAmplitude            % Action potential amplititude
        timeScale               % The time scale
        voltageScale            % The voltage scale
        peakData                % Object where the repolorization calculation are determined.
        attenuation             % Attenuation with respect to the the first peakNum (1).  If peakNum = 1, value will be equal to 0;
        instantFrequency        % The instantaneous frequency with respect to the 'next' waveform.
        avgFrequency            % The average frequency with respect to the overall segmentation.
        diastolicInterval       % The diastolic interval - always 'looking' back at the previous waveform.
        cycleLength             % Elapsed time with respect to the 'next' waveform.
    end
    
    methods
        function obj = apdData(peakNum, actionPotentialTime, actionPotentialVoltage, startTime, stopTime)
            % APDDATA Constructor - during instantiation, the attributes of the action potential will
            %   be determined from the input parameters.
            %
            % INPUT:
            %     peakNum:                 Peak number.
            %     actionPotentialVoltage:  Action potential voltage.
            %     actionPotentialTime:     Action potential time.
            %     startTime                Start time for the action potential.
            %     stopTime                 Stop time for the action potential.
            %
            % OUTPUT:
            %     Initialized apdData object.
            
            if nargin > 0
                % Baseline state.
                obj.peakNum = peakNum;
                obj.actionPotentialVoltage = actionPotentialVoltage;
                obj.actionPotentialTime = actionPotentialTime;
                obj.startTime = startTime;
                obj.stopTime = stopTime;
                
                % Attributes to help define the state.
                cycleCalculations = segmentation.functions.cycleCalculations_f;
                obj.peakTime = cycleCalculations.cyclePeakTime(obj.actionPotentialTime, obj.actionPotentialVoltage);
                minPeakVoltage = cycleCalculations.cycleMinVoltage(obj.actionPotentialTime, obj.actionPotentialVoltage, obj.peakTime);
                obj.peakVoltage = cycleCalculations.cyclePeakVoltage(obj.actionPotentialVoltage);
                obj.absAmplitude = cycleCalculations.cycleABSAmplitude(obj.peakVoltage, minPeakVoltage);
                obj.timeScale = calcTimeScale(obj, obj.actionPotentialTime, obj.peakTime);
                obj.voltageScale = calcVoltageScale(obj, obj.actionPotentialVoltage, minPeakVoltage, obj.absAmplitude);
            end
        end
        
        function rslt = calcTimeScale(~, actionPotentialTime, peakTime)
            % CALCTIMESCALE Shift the time vector - the peak time will be
            % equal to the origin (0,0) on the cartesian coordinate system.
            %
            % INPUT:
            %     actionPotentialTime:  Action potential time vector.
            %     peakTime:             Point in time where the peak voltage of the a
            %                           action potential is present.
            %
            % OUTPUT:
            %     The scaled time where the peakTime will be centered on the origin of a
            %     cartesian coordinate system (0,0).  If either the actionPotentialTime
            %     or the peak time parameters are empty, the resultant shifted time
            %     vector will be empty.
            
            rslt = [];
            if(~isempty(actionPotentialTime) && ~isempty(peakTime))
                rslt = actionPotentialTime - peakTime;
            end
            
        end
        
        function rslt = calcVoltageScale(~, actionPotentialVoltage, minPeakVoltage, actionPotentialAmplitude)
            % CALCVOLTAGESCALE Voltage scaling - normalize the voltage to the amplitude.
            %
            % INPUT:
            %     actionPotentialVoltage:    Action potential volage vector.
            %     minPeakVoltage:            Smallest action potential voltage.
            %     actionPotentialAmplitude:  The action potential amplitude.
            %
            % OUTPUT:
            %     The normalized voltage with respect to the action potential
            %     amplitude. If any of the parameters are empty, the resultant
            %     scaled voltage vector will be empty.
            
            rslt = [];
            if(~isempty(actionPotentialVoltage) && ~isempty(minPeakVoltage) && ~isempty(actionPotentialAmplitude))
                rslt = (actionPotentialVoltage - minPeakVoltage) ./ actionPotentialAmplitude;
            end
        end
    end
end
