# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Class to return PID information from daemontools status files.
# YMMV, you may need to check tai.h for format information.
class Svstat
  # Identify status file.
  def initialize(dir)
    @statfile = File.join(dir, "supervise", "status")
  end

  # Provide PID information.
  def pid
    # Open status file for binary reading.
    f = File.open(@statfile, "rb:binary")

    # Seek to where PID information is.
    f.seek(12)

    # Read four bytes.
    bytes = f.read(4)

    # Unpack unsigned integer.
    data = bytes.unpack("i*")

    f.close
    return(data)
  end
end
