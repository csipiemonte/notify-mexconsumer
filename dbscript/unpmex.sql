CREATE TABLE unpmex.messages (
	id varchar(36) NOT NULL,
	bulk_id bpchar(36) NULL,
	user_id varchar(255) NOT NULL,
	email_to varchar(255) NULL,
	email_subject varchar(255) NULL,
	email_body text NULL,
	email_template_id varchar(255) NULL,
	sms_phone varchar(50) NULL,
	sms_content text NULL,
	push_token text NULL,
	push_title varchar(255) NULL,
	push_body text NULL,
	push_call_to_action varchar(255) NULL,
	mex_title varchar(255) NULL,
	mex_body text NULL,
	mex_call_to_action varchar(255) NULL,
	io text NULL,
	client_token text NULL,
	sender varchar(255) NULL,
	tag_csv varchar(255) NULL,
	correlation_id varchar(36) NULL,
	read_at timestamptz NULL,
	"timestamp" timestamptz NULL DEFAULT now(),
	memo text NULL,
	tag _text NULL,
	CONSTRAINT idx_7430785_primary PRIMARY KEY (id)
);
CREATE INDEX idx_7430785_ft_tag ON unpmex.messages USING gin (to_tsvector('simple'::regconfig, (tag_csv)::text));
CREATE INDEX idx_7430785_timestamp ON unpmex.messages USING btree ("timestamp");
CREATE INDEX messages_sender_id_idx ON unpmex.messages USING btree (sender, id);
CREATE INDEX messages_sender_idx ON unpmex.messages USING btree (sender);
CREATE INDEX messages_tag_array_idx_gin ON unpmex.messages USING gin (tag);
CREATE INDEX messages_timestamp_sender_idx ON unpmex.messages USING btree ("timestamp", sender);
CREATE INDEX messages_user_id_id_idx ON unpmex.messages USING btree (user_id, id);
CREATE INDEX messages_user_id_idx ON unpmex.messages USING btree (user_id);


CREATE TABLE unpmex.messages2 (
	id varchar(36) NOT NULL,
	bulk_id bpchar(36) NULL,
	user_id varchar(255) NOT NULL,
	email_to varchar(255) NULL,
	email_subject varchar(255) NULL,
	email_body text NULL,
	email_template_id varchar(255) NULL,
	sms_phone varchar(50) NULL,
	sms_content text NULL,
	push_token text NULL,
	push_title varchar(255) NULL,
	push_body text NULL,
	push_call_to_action varchar(255) NULL,
	mex_title varchar(255) NULL,
	mex_body text NULL,
	mex_call_to_action varchar(255) NULL,
	io text NULL,
	client_token text NULL,
	sender varchar(255) NULL,
	tag_csv varchar(255) NULL,
	correlation_id varchar(36) NULL,
	read_at timestamptz NULL,
	"timestamp" timestamptz NULL DEFAULT now(),
	memo text NULL,
	tag _text NULL
);
CREATE INDEX idx_8973128_idx_id ON unpmex.messages2 USING btree (id);
CREATE INDEX messages2_tag_array_idx_gin ON unpmex.messages2 USING gin (tag);


CREATE OR REPLACE FUNCTION unpmex.insert_messages2()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN
        insert into messages2 values (new.*);
        RETURN NEW;
    END;
$function$
;


CREATE OR REPLACE FUNCTION unpmex.update_messages2()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN
        delete from messages2 where id = NEW.id;
        INSERT INTO messages2 values(NEW.*);
        RETURN NEW;
    END;
$function$
;


create trigger bck_insert_messages after
insert
    on
    unpmex.messages for each row execute procedure insert_messages2();


create trigger bck_update_messages after
update
    on
    unpmex.messages for each row execute procedure update_messages2();
