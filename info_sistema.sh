#!/bin/bash

ARCHIVO_SALIDA="informacion_sistema.txt"

# Limpiar el archivo de salida al inicio
> $ARCHIVO_SALIDA

# Nombres de usuario
echo "Nombres de usuario:" >> $ARCHIVO_SALIDA
cut -d: -f1 /etc/passwd >> $ARCHIVO_SALIDA
echo "" >> $ARCHIVO_SALIDA

# Historial de comandos en bash de los usuarios (opcional)
echo "Historial de comandos en bash de los usuarios (opcional):" >> $ARCHIVO_SALIDA
for home in /home/*; do
  usuario=$(basename $home)
  historial="$home/.bash_history"
  if [ -f "$historial" ]; then
    echo "Historial de $usuario:" >> $ARCHIVO_SALIDA
    cat $historial >> $ARCHIVO_SALIDA
  else
    echo "No se encontró historial para $usuario" >> $ARCHIVO_SALIDA
  fi
  echo "" >> $ARCHIVO_SALIDA
done

# Procesos en ejecución
echo "Procesos en ejecución:" >> $ARCHIVO_SALIDA
ps aux >> $ARCHIVO_SALIDA
echo "" >> $ARCHIVO_SALIDA

# Interfaces de red
echo "Interfaces de red:" >> $ARCHIVO_SALIDA
ip addr >> $ARCHIVO_SALIDA
echo "" >> $ARCHIVO_SALIDA

# Conexiones de red
echo "Conexiones de red:" >> $ARCHIVO_SALIDA
ss -tulwn >> $ARCHIVO_SALIDA
echo "" >> $ARCHIVO_SALIDA

# Archivos asociados a los procesos
echo "Archivos asociados a los procesos:" >> $ARCHIVO_SALIDA
lsof >> $ARCHIVO_SALIDA
echo "" >> $ARCHIVO_SALIDA

# Archivos de configuración importantes en el sistema
echo "Archivos de configuración importantes en el sistema y su contenido:" >> $ARCHIVO_SALIDA
for archivo in /etc/passwd /etc/group /etc/hosts /etc/nsswitch.conf /etc/fstab /etc/sysctl.conf /etc/sudoers /etc/sudoers.d /etc/crontab /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.monthly /etc/cron.weekly /etc/resolv.conf /etc/rsyslog.conf /etc/security/limits.conf /etc/security/limits.d /etc/netplan /etc/hostname; do
  if [ -f $archivo ]; then
    echo "Contenido de $archivo:" >> $ARCHIVO_SALIDA
    cat $archivo >> $ARCHIVO_SALIDA
    echo "" >> $ARCHIVO_SALIDA
  elif [ -d $archivo ]; then
    echo "Contenidos del directorio $archivo:" >> $ARCHIVO_SALIDA
    ls $archivo >> $ARCHIVO_SALIDA
    echo "" >> $ARCHIVO_SALIDA
  else
    echo "El archivo o directorio $archivo no existe o no es accesible." >> $ARCHIVO_SALIDA
    echo "" >> $ARCHIVO_SALIDA
  fi
done