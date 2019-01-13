#! /usr/bin/env ruby

################################################################################
# FILE        : Alerter.rb
# DESCRIPTION : Produces an alert window that can flash in a given interval
# AUTHOR      : M H Khaliq
# LICENSE     : MIT
################################################################################



################################################################################
# REQUIREMENTS
################################################################################

require 'tk'



################################################################################
# MAIN
################################################################################

if ARGV.size < 6
  $stderr.puts "Usage: #{$0} <title> <colour 1> <colour 2> <delay> <font> " +
      '<string> [<string> [...]]'
  exit( 1 )
end #if 1  

rootTitle = ARGV.shift
colour1 = ARGV.shift
colour2 = ARGV.shift
delay = ARGV.shift.to_f
displayFont = ARGV.shift

root = TkRoot.new { title rootTitle }
frame = TkFrame.new( root )
labelsA = Array.new
row = 1
while ARGV.size > 0
  label = TkLabel.new( frame ) do
    text ARGV.shift
    height 1
    font displayFont
    padx 5
    pady 3
    foreground colour1
    background colour2
    grid( 'row' => row, 'column' => 1, 'sticky' => 'ew' )
  end #do
  labelsA.push( label )
  row = row + 1
end #while

if delay > 0.0
  Thread.new do
    toggle = true
    while true
      if toggle
        colour_a = colour2
        colour_b = colour1
      else
        colour_a = colour1
        colour_b = colour2
      end #if (1)
      toggle = ! toggle
      labelsA.each do |item|
        item.configure( 'foreground' => colour_a, 'background' => colour_b )
      end #do
      sleep( delay )
    end #while
  end #Thread(1)
end #if 1

frame.pack
Tk.mainloop()


exit



# Local Variables:
# mode:ruby
# End:
