<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Doctor" %>
<%@ page import="model.Treatment" %>

<%
    // Retrieve the list of doctors and treatments from the request attributes
    List<Doctor> doctorList = (List<Doctor>) request.getAttribute("doctorList");
    List<Treatment> treatmentList = (List<Treatment>) request.getAttribute("treatmentList");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <title>APU Medical Center</title>
    <%@ include file="includes/head.jsp" %>
</head>

<body id="top" data-spy="scroll" data-target=".navbar-collapse" data-offset="50">

    <%@ include file="includes/preloader.jsp" %>
    <%@ include file="includes/header.jsp" %>
    <%@ include file="includes/navbar.jsp" %>

     <!-- HOME -->
     <section id="home" class="slider" data-stellar-background-ratio="0.5">
          <div class="container">
               <div class="row">

                    <div class="owl-carousel owl-theme">
                         <div class="item item-first">
                              <div class="caption">
                                   <div class="col-md-offset-1 col-md-10">
                                        <h3>Let's make your life happier</h3>
                                        <h1>Healthy Living</h1>
                                        <a href="#team" class="section-btn btn btn-default smoothScroll">Meet Our
                                             Doctors</a>
                                   </div>
                              </div>
                         </div>

                         <div class="item item-second">
                              <div class="caption">
                                   <div class="col-md-offset-1 col-md-10">
                                        <h3>Learn more about APU Medical Center</h3>
                                        <h1>Our Story</h1>
                                        <a href="#about" class="section-btn btn btn-default btn-gray smoothScroll">More
                                             About Us</a>
                                   </div>
                              </div>
                         </div>

                         <div class="item item-third">
                              <div class="caption">
                                   <div class="col-md-offset-1 col-md-10">
                                        <h3>Patient First and Foremost</h3>
                                        <h1>Health Care for All</h1>
                                        <a href="#treatments"
                                             class="section-btn btn btn-default btn-blue smoothScroll">More Treatment
                                             Services</a>
                                   </div>
                              </div>
                         </div>
                    </div>

               </div>
          </div>
     </section>

     <!-- ABOUT -->
     <section id="about">
          <div class="container">
               <div class="row">

                    <div class="col-md-6 col-sm-6">
                         <div class="about-info">
                              <h2 class="wow fadeInUp" data-wow-delay="0.6s">We care for your <i
                                        class="fa fa-h-square"></i>ealth</h2>
                              <div class="wow fadeInUp" data-wow-delay="0.8s">
                                   <p>APU Medical Center (AMC) is your trusted healthcare partner, providing
                                        comprehensive medical services to meet all your health needs.
                                        Since our establishment, we have been committed to delivering quality healthcare
                                        with a patient-centered approach that puts your well-being first.</p>

                                   <p>Our experienced medical team specializes in treating chronic diseases such as
                                        diabetes, hypertension, and asthma, while also providing immediate care for
                                        common illnesses including flu, fever, and cough.
                                        We understand the importance of preventive care and offer comprehensive health
                                        check-ups for local students, as well as specialized EMGS medical screenings for
                                        international students.</p>

                                   <p>At AMC, we stay current with healthcare needs by providing COVID-19 screening
                                        services through both PCR and RTK-Ag tests.
                                        Our dental services cover everything from routine check-ups and cleanings to
                                        extractions, ensuring your oral health is maintained. We also perform minor
                                        surgeries, wound care, and provide essential vaccinations and immunizations to
                                        keep you protected.</p>

                                   <p>Our motto, <strong>"Patient Centered Treatments for Everyone"</strong>, reflects
                                        our commitment to accessible, quality healthcare that respects your individual
                                        needs and circumstances.</p>
                              </div>
                              <figure class="profile wow fadeInUp" data-wow-delay="1s">
                                   <img src="images/doc-image.jpg" class="img-responsive" alt="">
                                   <figcaption>
                                        <h3>Dr. Neil Jackson</h3>
                                        <p>General Principal</p>
                                   </figcaption>
                              </figure>
                         </div>
                    </div>
               </div>
          </div>
     </section>

    <!-- TEAM -->
    <section id="team" data-stellar-background-ratio="1">
    <div class="container">
        <div class="row">

            <div class="col-md-12 col-sm-12">
                <div class="section-title wow fadeInUp" data-wow-delay="0.1s">
                    <h2>Our Doctors</h2>
                </div>
            </div>

            <% 
            if (doctorList != null && !doctorList.isEmpty()) {
                final int MAX_DOCTORS_HOMEPAGE = 3;
                int doctorCount = Math.min(doctorList.size(), MAX_DOCTORS_HOMEPAGE);
                double delay = 0.4;
                
                // Calculate responsive column classes based on number of doctors
                String colClass = "";
                String containerClass = "row";
                
                if (doctorCount == 1) {
                    colClass = "col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3";
                } else if (doctorCount == 2) {
                    colClass = "col-md-4 col-sm-6";
                    containerClass = "row text-center";
                } else {
                    colClass = "col-md-4 col-sm-6";
                }
            %>
            
            <div class="<%= containerClass %>">
            <%
                for (int i = 0; i < doctorCount; i++) {
                    Doctor doc = doctorList.get(i);
                    
                    // Handle doctor name validation
                    String doctorName = doc.getName();
                    if (doctorName == null || doctorName.trim().isEmpty()) {
                        doctorName = "Doctor Name Not Available";
                    }
                    
                    // Handle specialization validation
                    String specialization = doc.getSpecialization();
                    if (specialization == null || specialization.trim().isEmpty()) {
                        specialization = "General Practice";
                    }
                    
                    // Handle profile picture validation
                    String profilePic = doc.getProfilePic();
                    if (profilePic == null || profilePic.trim().isEmpty()) {
                        profilePic = "default-doctor.png";
                    }
                    
                    // Handle phone validation
                    String phone = doc.getPhone();
                    if (phone == null || phone.trim().isEmpty()) {
                        phone = "Contact clinic for details";
                    }
                    
                    // Handle email validation
                    String email = doc.getEmail();
                    boolean hasValidEmail = (email != null && !email.trim().isEmpty() && email.contains("@"));
            %>
            <div class="<%= colClass %>">
                <div class="team-thumb wow fadeInUp" data-wow-delay="<%= delay %>s">
                    <img src="images/<%= profilePic %>" class="img-responsive" alt="<%= doctorName %> Profile Picture">
                    <div class="team-info">
                        <h3><%= doctorName %></h3>
                        <p class="doctor-specialization"><%= specialization %></p>
                        <div class="team-contact-info">
                            <p><i class="fa fa-phone"></i> <%= phone %></p>
                            <% if (hasValidEmail) { %>
                                <p><i class="fa fa-envelope-o"></i> <a href="mailto:<%= email %>">Email</a></p>
                            <% } else { %>
                                <p><i class="fa fa-envelope-o"></i> Email not available</p>
                            <% } %>
                            <% if (doc.getRating() > 0) { %>
                                <p class="doctor-rating">
                                    <i class="fa fa-star"></i> 
                                    Rating: <%= String.format("%.1f", doc.getRating()) %>/5.0
                                </p>
                            <% } %>
                        </div>
                        <ul class="social-icon">
                            <li><a class="fa fa-facebook-square" href="#"></a></li>
                            <% if (hasValidEmail) { %>
                                <li><a href="mailto:<%= email %>" class="fa fa-envelope-o"></a></li>
                            <% } %>
                        </ul>
                    </div>
                </div>
            </div>
            <% 
                    delay += 0.2;
                }
            %>
            </div>
            
            <!-- View All Doctors Button -->
            <div class="col-md-12 col-sm-12 text-center" style="margin-top:30px;">
                <% if (doctorList.size() > MAX_DOCTORS_HOMEPAGE) { %>
                    <p class="text-muted">Showing <%= doctorCount %> of <%= doctorList.size() %> doctors</p>
                <% } %>
                <a href="team.jsp" class="section-btn btn btn-default">
                    View All <%= doctorList.size() %> Doctors
                </a>
            </div>
            
            <% 
            } else { 
            %>
            <div class="col-md-12 col-sm-12 text-center">
                <div class="alert alert-info">
                    <i class="fa fa-info-circle"></i>
                    <strong>No doctors available at the moment.</strong>
                    <p>Please check back later or contact us for more information.</p>
                </div>
            </div>
            <% } %>

        </div>
    </div>
    </section>

    <!-- TREATMENTS -->
    <section id="treatments" data-stellar-background-ratio="2.5">
        <div class="container">
            <div class="row">

                <div class="col-md-12 col-sm-12">
                    <!-- SECTION TITLE -->
                    <div class="section-title wow fadeInUp" data-wow-delay="0.1s">
                        <h2>Treatments Available</h2>
                    </div>
                </div>

                <%
                    if (treatmentList != null && !treatmentList.isEmpty()) {
                        final int MAX_TREATMENTS_HOMEPAGE = 3;
                        int treatmentCount = Math.min(treatmentList.size(), MAX_TREATMENTS_HOMEPAGE);
                        double delay = 0.4;
                        
                        // Calculate responsive column classes based on number of treatments
                        String colClass = "";
                        String containerClass = "row";
                        
                        if (treatmentCount == 1) {
                            colClass = "col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3";
                        } else if (treatmentCount == 2) {
                            colClass = "col-md-4 col-sm-6";
                            containerClass = "row text-center";
                        } else {
                            colClass = "col-md-4 col-sm-6";
                        }
                %>
                
                <div class="<%= containerClass %>">
                <%
                        for (int i = 0; i < treatmentCount; i++) {
                            Treatment treatment = treatmentList.get(i);
                            
                            // Extract treatment name (characters before "-")
                            String displayName = treatment.getName();
                            if (displayName != null && displayName.contains("-")) {
                                displayName = displayName.substring(0, displayName.indexOf("-")).trim();
                            }
                            
                            // Handle null/empty descriptions
                            String shortDesc = treatment.getShortDescription();
                            if (shortDesc == null || shortDesc.trim().isEmpty()) {
                                shortDesc = "Treatment details available upon consultation.";
                            } else if (shortDesc.length() > 120) {
                                shortDesc = shortDesc.substring(0, 120) + "...";
                            }
                            
                            // Handle image path
                            String imagePath = treatment.getImagePath();
                            if (imagePath == null || imagePath.trim().isEmpty()) {
                                imagePath = "default-treatment.jpg";
                            }
                %>
                    <div class="<%= colClass %>">
                        <!-- TREATMENT THUMB -->
                        <div class="treatments-thumb wow fadeInUp" data-wow-delay="<%= delay %>s" data-treatment-id="<%= treatment.getId() %>">
                            <div class="treatment-image clickable-treatment">
                                <img src="images/<%= imagePath %>" class="img-responsive" alt="<%= displayName %>">
                            </div>
                            <div class="treatments-info">
                                <h3>
                                    <span class="treatment-name clickable-treatment">
                                        <%= displayName %>
                                    </span>
                                </h3>
                                <p><%= shortDesc %></p>
                            </div>
                        </div>
                    </div>
                <%
                            delay += 0.2;
                        }
                %>
                </div>
                
                <!-- View All Treatments Button -->
                <div class="col-md-12 col-sm-12 text-center" style="margin-top:30px;">
                    <% if (treatmentList.size() > MAX_TREATMENTS_HOMEPAGE) { %>
                        <p class="text-muted">Showing <%= treatmentCount %> of <%= treatmentList.size() %> treatments</p>
                    <% } %>
                    <a href="treatment.jsp" class="section-btn btn btn-default">
                        View All <%= treatmentList.size() %> Treatments
                    </a>
                </div>
                
                <%
                    } else {
                %>
                <div class="col-md-12 col-sm-12 text-center">
                    <div class="alert alert-info">
                        <i class="fa fa-info-circle"></i>
                        <strong>No treatments available at the moment.</strong>
                        <p>Please check back later or contact us for more information.</p>
                    </div>
                </div>
                <% } %>

            </div>
        </div>
    </section>

    <%@ include file="includes/footer.jsp" %>
    <%@ include file="includes/scripts.jsp" %>

</body>

</html>
