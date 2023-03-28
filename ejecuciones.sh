#!/bin/bash

# Autor: Fernando Cuesta Bueno 2º A2
# Asignatura: Inteligencia Artificial

# Script para ejecutar las diferentes pruebas utilizadas en el leaderboard.
# Los resultados obtenidos son los usados en el leaderboard para calcular la puntuación.
# Los resultados pueden verse en el archivo especificado en "fichero" (primera línea del script).
# El fichero de destino puede modificarse sin problema, simplemente cambiar el path de destino-

# Nota: si no aparece el porcentaje descubierto se trata de un 'Segmentation fault'.
# Espero que os ayude!!

dia=`date +"%d-%m-%Y"`
hora=`date +"%H:%M"`

fichero=ejecuciones
directorio=ejecuciones
path=$directorio/$fichero-$dia-$hora.txt

informacion=informacion.txt
intermedio=intermedio.txt
porcentajes=porcentajes.txt


rm -f $informacion $intermedio $porcentajes

mkdir -p $directorio

# ejecuciones mapa30

for level in 0 1 2 3;
do
	for orientation in 0 1 3;
	do
		for i in {0..4..1}
		do
			fila=(03 25 22 08 07)
			columna=(03 11 11 14 26)
			
			if [[ $level -eq 0 ]] || [[ $orientation -eq 0 ]]
			then
				echo -e "Mapa30 | Semilla: 0 | Nivel: $level | Coordenadas: (${fila[$i]}, ${columna[$i]}) | Orientación: $orientation | Porcentaje: " >> $informacion
				./build/practica1SG ./mapas/mapa30.map 0 $level ${fila[$i]} ${columna[$i]} $orientation | tail -n1 >> $intermedio
				awk 'END {print $NF}' $intermedio >> $porcentajes
			fi
		done
	done
done


# ejecuciones mapa50

for level in 0 1 2 3;
do
	for orientation in 0 2 4 5;
	do
		for i in {0..2..1}
		do
			fila=(42 07 09)
			columna=(19 09 42)
			
			if [[ $level -eq 0 ]] || [[ $orientation -eq 0 ]]
			then
				echo -e "Mapa50 | Semilla: 0 | Nivel: $level | Coordenadas: (${fila[$i]}, ${columna[$i]}) | Orientación: $orientation | Porcentaje: " >> $informacion
				./build/practica1SG ./mapas/mapa50.map 0 $level ${fila[$i]} ${columna[$i]} $orientation | tail -n1 >> $intermedio
				awk 'END {print $NF}' $intermedio >> $porcentajes
			fi
		done
	done
done

# ejecuciones mapa75

for level in 0 1 2 3;
do
	for orientation in 0 1 3;
	do
		for i in {0..3..1}
		do
			fila=(63 23 34 34)
			columna=(29 29 60 21)
			
			if [[ $level -eq 0 ]] || [[ $orientation -eq 0 ]]
			then
				echo -e "Mapa75 | Semilla: 0 | Nivel: $level | Coordenadas: (${fila[$i]}, ${columna[$i]}) | Orientación: $orientation | Porcentaje: " >> $informacion
				./build/practica1SG ./mapas/mapa75.map 0 $level ${fila[$i]} ${columna[$i]} $orientation | tail -n1 >> $intermedio
				awk 'END {print $NF}' $intermedio >> $porcentajes
			fi
		done
	done
done

paste $informacion $porcentajes >> $path

echo -e "\nNOTA: los huecos vacios son 'Segmentation fault'" >> $path

rm -f $informacion $intermedio $porcentajes
