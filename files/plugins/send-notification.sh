#!/bin/bash
#set -x

# 
# Script d'envoi de notification SMS via l'API Free Mobile
# https://github.com/C-Duv/freemobile-smsapi-client
# 
# Auteur: DUVERGIER Claude (http://claude.duvergier.fr)
# 
# Nécessite: sed, sh et wget
# 
# Possible usages:
#   send-notification.sh "All your base are belong to us"
#   echo "All your base are belong to us" | send-notification.sh
#   uptime | send-notification.sh


##
## Configuration système
##

# Caractère de fin de ligne (http://en.wikipedia.org/wiki/Percent-encoding#Character_data)
NEWLINE_CHAR="%0A" # Valeurs possibles : %0A, %0D et %0D%0A

# URL d'accès à l'API
SMSAPI_BASEURL="https://smsapi.free-mobile.fr"

# Action d'envoi de notification
SMSAPI_SEND_ACTION="sendmsg"

# Fichier listant les numéros de téléphone, login utilisateur free mobile et clé d'API
# Un enregistrement par ligne de la forme :
# numero_tel login    clé_api
# 0612345678 01928374 9zzlUR87j6HyzqK

API_KEYS_FILE=/etc/free_sms_apikeys

##
## Configuration utilisateur
## utilisé si aucun numéro de téléphone n'est passé en argument
##

# Login utilisateur / identifiant Free Mobile (celui utilisé pour accéder à l'Espace Abonné)
USER_LOGIN="CHANGEME"

# Clé d'identification (générée et fournie par Free Mobile via l'Espace Abonné, "Mes Options" : https://mobile.free.fr/moncompte/index.php?page=options)
API_KEY="CHANGEME"

if [ "$1" ]; then # Numéro de téléphonepassé en argument de la ligne de commande
    PHONE_NUM="$1"
    [ -r $API_KEYS_FILE ] ||exit -1
    PHONE_REC=$(grep $PHONE_NUM $API_KEYS_FILE)
    [ -z "$PHONE_REC" ] && exit -2
    USER_LOGIN=$(echo $PHONE_REC|cut -d' ' -f 2)
    API_KEY=$(echo $PHONE_REC|cut -d' ' -f 3)
fi

##
## Traitement du message
##

MESSAGE_TO_SEND=""
# Message lu de STDIN
while read line
do
    MESSAGE_TO_SEND="$MESSAGE_TO_SEND$line$NEWLINE_CHAR"
done
MESSAGE_TO_SEND=$(echo $MESSAGE_TO_SEND | sed 's/'$NEWLINE_CHAR'$//') # Retire le dernier saut de ligne


FINAL_MESSAGE_TO_SEND="$(echo -n $MESSAGE_TO_SEND | sed 's/\n/'$NEWLINE_CHAR'/g')"

##
## Appel à l'API (envoi)
##

# --insecure : Certificat de $SMSAPI_BASEURL ne fourni pas d'informations sur son propriétaire
# --write-out "%{http_code}" --silent --output /dev/null : Renvoi le code réponse HTTP uniquement
HTTP_STATUS_CODE=$(curl --insecure --get "$SMSAPI_BASEURL/$SMSAPI_SEND_ACTION" --data "user=$USER_LOGIN" --data "pass=$API_KEY" --data "msg=${FINAL_MESSAGE_TO_SEND}" --write-out "%{http_code}" --silent --output /dev/null)

# Codes réponse HTTP possibles
# 200 : Le SMS a été envoyé sur votre mobile.
# 400 : Un des paramètres obligatoires est manquant.
# 402 : Trop de SMS ont été envoyés en trop peu de temps.
# 403 : Le service n'est pas activé sur l'espace abonné, ou login / clé incorrect.
# 500 : Erreur côté serveur. Veuillez réessayez ultérieurement.

if [ "$HTTP_STATUS_CODE" -eq 200 ]; then
    exit 0
else
    logger  "nagios SMS notif error: API responded with $HTTP_STATUS_CODE"
    exit $HTTP_STATUS_CODE
fi
