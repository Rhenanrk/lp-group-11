-- Criação das tabelas básicas

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

for line in file do   -- Itera sobre todas as linhas do programa dool
	
	-- Copia classes
	if string.match(line, "class") then   -- Testa se a linha em quastão é o começo da "class"
		nome_class = string.match (line, "%s*class%s+(%a+)")
		extends = string.match (line, "%s*class%s+%a+extends%s+(%a+)")
		
		-- Cria tabela com componentes da classe 
		class = {nome_class_t = nome_class, extends_t = extends, 
				attribute = {params = {
							}
				}
		}

		-- Copia dados para a classe
		for lineInClass in file do   -- Itera sobre todas as linhas dentro da classe
			if string.match(lineInClass, "end") then   -- Testa se o iterador chegou no final da classe
				break

      		elseif string.match(lineInClass, "attribute") then   -- Testa se a linha é um atributo
				nome_attribute, tipo_attribute = string.match(lineInClass, "%s*attribute%s+(%a+)%s*:%s*(%a+)")
				attribute_list = {nome_attribute_t = nome_attribute, tipo_attribute_t = tipo_attribute}
				table.insert (class.attribute, attribute_list)

      		elseif string.match(lineInClass, "def") then   -- Testa se a linha é o começo do método
				tipo_method, nome_methods = string.match(lineInClass, "%s*def%s*(%a+)%s*(%a+)")
				
				-- Cria e preenche tabela com metodos da classe
				methods = {tipo_method_t = tipo_method, nome_methods_t = nome_methods,
						body_class = {
						},
            		params = {
            		}
				}

	        for linesInMeth in file do  -- Copia corpo do metodo 
	        	if string.match (linesInMeth, "begin") then  -- Testa se a linha é começo do método
	            	for linesInBody in file do
	              		if string.match(linesInBody, "end") then  -- Testa se o iterador chegou no final do método
	                		break
	              		end
	            	table.insert (methods.body_class, linesInBody)
	            end
	        	break
	          
		        elseif string.match(linesInMeth, ":") then -- Testa se a linha é um paramentro
			    	nome_params, tipo_params = string.match (linesInMeth, "%s*(%a+)%s*:%s*(%a+)")

			    	-- Cria e preenche tabela com paramentros da classe
			        params_list = {nome_params_t = nome_params, tipo_params_t = tipo_params} 
			        table.insert (methods.params, params_list)
			    end
	        end
      	end

		table.insert(class, methods)
		table.insert(program.classes, class) -- Insere a tabela class (criada e preenchida acima) na tabela classes do programa principal
		end -- Termina for que copia dados das classes
	end -- Termina if da classe


	-- Copia program
	if string.match(line, "program") then   -- Testa se a linha em quastão é o começo de program
		for line in file do   -- Itera sobre as linhas do body
			if string.match(line, "end") then
				break
			end
			table.insert(program.body, line)   -- Insere programa principal na tabela body
		end
		break
	end
end

---------------------------------------------------------------------------------->>
-- Testes

print (program.classes[1].nome_class_t)
print (program.classes[1].attribute[1].nome_attribute_t)
print (program.classes[1].attribute[1].tipo_attribute_t)
print (program.classes[1].attribute[2].nome_attribute_t)
print (program.classes[1].attribute[2].tipo_attribute_t)
for i,v in ipairs(program.body) do
	print(v)
end

---------------------------------------------------------------------------------->>
return program