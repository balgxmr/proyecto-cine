<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

    <title>Consulta boleto</title>
</head>
<body id="admin-login-bg2">
    <header class="header">
      <div id="header-title">
        <img src="img/LOGO_WHITE_TRANSPARENTE.png" alt="" />
        <a href="Home.html"><h1>INESTELAR</h1></a>
      </div>

      <div class="header-info">
        <a href="Consulta-pelicula.jsp"><h2>Películas</h2></a>
	        <a href="Consulta-sala.jsp"><h2>Salas</h2></a>
	        <a href="Consulta-boleto.jsp"><h2>Boletos</h2></a>
	        <a href="Consulta-asientos.jsp"><h2>Asientos</h2></a>
	        <a href="Consulta-horario.jsp"><h2>Horarios</h2></a>
	        <a href="Cliente-existe-pregunta.html"><h2>Reservar</h2></a>

      </div>

      <div class="redes">

      <a href="https://www.google.com/" id="search1"><i class="fa-solid fa-magnifying-glass"></i></a>
      <a href="https://www.instagram.com/" id="search1"><i class="fa-brands fa-instagram"></i></a>
      <a href="https://www.facebook.com/?locale=es_LA" id="search1"><i class="fa-brands fa-facebook"></i></a>
      </div>
    </header>
    <header class="modificarhead">
      <div class="search-container">
        <form class="search-form" method="get">
          <button type="submit"><img class="search-icon" src="img/icons/lupa.svg" alt="" /></button>
          <input type="text" name="cedula" placeholder="Buscar..." />
        </form>
      </div>
      <h1 id="mod_h1">Consultar boletos</h1>
    </header>
    <main class="main1">
      <section class="seccion-modificar">
        <div class="client-info">
          <table>
            <thead>
              <tr>
                <th id="thead">ID</th>
                <th id="thead">Nombre Completo</th>
                <th id="thead">Cédula</th>
                <th id="thead">Lugar de residencia</th>
                <th id="thead">Teléfono</th>
                <th id="thead">Email</th>
              </tr>
            </thead>
            <tbody>
              <%
                String cedula = request.getParameter("cedula");
                String errorMessage = "";
               
                if (cedula != null && !cedula.isEmpty()) {
                    Connection conexion = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;

                    try {
                        // Conexión a la base de datos
                        Class.forName("oracle.jdbc.driver.OracleDriver");
                        conexion = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "jose", "123");
                        String sql = "SELECT * FROM cliente WHERE ced_cliente = ?";
                        stmt = conexion.prepareStatement(sql);
                        stmt.setString(1, cedula);
                        rs = stmt.executeQuery();

                        if (rs.next()) {
              %>
                          <tr>
                            <td><%= rs.getInt("ID_CLIENTE") %></td>
                            <td><%= rs.getString("NOMBRE") %></td>
                            <td><%= rs.getString("CED_cliente") %></td>
                            <td><%= rs.getString("DIRECCION") %></td>
                            <td><%= rs.getString("TELEFONO") %></td>
                            <td><%= rs.getString("CORREO") %></td>
                          </tr>
              <%
                        } else {
                            errorMessage = "No se encontró ningún cliente con la cédula proporcionada.";
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        errorMessage = "Error al conectar a la base de datos: " + e.getMessage();
                    } finally {
                        if (rs != null) { try { rs.close(); } catch (SQLException ignore) {} }
                        if (stmt != null) { try { stmt.close(); } catch (SQLException ignore) {} }
                        if (conexion != null) { try { conexion.close(); } catch (SQLException ignore) {} }
                    }
                } else {
                    errorMessage = "Por favor, ingrese una cédula.";
                }
              %>
            </tbody>
          </table>
          <% if (!errorMessage.isEmpty()) { %>
              <h1 class="blink log_z1 rec-pass1"><%= errorMessage %></h1>
          <% } %>
        </div>
        
        </div>
      </section>
    </main>
    <footer id="footer">
      <section id="footer-links">
        <a href="">
          <div class="footer-link-box">
            <i class="fa-solid fa-house"></i>
            <h3>HOME</h3>
          </div>
        </a>

        <a href="">
          <div class="footer-link-box">
            <i class="fa-solid fa-user"></i>
            <h3>SOBRE NOSOTROS</h3>
          </div>
        </a>
      </section>

      <h5><b>CINESTELAR.</b> Todos los derechos reservados 2024.</h5>
    </footer>
</body>
</html>
