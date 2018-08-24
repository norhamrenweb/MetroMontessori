/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controladores;

import Montessori.*;
import atg.taglib.json.util.JSONArray;
import atg.taglib.json.util.JSONException;
import atg.taglib.json.util.JSONObject;
import com.google.gson.Gson;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;

import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author nmohamed
 */
@Controller
public class LessonsListControlador {

    static Logger log = Logger.getLogger(LessonsListControlador.class.getName());
//      private ServletContext servlet;

    private Object getBean(String nombrebean, ServletContext servlet) {
        ApplicationContext contexto = WebApplicationContextUtils.getRequiredWebApplicationContext(servlet);
        Object beanobject = contexto.getBean(nombrebean);
        return beanobject;
    }

    @RequestMapping("/homepage/loadLessons.htm")
    public ModelAndView loadLessons(HttpServletRequest hsr, HttpServletResponse hsr1) throws Exception {
        if ((new SessionCheck()).checkSession(hsr)) {
            return new ModelAndView("redirect:/userform.htm?opcion=inicio");
        }
        ModelAndView mv = new ModelAndView("homepage");
        HttpSession sesion = hsr.getSession();
        User user = (User) sesion.getAttribute("user");
        mv.addObject("lessonslist", this.getLessons(sesion, user, hsr.getServletContext()));
        mv.addObject("username", user.getName());
        int iduser = ((User) hsr.getSession().getAttribute("user")).getId();
        mv.addObject("teacherlist", this.getTeachers(iduser));
        return mv;
    }

    @RequestMapping("/schedule.htm")
    public ModelAndView schedule(HttpServletRequest hsr, HttpServletResponse hsr1) throws Exception {
        return new ModelAndView("schedule");
    }

    @RequestMapping("/loadschedule.htm")
    @ResponseBody
    public String loadschedule(HttpServletRequest hsr, HttpServletResponse hsr1) throws Exception {
        User user = (User) hsr.getSession().getAttribute("user");

       /* String idYear = "" + hsr.getSession().getAttribute("yearId");
        String idTerm = "" + hsr.getSession().getAttribute("termId");
        */
        String idTerm = hsr.getParameter("termid");
        String idYear = hsr.getParameter("yearid");
        
        HashMap<Integer,String> hashLevel =  new HashMap<>();
        HashMap<Integer,String> hashPersons = new HashMap<>();
        try {    
            String consulta = "SELECT GradeLevel,GradeLevelID FROM GradeLevels";
            ResultSet rs = DBConect.ah.executeQuery(consulta);
            while (rs.next())
            {
                hashLevel.put(rs.getInt("GradeLevelID"), rs.getString("GradeLevel"));
            }
            
            consulta = "select id,lastname,firstname from person";
            rs = DBConect.ah.executeQuery(consulta);

            while (rs.next()) {
                hashPersons.put(rs.getInt("id"),rs.getString("lastname") + ", " + rs.getString("firstname"));
            } 
        } catch (SQLException ex) {
            System.out.println("Error leyendo Alumnos: " + ex);
        }
        

        String consultAux = "";
        if (user.getType() == 1) {
            consultAux = "user_id = " + user.getId() + " and";
        }
        String consulta = "SELECT * FROM public.lessons where " + consultAux + " COALESCE(idea, FALSE) = FALSE and COALESCE(archive, FALSE) = FALSE and term_id= " + idTerm + " and " + "yearterm_id=" + idYear;
        ResultSet rs = DBConect.eduweb.executeQuery(consulta);
        ArrayList<JSONObject> lessonslist = new ArrayList<>();

        while (rs.next()) {
            JSONObject l = new JSONObject();
            l.put("title", rs.getString("name"));
            Timestamp stamp = rs.getTimestamp("start");
            SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
            l.put("start", rs.getTimestamp("start"));//sdfDate.format(stamp));
            l.put("end", rs.getTimestamp("finish"));//sdfDate.format(stamp));
            l.put("allDay", "false");
            l.put("objid", rs.getString("objective_id"));
            l.put("idteacher", rs.getString("user_id"));
            Level g = new Level();
            l.put("gradeLevel",hashLevel.get(rs.getInt("level_id")));
            l.put("share", false);
            lessonslist.add(l);
        }
        consulta = "SELECT * FROM lessons inner join lessonpresentedby on lessonid=id where teacherid=" + user.getId() + " AND COALESCE(idea, FALSE) = FALSE and COALESCE(archive, FALSE) = FALSE  and term_id= " + idTerm + " and " + "yearterm_id=" + idYear;
        rs = DBConect.eduweb.executeQuery(consulta);
        while (rs.next()) { // fast
            JSONObject l = new JSONObject();
            l.put("title", rs.getString("name"));
            Timestamp stamp = rs.getTimestamp("start");
            SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
            l.put("start", rs.getTimestamp("start"));//sdfDate.format(stamp));
            l.put("end", rs.getTimestamp("finish"));//sdfDate.format(stamp));
            l.put("allDay", "false");
            l.put("objid", rs.getString("objective_id"));
            l.put("idteacher", rs.getString("user_id"));
             Level g = new Level();
            l.put("gradeLevel",hashLevel.get(rs.getInt("level_id")));
            l.put("share", true);
            lessonslist.add(l);
        }
        for (JSONObject l : lessonslist) {
            String idobj = (String) l.get("objid");
            consulta = "SELECT * FROM public.objective where id=" + idobj;
            rs = DBConect.eduweb.executeQuery(consulta);
            while (rs.next()) {
                l.put("nameobj", rs.getString("name"));
            }
            String nameteacher = hashPersons.get(Integer.parseInt(l.getString("idteacher")));
            l.put("createdby", nameteacher);
        }
        return lessonslist.toString();
    }

    public static ArrayList<Teacher> getTeachers(int iduser) throws SQLException {
        LoginVerification login = new LoginVerification();
        HashMap<Integer, String> mapGroups = login.getSecurityGroupID();

        String consulta = "select distinct firstname,lastname,Staff.StaffID,GroupID from Staff inner join SecurityGroupMembership on Staff.StaffID = SecurityGroupMembership.StaffId order by firstname,lastname";
        //  if(iduser == -1) consulta = "select distinct firstname,lastname,Staff.StaffID,GroupID from Staff inner join SecurityGroupMembership on Staff.StaffID = SecurityGroupMembership.StaffId order by firstname,lastname";
        ResultSet rs = DBConect.ah.executeQuery(consulta);
        ArrayList<Teacher> t = new ArrayList<>();
        String firstname = "", lastname = "";
        int id, groupId;
        while (rs.next()) {
            firstname = rs.getString("firstname");
            lastname = rs.getString("lastname");
            id = rs.getInt("StaffID");
            groupId = rs.getInt("GroupID");
            if (id != iduser && mapGroups.get(groupId).equals("MontessoriTeacher")) {
                t.add(new Teacher(lastname + ", " + firstname, id));
            }

        }

        return t;
    }
//  

    public ArrayList<Lessons> getLessons(HttpSession sesion, User user, ServletContext servlet) throws SQLException {
//        this.conectarOracle();
        ArrayList<Lessons> lessonslist = new ArrayList<>();
        int yearid = (int) sesion.getAttribute("yearId");
        int termid = (int) sesion.getAttribute("termId");
        try {

            String consulta = "SELECT GradeLevel,GradeLevelID FROM GradeLevels";
            ResultSet rs2 = DBConect.ah.executeQuery(consulta);
            HashMap<Integer, String> mapLevel = new HashMap<Integer, String>();
            String name;
            int id;
            while (rs2.next()) {
                name = rs2.getString("GradeLevel");
                id = rs2.getInt("GradeLevelID");
                mapLevel.put(id, name);
            }

            consulta = "SELECT * FROM public.objective";
            ResultSet rs3 = DBConect.eduweb.executeQuery(consulta);

            HashMap<Integer, String> mapObjective = new HashMap<Integer, String>();
            while (rs3.next()) {
                name = rs3.getString("name");
                id = rs3.getInt("id");
                mapObjective.put(id, name);
            }

            consulta = "SELECT Title,CourseID FROM Courses";
            ResultSet rs4 = DBConect.ah.executeQuery(consulta);
            HashMap<Integer, String> mapSubject = new HashMap<Integer, String>();
            while (rs4.next()) {
                name = rs4.getString("Title");
                id = rs4.getInt("CourseID");
                mapSubject.put(id, name);
            }

            String consultAux = "";
            if (user.getType() == 1) {
                consultAux = "term_id=" + termid + " and " + "yearterm_id=" + yearid + " and " + "user_id = " + user.getId() + " and ";
            } else {
                consultAux = "term_id=" + termid + " and " + "yearterm_id=" + yearid + " and ";
            }

            consulta = "SELECT * FROM public.lessons where " + consultAux + " COALESCE(idea, FALSE) = FALSE and COALESCE(archive, FALSE) = FALSE";
            ResultSet rs = DBConect.eduweb.executeQuery(consulta);

            while (rs.next()) {
                Lessons lesson = new Lessons();
                lesson.setName(rs.getString("name"));
                lesson.setId(rs.getInt("id"));

                Level level = new Level();
                int idLevel = rs.getInt("level_id");
                name = mapLevel.get(idLevel);
                level.setName(name);
                lesson.setLevel(level);

                Objective sub = new Objective();
                int idObjective = rs.getInt("objective_id");
                name = mapObjective.get(idObjective);
                sub.setName(name);
                lesson.setObjective(sub);

                Subject subject = new Subject();
                int idSubject = rs.getInt("subject_id");
                name = mapSubject.get(idSubject);
                subject.setName(name);
                lesson.setSubject(subject);

                Timestamp stamp = rs.getTimestamp("start");
                Timestamp finish = rs.getTimestamp("finish");
                SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
                SimpleDateFormat sdfTime = new SimpleDateFormat("kk:mm");
                String dateStr = sdfDate.format(stamp);
                String timeStr = sdfTime.format(stamp);

                String timeStr2 = sdfTime.format(finish);
                lesson.setDate("" + dateStr);
                lesson.setStart(timeStr);
                lesson.setFinish(timeStr2);
                lesson.setShare(false);
                lesson.setTeacherid(rs.getInt("user_id"));
                lessonslist.add(lesson);

            }

            consultAux = "term_id=" + termid + " and " + "yearterm_id=" + yearid + " and ";

            consulta = "SELECT * FROM lessons inner join lessonpresentedby on lessonid=id where " + consultAux + " teacherid=" + user.getId() + " AND COALESCE(idea, FALSE) = FALSE and COALESCE(archive, FALSE) = FALSE";
            rs = DBConect.eduweb.executeQuery(consulta);
            while (rs.next()) {
                Lessons lesson = new Lessons();
                lesson.setName(rs.getString("name"));
                lesson.setId(rs.getInt("id"));

                Level level = new Level();
                int idLevel = rs.getInt("level_id");
                name = mapLevel.get(idLevel);
                level.setName(name);
                lesson.setLevel(level);

                Objective sub = new Objective();
                int idObjective = rs.getInt("objective_id");
                name = mapObjective.get(idObjective);
                sub.setName(name);
                lesson.setObjective(sub);

                Subject subject = new Subject();
                int idSubject = rs.getInt("subject_id");
                name = mapSubject.get(idSubject);
                subject.setName(name);
                lesson.setSubject(subject);

                Timestamp stamp = rs.getTimestamp("start");
                Timestamp finish = rs.getTimestamp("finish");
                SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
                SimpleDateFormat sdfTime = new SimpleDateFormat("hh:mm a");
                String dateStr = sdfDate.format(stamp);
                String timeStr = sdfTime.format(stamp);

                String timeStr2 = sdfTime.format(finish);
                lesson.setDate("" + dateStr);
                lesson.setStart(timeStr);
                lesson.setFinish(timeStr2);
                lesson.setShare(true);
                lesson.setTeacherid(rs.getInt("user_id"));
                lessonslist.add(lesson);

            }
        } catch (SQLException ex) {
            System.out.println("Error leyendo Alumnos: " + ex);
            StringWriter errors = new StringWriter();
            ex.printStackTrace(new PrintWriter(errors));
            log.error(ex + errors.toString());
        }

        return lessonslist;
    }
//     

    @RequestMapping("/homepage/deleteLesson.htm")
    @ResponseBody
    public String deleteLesson(HttpServletRequest hsr, HttpServletResponse hsr1) throws Exception {

        JSONObject jsonObj = new JSONObject();
        String[] id = hsr.getParameterValues("LessonsSelected");
        String nombre = hsr.getParameter("LessonsName");

        String message = null;
        try {
            HttpSession sesion = hsr.getSession();
            User user = (User) sesion.getAttribute("user");
            String consulta = "select attendance from lesson_stud_att where lesson_id = " + id[0];
            ResultSet rs = DBConect.eduweb.executeQuery(consulta);

            while (rs.next()) {
                String text = rs.getString("attendance");
                if (text != null) {
                    if (text != null && !text.equals("") && !text.equals("0")) {
                        message = "Presentation has attendance records,it can not be deleted";
                        break;
                    }
                }
            }
            consulta = "select * from progress_Report where lesson_id =" + id[0];
            ResultSet rs1 = DBConect.eduweb.executeQuery(consulta);
            while (rs1.next()) {
                int check = rs1.getInt("rating_id");
                if (check != 7 && check != 6)//empty rating or N/A , we could check here as well if the proesentatio has comments, but i think what is important is the rating
                {
                    message = "Presentation has progress records,it can not be deleted";
                }
            }
            if (message == null) {
                consulta = "DELETE FROM lesson_content WHERE lesson_id=" + id[0];
                DBConect.eduweb.executeUpdate(consulta);
                consulta = "DELETE FROM lesson_stud_att WHERE lesson_id=" + id[0];
                DBConect.eduweb.executeUpdate(consulta);
                consulta = "DELETE FROM progress_report WHERE lesson_id=" + id[0];//to delete the empty ratings and NAs so not to appear later in reports
                DBConect.eduweb.executeUpdate(consulta);
                consulta = "DELETE FROM public.lessons WHERE id=" + id[0];
                DBConect.eduweb.executeUpdate(consulta);
                message = "Presentation deleted successfully";
            }
            //mv.addObject("lessonslist", this.getLessons(user.getId(),hsr.getServletContext()));
            //mv.addObject("messageDelete",message);
            jsonObj.put("message", message);
            DBConect.eduweb.executeUpdate("Delete from lessonpresentedby where lessonid=" + id[0]);

            String note = "id: " + id[0] + " | namePresentation: " + nombre;

            ActivityLog.log(((User) (hsr.getSession().getAttribute("user"))), "", "Delete Presentation", note); //crear lesson

        } catch (SQLException ex) {
            System.out.println("Error : " + ex);
            StringWriter errors = new StringWriter();
            ex.printStackTrace(new PrintWriter(errors));
            log.error(ex + errors.toString());
        }

        return jsonObj.toString();
        //return mv;
    }

    @RequestMapping("/homepage/compartir.htm")
    @ResponseBody
    public String compartirLesson(@RequestBody ObjetoCompartir obj, HttpServletRequest hsr, HttpServletResponse hsr1) throws JSONException {
//        String obj = hsr.getParameter("obj");
//        JSONObject json = new JSONObject(obj);
//        JSONArray ids = json.getJSONArray("teachers");
//        String idlesson = json.getString("id");
        JSONArray ids = obj.getTeachers();
        String idlesson = obj.getId();

        try {
            String consulta;
            consulta = "delete from lessonpresentedby where lessonid=" + idlesson;
            DBConect.eduweb.executeUpdate(consulta);
            for (int i = 0; i < ids.length(); i++) {
                consulta = "insert into lessonpresentedby values(" + idlesson + "," + ids.getString(i) + ")";
                DBConect.eduweb.executeUpdate(consulta);
            }
        } catch (SQLException ex) {
            java.util.logging.Logger.getLogger(LessonsListControlador.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
            return "error";
        }
        return "Presentation shared successfully";
    }

    @RequestMapping("/homepage/cargarcompartidos.htm")
    @ResponseBody
    public String compartirSelect(HttpServletRequest hsr, HttpServletResponse hsr1) throws JSONException {
        String idlesson = hsr.getParameter("seleccion");
        String consulta = "select * from lessonpresentedby where lessonid=" + idlesson;
        ArrayList<Integer> teacherids = new ArrayList<>();
        ArrayList<Teacher> tlist = new ArrayList<>();
        try {
            ResultSet rs = DBConect.eduweb.executeQuery(consulta);
            while (rs.next()) {
                teacherids.add(rs.getInt("teacherid"));
            }
            String name;
            for (Integer s : teacherids) {
                name = fetchNameTeacher(s, hsr.getServletContext());
                tlist.add(new Teacher(name, s));
            }
        } catch (SQLException ex) {
            java.util.logging.Logger.getLogger(LessonsListControlador.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        JSONObject jsonObj = new JSONObject();
        jsonObj.put("t", new Gson().toJson(tlist));
        return jsonObj.toString();
    }

    @RequestMapping("/homepage/editLesson.htm")
    public ModelAndView editLesson(HttpServletRequest hsr, HttpServletResponse hsr1) throws Exception {
        if ((new SessionCheck()).checkSession(hsr)) {
            return new ModelAndView("redirect:/userform.htm?opcion=inicio");
        }
        ModelAndView mv = new ModelAndView("homepage");
        String[] id = hsr.getParameterValues("seleccion");
        try {
            HttpSession sesion = hsr.getSession();
            User user = (User) sesion.getAttribute("user");

            String consulta = "DELETE FROM public.lessons WHERE id=" + id[0];
            DBConect.eduweb.executeUpdate(consulta);
            mv.addObject("lessonslist", this.getLessons(sesion, user, hsr.getServletContext()));
        } catch (SQLException ex) {
            System.out.println("Error : " + ex);
            StringWriter errors = new StringWriter();
            ex.printStackTrace(new PrintWriter(errors));
            log.error(ex + errors.toString());
        }

        return mv;
    }

    public static String fetchNameTeacher(int id, ServletContext servlet) {
        String subjectName = null;
        try {
            String consulta = "select lastname,firstname from person where personid = " + id;
            ResultSet rs = DBConect.ah.executeQuery(consulta);

            while (rs.next()) {
                subjectName = rs.getString("lastname") + ", " + rs.getString("firstname");

            }
        } catch (SQLException ex) {
            System.out.println("Error : " + ex);
        }

        return subjectName;

    }

    @RequestMapping("/homepage/detailsLesson.htm")
    @ResponseBody
    public String detailsLesson(HttpServletRequest hsr, HttpServletResponse hsr1) throws Exception {

        //     ModelAndView mv = new ModelAndView("homepage");
        JSONObject jsonObj = new JSONObject();
        String[] id = hsr.getParameterValues("LessonsSelected");
        ArrayList<Progress> records = new ArrayList<>();
        ArrayList<String> contents = new ArrayList<>();
        try {
            String consulta = "select * FROM public.lessons WHERE id=" + id[0];
            ResultSet rs = DBConect.eduweb.executeQuery(consulta);
            Objective o = new Objective();
            int idobj = 0;
            while (rs.next()) {
                Method m = new Method();
                jsonObj.put("nameteacher", fetchNameTeacher(rs.getInt("user_id"), hsr.getServletContext()));
                String method = m.fetchName(rs.getInt("method_id"), hsr.getServletContext());
                if (method == null) {
                    jsonObj.put("method", "");
                } else {
                    jsonObj.put("method", method);
                }
                Timestamp date = rs.getTimestamp("date_created");
                SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
                String dateStr = sdfDate.format(date);
                jsonObj.put("datecreated", dateStr);
                jsonObj.put("comment", rs.getString("comments"));
                idobj = rs.getInt("objective_id");
            }
            jsonObj.put("objective", o.fetchName(idobj, hsr.getServletContext()));
            consulta = "select name from content where id in (select content_id from lesson_content where lesson_id = " + id[0] + ")";
            ResultSet rs1 = DBConect.eduweb.executeQuery(consulta);
            while (rs1.next()) {
                contents.add(rs1.getString("name"));
            }
            jsonObj.put("contents", new Gson().toJson(contents));
            consulta = "SELECT * FROM public.lesson_stud_att where lesson_id =" + id[0];
            ResultSet rs2 = DBConect.eduweb.executeQuery(consulta);

            while (rs2.next()) {
                Progress att = new Progress();

                att.setStudentid(rs2.getInt("student_id"));
                records.add(att);
            }
            consulta = "SELECT FirstName,LastName,MiddleName,StudentID FROM Students ";
            ResultSet rs3 = DBConect.ah.executeQuery(consulta);
            HashMap<String, String> map = new HashMap<String, String>();
            String first, LastName, middle, studentID;
            while (rs3.next()) {
                first = rs3.getString("FirstName");
                LastName = rs3.getString("LastName");
                middle = rs3.getString("MiddleName");
                studentID = rs3.getString("StudentID");
                map.put(studentID, LastName + ", " + first + " " + middle);
            }
            for (Progress record : records) {
                String id2 = "" + record.getStudentid();
                String name = map.get(id2);
                record.setStudentname(name);
            }
            jsonObj.put("students", new Gson().toJson(records));
            consulta = "select name from obj_steps where obj_id=" + idobj;
            ResultSet rs4 = DBConect.eduweb.executeQuery(consulta);
            ArrayList<String> steps = new ArrayList<>();
            while (rs4.next()) {
                steps.add(rs4.getString("name"));
            }
            jsonObj.put("steps", new Gson().toJson(steps));
        } catch (SQLException ex) {
            System.out.println("Error : " + ex);
            StringWriter errors = new StringWriter();
            ex.printStackTrace(new PrintWriter(errors));
            log.error(ex + errors.toString());
        }

        return jsonObj.toString();
    }
}
