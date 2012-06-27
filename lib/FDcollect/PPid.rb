# The standard Process library doesn't contain a method for getting
# ppids for a given process and Sys-Utils is old, so rolling a class to
# do it.
class Ppid
  # Using Enumerable to add grep method to file class.
  include Enumerable

  # iterate over procfs, and return currently running processes
  def ps

    # Named regex to make sure we have a number.
    pidre = /[0-9]+/

    pdir = Dir.new("/proc")
    myprocs = pdir.entries
    pdir.close

    myprocs.grep(pidre).each do |p|
      yield p
    end
  end


  # iterate over children PIDs
  def each(pid)
    # Include parent pid
    yield pid

    # Named expression built around parent process that is being queried.
    ppidre = /PPid:\s+#{pid}$/

    # Yield only valid PIDs to be iterated over.
    self.ps do |p|
      begin   # Processes appear and disappear constantly on a running
        # operating system.  Ignoring them as they disappear out
        # from under the application by using an empty rescue
        # block.

        # Open status file, and look for our parent process.
        myfile = File.new("/proc/#{p}/status", 'r')
        unless(myfile.grep(ppidre).empty?)
            yield p
        end
        myfile.close

      rescue # Rescue by doing nothing.
      end
    end
  end

  # Iterate over number of FDs opened by children processes.
  def fds(pid)
    self.each(pid) do |p|

      begin # Using begin and rescue block to handle disappearing
        # processes, as in the each method.

        mydir = Dir.new("/proc/#{p}/fd")
        myfiles = mydir.entries
        mydir.close # Close this to avoid opening too many FDs ourselves.

        # Instead of using a pattern to ignore dot files, or
        # match files comprising only of numbers, just subtract
        # 2 from the total.  It's faster.
        yield myfiles.length - 2

        # If the process disappears yield the proper number of open file
        # handles, which is now zero.
      rescue
        yield 0
      end

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
