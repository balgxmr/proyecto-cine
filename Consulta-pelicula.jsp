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
	    <title>Consultar-pelicula</title>
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
	    
	    <header class="modificarhead">
	      <div class="search-container">
	        <form action="Consulta-pelicula.jsp" class="search-form" method="get">
	          <button type="submit"><img class="search-icon" src="img/lupa.svg" alt="" /></button>
	          <input type="text" name="pelicula" placeholder="Buscar..." />
	        </form>
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
	     	String pelicula = request.getParameter("pelicula");
	     %>
		
		<%
		
		if (pelicula != ""){
		
			
		%>
			<section class="cards movies">
			
			<% 
			    PreparedStatement consulta_pelicula = conexion.prepareStatement("select p.id_pelicula, p.nombre_pelicula, suc.nombre_sucursal,e.id_exhibicion, e.horario, s.id_sala from pelicula p join exhibicion e on p.id_pelicula = e.id_pelicula join sala s on e.id_sala = s.id_sala join sucursal suc on s.id_sucursal = suc.id_sucursal WHERE nombre_pelicula LIKE ? AND ROWNUM = 1");
				consulta_pelicula.setString(1, "%" + pelicula + "%");
		        
		        ResultSet resultado = consulta_pelicula.executeQuery();
		        
		        HashMap<Integer, String> lista_nombres = new HashMap<>();
		        HashMap<Integer, List<Integer>> lista_id = new HashMap<>();
		        HashMap<Integer, String> lista_horarios = new HashMap<>();
		        
		        List<String> lista_pelicula = new ArrayList<>();
		        while (resultado.next()) {
		        	 int id_exhibicion = resultado.getInt("id_exhibicion");
		        	 int id_pelicula = resultado.getInt("id_pelicula");
	                 String nombre_pelicula = resultado.getString("nombre_pelicula");
	                 String horario = resultado.getString("horario");
	                 String nombre_sucursal = resultado.getString("nombre_sucursal");
	                 int id_sala = resultado.getInt("id_sala");
	
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
      </section>

      <h5><b>CINESTELAR.</b> Todos los derechos reservados 2024.</h5>
    </footer>
	</body>
</html>