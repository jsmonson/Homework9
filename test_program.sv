import factory_pkg::*;
import package_test::*;

`include "TestGood.sv"
`include "Test_v3.sv"
`include "TestBad.sv"
 
program test;
   initial begin
      component c;
      
      factory::printFactory();
      c = factory::get_test();
   end
endprogram // test
 