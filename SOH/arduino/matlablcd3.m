% 创建串口对象
s = serialport("COM4", 9600);

try
    % 模拟温度、湿度和压力数据
    while true
        temperature = randi([20, 30]); % 随机生成温度数据（20到30之间）
        SOH= randi([40, 60]);    % 随机生成湿度数据（40到60之间）
        SOC = randi([1000, 1200]);% 随机生成压力数据（1000到1200之间）

        % 格式化数据为字符串，以"Temperature:XX Humidity:YY Pressure:ZZ"的格式发送
        dataToSend = sprintf("Temperature:%d SOH:%d SOC:%d\n", temperature,SOH,SOC);

        % 向 Arduino 发送数据
        write(s, dataToSend, "string");

        % 暂停一段时间，例如1秒
        pause(1);
    end
catch
    % 捕获键盘中断等异常时执行ctrl+c
    disp('Loop terminated.');
    % 关闭串口对象
    delete(s);
end