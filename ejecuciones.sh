#!/bin/bash

# Autor: Fernando Cuesta Bueno 2º A2
# Asignatura: Inteligencia Artificial

# Actualizaciones:
# 28/03/2023 - 10:15 -> todas las ejecuciones almacenadas en la misma carpeta
# 28/03/2023 - 13:05 -> las ejecuciones se realizan desde ./practica1 en vez de ./practica1/build. 
#			Antes de realizar las ejecuciones compila el proyecto de nuevo.
# 28/03/2023 - 15:03 -> (Ángel Sánchez) Añadida distinta funcionalidad dependiendo de si se utiliza
#			la carpeta build para compilar o no. Basta con cambiar la varible "carpetabuild" de 1 (true) 
#			a 0 (false) o viceversa. Siempre suponiendo que este script se situa en el directorio raiz del 
#			proyecto.
# 28/03/2023 - 15:37 -> (Ángel Sánchez) Se calcula el porcentaje medio de las ejecuciones en cada mapa.
#
# Script para ejecutar las diferentes pruebas utilizadas en el leaderboard.
# Los resultados obtenidos son los usados en el leaderboard para calcular la puntuación.
# Los resultados pueden verse en el archivo especificado en "fichero" (primera línea del script).
# El fichero de destino puede modificarse sin problema, simplemente cambiar el path de destino-

# Nota: si no aparece el porcentaje descubierto se trata de un 'Segmentation fault'.
# Espero que os ayude!!

carpetabuild=1 

dia=`date +"%d-%m-%Y"`
hora=`date +"%H:%M"`

fichero=ejecuciones
directorio=ejecuciones
path=$directorio/$fichero-$dia-$hora.txt

informacion=informacion.txt
intermedio=intermedio.txt
porcentajes=porcentajes.txt

#Para el calculo de las medias
sumaejecucion=0
porcentajeactual=0

rm -f $informacion $intermedio $porcentajes

mkdir -p $directorio

if [ $carpetabuild -eq 1 ];then
pathejecucion="./build/practica1SG"
cd build 
cmake ..
make
cd ..
elif [ $carpetabuild -eq 0 ];then
pathejecucion="./practica1SG"
cmake .
make
fi

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
				$pathejecucion ./mapas/mapa30.map 0 $level ${fila[$i]} ${columna[$i]} $orientation | tail -n1 >> $intermedio
				porcentajeactual=$(awk 'END {print $NF}' $intermedio)
				echo $porcentajeactual >> $porcentajes
				sumaejecucion=$(echo "$sumaejecucion+$porcentajeactual" | bc)
			fi
		done
	done
done

echo "Media mapa 30: " $(echo "scale = 2; $sumaejecucion/30" | bc)  >> $path
porcentajeactual=0
sumaejecucion=0

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
				$pathejecucion ./mapas/mapa50.map 0 $level ${fila[$i]} ${columna[$i]} $orientation | tail -n1 >> $intermedio
				porcentajeactual=$(awk 'END {print $NF}' $intermedio)
				echo $porcentajeactual >> $porcentajes
				sumaejecucion=$(echo "$sumaejecucion+$porcentajeactual" | bc)
			fi
		done
	done
done

echo "Media mapa 50: " $(echo "scale = 2; $sumaejecucion/21" | bc)  >> $path
porcentajeactual=0
sumaejecucion=0

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
				$pathejecucion ./mapas/mapa75.map 0 $level ${fila[$i]} ${columna[$i]} $orientation | tail -n1 >> $intermedio
				porcentajeactual=$(awk 'END {print $NF}' $intermedio)
				echo $porcentajeactual >> $porcentajes
				sumaejecucion=$(echo "$sumaejecucion+$porcentajeactual" | bc)
			fi
		done
	done
done

echo "Media mapa 75: " $(echo "scale = 2; $sumaejecucion/24" | bc)  >> $path

paste $informacion $porcentajes >> $path

echo -e "\nNOTA: los huecos vacios son 'Segmentation fault'" >> $path

rm -f $informacion $intermedio $porcentajes
