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
require 'set'



################################################################################
# CONSTANTS
################################################################################

READ_BUFFER_SIZE = 16
MIN_PRINT_ASCII = 0x20
MAX_PRINT_ASCII = 0x7E
PRINTABLE_SET = Set[*(MIN_PRINT_ASCII .. MAX_PRINT_ASCII)]



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
    until fh.eof?
        buffer = fh.read(READ_BUFFER_SIZE)
	    out_s = '%08X  ' % offset
	    print_s = ' '
		buffer.each_byte do |b|
		    out_s << '%02X ' % b
		    if PRINTABLE_SET === b
			    print_s << b.chr
			else
			    print_s << '.'
			end
		end
		(READ_BUFFER_SIZE - buffer.size).times { out_s << '   '}
		out_s << print_s
        puts out_s
		offset = offset + READ_BUFFER_SIZE
	end
end



################################################################################
# END
################################################################################

