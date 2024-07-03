<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.lang.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>


<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8" />
	    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
	    <!-- CSS -->
	    <link rel="stylesheet" href="style.css" />
	    <!-- Iconos: Font-Awesome -->
	    <script src="https://kit.fontawesome.com/5ddbd215bf.js" crossorigin="anonymous"></script>
	    <title>Consultar-sala</title>
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
		
		<%-- Inicializar variables de conexion --%>
	    <% Connection conexion = null; %>
	    
	    <% 
	        //creamos la conexion
            // Cargar el driver de Oracle
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Establecer la conexion con la base de datos Oracle
            String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:xe";
            String username = "jose";
            String password = "123";
            conexion = DriverManager.getConnection(jdbcUrl, username, password);
         %>
	    
	     <% // captura de los valores que vienen desde el formulario.
	     	String sala = request.getParameter("sala");
	     %>
	        
		<section>
		
		<!-- Formulario para seleccionar sucursal -->
	      <form class="container-sect movie" action="Consulta-sala.jsp" method="GET">
        <div class="select-container">
          <select name="sala" id="sala" class="select-box">
         
            <%      
               //consulta
               PreparedStatement consulta_sucursal = conexion.prepareStatement("Select * From sucursal suc join sala s on suc.id_sucursal = s.id_sucursal");

               ResultSet resultado = consulta_sucursal.executeQuery();
               
               while (resultado.next()) {
                   String nombre_sucursal = resultado.getString("nombre_sucursal");
                   int id_sala = resultado.getInt("id_sala");

           %>
                   <option value="<%= id_sala %>"><%= nombre_sucursal %> --> SALA: <%= id_sala %></option>
                   
           <%                        
               }
           %>
          </select>
          <div class="icon-container">
            <i class="fa-solid fa-caret-down"></i>
          </div>
        </div>
        
        <button type="submit">Seleccionar</button>
      </form>
		
		</section>
		
		<%
		
		if (sala != ""){
		
			
		%>
			<section class="cards movies">
			
			<% 
			    PreparedStatement consulta_sala = conexion.prepareStatement("Select * from sala s join exhibicion e on s.id_sala = e.id_sala join pelicula p on e.id_pelicula = p.id_pelicula WHERE s.id_sala = ? AND TRUNC(e.fecha) = TRUNC(SYSDATE) ORDER BY p.id_pelicula, e.horario");
				consulta_sala.setString(1, sala);
		        
		        ResultSet resultado_sala = consulta_sala.executeQuery();
		        
		        HashMap<Integer, String> lista_nombres = new HashMap<>();
		        HashMap<Integer, List<Integer>> lista_id = new HashMap<>();
		        HashMap<Integer, String> lista_horarios = new HashMap<>();
		        
		        List<String> lista_pelicula = new ArrayList<>();
		        while (resultado_sala.next()) {
	                 int id_pelicula = resultado_sala.getInt("id_pelicula");
	                 int id_exhibicion = resultado_sala.getInt("id_exhibicion");
	                 String nombre_pelicula = resultado_sala.getString("nombre_pelicula");
	                 String horario = resultado_sala.getString("horario");
	
	                 if (!lista_nombres.containsKey(id_pelicula)){
	                     lista_nombres.put(id_pelicula, nombre_pelicula);
	                 }
	
	                 lista_id.computeIfAbsent(id_pelicula, i -> new ArrayList<>()).add(id_exhibicion);
	
	                 if (!lista_horarios.containsKey(id_exhibicion)){
		                 lista_horarios.put(id_exhibicion, horario);
	                 }
		        }
	
		        for (Map.Entry<Integer, List<Integer>> entry : lista_id.entrySet()) {
		        	Integer id_pelicula = entry.getKey();
	                List<Integer> lista_id_exhibicion = entry.getValue();
	                
	                String nombre_pelicula = lista_nombres.get(id_pelicula);
	                
	                %>
						<div class="card movie">
				          <img src="img/imagen_peliculas.jpg" width="250px" height="400px"/>
				          <div class="card-info movie">
				            <h2><%= nombre_pelicula%></h2>
				            <hr />
				            <h3>Horarios</h3>
				            <table>
	    		    <% 
	    		    
	                for (Integer id_exhibicion : lista_id_exhibicion){
	                    String horario = lista_horarios.get(id_exhibicion);
	
	                    %>
			                <tr>
			                  <td>
			                  <div >
	
			                    <button type="submit" ><%= horario %></button>
			                   </div>  
			                  </td>
			                </tr>
		 				<%                    
	                }
		        	
	                               		 
	            	%>
	             			</table>
	             	   	   </div>
			        	</div>                		 
	             	<%	
	            }
        %>
       
	</section>
		
	<%	
		
	}
		
	%>

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
