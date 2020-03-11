


function readjson()

   out = Dic[]
   for file in glob("*Z.json","/tmp/test/")
       json = readline(file)   # not json yet
       replace!(json, "][" => "," )   # now it is
   end 

   return 
   
end 
