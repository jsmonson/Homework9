class TestGood extends component;
   typedef registry #(TestGood, "TestGood") type_id;
   Environment env;
      
   virtual function void run_test();
      $display("Running Good Test:");
	  env = new(1000);
	  env.build();
	  env.run();
   endfunction // run_test
   
endclass // TestGood
