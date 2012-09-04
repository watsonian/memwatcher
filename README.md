# MemWatcher

This is a small Sinatra app that's designed to run on a server that you want
to monitor memory usage on. You configure a memory threshold and every time
the `/memcheck` page is hit the memory usage on the server is checked. If it
exceeds the specified amount, it records the running processes and the memory
usage at that time. Subsequent memory checks won't be recorded unless they
exceed the last highest memory usage seen. The max seen memory is reset after
a configurable number of times.

![](https://img.skitch.com/20120904-ei2851g3ij73e7mqp7m95q8f8s.jpg)

## Configuration

The following configuration options are available via environment variables:

* `MEMWATCHER_MEMORY_THRESHOLD` - The memory threshold to record a process
  listing if exceeded. Defaults to 50MB.
* `MEMWATCHER_MAX_CHECKS` - The number of checks before the max seen memory
  usage is reset. Dfaults to 6.
* `MEMWATCHER_LOGS_TO_KEEP` - The number of log files to keep. Defaults to 25.
* `MEMWATCHER_LOG_DIR` - The location to store the logs. Defaults to `log/procs`.

## Copyright

Copyright (c) 2012 Joel Watson. See LICENSE for details.
