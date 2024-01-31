classdef waveformGenerator
    % WAVEFORMGENERATOR Creation of test waveforms.
    %     Only to be used to assist with the analysis in the test cases.
    %
    % Author:  Jonathan Cook
    % Created: 2018-08-23
    
    properties(Access = private)
        secondsPerSample = 1 / 2048;     % Data points per waveform.
        period                           % Max value of one complete cycle.
        waveformX                        % X-axis data.
    end
    
    properties
        frequency     % Cycle frequency (i.e. 1 = one cycle per second, 60 = sixty cycles per second).
        numOfCycles   % Number of desired cycles - This value, coupled with the period, frequency, yields waveformX.
        coefficient   % Waveform multipier (i.e. 2 = each 'y' value will be multiplied by 2).
        shift         % Waveform shift (i.e. 5 = the entire waveform will be shifted in the verticle position by a value of 5).
    end
    
    methods
        function obj = waveformGenerator(varargin)
            % WAVEFORMGENERATOR Constructor.  If no parameters are
            % provided, each attribute is set to a value of zero.
            
            if nargin == 0
                obj.frequency = 0;
                obj.numOfCycles = 0;
                obj.coefficient = 0;
                obj.shift = 0;
            else
                obj.frequency = varargin{1};
                obj.numOfCycles = varargin{2};
                obj.coefficient = varargin{3};
                obj.shift = varargin{4};
                
                obj.period = obj.numOfCycles / obj.frequency;
                obj.waveformX = (0:obj.secondsPerSample:obj.period);
            end
        end
        
        function[x, y] = sinusoid(obj)
            % SINUSOID Generate x and y values of a simple sinosidal
            % waveform.
            %
            % OUTPUT:
            %     x: Generated x values.
            %     y: Genearted y values.
            
            x = obj.waveformX;
            y = obj.shift + (obj.coefficient * sin(2 * pi * obj.frequency * obj.waveformX));
        end
        
        function[x, y] = variableAmplitudeSinsoid(obj, oddFlag)
            % VARIABLEAMPLITUDESINSOID Generate x and y values of a
            % sinusoidal waveform with varying amplitudes.  The
            % amplitude of odd or even cycles is decreased by 0.5.
            % This is dictated by the oddFlag.
            %
            % INPUT:
            %     oddFlag: If 'true', the odd cycle's amplitude will be
            %     decreased by a value of 0.5.  If 'false', the even
            %     cycle's amplitude will be decreased by a value of 0.5.
            %
            % OUTPUT:
            %     x:  Generated x values.
            %     y:  Generated y values.
            
            if(isempty(oddFlag))
                error('MATLAB:variableAmplitudeSinsoid:nullOddFlag',...
                    'The oddFlag is not properly set to true or false.');
            end
            
            [x, y] = sinusoid(obj);
            target = (0:1:obj.numOfCycles);
            
            if(oddFlag)
                waveformPeakNum = target(logical(mod(target, 2)));
            else
                waveformPeakNum = target(logical(mod(target, 2) == 0));
            end
            
            for i = 1:length(waveformPeakNum)
                stop = waveformPeakNum(i);
                if i == 1
                    start = 0;
                elseif i > 1
                    start = stop - 1;
                end
                conditional = (x >= start & x <= stop);
                y(conditional) = y(conditional) * 0.5;
            end
        end
        
        function[x, y] = sawtooth(obj)
            % SAWTOOTH Generate x and y values for a sawtooth waveform.
            %
            % NOTE: Depends on the Signal Processing Toolbox.
            %
            % OUTPUT:
            %     x:  Generated x values.
            %     y:  Generated y values.
            
            x = obj.waveformX;
            y = obj.shift + (obj.coefficient * sawtooth(2 * pi * obj.frequency * obj.waveformX));
        end
        
        function[x, y] = singleTeepee(obj)
            % SINGLETEEPEE Generate a single spike waveform where the x
            % values start at -10 and proceed to +10.  The y values will
            % reach a peak value of 1.0 when x = 0.
            %
            % OUTPUT:
            %     x:  Generated x values.
            %     y:  Generated y values.
            
            % All x values starting at -10 to 10, incrementing by 0.25.
            x = (-10:0.01:10);
            
            % Positive slope - starting at zero and incrementing by 0.025
            % until 0.9750 - to avoid duplicate vector values with respect
            % to y2.
            y1 = (0:0.001:0.9990);
            
            % Negative slope - starting at one and decrementing by 0.025
            % until 0.
            y2 = (1:-0.001:0);
            
            % Concatenate values to form the y-axis values for the teepee.
            y = [y1 y2];
        end
        
        function[x, y] = sizeZ(obj)
            % SIZEZ Generate a 'lightening' looking waveform (z placed on its
            % side).
            %
            % OUTPUT:
            %     x:  Generated x values.
            %     y:  Generated y values.
            
            % All of the x values.
            x = (0:0.01:5.5);
            
            % Three different segments to create a different slope (negative)
            % between the max and min peak values.
            y1 = (0:0.01:1.99);
            y2 = (2:-0.1:-2.99);
            y3 = (-3:0.01:0);
            
            % Concatenate the values.
            y = [y1, y2, y3];
        end
    end
end
