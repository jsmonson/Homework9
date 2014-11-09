//////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Package that defines the scoreboard for 
//          Chap_8_Advanced_OOP_and_Testbench_Guidelines/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: scoreboard_pkg.sv,v $
// Revision 1.1  2011/05/29 19:16:11  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/29 19:28:37  Greg
// Initial check-in
//
//////////////////////////////////////////////////////////////////////////////////////////

package scoreboard_pkg;

   import packet_pkg::*;
   
   // Parameterized class to do compare
class comparator #(type T=bit[3:0]);
   function void compare(input string name, input T expected, input T actual);
      if (expected !== actual) begin
         $display("%0t: ERROR for %s, expected=0x%0h != actual=0x%0h", $time, name, expected, actual);
      end
   endfunction   
endclass

   // Class scoreboard that instantiates the comparator class
   // for the 4, 8, and 16-bit fields we want to compare
   // and defines the compare_expected function.
class Scoreboard;
   static int num_compared = 0;
   comparator #(bit [3:0]) compare_4bit;
   comparator #(bit [7:0]) compare_8bit;
   comparator #(bit [15:0]) compare_16bit; 

   // Instantiate the 3 comparators.
   function new();
      compare_4bit = new();
      compare_8bit = new();
      compare_16bit = new();
   endfunction // new

   // Compare the expected values of the version, ihl, total length, and the header checksum
   function void compare_expected(input packet pkt);
      num_compared++;
      compare_4bit.compare("version", pkt.header.version, VERSION);
      compare_4bit.compare("ihl", pkt.header.ihl, IHL);
      compare_8bit.compare("total length", pkt.header.total_length, TOTAL_LENGTH);
      compare_16bit.compare("header checksum", pkt.header.header_checksum, calc_header_checksum(pkt));
   endfunction // compare_expected

   // Calculate the expected header checksum.  Needs to be independent of the calc_header_checksum
   // function in the packet class as to not replicate bugs.
   function bit[15:0] calc_header_checksum(input packet pkt);
      calc_header_checksum = {pkt.header.version, pkt.header.ihl, pkt.header.type_of_service} ^ 
			     pkt.header.total_length  ^ pkt.header.identification ^ 
			     {pkt.header.flags, pkt.header.fragment_offset} ^ {pkt.header.time_to_live, pkt.header.protocol} ^ 
			     pkt.header.source_ip_address[31:16] ^ pkt.header.source_ip_address[15:0] ^
			     pkt.header.destination_ip_address[31:16] ^ pkt.header.destination_ip_address[15:0];
   endfunction

   
endclass : Scoreboard

endpackage