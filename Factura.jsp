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
    <title>Factura</title>
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
		    	
		        //creamos la conexion
	            // Cargar el driver de Oracle
	            Class.forName("oracle.jdbc.driver.OracleDriver");

	            // Establecer la conexion con la base de datos Oracle
	            String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:xe";
	            String username = "jose";
	            String password = "123";
	            conexion = DriverManager.getConnection(jdbcUrl, username, password);
               
               //consulta
               PreparedStatement consulta_sucursal = conexion.prepareStatement("Select * From exhibicion e join sala s on e.id_sala = s.id_sala join pelicula p on e.id_pelicula = p.id_pelicula join sucursal suc on s.id_sucursal = suc.id_sucursal join tipo_sala ts on s.id_tipo_sala = ts.id_tipo_sala WHERE e.id_exhibicion = ?");
               consulta_sucursal.setString(1, exhibicion);
               
               ResultSet resultado = consulta_sucursal.executeQuery();
               
               resultado.next();
               
               String nombre_pelicula = resultado.getString("nombre_pelicula");
               String nombre_sucursal = resultado.getString("nombre_sucursal");
               int numero_sala = resultado.getInt("id_sala");
               Date fecha = resultado.getDate("fecha");
               Time hora = resultado.getTime("horario");
               int precio_ninos = resultado.getInt("importe_ninos");
               int precio_adultos = resultado.getInt("importe_adultos");
               int precio_terceraedad = resultado.getInt("importe_terceraedad");
               
               //parsear la cantidad a entero
               
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
               
               //calcular el boleto por cada tipo
               
              double adultosDouble = precio_adultos * adultosInt;
               double ninosDouble = precio_ninos * ninosInt;
               double terceraedadDouble = precio_terceraedad * terceraedadInt;
               
               //sumar subtotal y los impuestos
               double subtotal = adultosDouble + ninosDouble + terceraedadDouble;
               double interes = subtotal * 0.07;
               double total = subtotal + interes;
               
               
         %>
      <section class="cards factura">
        <form action="Factura-completada.jsp" method="GET" class="card form factura">
          <div class="card-info form">
            <h2>FACTURA</h2>
            <hr />
            <div class="factura-cliente-info">
              <h3>Cliente: <%= cliente %></h3>
              <h3>Película: <%= nombre_pelicula %></h3>
              <h3>Cine: <%= nombre_sucursal %></h3>
              <h3>Sala: <%= numero_sala %></h3>
              <h3>Horario: <%= hora %></h3>
              <h3>Fecha: <%= fecha %></h3>
            </div>

            <div class="boleto-info">
              <h3>(<%= ninos %>) Boleto Niño: </h3>
              <h3>(<%= adultos %>) Boleto Adulto: </h3>
              <h3>(<%= terceraedad %>) Boleto Tercera Edad: </h3>
            </div>

            <div class="precio-info">
              <h3>Subotal: <%= subtotal %></h3>
              <h3>Interes: <%= interes %></h3>
              <h3>Total: <%= total %></h3>
              
            </div>
            <input type="hidden" name="id_cliente" value="<%= cliente %>"></input>
			<input type="hidden" name="id_exhibicion" value="<%= exhibicion %>"></input>
			<input type="hidden" name="asientos" value="<%= asientos %>"></input>
			<input type="hidden" name="adultos" value="<%= adultos %>"></input>
			<input type="hidden" name="ninos" value="<%= ninos %>"></input>
			<input type="hidden" name="terceraedad" value="<%= terceraedad %>"></input>
            <button type="submit" value="asientos">Pagar</button>
          </div>
        </form>
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
      </section>

      <h5><b>CINESTELAR.</b> Todos los derechos reservados 2024.</h5>
    </footer>
  </body>
</html>
