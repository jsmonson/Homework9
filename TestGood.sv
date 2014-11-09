class TestGood extends component;
   typedef registry #(TestGood, "TestGood") type_id;
   Environment env;
      
   virtual function void run_test();
      $display("Running Good Test:");
   endfunction // run_test
   
endclass // TestGood
