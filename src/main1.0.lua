program = {classes = {name = nil, extends = nil, attribute = {name = nil, tipo = nil}, 
methods = {name = nil, params = {MethodParam = {name = nil, type_paramn}}, 
type_method = nil, body = {} } }, body = {} }

file = arg[1]
io.open (file, "r")
for line in io.lines(file) do 
	print (line)
end

return program