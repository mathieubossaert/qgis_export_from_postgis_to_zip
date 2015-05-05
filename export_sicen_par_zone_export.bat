SET taxons=%4
ECHO nom fichier : %taxons%

rem adapter le chemin à votre arborescence
MKDIR "G:\SICEN\EXPORTS"\%1\sicen_%3
G:
CD "G:\SICEN\EXPORTS"\%1\sicen_%3
pgsql2shp -f sicen_point_espece.shp -h 192.168.1.231 -u username -g geometrie sicen "SELECT export.tous_point_espece_selon_format_esri.* FROM export.tous_point_espece_selon_format_esri, export.zone_export_donnee WHERE nom_latin<>'Aucune observation' AND nom_latin ILIKE ANY(outils.generalise_element(COALESCE(CASE WHEN '%taxons%' = '' THEN null ELSE '%taxons%' END,' '))) AND st_dwithin(export.tous_point_espece_selon_format_esri.geometrie, export.zone_export_donnee.geometrie,200) AND (diffusable IS TRUE OR diffusable IS NULL) AND id_zone='%2';"
pgsql2shp -f sicen_ligne_espece.shp -h 192.168.1.231 -u username -g geometrie sicen "SELECT export.tous_ligne_espece_selon_format_esri.*, taxref.classe, taxref.ordre, taxref.famille FROM export.tous_ligne_espece_selon_format_esri JOIN inpn.taxref ON export.tous_ligne_espece_selon_format_esri.cd_ref=cd_nom, export.zone_export_donnee WHERE nom_latin<>'Aucune observation' AND nom_latin ILIKE ANY(outils.generalise_element(COALESCE(CASE WHEN '%taxons%' = '' THEN null ELSE '%taxons%' END,' '))) AND st_intersects(export.tous_ligne_espece_selon_format_esri.geometrie, export.zone_export_donnee.geometrie) AND (diffusable IS TRUE OR diffusable IS NULL) AND id_zone='%2';"
pgsql2shp -f sicen_perimetre_espece.shp -h 192.168.1.231 -u username -g geometrie sicen "SELECT export.tous_perimetre_espece_selon_format_esri.*, taxref.classe, taxref.ordre, taxref.famille FROM export.tous_perimetre_espece_selon_format_esri JOIN inpn.taxref ON export.tous_perimetre_espece_selon_format_esri.cd_ref=cd_nom, export.zone_export_donnee WHERE nom_latin<>'Aucune observation' AND nom_latin ILIKE ANY(outils.generalise_element(COALESCE(CASE WHEN '%taxons%' = '' THEN null ELSE '%taxons%' END,' '))) AND st_intersects(export.tous_perimetre_espece_selon_format_esri.geometrie, export.zone_export_donnee.geometrie) AND (diffusable IS TRUE OR diffusable IS NULL) AND id_zone='%2';"
pgsql2shp -f sicen_point_habitat.shp -h 192.168.1.231 -u username -g geometrie sicen "SELECT export.tous_point_habitat_selon_format_esri.* FROM export.tous_point_habitat_selon_format_esri, export.zone_export_donnee WHERE  st_intersects(export.tous_point_habitat_selon_format_esri.geometrie, export.zone_export_donnee.geometrie) AND (diffusable IS TRUE OR diffusable IS NULL) AND id_zone='%2';"
pgsql2shp -f sicen_perimetre_habitat.shp -h 192.168.1.231 -u username -g geometrie sicen "SELECT export.tous_perimetre_habitat_selon_format_esri.* FROM export.tous_perimetre_habitat_selon_format_esri, export.zone_export_donnee WHERE st_intersects(export.tous_perimetre_habitat_selon_format_esri.geometrie, export.zone_export_donnee.geometrie) AND (diffusable IS TRUE OR diffusable IS NULL) AND id_zone='%2';"
psql -c "INSERT INTO md.structure_a_recu_ese(id_structure, id_entite, date_envoi) SELECT '%1', export.tous_point_espece_selon_format_esri.id_entite, '%3' FROM export.tous_point_espece_selon_format_esri, export.zone_export_donnee WHERE nom_latin<>'Aucune observation' AND nom_latin ILIKE ANY(outils.generalise_element(COALESCE(CASE WHEN '%taxons%' = '' THEN null ELSE '%taxons%' END,' '))) AND st_intersects(export.tous_point_espece_selon_format_esri.geometrie, export.zone_export_donnee.geometrie) AND (diffusable IS TRUE OR diffusable IS NULL) AND id_zone='%2'" -h 192.168.1.231 -U username sicen
psql -c "INSERT INTO md.structure_a_recu_ese(id_structure, id_entite, date_envoi) SELECT '%1', export.tous_ligne_espece_selon_format_esri.id_entite, '%3' FROM export.tous_ligne_espece_selon_format_esri, export.zone_export_donnee WHERE nom_latin<>'Aucune observation' AND nom_latin ILIKE ANY(outils.generalise_element(COALESCE(CASE WHEN '%taxons%' = '' THEN null ELSE '%taxons%' END,' '))) AND st_intersects(export.tous_ligne_espece_selon_format_esri.geometrie, export.zone_export_donnee.geometrie) AND (diffusable IS TRUE OR diffusable IS NULL) AND id_zone='%2'" -h 192.168.1.231 -U username sicen
psql -c "INSERT INTO md.structure_a_recu_ese(id_structure, id_entite, date_envoi) SELECT '%1', export.tous_perimetre_espece_selon_format_esri.id_entite, '%3' FROM export.tous_perimetre_espece_selon_format_esri, export.zone_export_donnee WHERE nom_latin<>'Aucune observation' AND nom_latin ILIKE ANY(outils.generalise_element(COALESCE(CASE WHEN '%taxons%' = '' THEN null ELSE '%taxons%' END,' '))) AND st_intersects(export.tous_perimetre_espece_selon_format_esri.geometrie, export.zone_export_donnee.geometrie) AND (diffusable IS TRUE OR diffusable IS NULL) AND id_zone='%2'" -h 192.168.1.231 -U username sicen
psql -c "INSERT INTO md.structure_a_recu_ese(id_structure, id_entite, date_envoi) SELECT '%1', export.tous_point_habitat_selon_format_esri.id_entite, '%3' FROM export.tous_point_habitat_selon_format_esri, export.zone_export_donnee WHERE st_intersects(export.tous_point_habitat_selon_format_esri.geometrie, export.zone_export_donnee.geometrie) AND (diffusable IS TRUE OR diffusable IS NULL) AND id_zone='%2'" -h 192.168.1.231 -U username sicen
psql -c "INSERT INTO md.structure_a_recu_ese(id_structure, id_entite, date_envoi) SELECT '%1', export.tous_perimetre_habitat_selon_format_esri.id_entite, '%3' FROM export.tous_perimetre_habitat_selon_format_esri, export.zone_export_donnee WHERE st_intersects(export.tous_perimetre_habitat_selon_format_esri.geometrie, export.zone_export_donnee.geometrie) AND (diffusable IS TRUE OR diffusable IS NULL) AND id_zone='%2'" -h 192.168.1.231 -U username sicen

DIR "G:\SICEN\EXPORTS"\%1\sicen_%3
explorer "G:\SICEN\EXPORTS"\%1\sicen_%3