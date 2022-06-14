# TpsSMB111

## _A l'attention du professeur Mr Weinbach_

N'ayant pas pu réaliser le Tp avec Cyclegan, j'ai utilisé la bibliotheque [dddddsr](https://github.com/zecloud/Azure-function-image-super-resolution) pour faire ce TP.

J'ai utilisé un deuxieme blob à la place de la base de donnée CosmosDb pour stocker des image traitées.

le script de création des ressources du Tp est [TP2_ProjetAzureFunction.sh](https://github.com/mousambe/TpsSMB111/blob/master/TP2_ProjetAzureFunction.sh)

le code de la partie frontend est [TpAzureFuncFront](https://github.com/mousambe/TpsSMB111/tree/master/TpAzureFuncFront)

le code de l'azure function est [TpAzureFuncBack](https://github.com/mousambe/TpsSMB111/tree/master/TpAzureFuncBack)

Le lien pour acceder au web app est [tpazurewebapp](https://tpazurewebapp.azurewebsites.net/)

Pour les tests merci d'utiliser ces [images](https://github.com/mousambe/TpsSMB111/tree/master/TpAzureFuncFront/images) car les images de grandes resolutions ne sont pas adaptées.

N'ayant pas pu utiliser la biding SignalR, j'ai mis un timer sur l'application front avant qu'elle n'aille chercher l'image dans container des images traitées.
De ce fait faut patienter une minutes avant de voir l'image traitée. Si au bout d'une minute vous ne la voyez pas merci de reactuliser et d'upload une autre image puis patienter.

J'ai aussi joint le [script de creation des ressources pour le  Tp1 sur Iaas](https://github.com/mousambe/TpsSMB111/blob/master/TP1_ProjetIAAS.sh)

**Merci de votre comprehensio**
