DROP TABLE IF EXISTS "user" CASCADE;
DROP TABLE IF EXISTS "group" CASCADE;
DROP TABLE IF EXISTS "directory" CASCADE;
DROP TABLE IF EXISTS "limit" CASCADE;

CREATE TABLE "group" (
  gid SERIAL PRIMARY KEY,
  groupname TEXT NOT NULL UNIQUE,
  enabled BOOLEAN NOT NULL DEFAULT true,
  update_num INTEGER NOT NULL DEFAULT 0,
  update_done INTEGER NOT NULL DEFAULT 0
);
SELECT setval('group_gid_seq', 2000);

CREATE TABLE "user" (
  login TEXT PRIMARY KEY,
  passwd TEXT,
  sftpuserkeys TEXT,
  uid SERIAL NOT NULL UNIQUE,
  gid INTEGER NOT NULL REFERENCES "group"(gid) ON UPDATE CASCADE ON DELETE CASCADE,
  enabled BOOLEAN NOT NULL DEFAULT true,
  email TEXT,
  CONSTRAINT one_credential CHECK (passwd IS NULL AND sftpuserkeys IS NOT NULL OR passwd IS NOT NULL AND sftpuserkeys IS NULL)
);
SELECT setval('user_uid_seq', 2000);

CREATE TABLE "directory" (
  gid INTEGER NOT NULL REFERENCES "group"(gid) ON UPDATE CASCADE ON DELETE CASCADE,
  directory TEXT NOT NULL,
  PRIMARY KEY (gid, directory),
  CONSTRAINT dirname CHECK (directory SIMILAR TO '[a-zA-Z0-9_-]+(/[a-zA-Z0-9_-]+)?')
);
CREATE OR REPLACE FUNCTION directory_subdir_check() RETURNS trigger AS $body$
DECLARE
  superdir TEXT;
BEGIN
  IF ( NEW.directory ~* '^[a-zA-Z0-9_-]+(/[a-zA-Z0-9_-]+)$' ) THEN
    PERFORM 1 FROM directory WHERE gid=NEW.gid AND NEW.directory SIMILAR TO directory||'/[a-zA-Z0-9_-]*';
    IF FOUND THEN
      RAISE EXCEPTION 'The directory % is not valid, when a superdir is defined', NEW.directory;
    END IF;
  ELSE
    PERFORM 1 FROM directory WHERE gid=NEW.gid AND directory SIMILAR TO NEW.directory||'/[a-zA-Z0-9_-]*';
    IF FOUND THEN
      RAISE EXCEPTION 'The directory % is not valid, since a subdir is defined', NEW.directory;
    END IF;
  END IF;
  RETURN NEW;
END;
$body$
LANGUAGE plpgsql;
CREATE TRIGGER check_subdir BEFORE INSERT OR UPDATE ON "directory" FOR EACH ROW EXECUTE PROCEDURE directory_subdir_check();

CREATE TABLE "limit" (
  login TEXT NOT NULL REFERENCES "user"(login) ON UPDATE CASCADE ON DELETE CASCADE,
  gid INTEGER NOT NULL,
  directory text NOT NULL,
  PRIMARY KEY (login, gid, directory),
  CONSTRAINT directory_fkey FOREIGN KEY (gid, directory) REFERENCES "directory"(gid, directory) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE OR REPLACE VIEW users AS
 SELECT login AS userid, passwd, sftpuserkeys, uid, "user".gid, '/home/' || groupname AS homedir, '/bin/sh' AS shell
 FROM "user", "group"
 WHERE "user".enabled AND "group".enabled AND "user".gid = "group".gid
UNION
 SELECT 'root' AS userid, NULL AS passwd, NULL AS sftpuserkeys, 0 AS uid, 0 AS gid, '/home/' AS homedir, '/bin/sh' AS shell;

CREATE OR REPLACE VIEW groups AS
 SELECT "group".gid, groupname, login AS members
 FROM "user", "group"
 WHERE "user".enabled AND "group".enabled AND "user".gid = "group".gid
UNION
 SELECT '0' AS gid, 'root' AS groupname, 'root' AS members;

GRANT SELECT ON TABLE users TO proftpd;
GRANT SELECT ON TABLE groups TO proftpd;

CREATE OR REPLACE RULE limit_insert AS ON INSERT to "limit" DO ALSO
UPDATE "group"
SET    update_num=update_num+1
FROM   "user"
WHERE  "group".gid = "user".gid AND
       "user".login = NEW.login;
CREATE OR REPLACE RULE limit_delete AS ON DELETE to "limit" DO ALSO
UPDATE "group"
SET    update_num=update_num+1
FROM   "user"
WHERE  "group".gid = "user".gid AND
       "user".login = OLD.login;
CREATE OR REPLACE RULE limit_update AS ON UPDATE to "limit" DO ALSO
UPDATE "group"
SET    update_num=update_num+1
FROM   "user"
WHERE  "group".gid = "user".gid AND
       "user".login IN (OLD.login, NEW.login);

CREATE OR REPLACE RULE directory_insert AS ON INSERT to "directory" DO ALSO
UPDATE "group"
SET    update_num=update_num+1
WHERE  "group".gid = NEW.gid;
CREATE OR REPLACE RULE directory_delete AS ON DELETE to "directory" DO ALSO
UPDATE "group"
SET    update_num=update_num+1
WHERE  "group".gid = OLD.gid;
CREATE OR REPLACE RULE directory_update AS ON UPDATE to "directory" DO ALSO
UPDATE "group"
SET    update_num=update_num+1
WHERE  "group".gid IN (OLD.gid, NEW.gid);

-- From: https://wiki.postgresql.org/wiki/Audit_trigger
create schema audit;
revoke create on schema audit from public;
create table audit.logged_actions (
    schema_name text not null,
    table_name text not null,
    user_name text,
    action_tstamp timestamp with time zone not null default current_timestamp,
    action CHAR(1) NOT NULL check (action in ('I','D','U')),
    original_data text,
    new_data text,
    query text
) with (fillfactor=100);
revoke all on audit.logged_actions from public;
grant select on audit.logged_actions to public;
create index logged_actions_schema_table_idx on audit.logged_actions(((schema_name||'.'||table_name)::TEXT));
create index logged_actions_action_tstamp_idx on audit.logged_actions(action_tstamp);
create index logged_actions_action_idx on audit.logged_actions(action);
CREATE OR REPLACE FUNCTION audit.if_modified_func() RETURNS trigger AS $body$
DECLARE
    v_old_data TEXT;
    v_new_data TEXT;
BEGIN
    /*  If this actually for real auditing (where you need to log EVERY action),
        then you would need to use something like dblink or plperl that could log outside the transaction,
        regardless of whether the transaction committed or rolled back.
    */
    /* This dance with casting the NEW and OLD values to a ROW is not necessary in pg 9.0+ */
    if (TG_OP = 'UPDATE') then
        v_old_data := ROW(OLD.*);
        v_new_data := ROW(NEW.*);
        insert into audit.logged_actions (schema_name,table_name,user_name,action,original_data,new_data,query) 
        values (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data,v_new_data, current_query());
        RETURN NEW;
    elsif (TG_OP = 'DELETE') then
        v_old_data := ROW(OLD.*);
        insert into audit.logged_actions (schema_name,table_name,user_name,action,original_data,query)
        values (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data, current_query());
        RETURN OLD;
    elsif (TG_OP = 'INSERT') then
        v_new_data := ROW(NEW.*);
        insert into audit.logged_actions (schema_name,table_name,user_name,action,new_data,query)
        values (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_new_data, current_query());
        RETURN NEW;
    else
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - Other action occurred: %, at %',TG_OP,now();
        RETURN NULL;
    end if;
EXCEPTION
    WHEN data_exception THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [DATA EXCEPTION] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN unique_violation THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [UNIQUE] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN others THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [OTHER] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
END;
$body$
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, audit;
CREATE TRIGGER group_audit     AFTER INSERT OR UPDATE OR DELETE ON "group"     FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func();
CREATE TRIGGER user_audit      AFTER INSERT OR UPDATE OR DELETE ON "user"      FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func();
CREATE TRIGGER directory_audit AFTER INSERT OR UPDATE OR DELETE ON "directory" FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func();
CREATE TRIGGER limit_audit     AFTER INSERT OR UPDATE OR DELETE ON "limit"     FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func();

GRANT select,update on "group" TO "sftp-cron";
GRANT SELECT ON "directory","limit","user" TO "sftp-cron";

GRANT select,update,insert,update,delete ON "group","directory","limit","user" TO neo;
GRANT SELECT,USAGE ON SEQUENCE group_gid_seq, user_uid_seq TO neo;

