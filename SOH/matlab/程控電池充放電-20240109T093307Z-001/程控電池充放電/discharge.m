%% 連接NI-VISA控制GPP-3323
clear;
close all;
clc;

try 
    assemblyCheck = NET.addAssembly('Ivi.Visa');
catch
    error('Error loading .NET assembly Ivi.Visa');
end

resourceString5 = 'ASRL3::INSTR'; % USB-TMC (Test and Measurement Class)
s = serialport("COM4", 9600); % arduino

% Opening VISA session to the instrument
scope = Ivi.Visa.GlobalResourceManager.Open(resourceString5);
scope.Clear()

%% 開啟GPP-3323電子負載器模式並設定汲取電流
WRVI_load(scope,2);
pause(2);

%% 初始化數組以記錄數據
% Initialize record arrays
voltage_load = [];
current_load = [];
temprature = [];
time = [];

%% 開始充電並記錄數據
start_time = tic; % the timer begins
while true
    [v_l, i_l] = RDVI_load(scope);
    temp = Temp(s);
    elapsed_time = toc(start_time);
    voltage_load = [voltage_load; str2double(v_l)];
    current_load = [current_load; str2double(i_l)];
    temprature = [temprature; str2double(temp)];
    time = [time; toc(start_time);];
    
    if str2double(v_l) <= 1.9800
        capacity_value = str2double(i_l).*time(end)./3600;
        capacity = ones(size(voltage_load)) * capacity_value;
        disp('discharging is complete');
        off_ch1(scope);
        off_ch2(scope);
        break;
    end
    pause(6);
end
data = [capacity, voltage_load, -1.*current_load, temprature, time];
data_table = table(capacity, voltage_load, -1.*current_load, temprature, time, ...
    'VariableNames', {'Capacity', 'Voltage_Load', 'Current_Load', 'Temperature', 'Time'});
writetable(data_table,'Cycle5.csv');



