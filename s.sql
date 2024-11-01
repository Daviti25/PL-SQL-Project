create table Persons (
id number(11)
CONSTRAINT prsn_prsn_id_pk PRIMARY KEY
CONSTRAINT prsn_prsn_id_nn NOT NULL,
first_name varchar2(25)
CONSTRAINT prsn_prsn_fn_nn NOT NULL,
last_name varchar2(25)
CONSTRAINT prsn_prsn_ln_nn NOT NULL,
password varchar2(25)
CONSTRAINT prsn_prsn_psw_nn NOT NULL,
birth_date date
CONSTRAINT prsn_prsn_bd_nn NOT NULL,
registration_date date
CONSTRAINT prsn_prsn_rd_nn NOT NULL
);



create table Documents (
doc_id number(8)
CONSTRAINT doc_doc_id_pk PRIMARY KEY
CONSTRAINT doc_doc_id_nn NOT NULL,
about_document varchar2(200)
CONSTRAINT doc_ab_doc_nn NOT NULL,
doc_registration_date date
CONSTRAINT doc_rg_date_nn NOT NULL,
person_id number(11)
CONSTRAINT doc_author_id_nn NOT NULL,
CONSTRAINT doc_person_id_fk foreign key (person_id) 
           references 
           persons(person_id)
);

create table Movements(
doc_id number(11)
constraint mov_doc_id_pk primary key
constraint mov_doc_id_nn not null,
send_date date
constraint mov_send_date_nn not null,
sender_person number(11)
constraint mov_sender_person_nn not null,
reciever_person number(11)
constraint mov_reciever_person_nn not null,
comments varchar(200),
constraint mov_doc_id_fk foreign key (doc_id)
           references 
           documents(doc_id)
);






create or replace view DocumentsByPerson 
as select d.doc_id, d.about_document, d.doc_registration_date,
p.person_id, p.first_name, p.last_name, p.password, p.birth_date,
p.registration_date
from documents d left join persons p
on (d.person_id = p.person_id);





create or replace view DocumentsbyMovements
as select d.doc_id, d.about_document, d.doc_registration_date, d.person_id,
          m.send_date, m.sender_person, m.reciever_person, m.comments
from documents d left join movements m
on (d.doc_id = m.doc_id);





create or replace procedure AddPerson(
 person_id                 persons.person_id%type,
 person_first_name         persons.first_name%type,
 person_last_name          persons.last_name%type,
 person_password           persons.password%type,
 person_birth_date         persons.birth_date%type,
 person_registration_date  persons.registration_date%type
 )
as
begin
 insert into persons(person_id, first_name, last_name, password, birth_date, registration_date)
  values(person_id, person_first_name, person_last_name, person_password, person_birth_date, person_registration_date);
  commit;
  dbms_output.put_line('insert succesful');
 exception
  when others 
   then dbms_output.put_line('error');
end;



create or replace procedure GetPerson(
persons_id persons.person_id%type
)
is
person_count NUMBER;
r_person persons%ROWTYPE;
begin
 select count(*) into person_count from persons where person_id = persons_id;
if person_count > 0 then
 select * into r_person
  from persons
  where person_id = persons_id;
  dbms_output.put_line(r_person.person_id || ', ' || r_person.first_name ||
                       ', ' || r_person.last_name || ', ' || r_person.password || ', ' || r_person.birth_date ||
                       ', ' || r_person.registration_date);
else
 dbms_output.put_line('no person with that id');
end if;
exception
 when others
  then dbms_output.put_line('error occured');
end;







create or replace procedure EditPerson(
persons_id persons.person_id%type,
new_password persons.password%type
)
as
person_count NUMBER;
begin
 select count(*) into person_count from persons where person_id = persons_id;
if
person_count > 0 then 
 update persons
  set password = new_password
  where person_id = persons_id;
  commit;
  dbms_output.put_line('Changed Succesfuly');
else
 dbms_output.put_line('no person with that id');
end if;
exception
 when others
  then dbms_output.put_line('error occured');
end;






create or replace procedure DeletePerson(
persons_id persons.person_id%type
)
as
person_count NUMBER;
begin
 select count(*) into person_count from persons where person_id = persons_id;
if person_count > 0 then
 delete from persons where person_id = persons_id;
 commit;
 dbms_output.put_line('delete succesful');
else
 dbms_output.put_line('no person with that id');
end if;
exception
 when others 
  then dbms_output.put_line('error occured');
end; 


create or replace procedure AddDocument(
 doc_id                   documents.doc_id%type,
 about_document           documents.about_document%type,
 doc_registration_date    documents.doc_registration_date%type,
 person_id                documents.person_id%type
 )
as
begin
 insert into documents
  values(doc_id, about_document, doc_registration_date, person_id);
  commit;
  dbms_output.put_line('insert succesful');
exception
 when others 
  then dbms_output.put_line('error');
end;

create or replace procedure GetDocument(
document_id documents.doc_id%type
)
is
 r_document documents%ROWTYPE;
 doc_count NUMBER;
begin
 select count (*) into doc_count from documents where doc_id = document_id;
if doc_count > 0 then
 select * into r_document
 from documents
 where doc_id = document_id;
 dbms_output.put_line(r_document.doc_id || ', ' || r_document.about_document ||
                       ', ' || r_document.doc_registration_date || ', ' || r_document.person_id);
else
 dbms_output.put_line('no document with that id');
end if;
exception
 when others
  then dbms_output.put_line('error occured');
end; 



create or replace procedure EditDocument(
document_id documents.doc_id%type,
about_doc documents.about_document%type
)
as
 doc_count NUMBER;
begin
 select count(*) into doc_count from documents where doc_id = document_id;
 if doc_count > 0 then
  update documents
   set about_document = about_doc
   where doc_id = document_id;
   commit;
   dbms_output.put_line('Changed Sucessfully');
 else
  dbms_output.put_line('No document with that id');
 end if;

exception
 when others
  then dbms_output.put_line('error occured');
end;



CREATE OR REPLACE PROCEDURE DeleteDocument (
    document_id documents.doc_id%TYPE
)
AS
    doc_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO doc_count FROM documents WHERE doc_id = document_id;

    IF doc_count > 0 THEN
        DELETE FROM documents WHERE doc_id = document_id;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Delete successful');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No document with that ID');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred');
END;
