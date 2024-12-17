% Manual Car Parking System with GUI
clc;
clear;

% File to store car details in Excel
fileName = 'carParkingDetails.xlsx';
if exist(fileName, 'file') ~= 2
    headers = {'Car Number', 'Entry Time', 'Exit Time', 'Parking Duration (hrs)', 'Parking Fee'};
    writecell(headers, fileName);  
end

% Create GUI Window
f = figure('Name', 'Automated Car Parking System', 'NumberTitle', 'off', ...
    'Position', [500, 300, 500, 400], 'Color', [0.8, 0.9, 1]); % Light blue background

% Labels and Inputs
uicontrol(f, 'Style', 'text', 'Position', [50, 300, 150, 25], 'String', 'Car Number:', ...
    'HorizontalAlignment', 'right', 'BackgroundColor', [0.6, 0.8, 1]);
carNumberInput = uicontrol(f, 'Style', 'edit', 'Position', [220, 300, 200, 25]);

uicontrol(f, 'Style', 'text', 'Position', [50, 250, 150, 25], 'String', 'Entry Time (YYYY-MM-DD HH:MM:SS):', ...
    'HorizontalAlignment', 'right', 'BackgroundColor', [0.6, 0.8, 1]);
entryTimeInput = uicontrol(f, 'Style', 'edit', 'Position', [220, 250, 200, 25]);

uicontrol(f, 'Style', 'text', 'Position', [50, 200, 150, 25], 'String', 'Exit Time (YYYY-MM-DD HH:MM:SS):', ...
    'HorizontalAlignment', 'right', 'BackgroundColor', [0.6, 0.8, 1]);
exitTimeInput = uicontrol(f, 'Style', 'edit', 'Position', [220, 200, 200, 25]);

uicontrol(f, 'Style', 'text', 'Position', [50, 150, 150, 25], 'String', 'Parking Duration (hrs):', ...
    'HorizontalAlignment', 'right', 'BackgroundColor', [0.6, 0.8, 1]);
durationInput = uicontrol(f, 'Style', 'edit', 'Position', [220, 150, 200, 25]);

uicontrol(f, 'Style', 'text', 'Position', [50, 100, 150, 25], 'String', 'Parking Fee per Hour ($):', ...
    'HorizontalAlignment', 'right', 'BackgroundColor', [0.6, 0.8, 1]);
feeInput = uicontrol(f, 'Style', 'edit', 'Position', [220, 100, 200, 25]);
% Save Button
uicontrol(f, 'Style', 'pushbutton', 'String', 'Save & Calculate', 'Position', [150, 50, 200, 40], ...
    'FontSize', 10, 'BackgroundColor', [0.4, 0.7, 1], 'ForegroundColor', 'white', ...
    'Callback', @(src, event) saveCarDetails(carNumberInput, entryTimeInput, exitTimeInput, durationInput, feeInput, fileName));

% Save Car Details Function
function saveCarDetails(carNumberInput, entryTimeInput, exitTimeInput, durationInput, feeInput, fileName)
    % Retrieve Inputs
    carNumber = get(carNumberInput, 'String');
    entryTimeStr = get(entryTimeInput, 'String');
    exitTimeStr = get(exitTimeInput, 'String');
    durationStr = get(durationInput, 'String');
    feePerHourStr = get(feeInput, 'String');

    % Validate Inputs
    if isempty(carNumber) || isempty(entryTimeStr) || isempty(exitTimeStr) || isempty(durationStr) || isempty(feePerHourStr)
        errordlg('Please fill in all fields!', 'Input Error');
        return;
    end

    try
        entryTime = datetime(entryTimeStr, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
        exitTime = datetime(exitTimeStr, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
        parkingDuration = str2double(durationStr);
        feePerHour = str2double(feePerHourStr);

        % Check for invalid values
        if isnan(parkingDuration) || isnan(feePerHour) || parkingDuration <= 0 || feePerHour <= 0
            errordlg('Invalid parking duration or fee per hour!', 'Input Error');
            return;
        end

        % Calculate Parking Fee
        parkingFee = parkingDuration * feePerHour;
        newRow = {carNumber, datestr(entryTime), datestr(exitTime), parkingDuration, parkingFee};

        % Read existing data and append new data
        try
            carData = readcell(fileName);
            rowIndex = size(carData, 1) + 1;  
            writecell(newRow, fileName, 'Range', ['A', num2str(rowIndex)]);

            msgbox(['Data saved successfully! Total Parking Fee: $', num2str(parkingFee)], 'Success', ...
                'BackgroundColor', [0.7, 1, 0.7]); % Green background
        catch ME
            disp('Error Details:');
            disp(ME.message);
            errordlg('Error saving data to the file. Check file permissions.', 'File Error');
        end
    catch
        errordlg('Invalid date format! Use YYYY-MM-DD HH:MM:SS', 'Input Error');
    end
end
