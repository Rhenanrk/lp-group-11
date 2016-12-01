-- Criação das tabelas

program = {
	classes = {
		name = nil, extends = nil, 
		attribute = {
			name = nil, type_attribute = nil
		},
		methods = {
			name = nil, type_method = nil,
			params = {
				MethodParam = {
					name = nil, type_paramn = nil
				}
			}, 
			body_method = { 
			}
		}
	}, 
	body = { 
	}
}


---------------------------------------------------------------------------------->>
-- Recebe nome e abre arquivo DOOL e arquivo de saída

file = arg[1]
io.input (file)
io.output ("prog.c")


---------------------------------------------------------------------------------->>
-- Casamento de padrões: copia os dados para suas tabelas

for line in io.lines(file) do   -- itera sobre todas as linhas do arquivo dool
	
	-- Copia classes
	if string.match(line, "class") then   -- testa se a linha em quastão é o começo da "class"
		nome = string.match(line, "%s*class%s*(%a+)")
--		print (line)
--		print (nome)
		table.insert (program.classes.name, nome)
		
		-- Copia dados da classe
		for line in io.lines(file) do   -- itera sobre todas as linhas dentro da classe
			if line == "end" then   -- testa se o iterador chegou no final da classe
				break
			end
			if string.match(line, "attribute") then   -- testa se a linha em quastão é um atributo
				nome, tipo = string.match(line, "%s*attribute%s+(%a+)%s*:%s*(%a+)")
				table.insert (program.classes.attribute.name, nome)
				table.insert (program.classes.attribute.type_attribute, tipo)
			end

			if string.match(line, "def") then   -- testa se a linha em quastão é um método
				tipo, nome = string.match(line, "%s*def%s*(%a+)%s*(%a+)")
				table.insert (program.classes.methods.name, nome)
				table.insert (program.classes.methods.type_method, tipo)
			end

			if string.match(line, "def") then   -- testa se a linha em quastão é um parametro
				nome, tipo = string.match(line, "%s*(%a+)%s*:%s*(%a+)")
				table.insert (program.classes.methods.params.MethodParam.name, nome)
				table.insert (program.classes.methods.params.MethodParam.type_paramn, tipo)
			end

			if string.match(line, "begin") then   -- testa se a linha em quastão é o começo do médoto
				for line in io.lines(file) do
					if line == "end" then   -- testa se o iterador chegou no final do body do método
						break
					end
					table.insert(program.classes.methods.body_method, line)
				end
			end

		end
	end

	-- Copia program
	if string.match(line, "program") then   -- testa se a linha em quastão é o começo de program
		for line in io.lines(file) do   -- itera sobre as linhas do body
			if line == "end" then
				break
			end
			table.insert(program.body, line)   -- insere programa principal na tabela body
		end
	end
end


---------------------------------------------------------------------------------->>
return program