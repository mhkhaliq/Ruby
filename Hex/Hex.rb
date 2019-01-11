#! /usr/bin/env ruby

################################################################################
# FILE        : Hex.rb
# DESCRIPTION : Outputs in hexadecimal form the contents of any given file
# AUTHOR      : M H Khaliq
# LICENSE     : MIT
################################################################################



################################################################################
# IMPORTS
################################################################################

require 'optparse'



################################################################################
# CONSTANTS
################################################################################

READ_BUFFER_SIZE = 16
PADDING_ITEM_LENGTH = 3
PADDING_SIZE = READ_BUFFER_SIZE * PADDING_ITEM_LENGTH

NUM_ASCII_CHARS = 256
MIN_PRINT_ASCII = 0x20
MAX_PRINT_ASCII = 0x7E
UNPRINTABLE_CHAR = '.'



################################################################################
# MAIN
################################################################################

STDOUT.sync = true

filename = ''
OptionParser.new do |opts|
    opts.banner = "Usage: Hex.rb [options]"
    opts.on('-f FILE', '--file FILE', 'File to show as hexadecimals') do |f|
	    filename = f
    end
end.parse!

if filename.empty?
    STDERR.puts 'Expecting a file name!'
	exit(1)
end

File.open(filename, 'rb') do |fh|
    offset = 0
	
	# Create the lookup arrays
	hex_a = Array.new(NUM_ASCII_CHARS)
	print_a = Array.new(NUM_ASCII_CHARS)
	(0 ... NUM_ASCII_CHARS).each do |i|
	    hex_a[i] =  '%02X ' % i
		if i >= MIN_PRINT_ASCII && i <= MAX_PRINT_ASCII
		    print_a[i] = i.chr
		else
		    print_a[i] = UNPRINTABLE_CHAR
		end
	end
		
    until fh.eof?
        buffer = fh.read(READ_BUFFER_SIZE)
	    offset_s = '%08X  ' % offset
	    print_s = ' '
		hex_s = ''
		
		buffer.each_byte do |b|
		    hex_s << hex_a[b]
			print_s << print_a[b]
		end
				
		if READ_BUFFER_SIZE > buffer.size
		    hex_s = hex_s.ljust(PADDING_SIZE, ' ')
        end			
		out_s = offset_s << hex_s << print_s
		puts out_s
		offset = offset + READ_BUFFER_SIZE
	end
end



################################################################################
# END
################################################################################

