class Test_v3 extends component;
    typedef registry #(Test_v3, "Test_v3") type_id;
   Environment env;
      
   virtual task run_test();
      Driver_cbs_scoreboard sb_callback;
      Driver_cbs_v3 dcs;
      $display("Running v3 Test:");
      env = new(1000);
      env.build();
       begin
	 dcs = new();
	 sb_callback = new();
	 env.drv.cbs.push_back(dcs);
	 env.drv.cbs.push_back(sb_callback);
      end
      env.run();
      $display("%0t: Corrupted %0d Packets",$time, dcs.corruption_cnt);
      $display("%0t:Test Finished with %d comparisons.",$time, sb_callback.scb.num_compared);
   endtask // run_test
endclass // Test_v3
