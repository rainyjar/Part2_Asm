
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import model.DoctorFacade;
import model.Doctor;

/**
 *
 * @author chris
 */
@WebServlet(urlPatterns = {"/DoctorServlet"})
@MultipartConfig

public class DoctorServlet extends HttpServlet {

    @EJB
    private DoctorFacade doctorFacade;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet DoctorServlet</title>");            
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet DoctorServlet at " + request.getContextPath() + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
//    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Doctor doctor = doctorFacade.find(id);
            if (doctor != null) {
                doctorFacade.remove(doctor);
            }
            response.sendRedirect("DoctorServlet");
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Doctor doctor = doctorFacade.find(id);

            if (doctor != null) {
                doctor.setName(request.getParameter("name"));
                doctor.setEmail(request.getParameter("email"));
                doctor.setPassword(request.getParameter("password"));
                doctor.setPhone(request.getParameter("phone"));
                doctor.setGender(request.getParameter("gender"));
                doctor.setSpecialization(request.getParameter("specialization"));

                try {
                    String dobStr = request.getParameter("dob");
                    java.util.Date utilDate = new SimpleDateFormat("yyyy-MM-dd").parse(dobStr);
                    java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
                    doctor.setDob(sqlDate);
                } catch (ParseException e) {
                    e.printStackTrace(); // log or handle
                }

                Part file = request.getPart("profilePic");
                try {
                    String uploadedFileName = UploadImage.uploadProfilePicture(file, getServletContext());
                    if (uploadedFileName != null) {
                        doctor.setProfilePic(uploadedFileName);
                    }
                } catch (IllegalArgumentException e) {
                    request.setAttribute("error", e.getMessage());
                    request.getRequestDispatcher("/manager/edit_doctor.jsp").forward(request, response);
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Upload failed: " + e.getMessage());
                    request.getRequestDispatcher("/manager/edit_doctor.jsp").forward(request, response);
                    return;
                }

                doctorFacade.edit(doctor); // update to DB
            }

            response.sendRedirect("DoctorServlet"); // go back to list
        } else {
            // Registration block
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");
            String dobStr = request.getParameter("dob");
            String specialization = request.getParameter("specialization");

            // Parse date of birth
            Date dob = null;
            if (dobStr != null && !dobStr.isEmpty()) {
                dob = Date.valueOf(dobStr); // yyyy-MM-dd
            }

            String uploadedFileName = null;
            Part file = request.getPart("profilePic");

            try {
                uploadedFileName = UploadImage.uploadProfilePicture(file, getServletContext());
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("/manager/register_doctor.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Upload failed: " + e.getMessage());
                request.getRequestDispatcher("/manager/register_doctor.jsp").forward(request, response);
                return;
            }

            Doctor d = new Doctor();
            d.setName(name);
            d.setEmail(email);
            d.setPassword(password);
            d.setPhone(phone);
            d.setGender(gender);
            d.setDob(dob);
            d.setSpecialization(specialization);
            d.setProfilePic(uploadedFileName);

            try {
                doctorFacade.create(d);
                request.setAttribute("success", "Doctor registered successfully.");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Failed to register doctor: " + e.getMessage());
            }
            request.getRequestDispatcher("manager/register_doctor.jsp").include(request, response);

        }
    }

//    retreive Doctors detail
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Doctor doctor = doctorFacade.find(id);
            request.setAttribute("doctor", doctor);
            request.getRequestDispatcher("/manager/edit_doctor.jsp").forward(request, response);
        } else {
            // Default: show list
            List<Doctor> doctorList = doctorFacade.findAll();
            request.setAttribute("doctorList", doctorList);
            request.getRequestDispatcher("/manager/list_doctor.jsp").forward(request, response);
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
    }// </editor-fold>

}
