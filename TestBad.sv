class bad_packet extends packet;
   static int corruption_cnt;
         
   virtual function automatic void calc_header_checksum();
      int  corrupt;
      corrupt = $urandom_range(0,99);
      header.calc_header_checksum();
      
      if(corrupt < 2) begin
	 header.header_checksum = ~header.header_checksum;
	 corruption_cnt++;
      end
      
  endfunction
   
endclass // bad_packet


class TestBad extends component;
   typedef registry #(TestBad, "TestBad") type_id;
   Environment env;
   
   virtual task run_test();
      Driver_cbs_scoreboard sb_callback;
      bad_packet badp;
      
      $display("Running Good Test:");
    
      env = new(1000);
      env.build();
      begin
	 sb_callback = new();
	 badp = new();
	 env.gen.blueprint = badp;
	 env.drv.cbs.push_back(sb_callback);
      end
      env.run();
      $display("%0t:Send %0d Bad Packets",$time, bad_packet::corruption_cnt);
      $display("%0t:Test Finished with %d comparisons.",$time, sb_callback.scb.num_compared);
   endtask // run_test
   
endclass // TestBad
