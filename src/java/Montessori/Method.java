/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Montessori;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletContext;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 *
 * @author nmohamed
 */
public class Method {
     private String[] id;
    private String name;
    private ServletContext servlet;

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    private String description;
      
    
    private Object getBean(String nombrebean, ServletContext servlet)
    {
        ApplicationContext contexto = WebApplicationContextUtils.getRequiredWebApplicationContext(servlet);
        Object beanobject = contexto.getBean(nombrebean);
        return beanobject;
    }
    public String[] getId() {
        return id;
    }

    public void setId(String[] id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
 public String fetchName(int id, ServletContext servlet)
    { String name = null ;
        try {
            Connection cn;
            DriverManagerDataSource dataSource = (DriverManagerDataSource) this.getBean("dataSource", servlet);
            cn = dataSource.getConnection();
            Statement fetchconect = cn.createStatement(); 
            String consulta = "SELECT name FROM public.method where id = "+id;
            ResultSet rs = fetchconect.executeQuery(consulta);
          
            while (rs.next())
            {
                name = rs.getString("name");
                
            }
            cn.close();
            //this.finalize();
            
        } catch (SQLException ex) {
            System.out.println("Error reading methods: " + ex);
        }
       
        return name;
    
    }   
    
}
