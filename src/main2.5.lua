-- Cria��o das tabelas

program = {
	classes = {
	},
	body = {
	}
}


---------------------------------------------------------------------------------->>
-- Recebe nome e abre arquivo DOOL e arquivo de sa�da

file = arg[1]
io.input (file)
file = io.lines()
io.output ("prog.c")


---------------------------------------------------------------------------------->>
-- Casamento de padr�es: copia os dados para suas tabelas

for line in file do   -- itera sobre todas as linhas do arquivo dool
	
	-- Copia classes
	if string.match(line, "class") then   -- testa se a linha em quast�o � o come�o da "class"
		nome_class = string.match (line, "%s*class%s+(%a+)")
		extends = string.match (line, "%s*class%s+%a+extends%s+(%a+)")
		
		-- Cria tabela com componentes da classe 
		class = {nome_class_t = nome_class, extends_t = extends, 
				attribute = {params = {
							}
				}
		}

		-- Copia dados para a classe
		for lineInClass in file do   -- itera sobre todas as linhas dentro da classe
			if string.match(lineInClass, "end") then   -- testa se o iterador chegou no final da classe
				break
			end

			if string.match(lineInClass, "attribute") then   -- testa se a linha � um atributo
				nome_attribute, tipo_attribute = string.match(lineInClass, "%s*attribute%s+(%a+)%s*:%s*(%a+)")
				attribute_list = {nome_attribute_t = nome_attribute, tipo_attribute_t = tipo_attribute}
				table.insert (class.attribute, attribute_list)
			end

			if string.match(lineInClass, "def") then   -- testa se a linha � o come�o do m�todo
				tipo_method, nome_methods = string.match(lineInClass, "%s*def%s*(%a+)%s*(%a+)")
				
				-- Cria tabela com metodos da classe
				methods = {tipo_method_t = tipo_method, nome_methods_t = nome_methods, 
						body_class = { 
						} 
				}

				for lineInMethods in file do
					if string.match (lineInMethods, "begin") then
						for lineInBody in file do
							if string.match(lineInBody, "end") then   -- testa se o iterador chegou no final do body do m�todo
								break
							end
							table.insert (methods.body_class, lineInBody)
						end
						break
					end	
				end
			end
		
		table.insert(class, methods)
		table.insert(program.classes, class) -- Insere a tabela class (criada e preenchida acima) na tabela classes do programa principal
		end -- termina for que copia dados das classes
	end -- termina if classes

	-- Copia program
	if string.match(line, "program") then   -- testa se a linha em quast�o � o come�o de program
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