-- Symbolic driver (sender) for a heterogenous environment

require "symtc"

function pipe_test (provider)
   pipe_fd = io.open("pipey", "w")
   if pipe_fd == nil then
      io.stderr:write("Could not open pipe\n")
      error("Could not open pipe")
   end
   pipe_fd:close()
end

symtc.execute(arg[1], pipe_test)
