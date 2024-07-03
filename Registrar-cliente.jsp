<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.lang.*" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- CSS -->
    <link rel="stylesheet" href="style.css" />
    <!-- Iconos: Font-Awesome -->
    <script src="https://kit.fontawesome.com/5ddbd215bf.js" crossorigin="anonymous"></script>
<meta charset="UTF-8">
<title>Crear-Cliente</title>
</head>
<body id="admin-login-bg">
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
	<section class="cards">
	<div class="card form">
          <div class="card-info form">
	
  <%-- Obtener los paremetros del formulario --%>
    <% String nombre = request.getParameter("nombre"); %>
    <% String cedula = request.getParameter("cedula"); %>
    <% String direccion = request.getParameter("direccion"); %>
    <% String correo = request.getParameter("correo"); %>
    <% String telefono = request.getParameter("telefono"); %>

    <%-- Inicializar variables de conexion --%>
    <% Connection conexion = null; %>
    <% CallableStatement llamada = null; %>

 
    <%
    	//creamos la conexion
        // Cargar el driver de Oracle
        Class.forName("oracle.jdbc.driver.OracleDriver");

        // Establecer la conexion con la base de datos Oracle
        String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:xe";
        String username = "jose";
        String password = "123";
        conexion = DriverManager.getConnection(jdbcUrl, username, password);

        // Llamar al procedimiento almacenado
        String procedimiento = "{call insertar_cliente(?, ?, ?, ?, ?, ?)}";
        llamada = conexion.prepareCall(procedimiento);

        // Establecer los par�metros del procedimiento
        llamada.setString(1, cedula);
        llamada.setString(2, nombre);
        llamada.setString(3, direccion);
        llamada.setString(4, correo);
        llamada.setString(5, telefono);

        // Registrar el par�metro de salida para el ID generado
        llamada.registerOutParameter(6, Types.NUMERIC);

        // Ejecutar la llamada al procedimiento almacenado
        llamada.execute();

        // Obtener el ID generado
        int idGenerado = llamada.getInt(6);

        // Mostrar mensaje de �xito y el ID generado
        out.println("<h2>REGISTRO EXITOSO</h2>");
        out.println("<p>Nombre: " + nombre + "</p>");
        out.println("<p>Cedula: " + cedula + "</p>");
        out.println("<p>Direccion: " + direccion + "</p>");
        out.println("<p>Correo registrado: " + correo + "</p>");
        out.println("<p>Telefono: " + telefono + "</p>");
        out.println("<div class='imagen_centro'><img src='img/realizado.gif' height='80px' width='80px'></div>");


    
    
    %>
             
             <form action="Pelicula.jsp" method="GET">
             	<input type="hidden" name="id_cliente" value="<%= idGenerado %>"></input>

            	<button type="submit">Siguiente</button>
             
             </form>
       
      </section>
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
      </section>

      <h5><b>CINESTELAR.</b> Todos los derechos reservados 2024.</h5>
    </footer>
</body>
</html>