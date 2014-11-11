package packet_pkg;
parameter VERSION = 4;
parameter IHL = 5;
parameter TOTAL_LENGTH = 224;
class header_class;
  rand bit[3:0] version;
  rand bit[3:0] ihl;
  rand bit[15:0] total_length;
  rand bit[7:0] type_of_service;
  rand bit[15:0] identification;
  rand bit[2:0] flags;
  rand bit[12:0] fragment_offset;
  rand bit[7:0] time_to_live;
  rand bit[7:0] protocol;
  bit[15:0] header_checksum;
  rand bit[31:0] destination_ip_address;
  rand bit[31:0] source_ip_address;
  constraint flag_c {
      flags[0] == 0;
  }
  constraint constants {
      version == 4; ihl == 5; total_length == 224;
  }
  function new();
  endfunction
  function header_class copy();
    copy = new();
    copy.version = version;
    copy.ihl = ihl;
    copy.total_length = total_length;
    copy.type_of_service = type_of_service;
    copy.identification = identification;
    copy.flags = flags;
    copy.fragment_offset = fragment_offset;
    copy.time_to_live = time_to_live;
    copy.protocol = protocol;
    copy.header_checksum = header_checksum;
    copy.destination_ip_address = destination_ip_address;
    copy.source_ip_address = source_ip_address;
    return copy;
  endfunction
  function void calc_header_checksum();
      header_checksum = {version, ihl, type_of_service} ^ 
			     total_length  ^ identification ^ 
			     {flags, fragment_offset} ^ {time_to_live, protocol} ^ 
			     source_ip_address[31:16] ^ source_ip_address[15:0] ^
			     destination_ip_address[31:16] ^ destination_ip_address[15:0];
   endfunction
endclass // header_class
  
  
class data_class;
  rand bit[63:0] payload;
  function new();
  endfunction
  function data_class copy();
    copy = new();
    copy.payload = payload;
    return copy;
  endfunction
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
  function new();
    super.new();
  endfunction
  function packet copy();
    copy = new();
    copy.header = header.copy();
    copy.data = data.copy();
    return copy;
  endfunction
  function void display();
    $display("Transaction ID: %d",id);
  endfunction
  function void calc_header_checksum();
    header.calc_header_checksum();
  endfunction
endclass // packet
   
endpackage // packet_pkg
   