#! /usr/bin/env ruby
################################################################################
# FILE        : Colours.rb
# DESCRIPTION : Displays all colours found for X11 as buttons that print the
#               RGB value and colour name(s) to STDOUT when pressed
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

RGB_FILE = '/usr/openwin/lib/X11/rgb.txt'



################################################################################
# MAIN
################################################################################

$stderr.sync = true
$stdout.sync = true

begin
  inFile = File.open( RGB_FILE )
rescue Exception
  $stderr.puts "Cannot open '#{RGB_FILE}' for reading: #{$!}"
  exit( 1 )
end #begin
coloursH = Hash.new( '' )
until inFile.eof?
  data = inFile.gets
  data.sub!( /^\s+/, '' )
  data.sub!( /\s+$/, '' )
  if data =~ /^(\d+)\s+(\d+)\s+(\d+)\s+(.*)$/o
    rgbValue = sprintf( '%03d %03d %03d', $1, $2, $3 )
    coloursH[rgbValue] = "#{coloursH[rgbValue]} '#{$4}'"
  end #if 1
end #until
inFile.close

if coloursH.empty?
  $stderr.puts "No colours in file '#{RGB_FILE}' !"
  exit( 2 )
end #if 1

root = TkRoot.new { title 'X11 Colours' }
frame = TkFrame.new( root )
maxCols = ( Math.sqrt( coloursH.size ) + 0.5 ).to_i
count = 0
coloursH.keys.sort.each do |rgb|
  colour = coloursH[rgb]
  colour =~ /\s+'(\S+)'/o
  TkButton.new( frame ) do
    background $1
    foreground $1
    activebackground $1
    activeforeground $1
    padx 7
    pady 1
    command { puts "#{rgb}  #{colour}" }
    grid( 'row' => count / maxCols, 'column' => count % maxCols, 
        'sticky' => 'news' )
  end #do
  count = count + 1
end #do
frame.pack
Tk.mainloop()


exit



# Local Variables:
# mode:ruby
# End:
