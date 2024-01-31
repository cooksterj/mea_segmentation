classdef outData
    % OUTDATA OutData class.
    %   Attributes related to each baseline waveform.  Within each baseline waveform there could
    %   either be a field potential section [fpSection], action potential section [apSection], or both.
    %   If data is to be summarized on the base waveform, it should be placed in this class.
    %
    % See also:
    % apdData [action potential object] = apSection
    % fieldData  [field potential object] = fpSection
    %
    % Author:  Jonathan Cook
    % Created: 2018-07-07
    
    properties
        index                      % Identifier - auditing purposes only.
        time                       % Time measurments.
        voltage                    % Voltage measurements.
        esub                       % Electroporation time stamps.
        experimentNum              % Experiment identifier.
        wellElectrodeData          % Well electrode data object.
        medicationName             % The medication name [default value = No Medication].
        medicationConcen           % The medication concentration [default value = no Concentration].
        apSection                  % Action potential section.
        fpSection                  % Field potential section.
    end
    
    properties (Constant)
        version = '3.0.0';  % Version of release.
    end
    
    methods
        function obj = outData(index, time, voltage, esub, experimentNum, wellElectrodeData)
            % OUTDATA Constructor - during instantiation, the baseline attributes of the
            % outData object will be created from the input parameters.
            %
            % INPUT:
            %     index:              Arbitrary number that is assigned during initalization.  For auditing purposes.
            %     time:               The time measurements for the well/electrode.
            %     voltage:            The voltage measurements for the well/electrode.
            %     esub:               The electroporation times during experimentation.
            %     experimentNum:      A number relating to how many start/stop times have been identified.
            %     wellElectrodeData:  A wellElectrodeData object.
            %
            % OUTPUT:
            %     Initialized outData object.
            
            if nargin > 0
                obj.index = index;
                obj.voltage = voltage;
                obj.time = time;
                obj.esub = esub;
                obj.experimentNum = experimentNum;
                obj.wellElectrodeData = wellElectrodeData;
                obj.medicationName = 'No Medication';
                obj.medicationConcen = 'No Concentration';
            end
        end
    end
end