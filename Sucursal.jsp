<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.lang.*" %>
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
    <title>Escoger-sucursal</title>
  </head>
  <body>
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
    <main>
      <!-- Formulario para seleccionar sucursal -->
      <form class="container-sect movie" action="Pelicula.jsp" method="GET">
        <div class="select-container">
          <select name="sucursal" id="sucursal" class="select-box">
          
          <%-- Inicializar variables de conexion --%>
		    <% Connection conexion = null; %>
		    <% CallableStatement llamada = null; %>
          
            <%      
            
            String cliente = request.getParameter("id_cliente");
            
          //creamos la conexion
            // Cargar el driver de Oracle
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Establecer la conexion con la base de datos Oracle
            String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:xe";
            String username = "jose";
            String password = "123";
            conexion = DriverManager.getConnection(jdbcUrl, username, password);
               
               //consulta
               PreparedStatement consulta_sucursal = conexion.prepareStatement("Select * From sucursal");

               ResultSet resultado = consulta_sucursal.executeQuery();
               
               while (resultado.next()) {
                   int id_sucursal = resultado.getInt("id_sucursal");
                   String nombre = resultado.getString("nombre_sucursal");
           %>
                   <option value="<%= id_sucursal %>"><%= nombre %></option>
                   
           <%                        
               }
           %>
          </select>
          <div class="icon-container">
            <i class="fa-solid fa-caret-down"></i>
          </div>
        </div>
        <input type="hidden" name="id_cliente" value="<%= cliente %>"></input>
        <button type="submit">Seleccionar</button>
      </form>

      
    </main>

   
  </body>
</html>
