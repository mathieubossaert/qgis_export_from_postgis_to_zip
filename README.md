# qgis_export_from_postgis_to_zip

L'export de données est une chose récurente.
Ce dépot contient de quoi automatiser ces exports depuis QGis, et en garder la trace.

Il nécessite :
  * la création d'une table spatiale qui stocke les périmètres d'export, qui sera éditée dans QGis.
  * la création d'une table qui stocke quelles données ont été envoyées à qui et quand
  * le fichier de commande qui génère l'export (un .bat dans notre cas)
  * l'action python qui se déclenche sur les objets de la table perimetre_export
