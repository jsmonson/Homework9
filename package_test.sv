package package_test;
  `define SV_RAND_CHECK(r)\
  do begin \
    if (!(r)) begin\
      $display("%s:%0d Randomization failed \"%s\"", \
          `__FILE__, `__LINE__, `"r`"); \
      end \
  end while(0)
  

  virtual class Driver_cbs;

     virtual task pre_tx(ref base_packet pkt);
	     //Callback does nothing
     endtask // pre_tx

     virtual task post_tx(ref base_packet pkt);
     
     endtask // post_tx
  endclass // Driver_cbs
  
  class Driver_cbs_scoreboard extends Driver_cbs;
    Scoreboard scb;
    function new(input Scoreboard scb);
      this.scb = scb;
    endfunction
    virtual task post_tx(ref base_packet pkt);
      scb.compare_expected(pkt);
    endtask // post_tx
  endclass 
   
  class Driver_cbs_v3 extends Driver_cbs;
    virtual task pre_tx(ref base_packet pkt);
      pkt.version = $urandom_range(0,999) < 10 ? 3 : 4; // 1% of packets have version 3
    endtask
  endclass 
  class Driver;
    mailbox #(base_packet) gen2drv;

    base_packet p;
    Driver_cbs cbs[$];
     
    function new(input mailbox #(base_packet) gen2drv);
        this.gen2drv = gen2drv;
    endfunction // new
     
    task run(input int count);
       repeat(count) begin
          gen2drv.get(p);
	        foreach cbs[i] cbs[i].pre_tx(p);
	           transmit(p);
	        foreach cbs[i] cbs[i].post_tx(p);
       end
    endtask // run

    task transmit(base_packet pkt);
       
       wait 10 ns;
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
            blueprint.calc_header_checksum();
            gen2drv.put(blueprint.copy()); // requires base_packet class copy to have been implemented by a child class or will not compile!
        end
    endtask
  endclass

  class Environment;
    Generator gen;
    Driver drv;
    Scoreboard scb;
    mailbox #(base_packet) gen2drv;
    int count;
    function new(int count);
       this.count = count;
    endfunction;
    function void build();
      gen2drv = new();
      gen = new(gen2drv);
      drv = new(gen2drv);
      scb = new();
    endfunction
  
    task run();
        fork
          gen.run(count);
          drv.run(count);
        join
        $display("%0t:Test Finished with %d comparisons.",$time, scb.num_compared);
     endtask 
  endclass

endpackage
