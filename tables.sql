CREATE SCHEMA /*IF NOT EXISTS*/ export;

CREATE TABLE export.zone_export_donnee
(
  id_zone serial NOT NULL PRIMARY KEY,
  motif text,
  id_structure integer NOT NULL,
  date date NOT NULL DEFAULT ('now'::text)::date,
  taxons text,
  geometrie geometry(MULTIPOLYGON, 2154)
);
ALTER TABLE export.zone_export_donnee
  ADD CONSTRAINT fk_zone_export_id_structure_est_md_structure FOREIGN KEY (id_structure) REFERENCES md.structure (id_structure) ON UPDATE NO ACTION ON DELETE NO ACTION;


CREATE TABLE export.structure_a_recu_observation
(
  id serial NOT NULL PRIMARY KEY,
  id_structure integer NOT NULL,
  id_obs integer NOT NULL,
  date_envoi date NOT NULL
);
ALTER TABLE export.structure_a_recu_observation
  ADD CONSTRAINT fk_structure_recoit_id_structure_est_md_structure FOREIGN KEY (id_structure) REFERENCES md.structure (id_structure) ON UPDATE NO ACTION ON DELETE NO ACTION;
