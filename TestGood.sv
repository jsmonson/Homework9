class TestGood extends component;
   typedef registry #(TestGood, "TestGood") type_id;
   Environment env;
      
   virtual task run_test();
      Driver_cbs_scoreboard sb_callback;
      $display("Running Good Test:");
    
      env = new(1000);
      env.build();
      begin
	 sb_callback = new();
	 env.drv.cbs.push_back(sb_callback);
      end
      env.run();
      $display("%0t:Test Finished with %d comparisons.",$time, sb_callback.scb.num_compared);
   endtask // run_test
   
endclass // TestGood
