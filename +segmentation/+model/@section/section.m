classdef section
    % SECTION Waveform sub-set section definition.
    %   A section (sub-set) of data within the overall acquisitioned data.
    %   The attributeData object could be either a fieldData or apdData
    %   object - depending if the sectionType attribute is equal to
    %   ACTION_POTENTIAL or FIELD_POTENTIAL.
    %
    % During instantiation - the attributeData attribute is not
    % initialized.  This attribute is set when the user interacts with the
    % user interface.
    %
    % See also:
    % segmentation.model.sectionType
    % segmentation.model.smoothAlgorithmType
    %
    % Author:  Jonathan Cook
    % Created: 2019-02-28
    
    properties
        sectionType                      % The section type (see the sectionType class).
        voltageSection                   % Voltage measurements within the section.
        voltageSectionSmoothed           % Voltage measurments after applying the smoothing algorithm within the section.
        voltageSectionSmoothedAlgorithm  % The type of smoothing algorithm used (see the smoothAlgorithmType class).
        timeSection                      % Time measurements within the section.
        leftCursorLoc                    % The starting cursor position for the section.
        rightCursorLoc                   % The stopping cursor position for the section.
        processed                        % Processed flag - defines if the section was processed/viewed.
        omit                             % Omit flag - defines if something is wrong with the data.
        attributeData                    % Attribute data can be either an apdData or fieldData object.
    end
    
    methods
        function obj = section(sectionType, ...
                voltageSection, ...
                voltageSectionSmoothed, ...
                voltageSectionSmoothedAlgorithm, ...
                timeSection, ...
                leftCursorLoc, ...
                rightCursorLoc)
            % SECTION Constructor.
            % By default, the processed and omit flags are set to 0, and
            % the attributData object is not initiaized.  Initialization of
            % the attributData object happens during user interaction with
            % with the user interface, were the segement of interest is
            % identified.
            %
            % INPUT:
            %     sectionType:                      Enum of sectionType.
            %     voltageSection:                   Raw voltage measurements.
            %     voltageSectionSmoothed:           Smoothed voltage measurements.
            %     voltageSectionSmoothedAlgorithm:  Enum of smoothAlgorithmType.
            %     timeSection:                      Raw time measurements.
            %     leftCursorLoc:                    Left cursor position.
            %     rightCursorLoc:                   Right cursor position.
            %
            % EXCEPTION:
            %     [1] If input parameter sectionType is not of type segmentation.model.sectionType.
            %     [2] if input parameter voltageSectionSmoothedAlgorithm is not of type segmentation.model.smoothAlgorithmType.
            
            if nargin > 0
                if (~strcmp(class(sectionType), "segmentation.model.sectionType"))
                    error('MATLAB:sectionType:invalid', ...
                        segmentation.model.errorData.msgIncorrectSectionType);
                end
                
                if(~strcmp(class(voltageSectionSmoothedAlgorithm), "segmentation.model.smoothAlgorithmType"))
                    error('MATLAB:smoothAlgorithmType:invalid', ...
                        segmentation.model.errorData.msgIncorrectSmoothAlgorithmType);
                end
                
                obj.sectionType = sectionType;
                obj.voltageSection = voltageSection;
                obj.voltageSectionSmoothed = voltageSectionSmoothed;
                obj.voltageSectionSmoothedAlgorithm = voltageSectionSmoothedAlgorithm;
                obj.timeSection = timeSection;
                obj.leftCursorLoc = leftCursorLoc;
                obj.rightCursorLoc = rightCursorLoc;
                obj.processed = 0;
                obj.omit = 0;
            end
        end
    end
end
