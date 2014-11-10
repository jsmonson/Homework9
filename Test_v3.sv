class Test_v3 extends component;
    typedef registry #(Test_v3, "Test_v3") type_id;
	
	Environment env;
      
   virtual function void run_test();
      $display("Running Good Test:");
	  env = new(1000);
	  env.build();
	  begin
		 Driver_cbs_v3 dcs = new();
		 env.drv.sbs.push_back(dcs);
	  end
	  env.run();
   endfunction // run_test
endclass // Test_v3
