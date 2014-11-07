program automatic test ();

  import package_test::*;
  Environment env;
  
  initial begin
    env = new(50);
    env.build();
    env.run();
  end
 

    
endprogram