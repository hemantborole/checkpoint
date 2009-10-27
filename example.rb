require 'checkpoint'

class Transaction
  include Checkpoint

  attr_accessor :name

  def proc1
    @name='name1'
    puts "Proc1: Name is #{@name}"
  end

  def proc2
    puts "Proc2: Reading name from undump as:#{@name}:"
  end

  def proc3
    @name='name2'
    puts "Proc3: Name is #{@name}"
  end

  def proc4
    puts "Proc4: Reading name from undump as:#{@name}:"
  end

  def proc5
    @name='name3'
    puts "Proc5: Name is #{@name}"
  end

  def proc6
    puts "Proc6: Reading name from undump as:#{@name}:"
  end

  def proc7
    @name='name4'
    puts "Proc7: Name is #{@name}"
  end

  def proc8
    puts "Proc8: Reading name from undump as:#{@name}:"
  end

  def transact
    ## Adding sleeps to let you Ctrl-C
    checkpoint( {} ) { proc1 }
    sleep 1
    checkpoint( {} ) { proc2 }
    sleep 1
    checkpoint( {} ) { proc3 }
    sleep 1
    checkpoint( {} ) { proc4 }
    sleep 1
    checkpoint( {} ) { proc5 }
    sleep 1
    checkpoint( {} ) { proc6 }
    sleep 1
    checkpoint( {} ) { proc7 }
    sleep 1
    checkpoint( {} ) { proc8 }
  end
end

## main.
t=Transaction.new
t.transact
