clc;

% 加載訓練數據
train_file = {'B0029', 'B0030', 'B0031'};
[dataset, train_dataset, soh] = load_data(train_file);

% 定義超參數空間
vars = [
    optimizableVariable('LSTMHiddenUnits', [100, 400], 'Type', 'integer'),
    optimizableVariable('DropoutRate1', [0.001, 0.5]),
    optimizableVariable('DropoutRate2', [0.001, 0.5]),
    optimizableVariable('DropoutRate3', [0.001, 0.5]),
    optimizableVariable('DropoutRate4', [0.001, 0.5]),
    optimizableVariable('InitialLearnRate', [1e-7, 1e-3], 'Transform', 'log')
];

% 運行貝葉斯優化
results = bayesopt(@(params) bayesOptObjective(params, train_dataset, soh), vars, 'MaxObjectiveEvaluations', 20);

% 獲取最佳超參數
bestHyperparameters = results.XAtMinObjective;

% 使用最佳超參數訓練最終模型
layers = [
    sequenceInputLayer(size(train_dataset, 2)) 
    lstmLayer(bestHyperparameters.LSTMHiddenUnits)
    dropoutLayer(bestHyperparameters.DropoutRate1)
    lstmLayer(bestHyperparameters.LSTMHiddenUnits)
    dropoutLayer(bestHyperparameters.DropoutRate2)
    lstmLayer(bestHyperparameters.LSTMHiddenUnits)
    dropoutLayer(bestHyperparameters.DropoutRate3)
    lstmLayer(bestHyperparameters.LSTMHiddenUnits)
    dropoutLayer(bestHyperparameters.DropoutRate4)
    fullyConnectedLayer(1, 'WeightsInitializer', 'glorot')
    regressionLayer
];

options = trainingOptions(...
    'sgdm',...
    'MaxEpochs', 33, ...
    'MiniBatchSize', 32,...
    'InitialLearnRate', bestHyperparameters.InitialLearnRate,...
    'ExecutionEnvironment', 'auto',...
    'Plots', 'training-progress'...
);

final_lstm_model = trainNetwork(train_dataset', soh', layers, options);

% Define bayesOptObjective function at the end of the file
function loss = bayesOptObjective(params, train_dataset, soh)
    layers = [
        sequenceInputLayer(size(train_dataset, 2)) 
        lstmLayer(params.LSTMHiddenUnits)
        dropoutLayer(params.DropoutRate1)
        lstmLayer(params.LSTMHiddenUnits)
        dropoutLayer(params.DropoutRate2)
        lstmLayer(params.LSTMHiddenUnits)
        dropoutLayer(params.DropoutRate3)
        lstmLayer(params.LSTMHiddenUnits)
        dropoutLayer(params.DropoutRate4)
        fullyConnectedLayer(1, 'WeightsInitializer', 'glorot')
        regressionLayer
    ];
    
    options = trainingOptions(...
        'sgdm',...
        'MaxEpochs', 33, ...
        'MiniBatchSize', 32,...
        'InitialLearnRate', params.InitialLearnRate,...
        'ExecutionEnvironment', 'auto',...
        'Plots', 'training-progress'...
    );

    lstm_model = trainNetwork(train_dataset', soh', layers, options);
    
    predicted_soh = predict(lstm_model, train_dataset');
    
    loss = mean((predicted_soh - soh').^2);
end