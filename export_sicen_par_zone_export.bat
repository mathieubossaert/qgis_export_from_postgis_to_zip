SET repertoire="G:\SICEN\EXPORTS"
MKDIR %repertoire%\%1\sicen_%3

pgsql2shp -f %repertoire%\%1\sicen_%3\sicen_point_espece.shp -h 192.168.1.231 -u dba -g geometrie sicen "SELECT export.tous_point_espece_selon_format_esri.* FROM export.tous_point_espece_selon_format_esri, export.zone_export_donnee ON st_dwithin(export.tous_point_espece_selon_format_esri.geometrie, export.zone_export_donnee.geometrie,200) WHERE nom_latin<>'Aucune observation' AND (diffusable IS TRUE OR diffusable IS NULL) AND id_zone='%2';"
rem adaptez et dupliquez la ligne précédente pour les différentes couches à interroger
psql -c "INSERT INTO md.structure_a_recu_ese(id_structure, id_entite, date_envoi) SELECT '%1', export.tous_point_espece_selon_format_esri.id_entite, '%3' FROM export.tous_point_espece_selon_format_esri JOIN export.zone_export_donnee ON st_intersects(export.tous_point_espece_selon_format_esri.geometrie, export.zone_export_donnee.geometrie) WHERE nom_latin<>'Aucune observation' AND (diffusable IS TRUE OR diffusable IS NULL) AND id_zone='%2'" -h 192.168.1.231 -U dba sicen
rem adaptez et dupliquez la ligne précédente pour les différentes couches à interroger

DIR %repertoire%\%1\sicen_%3

explorer %repertoire%\%1\sicen_%3
