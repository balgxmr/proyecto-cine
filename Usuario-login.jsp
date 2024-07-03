<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <!-- CSS -->
    <link rel="stylesheet" href="style.css" />

    <!-- Iconos: Font-Awesome -->
    <script src="https://kit.fontawesome.com/5ddbd215bf.js" crossorigin="anonymous"></script>

    <title>Usuario-Login</title>
</head>
<body id="admin-login-bg">
    <header class="header">
      <div id="header-title">
        <img src="img/LOGO_WHITE_TRANSPARENTE.png" alt="" />
        <a href="Home.html"><h1>INESTELAR</h1></a>
      </div>
    </header>

    <section class="cards">
        <form action="Usuario-login.jsp" method="post" class="card form">
            <div class="card-info form">
                <h2>Iniciar Sesión</h2>
                <h3>Ingrese sus datos personales.</h3>

                <h4 class="card form-field">Cedula</h4>
                <input type="text" name="cedula" class="form-input" placeholder="Ingresa tu cédula" required />

                <h4 class="card form-field">Nombre</h4>
                <input type="text" name="nombre" class="form-input" placeholder="Ingresa tu nombre" required />

                <button type="submit" name="login" value="login">Iniciar Sesión</button>
        
    

    <% 
        String cedula = request.getParameter("cedula");
        String nombre = request.getParameter("nombre");
        String errorMessage = "";

        if (cedula != null && nombre != null) {
            try {
                // Conexión a la base de datos
                Class.forName("oracle.jdbc.driver.OracleDriver");
                String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:xe";
                String dbUsername = "jose";
                String dbPassword = "123";
                Connection conexion = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);
                
                PreparedStatement stmt = conexion.prepareStatement("SELECT * FROM empleado WHERE cedula=? AND nombre=?");
                stmt.setString(1, cedula);
                stmt.setString(2, nombre);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    // Redirigir a la página de inicio si el login es correcto
                    response.sendRedirect("Home.html");
                } else {
                    // Mostrar mensaje de error si el login es incorrecto
                    errorMessage = "Cédula o nombre incorrectos";
                }
                
                // Cerrar recursos
                rs.close();
                stmt.close();
                conexion.close();
            } catch (SQLException e) {
                e.printStackTrace();
                errorMessage = "Error SQL: " + e.getMessage(); // Mensaje de error específico para SQL
            } catch (Exception e) {
                e.printStackTrace();
                errorMessage = "Error al conectar a la base de datos: " + e.getMessage(); // Mensaje de error general
            }
        }
    %>
    
    <% if (!errorMessage.isEmpty()) { %>
        <h1 class="blink log_z1 rec-pass1"><%= errorMessage %></h1>
        <h1 class=" log_z1 rec-pass1">Contacta con el administrador</h1>
    <% } %>
        </div>
        </form>
        </section>

</body>
</html>
