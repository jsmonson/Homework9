import factory_pkg::*;
import package_test::*;
import packet_pkg::*;

`include "TestGood.sv"
`include "Test_v3.sv"
`include "TestBad.sv"
 
program test;
   initial begin
      component c;
      
      factory::printFactory();
      c = factory::get_test();
      c.run_test();
   end
endprogram // test
 