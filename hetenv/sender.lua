-- Symbolic driver (sender) for a heterogenous environment

require "symtc"

function pipe_test (provider, send_file, recv_file)
   local send_fd, err = io.open(send_file, "w")
   if send_fd == nil then
      print("SENDER: Could not open send pipe: " .. err)
      error()
   end
   print("SENDER: Open send pipe")
   local recv_fd, err = io.open(recv_file, "r")
   if recv_fd == nil then
      print("SENDER: Could not open receive pipe: " .. err)
      error()
   end
   print("SENDER: Open recv pipe")

   local data = provider:getstring("message\n", "symval")
   send_fd:write(data)
   send_fd:close()
   print("SENDER: Message sent")

   response = recv_fd:read()
   print("SENDER: Response received of size " .. #response)
   recv_fd:close()
end

symtc.execute(arg[3], pipe_test, arg[1], arg[2])
