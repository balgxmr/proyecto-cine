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
    <title>Boletos</title>
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
        <a href="https://www.google.com/"><i class="fa-solid fa-magnifying-glass"></i></a>
        <a href="https://www.instagram.com/"><i class="fa-brands fa-instagram"></i></a>
        <a href="https://www.facebook.com/?locale=es_LA"><i class="fa-brands fa-facebook"></i></a>
      </div>
    </header>

    <main>
    	
    	<%-- Inicializar variables de conexion --%>
	    <% Connection conexion = null; %>
	    <% CallableStatement llamada = null; %>
    	
    	<%      
    		//tomar los valores del formulario
    			String cliente = request.getParameter("id_cliente");
		    	String exhibicion = request.getParameter("id_exhibicion");
		    	
		    	//creamos la conexion
	            // Cargar el driver de Oracle
	            Class.forName("oracle.jdbc.driver.OracleDriver");

	            // Establecer la conexion con la base de datos Oracle
	            String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:xe";
	            String username = "jose";
	            String password = "123";
	            conexion = DriverManager.getConnection(jdbcUrl, username, password);
               
               //consulta
               PreparedStatement consulta_sucursal = conexion.prepareStatement("Select * From exhibicion e join sala s on e.id_sala = s.id_sala join pelicula p on e.id_pelicula = p.id_pelicula join sucursal suc on s.id_sucursal = suc.id_sucursal WHERE e.id_exhibicion = ?");
               consulta_sucursal.setString(1, exhibicion);
               
               ResultSet resultado = consulta_sucursal.executeQuery();
               
               resultado.next();//guardo los valores de la consulta en variables y las imprimo
               String nombre_pelicula = resultado.getString("nombre_pelicula");
               String nombre_sucursal = resultado.getString("nombre_sucursal");
               int numero_sala = resultado.getInt("id_sala");
               Date fecha = resultado.getDate("fecha");
               Time hora = resultado.getTime("horario");
               
         %>
      <section class="cards movies">
        <!-- Primera Pelicula -->
        <div class="card movie">
          <img src="img/imagen_peliculas.jpg" />
          <div class="card-info movie">
            <h2><%= nombre_pelicula %></h2>
            <hr />
            <h3>Cine: <%= nombre_sucursal %></h3>
            <h3>Fecha: <%= fecha %></h3>
            <h3>Hora: <%= hora %></h3>
            <h3>Sala: <%= numero_sala %></h3>
          </div>
        </div>
      </section>

      <section class="cards movies">
        <!-- Primera Pelicula -->
        <div class="card movie">
          <div class="card-info movie boleto">
            <h2>BOLETOS</h2>
            <hr />
            <h3>Digite la cantidad de boletos</h3>

            <form action="Asientos.jsp" method="GET">
            <!-- Se envian valores hidden porque los necesitaremos en las siguientes paginas -->
            	<input type="hidden" name="id_cliente" value="<%= cliente %>"></input>
            	<input type="hidden" name="id_exhibicion" value="<%= exhibicion %>"></input>
            	<input type="hidden" name="asientos" value=""></input>
              <table>
                <tr>
                  <th><h4>ADULTO</h4></th>
                  <th><input class="form-input" name="adultos" type="number" placeholder="0" /></th>
                </tr>

                <tr>
                  <th><h4>NIÑOS (1-12 años)</h4></th>
                  <th><input class="form-input" name="ninos" type="number" placeholder="0" /></th>
                </tr>

                <tr>
                  <th><h4>TERCERA EDAD</h4></th>
                  <th><input class="form-input" name="terceraedad" type="number" placeholder="0" /></th>
                </tr>
              </table>
              <button type="submit">Siguiente</button>
            </form>
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
