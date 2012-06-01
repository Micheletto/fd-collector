# The standard Process library doesn't contain a method for getting
# ppids for a given process and Sys-Utils is old, so rolling a class to 
# do it.
class Ppid
    # iterate over children PIDs
    def each(pid)
        # Include parent pid
        yield pid
        
        # Named regex to make sure we have a number.
        pidre = /[0-9]+/

        # Assuming this is being run on a modern linux variant that
        # has -ppid flag.  Procfs does not appear to list children processes,
        # but parent process is available as the PPid flag in 'status'.  
        # This should be converted to do that rather than shelling out to ps.
        ppids = %x(/bin/ps --ppid #{pid} -o pid)

        # Will change this to raise an exception in the future and
        # handle that by rechecking for the parent process, but just
        # dying for now.
        if(! $?.to_i.zero?):
            puts "ps command failed."
            exit 1
        end
        
        # Yield only valid PIDs to be iterated over.
        ppids.each do |p|
            mypid = pidre.match(p) 
            if mypid
                yield mypid
            end
        end
    end

    # Iterate over number of FDs opened by children processes.
    def fds(pid)
        self.each(pid) do |p|
            mydir = Dir.new("/proc/#{p}/fd")
            myfiles = mydir.entries
            mydir.close # Close this to avoid opening too many FDs ourself.

            # Instead of using a pattern to ignore dot files, or
            # match files comprising only of numbers, just subtract
            # 2 from the total.  It's faster.
            yield myfiles.length - 2
        end
    end

    # Return the total of all FDs opened by children processes of pid.
    def total(pid)
        tot = 0
        self.fds(pid) do |n|
            tot += n
        end

        # Return this value.
        tot
    end
end
