%% 連接NI-VISA控制GPP-3323與arduino
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

%Opening VISA session to the instrument
scope = Ivi.Visa.GlobalResourceManager.Open(resourceString5);
scope.Clear()

%% 設定設定電源供應器的電壓電流
WRVI_power(scope, 4.2, 1);
pause(2);

%% 初始化數組以記錄數據
voltage_power = [];
current_power = [];
temprature = [];
time = [];

%% 開始充電並記錄數據
start_time = tic; % 記錄程式開始時的時間
while true
    [v_p, i_p] = RDVI_power(scope);
    temp = Temp(s);
    elapsed_time = toc(start_time);
    voltage_power = [voltage_power; str2double(v_p)];
    current_power = [current_power; str2double(i_p)];
    temprature = [temprature; str2double(temp)];
    time = [time; toc(start_time);];
    
    if str2double(i_p) <= 0.0200
            disp('charging is complete');
            off_ch1(scope);
            off_ch2(scope);
            break;
    end   
    pause(6);
end
data = [voltage_power, current_power, time];
data_table = table(voltage_power, current_power, temprature, time, ...
    'VariableNames', {Voltage_Load', 'Current_Load', 'Temperature', 'Time'});
writetable(data_table,'charge_1.csv');

   


