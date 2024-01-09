function WRVI_load(scope, i_load) 
    scope.RawIO.Write([':LOAD2:CC ON' char(10)]);
    scope.RawIO.Write(['ISET2:' num2str(i_load) char(10)]);
    scope.RawIO.Write([':OUTPut2:STATe ON' char(10)]);
end