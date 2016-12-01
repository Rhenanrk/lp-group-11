-- Cria tabelas
program = {
	classes = {
		name = nil, extends = nil, 
		attribute = {
			name = nil, type_attribute = nil
		},
		methods = {
			name = nil, 
			params = {
				MethodParam = {
					name = nil, type_paramn
				}
			},
			type_method = nil, 
			body_method = { 
			} 
		} 
	}, 
	body = { 
	} 
}

-- Recebe nome e abre arquivo DOOL
file = arg[1]
io.open (file, "r")

-- Casamento de padões
for line in io.lines(file) do
	
	-- Copia classes
	if string.match(line, "class") then
		id = string.match(line, "%s*class%s*(%a+)")
		print (line)
		print (id)
		table.insert (program.classes.name, id)
		for lines in io.lines(file) do
			if string.match(lines, "attribute") then
				nome = (string.match(lines, "%s*%a+%s+(%a+)"))
				tipo = (string.match(lines, "%s*%a+%s+%a+%s+:%s+(%a+)"))
				table.insert (program.classes.attribute.name, nome)
				table.insert (program.classes.attribute.type_attribute, tipo)
			end
		end
	end

	-- Copia corpo do programa
	if string.match(line, "program") then
		for lines in io.lines(file) do
			table.insert(program.body, lines)   --precisa remover primeira e ultima linha
		end
	end
end

return program