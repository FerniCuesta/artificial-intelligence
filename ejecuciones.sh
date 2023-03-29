#!/bin/bash

# Autor: Fernando Cuesta Bueno 2º A2
# Asignatura: Inteligencia Artificial

# Actualizaciones:
# 28/03/2023 - 10:15 -> Todos los ficheros de ejecuciones se almacenan en la misma carpeta
# 28/03/2023 - 13:05 -> Las ejecuciones se realizan desde ./practica1 en vez de ./practica1/build. 
#			Antes de realizar las ejecuciones compila el proyecto de nuevo.
# 28/03/2023 - 15:03 -> (Ángel Sánchez) Añadida distinta funcionalidad dependiendo de si se utiliza
#			la carpeta build para compilar o no. Basta con cambiar la varible "carpetabuild" de 1 (true) 
#			a 0 (false) o viceversa. Siempre suponiendo que este script se situa en el directorio raiz del 
#			proyecto.
# 28/03/2023 - 15:37 -> (Ángel Sánchez) Se calcula el porcentaje medio de las ejecuciones en cada mapa.
#			(suponemos que siempre el mapa 30 se lanza 30 veces, el 50 21 veces y el 75 24 veces)
# 28/03/2023 - 19:37 -> (Ángel Sánchez) Ahora también se calcula la media en total, de todas las ejecuciones
#			en todos los mapas
# 29/03/2023 - 18:20 -> Los cálculos se realizan con variables en vez de con números fijos.
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

# para el calculo de las medias
mediam30=0
mediam50=0
mediam75=0
sumaejecucion=0
numejecuciones=0
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
				numejecuciones=$(echo "$numejecuciones+1" | bc)
			fi
		done
	done
done

mediam30=$(echo "scale = 2; $sumaejecucion/$numejecuciones" | bc)

echo "Media mapa 30: " $mediam30  >> $path

porcentajeactual=0
sumaejecucion=0
numejecuciones=0

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
				numejecuciones=$(echo "$numejecuciones+1" | bc)
			fi
		done
	done
done

mediam50=$(echo "scale = 2; $sumaejecucion/$numejecuciones" | bc)
echo "Media mapa 50: " $mediam50  >> $path
porcentajeactual=0
sumaejecucion=0
numejecuciones=0

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
				numejecuciones=$(echo "$numejecuciones+1" | bc)
			fi
		done
	done
done

mediam75=$(echo "scale = 2; $sumaejecucion/$numejecuciones" | bc)
echo "Media mapa 75: " $mediam75  >> $path

mediatresmapas=$(echo "$mediam30+$mediam50+$mediam75" | bc)
echo "Media de los tres mapas: " $(echo "scale = 2; $mediatresmapas/3" | bc)  >> $path

paste $informacion $porcentajes >> $path

echo -e "\nNOTA: los huecos vacios son 'Segmentation fault'" >> $path

rm -f $informacion $intermedio $porcentajes
