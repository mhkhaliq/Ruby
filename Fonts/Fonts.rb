#! /usr/bin/env ruby

################################################################################
# FILE        : Alerter.rb
# DESCRIPTION : Listbox of X11 fonts with example for selected font
# AUTHOR      : M H Khaliq
# LICENSE     : MIT
################################################################################



################################################################################
# REQUIREMENTS
################################################################################

require 'tk'



################################################################################
# CONSTANTS
################################################################################

FONTS_CMD = 'xlsfonts'
DISPLAY_STRING = 'The quick brown fox jumps over the lazy dog 0123456789'



################################################################################
# MAIN
################################################################################

$stderr.sync = true
$stdout.sync = true

begin
  inPipe = IO.popen( FONTS_CMD )
rescue Exception
  $stderr.puts "Cannot open read pipe '#{FONTS_CMD}': #{$!}"
  exit( 1 )
end #begin
fontsA = Array.new
until inPipe.eof?
  data = inPipe.gets
  data.sub!( /^\s+/, '' )
  data.sub!( /\s+$/, '' )
  next if data.length == 0
  fontsA.push( data )
end
inPipe.close
if fontsA.empty?
  $stderr.puts "No fonts found using '#{FONTS_CMD}' !"
  exit( 2 )
end #if 1

root = TkRoot.new { title 'X11 Font Viewer' }
frame = TkFrame.new( root )
listbox = TkListbox.new( frame ) do
  activestyle 'dotbox'
  selectmode 'single'
  foreground 'White'
  background 'Black'
  selectforeground 'White'
  selectbackground 'DeepSkyBlue'
  height 48
  width 0
  grid( 'row' => 0, 'column' => 0, 'sticky' => 'news' )
end #end do

entriesH = Hash.new
count = 0
fontsA.sort.each do |f|
  listbox.insert( 'end', f )
  entriesH[count] = f
  count = count + 1
end #do

listbox.bind( '<ListboxSelect>' ) do
  font = entriesH[listbox.curselection[0]]
  puts font
  Thread.new do
    system( "/home/khaliqmo/Projects/Utilities/Alerter.rb \"#{font}\" Black " +
        "White 0 \"#{font}\" \"#{DISPLAY_STRING}\"" )
  end #do
end #do

vsb = TkScrollbar.new( frame ) do
  command proc{ |*args| listbox.yview *args }
  grid( 'row' => 0, 'column' => 1, 'sticky' => 'ns' )
end #do
listbox.yscrollcommand( proc{ |first,last| vsb.set( first, last ) } )

frame.pack
Tk.mainloop()


exit



# Local Variables:
# mode:ruby
# End:
