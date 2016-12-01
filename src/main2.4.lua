-- Criação das tabelas

program = {
	classes = {
	},
	body = {
	}
}


---------------------------------------------------------------------------------->>
-- Recebe nome e abre arquivo DOOL e arquivo de saída

file = arg[1]
io.input (file)
file = io.lines()
io.output ("prog.c")


---------------------------------------------------------------------------------->>
-- Casamento de padrões: copia os dados para suas tabelas

for line in file do   -- itera sobre todas as linhas do arquivo dool
	
	-- Copia classes
	if string.match(line, "class") then   -- testa se a linha em quastão é o começo da "class"
		nome_class = string.match (line, "%s*class%s+(%a+)")
		extends = string.match (line, "%s*class%s+%a+extends%s+(%a+)")
		
		-- Cria tabela com componentes da classe 
		class = {nome_class_t = nome_class, extends_t = extends, 
				attribute = {params = {
							}
				}
		}

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
		for line in file do   -- itera sobre as linhas do body
			if string.match(line, "end") then
				break
			end
			table.insert(program.body, line)   -- insere programa principal na tabela body
		end
		--break
	end
end


---------------------------------------------------------------------------------->>
return program