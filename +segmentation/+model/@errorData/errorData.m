classdef errorData
    % ERRORDATA Error Message
    %   Class to contain constant objects that represent error messages.
    %   Provides a central location where to edit message where necessary.
    %
    % Author:  Jonathan Cook
    % Created: 2019-03-01
    
    properties (Constant)
        msgMultipleWellsMultipleElectrodes = "Multiple [or Zero] Wells and/or Electrodes detected. Well size:%d, Electrode size:%d";
        msgNoH5Selection = "No H5 file was selected.";
        msgWellElectrodeCheckboxesEmpty = "Well or Electrode selection are empty (or both).";
        msgWellLogicArrayEmpty = "Incorrect well logic array - empty";
        msgWellLogicArrayIncorrectSize = "Incorrect well logic array - size.";
        msgWellSelectionUIGeneral = "Fault with the well logical array - UI related error";
        msgElectrodeLogicArrayEmpty = "Incorrect electrode logic array - empty.";
        msgElectrodeLogicArrayIncorrectSize = "Incorrect electrode logic array - size.";
        msgElectrodeSelectionUIGeneral = "Fault with the electrode logical array - UI related error";
        msgPeakDataVoltageScaleIncorrectMax = "The input paramter voltageScale does not have a max value equal to one.";
        msgPeakDataVoltageScaleOutOfRange = "The scaled voltage is out of range with respect to the apdPct.";
        msgPeakDataVoltageScaleAndTimeSizeMismatch = "The scaled time and voltage vectors do not equal in size";
        msgPeakDataLinearInterpolationNaN = "Linear interpolation resulted in a NaN.";
        msgPeakDataLinearInterpolationGeneral = "Linear interpolation failed.";
        msgExperimentDataNoH5OrStruct = "The baseline file name is not a .h5 or .mat.  Please contact Research Analytics.";
        msgExperimentApOmitNotDetected = "An unitialized apOmit status has been detected.  Please contact Research Analytics.";
        msgExperimentFpOmitNotDetected = "An unitialized fpOmit status has been detected.  Please contact Research Analytics.";
        msgMultipleOutDataObjects = "Multiple outData objects detected.  Please contact Research Analytics for help";
        msgFieldDataGeneral = "Unable to create fieldData object.";
        msgApdDataNotInitialized = "The apdData vector is not initialized.";
        msgApdDataMissingFirstPeak = "Peak Num 1 is missing.";
        msgApdDataAttenuation = "Unable to calculate attenuation.";
        msgApdDataNegativeDiastolicInterval = "A negative diastolic interval has been calculated."
        msgDistinctWellNonNumeric = "The input to distinct_f.m is not a numeric array. Well identification cannot take place.";
        msgCycleCalculationsVoltageVectorEmpty = "The voltage vector is empty - voltage value isolation failed.";
        msgCycleAggregateCalculationsMultipleStartStop = "Only a single start or stop interval can be processed at a time.";
        msgCycleAggregateCalculationsEmptyStartStop = "One of the start, stop, or segmented time paremeters is empty";
        msgCycleAggregateCalculationsInvalidStartStop = "The start time of %s or stop time of %s is not valid";
        msgCycleAggregateCalculationsStartGreaterStop = "The start time of %s is incorrect with respect to the stop time of %s"
        msgCycleAggregateCalculationsTimeEmpty = "The segmented time or cycle vector is empty";
        msgCycleAggregateCalculationsTroughOutOfRange = "One of the time points associated with a start/stop cycle is out of range with respect to the segmented waveform";
        msgCycleAggregateCalculationsTroughNotEqual = "One of the time points associated with a start/stop cycle is not equal to at least one value in the segmented waveform";
        msgIncorrectSectionType = "Incorrect section type has been specified.";
        msgIncorrectSmoothAlgorithmType = "Incorrect smoothing algorithm has been specified.";
    end
end