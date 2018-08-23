package controladores;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet(name = "setupicono", urlPatterns = {"/setupicono"})
@MultipartConfig
public class setupicono extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processResponse(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ClassNotFoundException {
        String url = "/setupControlador/start.htm";
        response.flushBuffer();
        response.sendRedirect(request.getContextPath() + url);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ClassNotFoundException {
        //get the file chosen by the user
        Part filePart = request.getPart("fileToUpload");
        String url;
        String name = filePart.getName();
        
        String path = request.getServletContext().getRealPath("")+"/recursos/img/";
        String nombre = "iconoschool"+terminacion(filePart.getSubmittedFileName());
        InputStream initialStream = filePart.getInputStream();
        byte[] buffer = new byte[initialStream.available()];
        if(buffer.length == 0)
            url = "/setupControlador/start.htm?message=Select an image";
        else
            url = "/setupControlador/start.htm?message=Image succesfully set";
        initialStream.read(buffer);
        File archivo = new File(path+nombre);
        BufferedWriter bw;
        if(!archivo.exists()) {
            bw = new BufferedWriter(new FileWriter(archivo));
        }
        OutputStream outStream = new FileOutputStream(archivo);
        outStream.write(buffer);
        response.sendRedirect(request.getContextPath() + url);
    }
    
    private String terminacion(String nombre){
        String ret="";
        boolean copiar=false;
        for(int i = 0; i < nombre.length();i++){
            if(nombre.charAt(i)=='.')
                copiar=true;
            if(copiar)
                ret+=nombre.charAt(i);
        }
        return ret;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processResponse(request, response);
        } catch (ClassNotFoundException ex) {

        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
