# Prints to the console the correct useage of the program
def show_usage
  puts 'Usage:'
  puts 'ruby Ping.rb *filename.txt* *Number of tries*'
  puts '*filename.txt* should already exist and be valid.'
  puts '*Number of tries* should be a positive integer.'
end

$ips = []

# This method checks to see if the file exists.
# If it doesn't, it informs the user and prints
# out the correct usage.
def file_exists(filename)
  if filename.nil?
    puts
    puts 'You haven\'t entered a filename.'
    puts
    show_usage
    false
  else
    begin
      File.open(filename, 'r') do |f|
        f.each_line do |line|
          $ips.push(line.strip)
        end
      end
    rescue Errno::ENOENT
      puts
      puts "Failed to open #{filename}."
      puts
      show_usage
      false
    end
  end
end

# This method checks to make sure the number
# of ping tries is a positive Integer
def good_tries(num_tries)
  if num_tries.nil?
    puts
    puts 'You haven\'t entered number of tries.'
    puts
    show_usage
    false
  else
    if num_tries.is_a?(Integer) && num_tries.positive?
      $num_pings = num_tries
    else
      puts
      puts 'Number of tries should be a positive integer.'
      puts
      show_usage
      false
    end
  end
end

# If the filename is valid and the number of num_tries
# is a positive integer, create a thread for each IP address
# and ping them all.
if file_exists(ARGV[0]) && good_tries(ARGV[1].to_i)
  printing = Thread.new do
    print "Pinging"
    loop do
      sleep 0.4
      print "."
    end
  end.run

  threads = $ips.map do |ip|
    Thread.new { Thread.current[:result] = `ping -n #{$num_pings} #{ip}` }
  end

  threads.each do |thread|
    thread.join
    puts "\n"
    puts "#{thread[:result]} \n\n"
  end
end
