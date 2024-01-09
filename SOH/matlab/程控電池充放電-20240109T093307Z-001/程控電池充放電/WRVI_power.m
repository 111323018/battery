function WRVI_power(scope,  v_power, i_power) 
    scope.RawIO.Write(['VSET1:' num2str(v_power) char(10)]);
    scope.RawIO.Write(['ISET1:' num2str(i_power) char(10)]);
    scope.RawIO.Write([':OUTPut:STATe ON' char(10)]);
end