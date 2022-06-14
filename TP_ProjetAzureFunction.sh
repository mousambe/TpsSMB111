#!/bin/bash
# Ce script shell permet de creer les ressources azure dont on a besoin pour la réalisation du TP.



############################ ---------- Creation du Ressource Groupe et compte de stockage pour le tp

# --- Liste des variables
locationName="France Central"					#Region de deploiement

ressourceGroupName="tpazure"						#Nom du groupe de Ressource

storageAccountName="comptestockagemoustapha"		#Compte de stockage

containerImageupload="tpconainer"					#Container des images uploadeds

containerImageHD="hdtpcontainer"					#Container des images apres amelioration resolution

# Creation groupe de Ressource
az group create --name $ressourceGroupName --location "$locationName"

# Creation Compte de stockage
az storage account create --resource-group $ressourceGroupName \
	--name $storageAccountName \
	--location $locationName \
	--sku Standard_LRS \
	--kind StorageV2


# Creation du Container (blob)  des images uploadeds
az storage container create -n "tpcontainer" \
	--public-access blob \
	--account-key "UlpeH1V9N1n+mx6aDC1AxOcVn/6X6jMogT6+HVhphegnjhGRMRgs7PSD0wiBlv78y5gwXsszZFhk+AStn/ojvA==" \
    --account-name "comptestockagemoustapha"

# Creation du Container (blob) des images apres amelioration resolution
az storage container create -n "tpcontainer" \
	--public-access blob \
	--account-key "UlpeH1V9N1n+mx6aDC1AxOcVn/6X6jMogT6+HVhphegnjhGRMRgs7PSD0wiBlv78y5gwXsszZFhk+AStn/ojvA==" \
    --account-name "comptestockagemoustapha"

#-------------------------------------------------------------------------------------------------------------

############ ---------- Creation des ressources pour l'Azure function HelloNewImgBlobTriger et son deploiement

# Creation du nouveau projet azure function
func init TpAzureFunctions --worker-runtime python

# Creation du template de  l'azure function
func new --name HelloNewImgBlobTriger --template   "Azure Blob Storage trigger"

# Creqtion de la chaine de connection au storage pour l'azure function 
func azure storage fetch-connection-string comptestockagemoustapha

# Creation de l'azure function au niveau d'azure cloud
az functionapp create  --resource-group tpazure  \
	-consumption-plan-location westeurope \
	--runtime python \
	--runtime-version 3.8 \
	--functions-version 4 \
	--name "TpAzureFunctions" \
	--os-type linux \
	--storage-account "comptestockagemoustapha"

# Deploiement de l'azure function dans azure
func azure functionapp publish TpAzureFunctions --publish-local-settings

#-------------------------------------------------------------------------------------------------------------



############ ---------- Creation des ressources pour l'azure web app tpazurewebapp et son deploiement

# Geneartion du jeton de signature d'acces partagée pour accdeder au compte de stockage 
az storage account generate-sas --expiry 2023-12-31T12:00Z \
    --permissions rwdlac \
    --resource-types sco \
    --services b \
    --https-only \
    --account-key "UlpeH1V9N1n+mx6aDC1AxOcVn/6X6jMogT6+HVhphegnjhGRMRgs7PSD0wiBlv78y5gwXsszZFhk+AStn/ojvA==" \
    --account-name "comptestockagemoustapha"

# Configuration du CORS
az storage cors add --methods DELETE GET HEAD MERGE OPTIONS POST PUT \
    --origins "*" \
    --allowed-headers "*" \
    --exposed-headers "*" \
    --services b \
    --max-age 86400 \
    --timeout 86400 \
    --account-key "UlpeH1V9N1n+mx6aDC1AxOcVn/6X6jMogT6+HVhphegnjhGRMRgs7PSD0wiBlv78y5gwXsszZFhk+AStn/ojvA==" \
    --account-name "comptestockagemoustapha" \
    --sas-token "se=2022-07-31&sp=wacu&spr=https&sv=2021-06-08&ss=tbqf&srt=cos&sig=uxRhkFaboheTQEg7qGujYH2prtOQMCeydFYBNnEV0I8%3D"

# Creation d'un container registry azure pour heberger nos containers
az acr create --resource-group tpazure --name tpazurecontainerregistry --sku Basic

# Creation d'un docker image dans l'azure registry tpazurecontainerregistry, à partir du dockerfile de l'application web TpAzureFuncFront  
az acr build --file Dockerfile --registry tpazurecontainerregistry --image tpazrimg .

# Creation d'un app serice plan pour le deploimentde notre web app 
az appservice plan create -g tpazure -n tpazureapplan --is-linux --sku B2

# Creation et deploiement de notre w de notre web app  tpazurewebapp
az webapp create -g tpazure -p tpazureapplan -n tpazurewebapp -i tpazurecontainerregistry.azurecr.io/tpazrimg:latest

# Changement du port d'ecoute de l'app service : par defaut il ecoute sur 80, notre container ecoute sur 3000.
az webapp config appsettings set --resource-group tpazure --name tpazurewebapp --settings WEBSITES_PORT=3000


