require 'open3'

# Open3.popen3 'wvWare -p test '+ARGV[1] do |stdin, stdout, t|
# 	plaintext = stdout.read
# end
# =begin
file = File.open(ARGV[0],'rb')
$password = ''
startTime = Time.new
file.readlines.each do |pass|
	#Check
	Open3.popen3 'wvWare -p '+pass.chomp+' '+ARGV[1] do |stdin, stdout, t|
		plaintext = stdout.gets
# 		puts plaintext
		if plaintext != nil
			$password = pass
			break
		end
		stdin.close
		stdout.close
	end
end
puts $password
endTime = Time.new
puts endTime - startTime
# =end

