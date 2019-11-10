CREATE TABLE "APEXDEVELOPERS"."USUARIOS" 
   (	"ID" NUMBER NOT NULL ENABLE, 
	"USUARIO" VARCHAR2(255 BYTE), 
	"NOMBRE" VARCHAR2(255 BYTE), 
	"EMAIL" VARCHAR2(255 BYTE), 
	"DIRECCION" VARCHAR2(255 BYTE), 
	 CONSTRAINT "USUARIOS_PK" PRIMARY KEY ("ID")
   )
/
--AJAX CALLBACK
declare
	l_request	SYS.utl_http.req;
	l_response	SYS.utl_http.resp;
	l_download	RAW(32767);
    l_url_o varchar2(4000) := 'http://localhost:3002/user/';
    l_url varchar2(200);
    l_plain varchar(4000);
    jo          JSON_OBJECT_T;
    ja          JSON_ARRAY_T;
    keys        JSON_KEY_LIST;
    keys_string VARCHAR2(100);
begin
  
    l_request := SYS.utl_http.begin_request(l_url_o);
    SYS.utl_http.set_header(l_request, 'User-Agent', 'Mozilla/5.0 (Windows NT x.y; Win64; x64; rv:10.0) Gecko/20100101 Firefox/10.0');
    l_response := SYS.utl_http.get_response(l_request);
    
    LOOP
    BEGIN
        SYS.utl_http.read_raw(l_response, l_download);
        
        l_plain := UTL_RAW.CAST_TO_VARCHAR2 (l_download) ;
        
       DBMS_OUTPUT.put_line(l_plain);    
       
       for rec IN (
         select j.usuario,j.nombre , j.email, j.direccion, j.id
           from json_table(l_plain,'$[*]' COLUMNS 
            usuario varchar2(255)      PATH '$.usuario',
            nombre varchar2(255)       PATH '$.nombre',
            email varchar2(255)      PATH '$.email',
            direccion varchar2(255)       PATH '$.direccion',
            id number       PATH '$.id'
           ) j  ) 
         LOOP
            insert into usuarios (usuario,nombre,email,direccion,id) values
            (rec.usuario,rec.nombre,rec.email,rec.direccion,rec.id);
           dbms_output.put_line (rec.usuario||','||rec.nombre||rec.email||','||rec.direccion||','||rec.id);
       END LOOP;
    
        commit;
        
        EXCEPTION WHEN SYS.utl_http.end_of_body THEN
            EXIT;
        END;
    END LOOP;
    

    SYS.utl_http.end_response(l_response);

end;

/

