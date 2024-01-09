function [v, i] = RDVI_power(scope)
    scope.RawIO.Write([':MEASure1:VOLTage?' char(10)]);
    v = char(scope.RawIO.ReadString());
    scope.RawIO.Write([':MEASure1:CURRent?' char(10)]);
    i = char(scope.RawIO.ReadString());
end