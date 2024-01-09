function [v, i] = RDVI_load(scope)
    scope.RawIO.Write([':MEASure2:VOLTage?' char(10)]);
    v = char(scope.RawIO.ReadString());
    scope.RawIO.Write([':MEASure2:CURRent?' char(10)]);
    i = char(scope.RawIO.ReadString());
end