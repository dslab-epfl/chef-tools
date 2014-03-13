-- Symbolic driver (sender) for a heterogenous environment

require "symtc"

function pipe_test (provider, pipe_file)
   pipe_file = pipe_file or "pipey"

   local pipe_fd, err = io.open(pipe_file, "r+")
   if pipe_fd == nil then
      print("Could not open pipe: "..err)
      io.stderr:flush()
      error("Could not open pipe")
   end

   print("Pipe open")
   local data = provider:getstring("message\n", "symval")
   pipe_fd:write(data)
   print("Message sent")

   response = pipe_fd:read()
   print("Message received of size "..#response)
   pipe_fd:close()
end

symtc.execute(arg[2], pipe_test, arg[1])
