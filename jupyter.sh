#!/bin/bash
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# Il faut au moins avoir d'installé :
# - Firefox ou Chromium ou google-chrome-stable
# - terminator
# - Anaconda ou Jupyter

# --------Exemple de fichier ".desktop"---------------
# [Desktop Entry]
# Version=x.y
# Name=jupyter
# Comment=Choisir l'environnement et le navigateur pour Jupyter Notebook 
# Exec=/usr/bin/jupyter.sh
# Icon=/usr/share/pixmaps/jupyter.png
# Terminal=false
# Type=Application
# Categories=Development;



# Vérifications de l'existence des outils 
app_jupyter=$(command -v jupyter)
app_firefox=$(command -v firefox)
app_chromium=$(command -v chromium)
app_chrome=$(command -v google-chrome-stable)

if [ ! $app_jupyter ]
  then
  zenity --error \
  --width=300 \
  --text="Veuillez installer Jupyter où Anaconda.
http://jupyter.org/install
https://www.anaconda.com/download/#linux

Exemple pour installer Jupyter :
-----------Python 3------------------
python3 -m pip install --upgrade pip
python3 -m pip install jupyter
-----------Python 2------------------
python -m pip install --upgrade pip
python -m pip install jupyter"
   exit
fi

nb_navig=0

if [ $app_firefox ]
  then
  nb_navig=1
fi

if [ $app_chromium ]
  then
  nb_navig=$(echo "$nb_navig + 2" | bc -l )
fi

if [ $app_chrome ]
  then
  nb_navig=$(echo "$nb_navig + 4" | bc -l )
fi

# ----------------Affichage d'un message--------------------------
if [ $nb_navig = 0 ]
  then
  zenity --error \
  --width=300 \
  --text="Veuillez installer un de ces 3 navigateurs :
Firefox
Google-chrome-stable
Chromium"
   exit
fi

# ----------------Lecture des titres et répertoires dans dir_jupyter.txt --------------------------
# Formater le fichier "dir_jupyter.txt" sans espace et avec un retour chario aprés la dernière ligne
# ex : 
# Projets_3
# /home/user/travail/projets/3
# 

n=0
while read line
do
dir_Jupyter[$n]=$(echo $line | tr " " "_")
n=$((n=$n + 1))
done < /usr/share/jupyter/dir_jupyter.txt

# ----------------Affichage dans une boite de dialogue-------------------------
choix=$(zenity --list \
  --width=700 \
  --height=250 \
  --print-column=2 \
  --title="Choisissez le projet (lecture du fichier /usr/share/jupyter/dir_jupyter.txt)" \
  --column="Titre du projet" --column="Chemin du projet" \
${dir_Jupyter[@]})
# ----------------remplacer tilde par le chemin de l'utilisateur---------------
test_choix="$(echo "$choix" | cut -d'/' -f1)"
if test $test_choix = "~" ; then
  choix=$HOME$(echo $choix | tr -d "~")
fi

# ----------------Vérfication de l'existence du répertoire---------------------
if [ -e $choix ]; then
	echo $choix
else 
	zenity --error \
  --width=400 \
  --text="Veuillez créer le répertoire :
$choix

ou modifier le fichier :
/usr/share/jupyter/dir_jupyter.txt"
  exit
fi
if test $? = 1; then
  exit
fi

if test -z $choix; then
  exit
fi

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# Remarque :
# le code ci-dessous ne supporte pas qu'il y ai un ou plusieurs espace dans le texte des choix 
if [ $nb_navig = 1 ]; then
	chx_navig=`zenity --list \
  --title="Choix du navigateur (Il y a que Firefox de détecté)" \
  --column="Navigateur" \
	"firefox" \
	"Autres"`

elif [ $nb_navig = 2 ]; then
	chx_navig=`zenity --list \
  --title="Choix du navigateur (Il y a que Chromium de détecté)" \
  --column="Navigateur" \
	"chromium" \
	"Autres"`

elif [ $nb_navig = 3 ]; then
	chx_navig=`zenity --list \
  --title="Choix du navigateur" \
  --column="Navigateur" \
	"firefox" \
	"chromium" \
	"Autres"`


elif [ $nb_navig = 4 ]; then
	chx_navig=`zenity --list \
  --title="Choix du navigateur (Il y a que Chrome de détecté)" \
  --column="Navigateur" \
	"google-chrome-stable" \
	"Autres"`

elif [ $nb_navig = 5 ]; then
	chx_navig=`zenity --list \
  --title="Choix du navigateur" \
  --column="Navigateur" \
	"firefox" \
	"google-chrome-stable" \
	"Autres"`

elif [ $nb_navig = 6 ]; then
	chx_navig=`zenity --list \
  --title="Choix du navigateur" \
  --column="Navigateur" \
	"firefox" \
	"chromium" \
	"google-chrome-stable" \
	"Autres"`

fi

if test $? = 1; then
  exit
fi

if test -z $chx_navig; then
  exit
fi
		terminator -x jupyter notebook  --browser=$chx_navig $choix

