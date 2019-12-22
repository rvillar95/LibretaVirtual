<?php



defined('BASEPATH') or exit('No direct script access allowed');



class IndexModel extends CI_Model
{



    public function __construct()
    {

        parent::__construct();
    }



    function inicioProfesor($rut, $clave)
    {
        $this->db->select("idProfesor,rutProfesor,nombresProfesor,apellidosProfesor,fechaNacimientoProfesor,numeroProfesor,correoProfesor,fotoProfesor,claveProfesor,institucion_idInstitucion,responsableProfesor,estadoProfesor");
        $this->db->from("profesor");
        $this->db->where("rutProfesor", $rut);
        $this->db->where("estadoProfesor", 1);
        $this->db->where("claveProfesor", $clave);
        return $this->db->get()->result();
    }


    function inicioAlumno($rut, $clave, $token)
    {
        $this->db->select("idAlumno,rutAlumno,nombresAlumno,apellidosAlumno,fechaNacimientoAlumno,numeroAlumno,correoAlumno,fotoAlumno,claveAlumno,apoderado_idApoderado,institucion_idInstitucion,nacionalidadAlumno,responsableAlumno,estadoAlumno   ");
        $this->db->from("alumno");
        $this->db->where("rutAlumno", $rut);
        $this->db->where("estadoAlumno", 1);
        $this->db->where("claveAlumno", $clave);
        $user = $this->db->get()->result();

        $this->db->select('count (*)');
        $this->db->from('token_alumno');
        $this->db->where('alumnoToken_Alumno', $user[0]->idAlumno);
        $resultado = $this->db->count_all_results();

        $this->db->select('count (*)');
        $this->db->from('token_alumno');
        $this->db->where('nombreToken_Alumno', $token);
        $this->db->where('alumnoToken_Alumno', $user[0]->idAlumno);

        $resultadoToken = $this->db->count_all_results();



        if ($resultado == 0) {
            $data = array(
                "nombreToken_Alumno" => $token,
                "alumnoToken_Alumno" => $user[0]->idAlumno
            );
            $this->db->insert("token_alumno", $data);
        } else if ($resultado != 0) {
            if ($resultadoToken == 0) {
                $data = array(
                    "nombreToken_Alumno" => $token,
                    "alumnoToken_Alumno" => $user[0]->idAlumno
                );
                $this->db->insert("token_alumno", $data);
            }
        }

        return $user;
    }

    function inicioApoderado($rut, $clave)
    {
        $this->db->select("idApoderado,rutApoderado,nombresApoderado,apellidosApoderado,fechaNacimientoApoderado,numeroApoderado,correoApoderado,fotoApoderado,claveApoderado,parentescoApoderado,responsableApoderado,institucionApoderado,estadoApoderado");
        $this->db->from("apoderado");
        $this->db->where("rutApoderado", $rut);
        $this->db->where("estadoApoderado", 1);
        $this->db->where("claveApoderado", $clave);
        return $this->db->get()->result();

        $this->db->select('count (*)');
        $this->db->from('token_apoderado');
        $this->db->where('alumnoToken_Apoderado', $user[0]->idApoderado);
        $resultado = $this->db->count_all_results();

        if ($resultado == 0) {
            $data = array(
                "nombreToken_Apoderado" => $token,
                "alumnoToken_Apoderado" => $user[0]->idApoderado
            );
            $this->db->insert("token_apoderado", $data);
        }

        return $user;
    }

    function getMensajes()
    {
        $this->db->select("m.idMensaje,m.nombreMensaje,m.descripcionMensaje,m.fechaCreacionMensaje,concat(p.nombresProfesor,' ',p.apellidosProfesor) as nombreProfesor,p.fotoProfesor");
        $this->db->from("mensaje m");
        $this->db->join("profesor p", "p.idProfesor = m.profesor_idProfesor");
        return $this->db->get()->result();
    }

    function getInstitucion()
    {
        $this->db->select("idInstitucion,nombreInstitucion,descripcionInstitucion,ciudadInstitucion,logoInstitucion");
        $this->db->from("institucion");
        $this->db->where("idInstitucion", 1);
        return $this->db->get()->result();
    }


    function getCursos($id)
    {
        $this->db->select("c.idCurso, concat(c.nombreCurso,' ',g.nombreGrado_Curso,' ',l.nombreLetra_Curso ,' ',a.nombreAnno_Escolar) as nombreCurso");
        $this->db->from("curso c");
        $this->db->join("grado_curso g", "g.idGrado_Curso = c.grado_cursoidGrado_Curso");
        $this->db->join("anno_escolar a", "a.idAnno_Escolar = c.anno_escolar_idAnno_Escolar");
        $this->db->join("letra_curso l", "l.idLetra_Curso = c.letra_curso_idLetra_Curso");
        $this->db->join("profesor p ", "p.institucion_idInstitucion = c.institucion_idInstitucion");
        $this->db->join("curso_profesor k ", "k.curso_idCurso = c.idCurso");
        $this->db->where("p.idProfesor", $id);
        $this->db->where("k.profesor_idProfesor", $id);
        return $this->db->get()->result();
    }

    function getTalleres($id)
    {
        $this->db->select("idTaller, nombreTaller");
        $this->db->from("taller");
        $this->db->where("profesor_idProfesor", $id);
        return $this->db->get()->result();
    }

    function getAlumnos($id)
    {

        $this->db->select("a.idAlumno,concat(a.nombresAlumno,' ',a.apellidosAlumno) as nombreAlumno");
        $this->db->from("alumno a");
        $this->db->join("curso_alumno c", "c.alumno_idAlumno = a.idAlumno");
        $this->db->join("curso k", "k.idCurso = c.curso_idCurso");
        $this->db->where("c.curso_idCurso", $id);
        return $this->db->get()->result();
    }

    function getUltimoEvento()
    {
        $this->db->select('MAX(idEvento) AS "id"');
        $var = $this->db->get("evento")->result();
        return ($var[0]->id) + 1;
    }


    function addEvento($nombre, $descripcion, $fecha, $idCurso)
    {

        $idEvento = $this->getUltimoEvento();

        $data = array(
            "nombreEvento" => $nombre,
            "descripcionEvento" => $descripcion,
            "fechaEvento" => $fecha,
        );
        $this->db->insert("evento", $data);

        $data2 = array(
            "evento" => $idEvento,
            "curso" => $idCurso
        );
        $user = $this->db->insert("evento_curso", $data2);

        return $user;
    }

    function addMensaje($nombre, $descripcion, $fecha, $idCurso, $idProfesor)
    {
        $data = array(
            "nombreMensaje" => $nombre,
            "descripcionMensaje" => $descripcion,
            "fechaCreacionMensaje" => $fecha,
            "curso_profesor_idCurso_Profesor" => $idCurso,
            "profesor_idProfesor" => $idProfesor
        );
        $user = $this->db->insert("mensaje", $data);
        return $user;
    }

    public function getUltimoMensaje()
    {
        $this->db->select('MAX(idMensaje) AS "id"');
        $var = $this->db->get("mensaje")->result();
        return ($var[0]->id);
    }

    function push_notification_android($device_id, $message, $asunto)
    {
        //API URL of FCM
        $url = 'https://fcm.googleapis.com/fcm/send';

        /*api_key available in:
		Firebase Console -> Project Settings -> CLOUD MESSAGING -> Server key*/
        $api_key = 'AAAAUz7CJDA:APA91bH9HM2t5AZa8Vo0gyIGRq4q5co2cXmM0AU1-zV42hS3L-moJ-rQl7dabfre5NxQYjAYZXiTOCCZ6gqcJH2FX25z_rPQLtLKo6xZL_fdrUZeQr-wa3yWkitFQyZzUVfQBaHuxD6E';

        $fields = array(
            'registration_ids' => array(
                $device_id
            ),
            'data' => array(
                "message" => $message
            ),
            "notification" => array(
                "title" => $asunto,
                "body" => $message,
                "message" => "Come at evening...",
                'icon' => 'https://www.example.com/images/icon.png'
            )
        );

        //header includes Content type and api key
        $headers = array(
            'Content-Type:application/json',
            'Authorization:key=' . $api_key
        );

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));
        $result = curl_exec($ch);
        if ($result === FALSE) {
            die('FCM Send Error: ' . curl_error($ch));
        }
        curl_close($ch);
        return $result;
    }

    function addMensajeCurso($nombre, $descripcion, $fecha, $idCurso, $alumnos, $idProfesor)
    {

        $valor = explode(",", $alumnos);

        $data = array(
            "nombreMensaje" => $nombre,
            "descripcionMensaje" => $descripcion,
            "fechaCreacionMensaje" => $fecha,
            "curso_profesor_idCurso_Profesor" => $idCurso,
            "profesor_idProfesor" => $idProfesor
        );
        $this->db->insert("mensaje", $data);


        $idMensaje = $this->getUltimoMensaje();

        foreach ($valor as $value) {
            $data2 = array(
                "fechaLlegadaDetalle_Mensaje" => "Procesando",
                "fechaVistoDetalle_Mensaje" => "Procesando",
                "mensaje_idMensaje" => $idMensaje,
                "alumno_idAlumno" => $value
            );
            $this->db->insert('detalle_mensaje', $data2);

            $this->db->select("apoderado_idApoderado");
            $this->db->from("alumno");
            $this->db->where("idAlumno", $value);
            $var = $this->db->get()->result();

            $this->db->select("nombreToken_Alumno");
            $this->db->from("token_alumno");
            $this->db->where("alumnoToken_Alumno", $value);
            $tokens_alumnos = $this->db->get()->result();

            $this->db->select("nombreToken_Apoderado");
            $this->db->from("token_apoderado");
            $this->db->where("apoderadoToken_Apoderado", $var[0]->apoderado_idApoderado);
            $tokens_apoderados = $this->db->get()->result();


            $data3 = array(
                "fechaLlegadaDetalle_Mensaje" => "Procesando",
                "fechaVistoDetalle_Mensaje" => "Procesando",
                "mensaje_idMensaje" => $idMensaje,
                "apoderado_idApoderado" => $var[0]->apoderado_idApoderado
            );
            $this->db->insert('detalle_mensaje', $data3);

            for ($i = 0; $i < count($tokens_alumnos); $i++) {
                push_notification_android($tokens_alumnos[$i]->nombreToken_Alumno, $descripcion, $nombre);
            }

            for ($i = 0; $i < count($tokens_apoderados); $i++) {
                push_notification_android($tokens_apoderados[$i]->nombreToken_Apoderado, $descripcion, $nombre);
                
            }
        }
    }

    function inicioProfesor2($rut, $clave)
    {

        $this->db->select("idProfesor,rutProfesor,nombresProfesor,apellidosProfesor,fechaNacimientoProfesor,numeroProfesor,correoProfesor,fotoProfesor,claveProfesor,institucion_idInstitucion,responsableProfesor,estadoProfesor");

        $this->db->from("profesor");

        $this->db->where("rutProfesor", $rut);

        $this->db->where("estadoProfesor", 1);

        $this->db->where("claveProfesor", $clave);

        return $this->db->get()->result();
    }

    function inicioAdministrador($rut, $clave)
    {
        $this->db->select("idAdministrador,rutAdministrador,nombresAdministrador,apellidosAdministrador,fechaNacimientoAdministrador,numeroAdministrador,correoAdministrador,fotoAdministrador,claveAdministrador,institucionAdministrador,estadoAdministrador");
        $this->db->from("administrador");
        $this->db->where("rutAdministrador", $rut);
        $this->db->where("claveAdministrador", $clave);
        return $this->db->get()->result();
    }

    
}
