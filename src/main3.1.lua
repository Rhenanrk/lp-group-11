-- Criação das tabelas básicas

program = {
	classes = {
	},
	body = {
	}
}


---------------------------------------------------------------------------------->>
-- Recebe nome e abre arquivo DOOL

file = arg[1]
io.input (file)
file = io.lines()

-- Abre arquivo de saída C

file_out = io.open ("prog.c", "w") 
io.output(file_out)


---------------------------------------------------------------------------------->>
-- Casamento de padrões: copia os dados para suas tabelas

for line in file do   -- Itera sobre todas as linhas do programa dool
	
	-- Copia classes
	if string.match(line, "class") then   -- Testa se a linha em quastão é o começo da "class"
		nome_class = string.match (line, "%s*class%s+(%a+)")
		extends = string.match (line, "%s*class%s+%a+extends%s+(%a+)")
		
		-- Cria tabela com componentes da classe 
		class = {name = nome_class, extends = extends, 
				attributes = {params = {
							}
				},
        methods = { }
		}

		-- Copia dados para a classe
		for lineInClass in file do   -- Itera sobre todas as linhas dentro da classe
			if string.match(lineInClass, "end") then   -- Testa se o iterador chegou no final da classe
				break

      		elseif string.match(lineInClass, "attribute") then   -- Testa se a linha é um atributo
				nome_attribute, tipo_attribute = string.match(lineInClass, "%s*attribute%s+(%a+)%s*:%s*(%a+)")
				attribute_list = {name = nome_attribute, tipo = tipo_attribute}
				table.insert (class.attributes, attribute_list)

      		elseif string.match(lineInClass, "def") then   -- Testa se a linha é o começo do método
				tipo_method, nome_methods = string.match(lineInClass, "%s*def%s*(%a+)%s*(%a+)")
				
				-- Cria e preenche tabela com metodos da classe
				methods = {tipo = tipo_method, name = nome_methods,
						body = {
						},
            		params = {
            		}
				}

	        for linesInMeth in file do  -- Copia corpo do metodo 
	        	if string.match (linesInMeth, "begin") then  -- Testa se a linha é começo do corpo do método
	            	for linesInBody in file do
	              		if string.match(linesInBody, "end") then  -- Testa se o iterador chegou no final do método
	                		break
	              		end
                  table.insert (methods.body, linesInBody)
                end
                break
	          
		        elseif string.match(linesInMeth, ":") then -- Testa se a linha é um paramentro
			    	nome_params, tipo_params = string.match (linesInMeth, "%s*(%a+)%s*:%s*(%a+)")

			    	-- Cria e preenche tabela com paramentros da classe
			        params_list = {name = nome_params, tipo = tipo_params} 
			        table.insert (methods.params, params_list)
            end
	        end -- linesInMeth
      	end -- if do método

		end -- Termina for que copia dados das classes
		table.insert(class.methods, methods)
    table.insert(program.classes, class) -- Insere a tabela class (criada e preenchida acima) na tabela classes do programa principal


	-- Copia program
  elseif string.match(line, "program") then   -- Testa se a linha em quastão é o começo de program
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
-- Converte tabelas dool para C e modela arquivo de saída

io.write(string.format("#include <stdio.h>\n#include <stdlib.h>\n\n"))  -- Imprime cabeçalho padrão de C

for i, class in ipairs(program.classes) do  -- Itera na classe para imprimir a struct
 	io.write(string.format("struct %s;\n", class.name))
end

for i, class in ipairs(program.classes) do  -- Modela e imprime a struct, que é a simulação de classe
	vtable[class.name] = {}  -- Cria tabela para metodos dinamicos
	static[class.name] = {}  -- Cria tabela para metodos estáticos
	
	io.write(string.format("struct %s {\n", class.name))

	if class.extends then  -- Implementa herança se 'extends' for diferente de nil
		for i, ext in ipairs(program.classes) do
			if ext.name == class.extends then  -- Testa se o nome da classe é diferente de nil (se ela existe)
			    for i, extclass in ipairs(ext.attributes) do
			    	io.write(string.format("  int %s;\n", extclass.name))
			    end
			    for i, meth in ipairs(ext.methods) do
			    	if meth.tipo == "dynamic" then  -- Testa de o método é dinámico
			        	vtable[class.name][#vtable[class.name] + 1] = meth  -- Se o método for dinamico, implementar vtable
			    	end
			    end
			    break
			end
		end
	end

	for i, atrib in ipairs(class.attributes) do  -- Itera na tabela de atributos e os imprime
		io.write(string.format("  int %s;\n", atrib.name))
	end

	for i, meth in ipairs(class.methods) do  -- Itera na tabela de metodos e os imprime
		if meth.tipo == "dynamic" then  -- Testa se o método é dinamico (se for, implementa vtable)
			for k, v in ipairs(vtable[class.name]) do
		    	if v.name == meth.name then  -- Testa se a variavel iterada é duplicada
		      		duplicate = true
		      		break
		    	end
		  	end
		  
		  	if duplicate then
		    	vtable[class.name][k] = meth  -- Se for duplicada, nome da classe recebe nome da variável 
		  	else
		    	vtable[class.name][#vtable[class.name] + 1] = meth  -- Se não for duplicada é criado um novo componente na tabela vtable
		  	end
		else  -- Se não  for dinamico
		  	static[class.name][#static[class.name] + 1] = meth  -- É criado um novo componente na tabela static
		end
	end

	if #vtable[class.name] > 0 then  -- Testa se existem classes na tabela vtable e se houver, faz a modelagem no arquivo
		io.write(string.format("  struct vtable_%s *vtable;\n};\n\n", class.name))
		io.write(string.format("struct vtable_%s {\n", class.name))
		for k, v in ipairs(vtable[class.name]) do
	  		io.write(string.format("  int (*%s)(struct %s*", v.name, class.name))
	  		parameters(class, v)  -- Chama função que modela parametros (a fazer)
		end
	end
	io.write("};\n\n")
end

prototype(program, vtable, static)  -- Implementa o protótipo dos métodos

for i, class in ipairs(program.classes) do
  	if #vtable[class.name] > 0 then  -- Testa se existem vtables para a classe
    	existe_vtable = true
    	io.write(string.format("struct vtable_%s vtable_%s;\n\n", class.name, class.name))
  	end
end

io.write(string.format("int main() {\n"))

body(program.body, vtable, static)  -- Chama função que modela corpo do program (a fazer)

io.write("  return 0;\n}\n")