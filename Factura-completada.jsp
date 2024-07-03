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
    <title>Factura-completada</title>
  </head>

  <body>
  


    <%-- Inicializar variables de conexion --%>
    <% Connection conexion = null; %>
    <% CallableStatement llamada = null; %>
		
	
 
    <%
    
	    String cliente = request.getParameter("id_cliente");
		String exhibicion = request.getParameter("id_exhibicion");
		String asientos = request.getParameter("asientos");
	    String adultos = request.getParameter("adultos");
	    String ninos = request.getParameter("ninos");
	    String terceraedad = request.getParameter("terceraedad");
	    
	    
	    int id_cliente = Integer.parseInt(cliente);
	    int id_exhibicion = Integer.parseInt(exhibicion);
	    
	    int adultosInt = 0;
        int ninosInt = 0;
        int terceraedadInt = 0;
	    
	    if(adultos != ""){
    	    adultosInt = Integer.parseInt(adultos);
        }
        if(ninos != ""){
        	ninosInt = Integer.parseInt(ninos);
        }
        
        if(terceraedad != ""){
        	terceraedadInt = Integer.parseInt(terceraedad);
        }
	    
	    
    	//creamos la conexion
        // Cargar el driver de Oracle
        Class.forName("oracle.jdbc.driver.OracleDriver");

        // Establecer la conexion con la base de datos Oracle
        String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:xe";
        String username = "jose";
        String password = "123";
        conexion = DriverManager.getConnection(jdbcUrl, username, password);

      
        
        // Llamar al procedimiento almacenado
        String procedimiento = "{call insertar_boleto(?, ?, ?, ?, ?, ?, ?)}";
        llamada = conexion.prepareCall(procedimiento);

        // Establecer los parametros del procedimiento
        llamada.setInt(1, id_exhibicion);
        llamada.setInt(2, id_cliente);
        llamada.setInt(3, adultosInt);
        llamada.setInt(4, ninosInt);
        llamada.setInt(5, terceraedadInt);
        llamada.setString(6, asientos);


     // Registrar el par�metro de salida para el ID generado
        llamada.registerOutParameter(7, Types.NUMERIC);

        // Ejecutar la llamada al procedimiento almacenado
        llamada.execute();

        // Obtener el ID generado
        int idGenerado = llamada.getInt(7);
    %>
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
      <section class="cards">
        <div action="../../index.html" class="card form cliente_ex">
          <h3>Factura generada e impresa correctamente.</h3>
          <div class="card-info form cliente_ex">
            <a href="Home.html"><button>Volver al HOME</button></a>
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
