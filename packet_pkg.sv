package packet_pkg;

class header_class;
   
endclass // header_class

class data_class;
endclass // data_class
      
virtual class base_packet;
   rand header_class header;
   rand data_class data;

   static int count;
   int 	id;

   function new();
      id = count++;
      header = new();
      data = new();
   endfunction // new

   pure virtual function base_packet copy();
   pure virtual function void display();
   pure virtual function void calc_header_checksum();
endclass; // base_packet

class packet extends base_packet;
endclass // packet
   
endpackage // packet_pkg
   