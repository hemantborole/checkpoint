require 'rubygems'

module Checkpoint

  def init
    user = ENV['USER'] || ENV['USERNAME']
    procname = self.class.to_s
    @store ||= File.join( "/tmp", procname + '_' + user )
    @cp_last ||= @store + '.ck' 
    @current ||= 0
    @last_checkpoint = File.exists?( @cp_last ) ? File.read( @cp_last ).chomp.to_i : 0
  end

  def undump
    if @store and File.exists?( @store ) 
      old_current = @current
      File.open( @store, "r" ) {|f|
        newobj = Marshal.load( f.read )
        f.close
        newobj.instance_variables.each {|key|
          self.instance_variable_set(key, newobj.instance_variable_get(key))
        }
        self.instance_variable_set(:@current, old_current)
      }
    end
    @last_checkpoint = File.exists?( @cp_last ) ? File.read( @cp_last ).chomp.to_i : 0
  end

  def dump
    File.open( @store, "w" ) {|f|
      f.write( Marshal.dump( self ) )
      f.close
    }
    @last_checkpoint += 1
    @current += 1
    File.open( @cp_last, 'w' ) {|ck| ck.puts @last_checkpoint; ck.close}

  end

  def checkpoint( process_status={}, &blk )
    init ## just call it again, in case the user has not init'd, its harmless.
    if @last_checkpoint > @current
      @current += 1
      #puts "cp: #{@last_checkpoint} and current: #{@current}, Skipping ..."
      return
    end
    undump
    blk.call
    dump
  end

  private
  attr_accessor :store, :cp_last, :current, :last_checkpoint
end
