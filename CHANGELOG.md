# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) 
and this project adheres to [Semantic Versioning](http://semver.org/).

### Added
- Allow multiple electrodes per single well to be added to the work queue.
- If multiple electrodes and/or wells are selected - an warning message will be displayed to user.
- Library of error/warning messages.
- The ability to skip a work queue well electrode combination by manually selecting the processed flag.
- The ability to redo a work queue well electrode combination by manually unselecting the processed flag.

### Changed
- All directories have been switched to utilize a package scheme.
- Progress bar has been de-coupled from the main user interface.  A popup window will now be
displayed.

## 2.5.1 User Interface Improvements
### Added

### Changed
- If multiple electrodes are selected, the user interface will display a warning message to the console to 
only select a single electrode.
- All function .m files have had been moved into their own directory - organizational purposes.

### Removed

## 2.5.0 Workflow Queue
### Added
- Queue button to create a work order of well/electrodes to process.
- View button to display the work queue at the user's descretion.
- Redo button to allow the user to reposition the cursors for the action or field potentials.
- Well and electrode mapping object to create UI friendly attributes.

### Changed
- The size and position of the actionable buttons have been made consistent.
- Panel size has been adjusted for consistency.
- Medication name/concentration moved to the upper right corner.
- Consoldated the initalize button, queue, and view buttons into a new initalization panel.
- The field potential basic statistic box plot refresh has been adjusted to properly display the correct statistics.
- The action potential basic statistic box plot refresh has been adjusted to properly display the correct statistics.
- Save directory has been adjusted to work with a user specified directory.
- Save message will be displayed after segmentation has finished.

### Removed
- Medication and concentration text boxes and panel.  These attributes will now be altered in to the work queue.

## 2.4.1 Workflow Updates and Cycle Length
### Added
- During segmentation, the well will be highlighted 'bold' when it is the current target. It will be 
unbolded when the target of the segmentation shifts to a new well.
- Script to run all the test conditions at once.
- Script to run the converter without the option to run the sequence in the main application (ad hoc).
- Cycle length attribute for action potential and field potential segmentations.

### Changed
- The user now has the ability to change the electrode after segmentation has been completed
form the 'previous' well/electrode combination.
- The experiment .csv printer will output two additional fields (triangulation, fractional repolarization) 
- The figure generating scripts utilize the .csv attributes rather than re-calculating the appropriate
attribute (i.e. triangulation, fractional repolarization).
- The correct batch numbers will be displayed on the figures.
- For the box plots - the x-axis labels have been slanted 45 degrees.

## 2.4.0 Basic Histogram Figure Assessment
### Added
- Histogram visualizations for action potential attributes.  The user will provide a directory 
with any number of .csv's to process.  Figures will display the distributions of action potential
attributes of interest.

## 2.3.2 User Interface Improvements
### Added
- Save directory is defaulted to the location of the .h5 file.
- User can also specify the save location. [Save Directory Button].
- Progress message to denote where the state of the MCS data read.

### Changed
- The action potential error bar validation has been changed to display stacked
normalized waveforms with mean repolarizations at each interval.

### Removed
- Entire, segmented, and summary text labels for each plot.  The x-y and titles
for each axis should handle proper documentation.

## 2.3.1 User Interface Improvements
### Added
- Box plot to display field potential amplitudes.
- Ignore .mat files within .git version control.

### Changed
- Save the outData as an array - after segmentation has completed.  Instead
of all experimental data.
- Ensure medication name and concentration are correctly saved.

### Removed
- Error bar plot to display field potential amplitudes.

## 2.3.0 Field Potential Cycle
### Changed
- The method to identify each field potential cycle was adjusted.  The median
time between two maximum peaks identifies a cycle.  Originally, the time points
between the 'current' waveform's minimum voltage value vs. the maximum voltage of the
'next' waveform was used to determine the cycle 'stop' time of the current waveform.  
Peak detection fails at identifying minimum values; therefore, only the maximum values 
are taken into consideration.  This adjustment had large ramifications with repect to
determining the field potential's attributes if peak detection failed.

## 2.2.0 Field Potential Integration
### Added
- Test conditions for the calculations within the field potential segmentation.
- Additional test conditions for the action potential segmentation calculations.
- A 'Z' waveform within the waveform generation - help with test conditions.

### Changed
- Standard 'help' documentation for all classes and functions.
- Common calculations are defined in a single library.
- Aggregate calculations are defined in a signel library.
- Two .csv's will be produced when segmentation has been completed. One for 
field potentials and one for action potentials.  The same naming convention
will be used with an additional 'ap' and 'fp' label.
- Field potential and action potential can be identified together or separately
for each waveform.

### Removed
- App Desinger file [.mlapp].
- Erroneous test conditions.

## 2.1.0 Action Potential Segmentation Fix
### Changed
- Field potential segmentation - integrated with action potential segmentation.

## 2.0.0 - Updated User Interface
### Added
- UI is completely intregated with the visualization of baseline/segmented/basic figures.  Multiple windows
will no longer popup as the user navigates through each experiment.
- For the action potential segmentation - the UI will recognize multiple cursors (left and right)
- To proceed with segmentation QC and basic statistics, 'enter' can now be used.
- For each figure X and Y axis labels have been added.

### Changed
- Experiment initialization has been moved to the user interface.
- The signal QC has been refactored to work with the new user interface.
- The voltage measurements have been scaled to mV.
- The box plot mean values represent the actual mean values.  It was originally scaled by
1000.

### Removed
- MATLAB's 'apdesinger' was removed as the preferred editor - 'guide' has been used to 
create the new look and feel of the application.
- Three of the four statistic figures were removed.  The only one remaining is the box plot
of action potential repolarization intervals.  This was at the request of the principle
investigator.

## 1.1.2 - Experiment Test Case Updates
### Added
- Added test cases to validate writing a .csv when no file name is provided.
- Added test cases to validate counting outData results with or without omit statuses.

## 1.1.1 - Bug fixes
### Added
- The csv output will include medication name, medication concentration, peak time, apd 
start/stop time, left/right cursor times, .h5 file name, batch name, and version tag.
- Added version to the outData object.

### Changed
- Attenuation for the first peak will be empty instead of 0.  This should allow for correct
average calculations over a series of individual action potential waveforms.
- The csv output will not write a header if every experiment (well/electrode combination) has been
omitted.
- Creation of the segmentation line during left/right cursor selection has been updated to use [x,y] 
coordinates instead verticle points.  Resolution of vertical lines is not required - visualization only.

### Removed
- The attentuation number on each peak in the basic statistics figure (bottom right) has been removed. 
It was unreadable and erroneous (as per the researcher).

## 1.1.0 - Refactored with Test Classes
### Added
- Objects that will have an organzational structure to allow for test cases to be developed.
- New objects:  experiment, outData, apdData, peakData.
- Test conditions for each of the functions and objects.

### Changed
- Refactored exiting code structure to include segmented functions and objects.

### Removed
- Removed erroneous files that are no longer needed due to the refactoring effort.

## 1.0.0 - Historic
### Included
- Existing code provided from a variety of authors.
