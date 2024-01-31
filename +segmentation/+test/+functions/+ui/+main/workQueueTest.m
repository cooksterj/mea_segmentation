classdef workQueueTest < matlab.unittest.TestCase
    % WORKQUEUETEST - Test class for the
    % segmentation.functions.ui.main.workQueue_f functions.
    %
    % Author:  Jonathan Cook
    % Created: 2019-01-11
    
    properties
        % Testable functions property.
        workQueueHandles;
    end
    
    % Initialization.
    methods (TestClassSetup)
        function ClassSetup(testCase)
            % CLASSSETUP - Set the test case properties.
            
            testCase.workQueueHandles = segmentation.functions.ui.main.workQueue_f;
        end
    end
    
    methods(Test)
        function emptyWellAndElectrode_emptyWell(testCase)
        % EMPTYWELLANDELECTRODE_EMPTYWELLLOGICARRAY Empty well logic
        % array - validate a true is returned.

        wellLogical = [];
        electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];

        verifyTrue(testCase, testCase.workQueueHandles.emptyWellAndElectrode(wellLogical, electrodeLogical))
        end

        function emptyWellAndElectrode_emptyElectrode(testCase)
        % EMPTYWELLANDELECTRODE_EMPTYELECTRODELOGICARRAY Empty electrode
        % logic array - valdate a false is returned.

        wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        electrodeLogical = [];

        verifyTrue(testCase, testCase.workQueueHandles.emptyWellAndElectrode(wellLogical, electrodeLogical))
        end

        function emptyWellAndElectrode_emptyWell_emptyElectrode(testCase)
        % EMPTYWELLANDELECTRODE_EMPTYWELLANDELECTRODELOGICARRAY Empty well
        % and electrode logic array - validate a false is returned.

        wellLogical = [];
        electrodeLogical = [];

        verifyTrue(testCase, testCase.workQueueHandles.emptyWellAndElectrode(wellLogical, electrodeLogical))
        end

        function emptyWellAndElectrode_nonEmptyWell_nonEmptyElectrode(testCase)
        % EMPTYWELLANDELECTRODE_NONEMPTYWELLANDELECTRODELOGICARRAY Non empty
        % well and electrode logic array - validate a true is returned.

        wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];

        verifyFalse(testCase, testCase.workQueueHandles.emptyWellAndElectrode(wellLogical, electrodeLogical))
        end

        function multipleWellMultipleElectrode_singleWell_singleElectrode(testCase)
        % MULTIPLEWELLMULTIPLEELECTRODE_SINGLEWELLLOGICARRAY_SINGLEELECTRODELOGICARRAY
        % Single well and electrode logic array - validate false.

        wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];

        verifyFalse(testCase, testCase.workQueueHandles.multipleWellMultipleElectrode(wellLogical, electrodeLogical))
        end

        function multipleWellMultipleElectrode_multipleWell_singleElectrode(testCase)
        % MULTIPLEWELLMULTIPLEELECTRODE_MULTIPLEWELLLOGICARRAY_SINGLEELECTRODELOGICARRAY
        % Multiple well and single electrode logic array - validate false.

        wellLogical = [1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];

        verifyFalse(testCase, testCase.workQueueHandles.multipleWellMultipleElectrode(wellLogical, electrodeLogical))
        end

        function multipleWellMultipleElectrode_singleWell_multipleElectrode(testCase)
        % MULTIPLEWELLMULTIPLEELECTRODE_SINGLEWELLLOGICARRAY_MULTIPLEELECTRODELOGICARRAY
        % Single well and multiple electrode logic array - validate false.

        wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        electrodeLogical = [1 1 0 0 0 0 0 0 0 0 0 0];

        verifyFalse(testCase, testCase.workQueueHandles.multipleWellMultipleElectrode(wellLogical, electrodeLogical))
        end

        function multipleWellMultipleElectrode_multipleWell_multipleElectrode(testCase)
        % multipleWellMultipleElectrode_multipleWellLogicArray_multipleElectrodeLogicArray
        % Multiple well and electrode logic array - validate true.

        wellLogical = [1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        electrodeLogical = [1 1 0 0 0 0 0 0 0 0 0 0];

        verifyTrue(testCase, testCase.workQueueHandles.multipleWellMultipleElectrode(wellLogical, electrodeLogical))
        end

        function noWellOrElectrodeSelection_singleWell_noElectrode(testCase)
        % NOWELLORELECTRODESELECTION_SINGLEWELL_NOELECTRODE A well has been selected,
        % but no electrode has been selected - verify true.

        wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        electrodeLogical = [0 0 0 0 0 0 0 0 0 0 0 0];

        verifyTrue(testCase, testCase.workQueueHandles.noWellOrElectrodeSelection(wellLogical, electrodeLogical))
        end

        function noWellOrElectrodeSelection_noWell_singleElectrode(testCase)
        % NOWELLORELECTRODESELECTION_NOWELL_SINGLEELECTRODE No well has been selected,
        % but a single electrode has been selected - verify true.

        wellLogical = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];

        verifyTrue(testCase, testCase.workQueueHandles.noWellOrElectrodeSelection(wellLogical, electrodeLogical))
        end

        function noWellOrElectrodeSelection_singleWell_singleElectrode(testCase)
        % NOWELLORELECTRODESELECTION_SINGLEWELL_SINGLEELECTRODE A single well and
        % electrode have been selected - verify false.   

        wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];

        verifyFalse(testCase, testCase.workQueueHandles.noWellOrElectrodeSelection(wellLogical, electrodeLogical))
        end

        function noWellOrElectrodeSelection_noWell_noElectrode(testCase)
        % NOWELLORELECTRODESELECTION_NOWELL_NOELECTRODE No well or electrode have 
        % been selected - verify true. 

        wellLogical = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        electrodeLogical = [0 0 0 0 0 0 0 0 0 0 0 0];

        verifyTrue(testCase, testCase.workQueueHandles.noWellOrElectrodeSelection(wellLogical, electrodeLogical))
        end

        function wellElectrodeValid_multipleWell_singleElectrode(testCase)
        % WELLELECTRODEVALID_MULTIPLEWELL_SINGLEELECTRODE Valid - multiple well per
        % single electrode - verify true.

        wellLogical = [1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];

        verifyTrue(testCase, testCase.workQueueHandles.wellElectrodeValid(wellLogical, electrodeLogical))
        end

        function wellElectrodeValid_singleWell_multipleElectrode(testCase)
        % WELLELECTRODEVALID_SINGLEWELL_MULTIPLEELECTRODE Valid - single well for
        % multiple electrodes - verify true;

        wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        electrodeLogical = [1 1 1 1 0 0 0 0 0 0 0 0];

        verifyTrue(testCase, testCase.workQueueHandles.wellElectrodeValid(wellLogical, electrodeLogical))
        end

        function wellElectrodeValid_multipleWell_multipleElectrode(testCase)
        % WELLELECTRODEVALID_MULTIPLEWELL_MULTIPLEELECTRODE Invalid - multiple wells
        % and electrodes - verify false;

        wellLogical = [1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        electrodeLogical = [1 1 1 1 0 0 0 0 0 0 0 0];

        verifyFalse(testCase, testCase.workQueueHandles.wellElectrodeValid(wellLogical, electrodeLogical))
        end

        function wellElectrodeValid_noWell_noElectrode(testCase)
        % WELLELECTRODEVALID_NOWELL_NOELECTRODE Invalid - no wells or electrodes
        % - verify false.

        wellLogical = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        electrodeLogical = [0 0 0 0 0 0 0 0 0 0 0 0];

        verifyFalse(testCase, testCase.workQueueHandles.wellElectrodeValid(wellLogical, electrodeLogical))
        end

        function wellElectrodeValid_singleWell_noElectrode(testCase)
        % WELLELECTRODEVALID_SINGLEWELL_NOELECTRODE Invalid - single wells and
        % no electrodes - verify false.

        wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        electrodeLogical = [0 0 0 0 0 0 0 0 0 0 0 0];

        verifyFalse(testCase, testCase.workQueueHandles.wellElectrodeValid(wellLogical, electrodeLogical))
        end

        function wellElectrodeValid_noWell_singleElectrode(testCase)
        % WELLELECTRODEVALID_SINGLEWELL_NOELECTRODE Invalid - no wells and
        % single electrodes - verify false.

        wellLogical = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];

        verifyFalse(testCase, testCase.workQueueHandles.wellElectrodeValid(wellLogical, electrodeLogical))
        end

        function unprocessedWellElectrodeQueue_emptyWellElectrodeQueue(testCase)
        % UNPROCESSEDWELLELECTRODEQUEUE_EMPTYWELLELECTRODEQUEUE - empty input
        % parameter - verify empty.

        wellElectrodeQueue = segmentation.model.wellElectrodeData();
        verifyEmpty(testCase, testCase.workQueueHandles.unprocessedWellElectrodeWorkQueue(wellElectrodeQueue));
        end

        function unprocessedWellElectrodeQueue_valid(testCase)
        % UNPROCESSEDWELLELECTRODEQUEUE_VALID - multiple wellElectrodeData
        % objects - only one has an unprocessed flag set to 0
        % (unprocessed) - verify the correct wellElectrodeData object.
        
        wellLogical = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];
        
        % First wellElectrodeData - where the processed flag is set to 1.
        wellElectrodeQueue(1) = segmentation.model.wellElectrodeData(1, wellLogical, electrodeLogical);
        wellElectrodeQueue(1).processed = 1;
        
        % Second wellElectrodeData - where the processed flag remains = 0.
        wellElectrodeQueue(2) = segmentation.model.wellElectrodeData(2, wellLogical, electrodeLogical);
        
        % Thrid wellElectrodeData - where the processed flag is set to 1.
        wellElectrodeQueue(3) = segmentation.model.wellElectrodeData(3, wellLogical, electrodeLogical);
        wellElectrodeQueue(3).processed = 1;
        
        verifyEqual(testCase, ...
            wellElectrodeQueue(2), ...
            testCase.workQueueHandles.unprocessedWellElectrodeWorkQueue(wellElectrodeQueue));
        end

        function unprocessedWellElectrodeQueue_allProcessed(testCase)
        % UNPROCESSEDWELLELECTRODEQUEUE_ALLPROCESSED
        end
    end
end