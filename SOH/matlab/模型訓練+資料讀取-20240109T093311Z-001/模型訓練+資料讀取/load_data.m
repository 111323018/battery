function [dataset,train_dataset, soh] = load_data(fileNames)
%% load data form .mat file
dataset = table();
capacity_data = table();
counter = 1;

for j = 1:length(fileNames)
    filename = fileNames{j};
    data = load(filename);
    struct_array = data.(filename).cycle;

    discharge_indices = find(strcmp({struct_array.type}, 'discharge')); % 找到所有 discharge 的索引

    % iter every discharge cycle
    for i = 6:length(discharge_indices)
        discharge_index = discharge_indices(i);
        struct_a = struct_array(discharge_index);
        ambient_temperature = struct_a.ambient_temperature;

        % 將時間信息轉換為 datetime 對象
        date_time = datetime(struct_a.time(1), struct_a.time(2), struct_a.time(3), struct_a.time(4), struct_a.time(5), struct_a.time(6));

        % get capacity value
        capacity_now = struct_a.data(1).Capacity;

        % get 5 last capacity value
        for k = 1:5
            index = discharge_indices(i-k);
            if index >= 1 && strcmp(struct_array(index).type, 'discharge') && isfield(struct_array(index).data, 'Capacity') && ~isempty(struct_array(index).data(1).Capacity)
                capacity(k) = struct_array(index).data(1).Capacity;
            else
                capacity(k); 
            end
        end

        % iter every time step data
        for k = 1:length(struct_a.data(1).Temperature_measured)
            temperature_measured = struct_a.data(1).Temperature_measured(k);
            current_load = struct_a.data(1).Current_load(k);
            voltage_load = struct_a.data(1).Voltage_load(k);
            time_step = struct_a.data(1).Time(k);

            % add data to 'dataset'
            row_data = table(counter, ambient_temperature, date_time, capacity_now, capacity(1), ...
                capacity(2), capacity(3), capacity(4), capacity(5), temperature_measured, ...
                current_load, voltage_load, time_step, 'VariableNames', {'cycle', ...
                'ambient_temperature', 'date_time', 'capacity_now', 'capacity_1', 'capacity_2', ...
                'capacity_3', 'capacity_4', 'capacity_5', 'temperature_measured', 'current_load', ...
                'voltage_load', 'time_step'});
            dataset = [dataset; row_data];

            % put capacity value to 'capacity_data'
            row_capacity_data = table(counter, ambient_temperature, date_time,capacity_now, ...
                'VariableNames', {'cycle', 'ambient_temperature', 'date_time', 'capacity_now'});
            capacity_data = [capacity_data; row_capacity_data];
        end
        counter = counter + 1;
    end
end
%% clean dataset
% 刪除 current_load 小於 2 的行
rowsToRemove = dataset.current_load < 1;
dataset(rowsToRemove, :) = [];
dataset.Properties.RowNames = cellstr(num2str((1:height(dataset))'));

%% 計算SOH

% 選取需要的特徵('cycle', 'datetime', 'capacity')
attrib = {'cycle', 'date_time', 'capacity_now'};
dis_ele = dataset(:, attrib);
dis_ele.Properties.RowNames = cellstr(num2str((1:height(dis_ele))'));

% 獲取初始電池容量
C = dis_ele.capacity_now(1);

% 計算狀態健康度(SoH)
dis_ele.SOH = (dis_ele.capacity_now) / C;
soh = dataset.capacity_now / C;
disp(['soh:', num2str(size(soh))]);
%% Normalization

attribs = {'cycle', 'capacity_1', 'capacity_2', 'capacity_3' ,'capacity_4', 'capacity_5', ...
    'temperature_measured', 'current_load', 'voltage_load', 'time_step'};

train_dataset = dataset(:, attribs);
train_dataset = table2array(train_dataset);

% 使用 zscore 函數進行正規化
train_dataset = zscore(train_dataset);
end