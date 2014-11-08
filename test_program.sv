import factory_pkg::*;

`include "TestGood.sv"
`include "Test_v3.sv"
`include "TestBad.sv"
 
program test;
   initial begin
      factory::printFactory();
      factory::get_test();
   end
endprogram // test
 