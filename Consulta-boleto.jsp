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

    <title>Consulta-boleto</title>
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
        <a href="https://www.google.com/"><i class="fa-solid fa-magnifying-glass"></i></a>
        <a href="https://www.instagram.com/"><i class="fa-brands fa-instagram"></i></a>
        <a href="https://www.facebook.com/?locale=es_LA"><i class="fa-brands fa-facebook"></i></a>
      </div>
    </header>
    
    <header class="modificarhead">
      <div class="search-container">
        <form action="Consulta-boleto.jsp" class="search-form" method="get">
          <button type="submit"><img class="search-icon" src="img/lupa.svg" alt="" /></button>
          <input type="text" name="cedula" placeholder="Buscar..." />
        </form>
      </header>
      <h1 id="mod_h1">Consultar boletos</h1>
    </header>
    <main class="main1">
      <section class="seccion-modificar">
        <div class="client-info">
          <table>
            <thead>
              <tr>
                <th id="thead">Nombre</th>
                <th id="thead">Cedula</th>
                <th id="thead">Fecha</th>
                <th id="thead">Nombre Pelicula</th>
                <th id="thead">Sala</th>
                <th id="thead">Nombre Sucursal</th>
                <th id="thead">Cantidad Boletos</th>
                <th id="thead">Importe Total</th>
                
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

                    // Conexión a la base de datos
                        Class.forName("oracle.jdbc.driver.OracleDriver");
                        conexion = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "jose", "123");
                        String sql = "SELECT * FROM cliente c LEFT JOIN boleto b on c.id_cliente = b.id_cliente LEFT JOIN exhibicion e on e.id_exhibicion = b.id_exhibicion LEFT JOIN pelicula p on p.id_pelicula = e.id_pelicula LEFT JOIN sala s on s.id_sala = e.id_sala LEFT JOIN sucursal suc on suc.id_sucursal = s.id_sucursal WHERE c.ced_cliente = ?";
                        stmt = conexion.prepareStatement(sql);
                        stmt.setString(1, cedula);
                        rs = stmt.executeQuery();

                       	while (rs.next()) {
                       		String nombre = rs.getString("nombre");
                       	    int id_boleto = rs.getInt("id_boleto");
                       	    String ced_cliente = rs.getString("ced_cliente");
                       	    String fecha = rs.getString("fecha");
                       	    String nombre_pelicula = rs.getString("nombre_pelicula");
                       	    String id_sala = rs.getString("id_sala");
                       	    String nombre_sucursal = rs.getString("nombre_sucursal");
                       	    
                       	    int cantidad_ninos = rs.getInt("cantidad_ninos");
                       	    int cantidad_adultos = rs.getInt("cantidad_adultos");
                       	    int cantidad_terceraedad = rs.getInt("cantidad_terceraedad");
 
                       	    int cantidad_total = cantidad_ninos + cantidad_adultos + cantidad_terceraedad;
                       	    
                       	    double precio_ninos = rs.getInt("importe_ninos");
                       	    double precio_adultos = rs.getInt("importe_adultos");
                       	    double precio_terceraedad = rs.getInt("importe_terceraedad");
                       	    double total_importe = (precio_ninos*cantidad_ninos) + (precio_adultos*cantidad_adultos) + (precio_terceraedad*cantidad_terceraedad);
                       	    
                       	    if (id_boleto != 0){
                       	    	
                       	    	%>
                       	    	
                               <tr>
                                <td><%= nombre %></td>
       							<td><%= ced_cliente %></td>
       							<td><%= fecha %></td>
       							<td><%= nombre_pelicula %></td>
       							<td><%= id_sala %></td>
       							<td><%= nombre_sucursal %></td>
       							<td><%= cantidad_total %></td>
       							<td><%= total_importe %></td>
                               </tr>
                       	    	
                       	    	<%
                       	    }
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
        <a href="Home.html">
          <div class="footer-link-box">
            <i class="fa-solid fa-house"></i>
            <h3>HOME</h3>
          </div>
        </a>

        <a href="sobre-nosotros.html">
          <div class="footer-link-box">
            <i class="fa-solid fa-user"></i>
            <h3>SOBRE NOSOTROS</h3>
          </div>
        </a>

        <a href="Usuario-login.jsp">
          <div class="footer-link-box">
            <i class="fa-solid fa-right-from-bracket"></i>
            <h3>CERRAR SESIÓN</h3>
          </div>
        </a>
      </section>

      <h5><b>CINESTELAR.</b> Todos los derechos reservados 2024.</h5>
    </footer>
</body>
</html>
