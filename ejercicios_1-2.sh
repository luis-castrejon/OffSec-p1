#!/bin/bash

{

echo -e "||||||||||||||||||||||||||||||||||||||||||||||||||||  Ejercicio 1(a)  |||||||||||||||||||||||||||||||||||||||||||||||||\n"

# Extrae el hash para 'alex' y lo guarda en un archivo llamado alex.hash
grep '^alex:' ./shadow | cut -d':' -f2 > alex.hash

hashcat -m 1800 -a 3 alex.hash ?d?d?d?d?d?d
# Borra el archivo de hash después de usarlo
rm alex.hash

echo -e "\n||||||||||||||||||||||||||||||||||||||||||||||||||||  Ejercicio 1(b)  |||||||||||||||||||||||||||||||||||||||||||||||||\n"

# Los componentes de la contraseña
letra_mayuscula="J"  # Por Junio
letras_minusculas="unio"
numeros="2001"
caracteres_especiales='!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~¡¿ñÑáéíóúÁÉÍÓÚ'

nombre_archivo="diccionario.txt"

# Crea o vacía el archivo de salida si ya existe
> "$nombre_archivo"

# Genera combinaciones y guarda en el archivo
for i in $(seq 0 $((${#caracteres_especiales} - 1))); do
  especial=${caracteres_especiales:$i:1}
  printf "%s%s%s%s\n" "$letra_mayuscula" "$letras_minusculas" "$numeros" "$especial" >> "$nombre_archivo"
done

# Extrae el hash para 'andrea' y lo guarda en un archivo llamado andrea.hash
grep '^andrea:' ./shadow | cut -d':' -f2 > andrea.hash

hashcat -m 500 -a 0 andrea.hash "$nombre_archivo"

# Borra el archivo de diccionario después de usarlo
rm "$nombre_archivo"
# Borra el archivo de hash después de usarlo
rm andrea.hash 

echo -e "\n||||||||||||||||||||||||||||||||||||||||||||||||||||  Ejercicio 2  |||||||||||||||||||||||||||||||||||||||||||||||||\n"

# Descarga la lista de contraseñas más comunes
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/500-worst-passwords.txt

# Crea un archivo temporal con las contraseñas modificadas.
cat 500-worst-passwords.txt | sed 's/a/4/g; s/e/3/g; s/i/1/g; s/o/0/g;' > temp-passwords.txt
# Combina el archivo original y el archivo temporal, y guarda el resultado en otro archivo temporal.
cat 500-worst-passwords.txt temp-passwords.txt > combined-passwords.txt
# Sobrescribe el archivo original con el archivo combinado.
mv combined-passwords.txt 500-worst-passwords.txt
# Elimina el archivo temporal.
rm temp-passwords.txt

#hashcat -m 1000 -a 0 hashes.txt 500-worst-passwords.txt
echo -e "2F8457E7AA3E1173446F9CE7C3B0F156\n03D775A1D00B5C3449CA0DED893AB2FE" > temp_hashes.txt
hashcat -m 1000 -a 0 temp_hashes.txt 500-worst-passwords.txt
rm temp_hashes.txt

# Elimina el archivo de contraseñas después de usarlo
rm 500-worst-passwords.txt

} | tee resultado.txt 2>&1