% 创建串口对象
s = serialport("COM4", 9600);

% 设置串口对象参数
configureTerminator(s, "CR");

try
    % 模拟温度数据
    while true
        temperature = 25; % 假设温度为 25 度

        % 格式化温度数据为字符串
        dataToSend = sprintf("Temperature:%dC", temperature);

        % 向 Arduino 发送数据
        write(s, dataToSend, "string");

        % 暂停一段时间，例如1秒
        pause(1)
    end
catch
    % 捕获键盘中断等异常时执行ctrl+c
    disp('Loop terminated.');
end

% 关闭串口对象
delete(s);
