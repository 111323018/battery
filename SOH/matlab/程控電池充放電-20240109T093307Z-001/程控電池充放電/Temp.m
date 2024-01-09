function data = Temp(s)

% 設定參數
configureTerminator(s, "LF");
s.Timeout = 2;

try
    % 讀sensor數據
    data = readline(s);
catch
end

% 關閉連接
%delete(s);
