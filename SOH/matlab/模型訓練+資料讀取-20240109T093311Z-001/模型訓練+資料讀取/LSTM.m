clc;
% load in training data
train_file= {'B0029','B0030','B0031'};
[dataset,train_dataset, soh] = load_data(train_file);


%% set the LSTM model 
% set out model structure
layers = [
    sequenceInputLayer(size(train_dataset, 2))    
    lstmLayer(105)
    dropoutLayer(0.49314)
    lstmLayer(105)
    dropoutLayer(0.33371)
    lstmLayer(105)
    dropoutLayer(0.24333)
    lstmLayer(105)
    dropoutLayer(0.31968)
    fullyConnectedLayer(1, 'WeightsInitializer', 'glorot') % 使用 'glorot' 初始化
    regressionLayer];

%Set Training Option
options = trainingOptions(...
    'sgdm',...
    'MaxEpochs', 33, ...
    'MiniBatchSize', 32,...
    'InitialLearnRate', 5.6918*10^-6,...
    'ExecutionEnvironment', 'auto',...
    'Plots', 'training-progress'...
    );

%train LSTM model
lstm_model = trainNetwork(train_dataset', soh', layers, options);     
%% Validation
%load validation data
val_file= {'B0032'};
[~,val_dataset, soh] = load_data(val_file);

% predict by LSTM model
predicted_soh = predict(lstm_model, val_dataset');
%Normalization the predicted_soh
predicted_soh = predicted_soh/max(predicted_soh)

%% draw a demo figure
%set up step
step = 100;
indices = 1:step:length(soh);
% create a figure
figure;

% draw predicted_soh
plot(indices, predicted_soh(indices), 'DisplayName', 'Predict SOH');
hold on;

% draw actual 
plot(indices, soh(indices), 'DisplayName', 'Actual SOH');

% set label and title
xlabel('time');
ylabel('SOH');
legend('show');
title('Predict SOH  V.S  Actual SOH');

% count MAE,MSE,RMSE
mae = mean(abs(predicted_soh - soh));
average_mae = sum(mae) / numel(mae);
mse = mean((predicted_soh - soh).^2);
average_mse = sum(mse) / numel(mse);
rmse = sqrt(mean((predicted_soh - soh).^2));
average_rmse = sum(rmse) / numel(rmse);
%save lstm_model;