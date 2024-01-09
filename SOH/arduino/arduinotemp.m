% 创建串口对象
s = serialport("COM4", 9600); 
% 设置串口对象参数
configureTerminator(s, "LF");
s.Timeout = 2;

try
    while true
        % 读取传感器数据
        data = readline(s);
        disp(data);
        % 暂停一段时间，例如1秒
        pause(1);
    end
catch
    % 捕获键盘中断等异常时执行ctrl+c
    disp('Loop terminated.');
end

% 关闭串口对象
delete(s);
