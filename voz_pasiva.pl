%INTELIGENCIA ARTIFICIAL 2015/2016

%Ejemplos de ejecucion:
%?- pregunta.
%	[los, ninos, dibujaron, un coche].
%	un coche fue dibujado por los ninos

%?- pregunta.
%	[yo, cante, una, cancion].
%	una cancion fue cantada por mi 


%Pregunta inicial en la que se lee del usuario una frase en forma
%de lista (por ejemplo [los, ninos, dibujaron, una, flor]),
%a continuacion se transforma en voz pasiva y se escribe en pantalla
%Esta version solo admite verbos de la primera conjugacion
pregunta :- read(Frase), frase_voz_pasiva(FraseVozPasiva, Frase, []), write(FraseVozPasiva).

%GRAMATICAS:

%Gramatica en la que dada una frase devuelve en el parametro FraseVozPasiva su forma en voz pasiva
%Llama a la gramatica frase_voz_activa para analizar sintacticamente la oracion y devuelve los
%complementos necesarios para reformular la frase
frase_voz_pasiva(FraseVozPasiva) -->
	frase_voz_activa(Sujeto, Sexo, Persona, Tiempo, Numero, Infinitivo, Agente, CC),
	{
		participio(Participio, Infinitivo, Sexo, Numero),
		forma_ser(FormaSer, Tiempo, Persona, Numero),
		atom_concat(Sujeto, ' ', A),
		atom_concat(A, FormaSer, B),
		atom_concat(B, ' ', C),
		atom_concat(C, Participio, D),
		atom_concat(D, ' ', E),
		atom_concat(E, 'por ', F),
		agente(Agente, Ag),
		atom_concat(F, Ag, G),
		atom_concat(G, ' ', H),
		atom_concat(H, CC, FraseVozPasiva)
	}.


%Gramatica en la que se analiza sintacticamente una frase formada por un grupo nominal y otro verbal
%que concuerdan en persona y numero, por otro lado, me quedo con los complementos necesarios de ellos
%necesarios para la voz pasiva
frase_voz_activa(Sujeto, SexoSujeto, PersonaSujeto, Tiempo, NumeroSujeto, Infinitivo, Agente, CC) -->
	grupo_nominal(Persona, Numero, _, Agente),
	grupo_verbal(Infinitivo, Persona, Numero, Tiempo, SexoSujeto, PersonaSujeto, NumeroSujeto, Sujeto, CC).

%Gramatica que analiza sintacticamente un grupo nominal formado por un determinante y un sustantivo
%Hay dos gramaticas de este tipo iguales seguidas que se diferencian en que el primer parametro es
grupo_nominal(3, Numero, Sexo, Sujeto) -->
	[Determinante, Nombre],
	{
		es_determinante(Determinante, Numero, Sexo),
		es_sustantivo(Nombre, Numero, Sexo),
		atom_concat(Determinante, ' ', A),
		atom_concat(A, Nombre, Sujeto)
	}.

%Gramatica que analiza sintacticamente un grupo nominal formado por un determinante y un sustantivo
grupo_nominal(_, Numero, Sexo, Sujeto) -->
	[Determinante, Nombre],
	{
		es_determinante(Determinante, Numero, Sexo),
		es_sustantivo(Nombre, Numero, Sexo),
		atom_concat(Determinante, ' ', A),
		atom_concat(A, Nombre, Sujeto)
	}.

%Gramatica que analiza sintacticamente un grupo nominal formado por un solo pronombre personal
grupo_nominal(Persona, Numero, Sexo, P) -->
	[P],
	{
		es_pronombre(P, Persona, Numero, Sexo)
	}.


%Solo queremos frases en las que haya complemento directo porque si no no puede haber voz pasiva:
%Grupo verbal formado por un verbo y un complemento directo que es un grupo nominal:
grupo_verbal(Infinitivo, Persona, Numero, Tiempo, SexoSujeto, PersonaSujeto, NumeroSujeto, Sujeto, '') -->
	verbo(Infinitivo, Persona, Numero, Tiempo),
	grupo_nominal(PersonaSujeto, NumeroSujeto, SexoSujeto, Sujeto).

%Grupo verbal formado por un verbo, un complemento directo y un complemento circunstancial (en este orden):
grupo_verbal(Infinitivo, Persona, Numero, Tiempo, SexoSujeto, PersonaSujeto, NumeroSujeto, Sujeto, CC) -->
	verbo(Infinitivo, Persona, Numero, Tiempo),
	grupo_nominal(PersonaSujeto, NumeroSujeto, SexoSujeto, Sujeto),
	comp_circunstancial(Infinitivo, CC).
%Grupo verbal formado por un verbo, un complemento circunstancial y un complemento directo (en este orden):
grupo_verbal(Infinitivo, Persona, Numero, Tiempo, SexoSujeto, PersonaSujeto, NumeroSujeto, Sujeto, CC) -->
	verbo(Infinitivo, Persona, Numero, Tiempo),
	comp_circunstancial(Infinitivo, CC),
	grupo_nominal(PersonaSujeto, NumeroSujeto, SexoSujeto, Sujeto).

%Gramatica que analiza un verbo, comprobando su raiz y su terminacion
verbo(Infinitivo, Persona, Numero, Tiempo) -->
	[Verbo],
	{
		atom_concat(Raiz, Terminacion, Verbo),
		es_raiz(Raiz, Infinitivo),
		es_terminacion(Terminacion, Tiempo, Persona, Numero)
	}.

%Gramatica que analiza un complemento circunstancial formado por una preposicion y un grupo nominal
%y devuelve este complemento circunstancial como union de la preposicion y el grupo nominal
comp_circunstancial(Infinitivo, CC) -->
	preposicion(Preposicion),
	grupo_nominal(_, _, _, Sujeto),
	{
		tiene_preposicion(Infinitivo, Preposicion),
		atom_concat(Preposicion, ' ', A),
		atom_concat(A, Sujeto, CC)
	}.

%Gramatica que comprueba la existencia de una preposicion y la devuelve
preposicion(Preposicion) -->
	[Preposicion],
	{
		es_preposicion(Preposicion)
	}.


%Diccionario:

%verbo ser: imprescindible para la voz pasiva
forma_ser(soy, presente, 1, singular).
forma_ser(eres, presente, 2, singular).
forma_ser(es, presente, 3, singular).
forma_ser(somos, presente, 1, plural).
forma_ser(sois, presente, 2, plural).
forma_ser(son, presente, 3, plural).
forma_ser(fui, pasado, 1, singular).
forma_ser(fuiste, pasado, 2, singular).
forma_ser(fue, pasado, 3, singular).
forma_ser(fuimos, pasado, 1, plural).
forma_ser(fuisteis, pasado, 2, plural).
forma_ser(fueron, pasado, 3, plural).

%Verbos:
%primera conjugacion
es_raiz(cant, cantar).
es_raiz(dibuj, dibujar).
es_raiz(tom, tomar).
es_raiz(cont, contar).
es_raiz(pint, pintar).

%presente
es_terminacion(o, presente, 1, singular).
es_terminacion(as, presente, 2, singular).
es_terminacion(a, presente, 3, singular).
es_terminacion(amos, presente, 1, plural).
es_terminacion(ais, presente, 2, plural).
es_terminacion(an, presente, 3, plural).
%pasado
es_terminacion(e, pasado, 1, singular).
es_terminacion(aste, pasado, 2, singular).
es_terminacion(o, pasado, 3, singular).
es_terminacion(amos, pasado, 1, plural).
es_terminacion(asteis, pasado, 2, plural).
es_terminacion(aron, pasado, 3, plural).

%participios
participio(cantado, cantar, masculino, singular).
participio(cantada, cantar, femenino, singular).
participio(cantados, cantar, masculino, plural).
participio(cantadas, cantar, femenino, plural).
participio(dibujado, dibujar, masculino, singular).
participio(dibujada, dibujar, femenino, singular).
participio(dibujados, dibujar, masculino, plural).
participio(dibujadas, dibujar, femenino, plural).
participio(tomado, tomar, masculino, singular).
participio(tomada, tomar, femenino, singular).
participio(tomados, tomar, masculino, plural).
participio(tomadas, tomar, femenino, plural).
participio(contado, contar, masculino, singular).
participio(contada, contar, femenino, singular).
participio(contados, contar, masculino, plural).
participio(contadas, contar, femenino, plural).
participio(pintado, pintar, masculino, singular).
participio(pintada, pintar, femenino, singular).
participio(pintados, pintar, masculino, plural).
participio(pintadas, pintar, femenino, plural).


%pronombres personales
es_pronombre(yo, 1, singular, masculino).
es_pronombre(tu, 2, singular, masculino).
es_pronombre(el, 3, singular, masculino).
es_pronombre(ella, 3, singular, femenino).
es_pronombre(nosotros, 1, plural, masculino).
es_pronombre(nosotras, 1, plural, femenino).
es_pronombre(vosotros, 2, plural, masculino).
es_pronombre(vosotras, 2, plural, femenino).
es_pronombre(ellos, 3, plural, masculino).
es_pronombre(ellas, 3, plural, femenino).

%nombres propios, son pronombres personales de la tercera personal de singular
es_pronombre(juan, 3, singular, masculino).
es_pronombre(maria, 3, singular, femenino).

%predicados para la traducccion de 'yo' a 'mi' y de 'tu' a 'ti'
agente(yo, mi) :- !.
agente(tu, ti) :- !.
agente(Agente, Agente).

%Determinantes:
es_determinante(el, singular, masculino).
es_determinante(la, singular, femenino).
es_determinante(los, plural, masculino).
es_determinante(las, plural, femenino).
es_determinante(un, singular, masculino).
es_determinante(una, singular, femenino).
es_determinante(unos, plural, masculino).
es_determinante(unas, plural, femenino).

%Sustantivos:
es_sustantivo(nino, singular, masculino).
es_sustantivo(ninos, plural, masculino).
es_sustantivo(flor, singular, femenino).
es_sustantivo(flores, plural, femenino).
es_sustantivo(coche, singular, masculino).
es_sustantivo(jardin, singular, masculino).
es_sustantivo(decision, singular, femenino).
es_sustantivo(cuaderno, singular, masculino).
es_sustantivo(cancion, singular, femenino).
es_sustantivo(canciones, plural, femenino).

%Preposiciones:
es_preposicion(en).

%Correspondencias verbo-preposicion
tiene_preposicion(dibujar, en).
tiene_preposicion(saltar, en).
tiene_preposicion(cantar, en).