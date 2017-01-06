%INTELIGENCIA ARTIFICIAL 2015/2016

%Ejemplo de ejercucion:
%consulta tipo 1: valor del atributo de un empleado
%?-pregunta.
%	[cual, es, la, edad, de, 'Juan'].   <--- Hay que tener cuidado y poner el nombre de la persona entre comillas 
%											 para que no se interprete como una variable
%	El valor del atributo es: 25

%consulta tipo 2: nombres de los empleados de un atributo y un valor dados
%?- pregunta.
%	[cuales, son, los, nombres, de, los, empleados, del, departamento, 'Atencion al cliente']. <--- Hay que poner el valor del atributo como un solo elemento
%																									entre comillas simples
%	[Garcia,Juan,Martinez]

%pregunta inicial para realizar las consultas:
pregunta :- read(Pregunta), preguntaAux(Pregunta).

preguntaAux(Pregunta) :-
	procesa_pregunta(Empleado, Atributo, Pregunta, []),
	empleado(Empleado, Atributo, Valor),
	write('El valor del atributo es: '),
	write(Valor), !.

preguntaAux(Pregunta) :-
	procesa_pregunta(Atributo, Valor, Pregunta, []),
	setof(X, empleado(X, Atributo, Valor), Empleados),
	write(Empleados).


%gramaticas:
%gramaticas para consultar el valor de un atributo de un empleado:
procesa_pregunta(Empleado, Atributo) --> comienzo, determinante(Genero), atributo(Atributo, Genero), [de], trabajador(Empleado), !.
procesa_pregunta(Empleado, Atributo) --> [que], atributo(Atributo, _), [tiene], trabajador(Empleado), !.

%gramatica para consultar los nombres coincidentes con un valor y un atributo dados
procesa_pregunta(Atributo, Valor) --> comienzo, [los, nombres, de, los, empleados], nexo, atributo(Atributo, _), nexo, valor(Valor).


%procesa_pregunta(Atributo, Valor) --> comienzo(Numero), determinante(masculino, Numero), [nombres], nexo(GeneroAtr), atributo(Atributo, GeneroAtr), [Valor].

%Posibles comienzos de una pregunta
comienzo --> [cuales, son]; [cual, es]; [dime]; [dame]; [quiero, saber].

nexo --> [del]; [de, la]; [de]; [].

%Analisis de un determinante, necesitamos su genero para ver si concuerda con el genero del atributo del que vas seguido
determinante(Genero) --> [Determinante],
	{
		es_determinante(Determinante, Genero)
	}.

%Analisis de un atributo, necesitamos su genero para saber si concuerda con el determinante del que va precedido
atributo(Atributo, Genero) --> [Atributo],
	{
		es_atributo(Atributo),
		genero(Atributo, Genero)
	}.

%Analisis de un empleado
trabajador(Empleado) --> [Empleado],
	{
		es_empleado(Empleado)
	}.

%Gramtica que devuelve un valor como parte de una frase analizada
valor(Valor) --> [Valor].

%diccionario:

es_atributo(Atributo) :- empleado(_, Atributo, _), !.

es_empleado(Empleado) :- empleado(Empleado, _, _), !.

es_determinante(el, masculino).
es_determinante(los, masculino).
es_determinante(la, femenino).
es_determinante(las, masculino).

%departamentos, con su genero y numero:
genero(departamento, masculino).
genero(edad, femenino).
genero(salario, masculino).


%Base de datos:

%salarios
empleado('Juan', salario, 1000).
empleado('Garcia', salario, 1200).
empleado('Martinez', salario, 1000).
empleado('Marta', salario, 1500).
empleado('Pepe', salario, 1200).
empleado('Raquel', salario, 1200).
empleado('Alberto', salario, 900).
empleado('Paloma', salario, 800).
empleado('Enrique', salario, 2000).
empleado('Fernandez', salario, 1500).
empleado('Maria', salario, 800).
empleado('Francisco', salario, 1000).

%departamentos
empleado('Juan', departamento, 'Atencion al cliente').
empleado('Garcia', departamento, 'Atencion al cliente').
empleado('Martinez', departamento, 'Atencion al cliente').
empleado('Marta', departamento, 'Ventas').
empleado('Pepe', departamento, 'Ventas').
empleado('Raquel', departamento, 'Ventas').
empleado('Alberto', departamento, 'Seguridad').
empleado('Paloma', departamento, 'Seguridad').
empleado('Enrique', departamento, 'Seguridad').
empleado('Fernandez', departamento, 'Contabilidad').
empleado('Maria', departamento, 'Contabilidad').
empleado('Francisco', departamento, 'Contabilidad').

%edades
empleado('Juan', edad, 25).
empleado('Garcia', edad, 45).
empleado('Martinez', edad, 30).
empleado('Marta', edad, 36).
empleado('Pepe', edad, 28).
empleado('Raquel', edad, 50).
empleado('Alberto', edad, 39).
empleado('Paloma', edad, 40).
empleado('Enrique', edad, 34).
empleado('Fernandez', edad, 27).
empleado('Maria', edad, 35).
empleado('Francisco', edad, 47).