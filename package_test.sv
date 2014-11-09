package package_test;
  `define SV_RAND_CHECK(r)\
  do begin \
    if (!(r)) begin\
      $display("%s:%0d Randomization failed \"%s\"", \
          `__FILE__, `__LINE__, `"r`"); \
      end \
  end while(0)
  class base_packet;
    base_packet p;
    function 	base_packet	copy();
      return p;
    endfunction
  endclass
  
  class Driver;
    mailbox #(base_packet) gen2drv;
    base_packet p;
    function new(input mailbox #(base_packet) gen2drv);
        this.gen2drv = gen2drv;
    endfunction
    task run(input int count);
      repeat(count) begin
        gen2drv.get(p);
      end
    endtask
  endclass
  
  class Generator;
    mailbox #(base_packet) gen2drv;
    base_packet blueprint;
    function new(input mailbox #(base_packet) gen2drv);
        this.gen2drv = gen2drv;
        blueprint = new();
    endfunction
    task run(input int count);
        repeat(count) begin
            `SV_RAND_CHECK(blueprint.randomize());
            gen2drv.put(blueprint.copy()); // requires base_packet class copy to have been implemented by a child class or will not compile!
        end
  endtask
endclass

  class Environment;
    Generator gen;
    Driver drv;
    mailbox #(base_packet) gen2drv;
    int count;
    function new(int count);
       this.count = count;
    endfunction;
    function void build();
      gen2drv = new();
      gen = new(gen2drv);
      drv = new(gen2drv);
    endfunction
  
    task run();
        fork
          gen.run(count);
          drv.run(count);
        join
       // $display("%0t:Test Finished with %d errors.",$time, error_count);
     endtask 
  endclass

  
  
endpackage
