drop table messages;
drop table tasks;
drop table document_attributes;
drop table documents;
drop table attributes;
drop table types;
drop table step_groups;
drop table step_roles;
drop table steps;
drop table flows;
drop table categories;
drop table project_user_roles;
drop table roles;
drop table project_user_groups;
drop table project_users;
drop table projects;
drop table group_permissions;
drop table permissions;
drop table groups;
drop table sessions;
drop table users;

create table users(
	id bigserial not null primary key,
	email varchar(255) not null unique,
	name varchar(255) not null,
	password varchar(255) not null,
	reset_password_at timestamp without time zone,
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp
);

create table sessions(
	id bigserial not null primary key,
	user_id bigint not null references users(id),
	ip varchar(255) not null,
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp
);

create table groups(
	id bigserial not null primary key,
	name varchar(255) not null unique,
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp
);

create table permissions(
	id bigserial not null primary key,
	name varchar(255) not null unique,
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp
);

create table group_permissions(
	id bigserial not null primary key,
	group_id bigint not null references groups(id),
	permission_id bigint not null references permissions(id),
	name varchar(255) not null unique,
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp
);

create table projects(
	id bigserial not null primary key,
	user_id bigint not null references users(id),
	name varchar(255) not null unique,
	description text,
	metadata json not null default '{}',
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp
);

create table project_users(
	id bigserial not null primary key,
	user_id bigint not null references users(id),
	project_id bigint not null references projects(id),
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp,
	unique(user_id, project_id, deleted_at)
);

create table project_user_groups(
	id bigserial not null primary key,
	project_user_id bigint not null references project_users(id),
	group_id bigint not null references groups(id),
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp,
	unique(project_user_id, group_id, deleted_at)
);

create table roles(
	id bigserial not null primary key,
	project_id bigint null references projects(id),
	name varchar(255) not null,
	description text,
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp,
	unique(project_id, name, deleted_at)
);

create table project_user_roles(
	id bigserial not null primary key,
	project_user_id bigint not null references project_users(id),
	role_id bigint not null references roles(id),
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp,
	unique(project_user_id, role_id, deleted_at)
);

create table categories(
	id bigserial not null primary key,
	project_id bigint null references projects(id),
	name varchar(255) not null,
	description text,
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp,
	unique(project_id, name, deleted_at)
);

create table flows(
	id bigserial not null primary key,
	project_id bigint not null references projects(id),
	name varchar(255) not null,
	description text,
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp,
	unique(project_id, name, deleted_at)
);

create table steps(
	id bigserial not null primary key,
	flow_id bigint not null references flows(id),
	step_id bigint null unique references steps(id),
	name varchar(255) not null,
	description text,
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp,
	unique(flow_id, name, deleted_at)
);

create table step_roles(
	id bigserial not null primary key,
	step_id bigint not null references steps(id),
	role_id bigint not null references roles(id),
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp,
	unique(step_id, role_id, deleted_at)
);

create table step_groups(
	id bigserial not null primary key,
	step_id bigint not null references steps(id),
	group_id bigint not null references groups(id),
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp,
	unique(step_id, group_id, deleted_at)
);

create table types(
	id bigserial not null primary key,
	project_id bigint not null references projects(id),
	name varchar(255) not null,
	description text,
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp,
	unique(project_id, name, deleted_at)
);

create table attributes(
	id bigserial not null primary key,
	type_id bigint not null references types(id),
	name varchar(255) not null,
	description text,
	metadata json not null default '{}',
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp,
	unique(type_id, name, deleted_at)
);

create table documents(
	id bigserial not null primary key,
	type_id bigint not null references types(id),
	category_id bigint not null references categories(id),
	name varchar(255) not null,
	metadata json not null default '{}',
	expires_at timestamp without time zone,
	finished_at timestamp without time zone,
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp
);

create table document_attributes(
	id bigserial not null primary key,
	document_id bigint not null references documents(id),
	attribute_id bigint not null references attributes(id),
	value varchar(255) not null,
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp,
	unique(document_id, attribute_id, deleted_at)
);

create table tasks(
	id bigserial not null primary key,
	document_id bigint not null references documents(id),
	step_id bigint not null references steps(id),
	user_id bigint not null references users(id),
	metadata json not null default '{}',
	expires_at timestamp without time zone,
	finished_at timestamp without time zone,
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp,
	unique(document_id, step_id, deleted_at)
);

create table messages(
	id bigserial not null primary key,
	document_id bigint not null references documents(id),
	user_id bigint not null references users(id),
	message text not null,
	metadata json not null default '{}',
	deleted_at timestamp without time zone,
	created_at timestamp without time zone not null default current_timestamp,
	updated_at timestamp without time zone not null default current_timestamp
);