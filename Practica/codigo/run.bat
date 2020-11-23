#Cargar el archivo con clips -f run.bat
#Cambiar los nombres por los de vuestros archivos
#Podéis incluir todos los comandos clips que queráis ejecutar
# 'focus' debería mostrar solo los prints, que son volcados a salida.txt con 'dribble-on'

(load ontologia.clp)
(load reglas.clp)
(load prueba-1.clp)
(set-strategy random)
(watch focus) 
(reset)
(dribble-on salida.txt)
(run)
(dribble-off)
