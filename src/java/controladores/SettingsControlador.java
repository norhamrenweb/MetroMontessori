/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controladores;

import Montessori.Content;
import Montessori.DBConect;
import Montessori.Level;
import Montessori.Objective;
import Montessori.Subject;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

/**
 *
 * @author nmohamed
 */
public class SettingsControlador extends MultiActionController {

//      private ServletContext servlet;
    private Object getBean(String nombrebean, ServletContext servlet) {
        ApplicationContext contexto = WebApplicationContextUtils.getRequiredWebApplicationContext(servlet);
        Object beanobject = contexto.getBean(nombrebean);
        return beanobject;
    }

    //start only loads levels
    public ModelAndView start(HttpServletRequest hsr, HttpServletResponse hsr1) throws Exception {

        ModelAndView mv = new ModelAndView("settings");

        ResultSet rs = DBConect.ah.executeQuery("SELECT GradeLevel,GradeLevelID FROM GradeLevels");
        List<Level> grades = new ArrayList();
        Level l = new Level();
        l.setName("Select level");
        grades.add(l);
        while (rs.next()) {
            Level x = new Level();
            String[] ids = new String[1];
            ids[0] = "" + rs.getInt("GradeLevelID");
            x.setId(ids);
            x.setName(rs.getString("GradeLevel"));
            grades.add(x);
        }
        mv.addObject("gradelevels", grades);

        return mv;
    }

    //load subjects depend on the level selected
    public ModelAndView subjectlistLevel(HttpServletRequest hsr, HttpServletResponse hsr1) throws Exception {

        ModelAndView mv = new ModelAndView("settings");
        List<Subject> subjects = new ArrayList<>();
        List<Subject> activesubjects = new ArrayList<>();
        try {
            String[] levelid = new String[1];
            levelid = hsr.getParameterValues("seleccion1");
            ResultSet rs1 = DBConect.ah.executeQuery("select CourseID from Course_GradeLevel where GradeLevel IN (select GradeLevel from GradeLevels where GradeLevelID =" + levelid[0] + ")");
            Subject s = new Subject();
            s.setName("Select Subject");
            subjects.add(s);

            while (rs1.next()) {
                Subject sub = new Subject();
                String[] ids = new String[1];
                ids[0] = "" + rs1.getInt("CourseID");
                sub.setId(ids);

                subjects.add(sub);
            }
            for (Subject su : subjects.subList(1, subjects.size())) {
                String[] ids = new String[1];
                ids = su.getId();
                ResultSet rs2 = DBConect.ah.executeQuery("select Title,Active from Courses where reportcard = 1 and CourseID = " + ids[0]);
                while (rs2.next()) {
                    if (rs2.getBoolean("Active") == true) {
                        s.setName(rs2.getString("Title"));
                        activesubjects.add(s);
                    }
                }
            }

        } catch (SQLException ex) {
            System.out.println("Error leyendo Subjects: " + ex);
        }

        mv.addObject("subjects", activesubjects);

        return mv;
    }

    //depending on the subject selected loads the objects
    public ModelAndView objectivelistSubject(HttpServletRequest hsr, HttpServletResponse hsr1) throws Exception {

        ModelAndView mv = new ModelAndView("settingtable");
        List<Objective> objectives = new ArrayList<>();
        try {
            String subjectid = null;
            subjectid = hsr.getParameter("seleccion2");

            ResultSet rs1 = DBConect.eduweb.executeQuery("select name,id,description from public.objective where subject_id=" + subjectid);
            
            while (rs1.next()) {
                String[] ids = new String[1];
                Objective sub = new Objective();
                ids[0] = "" + rs1.getInt("id");
                sub.setId(ids);
                sub.setName(rs1.getString("name"));
                sub.setDescription(rs1.getString("description"));
                objectives.add(sub);
            }

        } catch (SQLException ex) {
            System.out.println("Error leyendo Objectives: " + ex);
        }

        mv.addObject("objectives", objectives);

        return mv;
    }
    
    //view content link per objective
    public ModelAndView contentlistObjective(HttpServletRequest hsr, HttpServletResponse hsr1) throws Exception {

        ModelAndView mv = new ModelAndView("settings");
        List<Content> contents = new ArrayList<>();
        try {
            String objectiveid = null;
            objectiveid = hsr.getParameter("seleccion3");

            ResultSet rs1 = DBConect.eduweb.executeQuery("SELECT name,id,description FROM public.content where public.content.id IN (select public.objective_content.content_id from public.objective_content where public.objective_content.objective_id =" + objectiveid + ")");
            //String[] ids = new String[1];
            while (rs1.next()) {
                Content eq = new Content();
                String[] id = new String[1];
                id[0] = "" + rs1.getInt("id");

                eq.setId(id);
                eq.setName(rs1.getString("name"));
                contents.add(eq);
            }

        } catch (SQLException ex) {
            System.out.println("Error leyendo contents: " + ex);
        }

        mv.addObject("contents", contents);

        return mv;
    }

    //depending on the subject selected load the contents for all the objects under this subject
    public ModelAndView contentlist(HttpServletRequest hsr, HttpServletResponse hsr1) throws Exception {

        ModelAndView mv = new ModelAndView("settings");
        List<Content> contents = new ArrayList<>();
        List<Objective> objectives = new ArrayList<>();
        try {
            ResultSet rs2 = DBConect.eduweb.executeQuery("select id, name from objective where subject_id =" + hsr.getParameter("seleccion"));
            while (rs2.next()) {
                Objective o = new Objective();
                String[] ids = new String[1];
                ids[0] = String.valueOf(rs2.getInt("id"));
                o.setId(ids);
                o.setName(rs2.getString("name"));
                objectives.add(o);
            }
            for (Objective obj : objectives) {
                String[] id = new String[1];
                id = obj.getId();
                ResultSet rs1 = DBConect.eduweb.executeQuery("SELECT name,id,description FROM public.content where public.content.id IN (select public.objective_content.content_id from public.objective_content where public.objective_content.objective_id =" + id[0] + ")");

                while (rs1.next()) {
                    Content eq = new Content();
                    String[] i = new String[1];
                    i[0] = "" + rs1.getInt("id");

                    eq.setId(i);
                    eq.setName(rs1.getString("name"));
                    eq.setObj(obj);
                    contents.add(eq);
                }

            }

        } catch (SQLException ex) {
            System.out.println("Error leyendo contents: " + ex);
        }

        mv.addObject("contents", contents);

        return mv;
    }

    //edit link open a form with the name & comments (we can use to edit anything)
    public ModelAndView editObjective(HttpServletRequest hsr, HttpServletResponse hsr1) throws Exception {

        ModelAndView mv = new ModelAndView("editsetting");
        Objective objective = new Objective();
        try {
            String[] id = new String[1];
            id[0] = hsr.getParameter("id");
            ResultSet rs = DBConect.eduweb.executeQuery("select name,description from objective where id =" + id[0]);
            while (rs.next()) {
                objective.setId(id);
                objective.setName(rs.getString("name"));
                objective.setDescription(rs.getString("description"));
            }

        } catch (SQLException ex) {
            System.out.println("Error leyendo contents: " + ex);

        }

        mv.addObject("objective", objective);

        return mv;
    }

    //saving the edited objective should write in the same id
    public ModelAndView saveObjective(HttpServletRequest hsr, HttpServletResponse hsr1) throws Exception {

        ModelAndView mv = new ModelAndView("editsetting");
        String message = null;
        try {

            String consulta = "update objective set name = '" + hsr.getParameter("name") + "',description ='" + hsr.getParameter("description") + "'where id =" + hsr.getParameter("id");
            DBConect.eduweb.executeUpdate(consulta);
            message = "Objective edited successfully";

        } catch (SQLException ex) {
            System.out.println("Error leyendo contents: " + ex);
            message = "Something went wrong";
        }

        mv.addObject("message", message);

        return mv;
    }

    // delete will delete and confirm (what will happen to the lessons, not allowed if there are lessons with this item)
    public ModelAndView deleteObjective(HttpServletRequest hsr, HttpServletResponse hsr1) throws Exception {

        ModelAndView mv = new ModelAndView("settingtable");
        String[] id = hsr.getParameterValues("id");
        String message = null;
        try {

            String consulta = "select name from lessons where objective_id = " + id[0];
            ResultSet rs = DBConect.eduweb.executeQuery(consulta);
            if (rs.next()) {
                message = "This objective is linked to lessons";
            } else {
                consulta = "DELETE FROM public.objective WHERE id=" + id[0];
                DBConect.eduweb.executeUpdate(consulta);
                // need to decide what to do with the contents
            }
        } catch (SQLException ex) {
            System.out.println("Error : " + ex);
        }

        mv.addObject("message", message);
        return mv;
    }
    // create new objective-method-content
    //
    public ModelAndView AddObjective(HttpServletRequest hsr, HttpServletResponse hsr1) throws Exception {

        ModelAndView mv = new ModelAndView("settingtable");
        String[] id = hsr.getParameterValues("id");
        String message = null;
        try {
            String consulta = "insert into objectives(name,description,subject_id) values('" + hsr.getParameter("name") + "','" + hsr.getParameter("description") + "," + id[0] + ")";
            DBConect.eduweb.executeUpdate(consulta);

            message = "Objectived added";

        } catch (SQLException ex) {
            System.out.println("Error : " + ex);
            message = "Something went wrong";
        }

        mv.addObject("message", message);
        return mv;
    }

}
