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
	    <title>Escoger-Pelicula</title>
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
	     	String cliente = request.getParameter("id_cliente");
	     	String cedula = request.getParameter("cedula");
	        String sucursal = request.getParameter("sucursal");
	     %>
	    
	    <%
	    	if(cliente == null){
			    PreparedStatement stmt = conexion.prepareStatement("SELECT * FROM cliente WHERE ced_cliente=? ");
		        stmt.setString(1, cedula);
		        ResultSet rs = stmt.executeQuery();
		       
		        if (!rs.next()) {//si el cliente no existe se regresa a la pagina para que ponga sus datos bien
		            // Redirigir a la página de inicio si el login es correcto
		            response.sendRedirect("Cliente-existente.html"); 
		        }else{
		        	 cliente = rs.getString("id_cliente");
		        }
	    	}
	    %>
	    
	    <% 
	    if(cliente != null){//significa que el cliente ya existe
	    %>
	    
			<section>
			
			<!-- Formulario para seleccionar sucursal -->
		      <form class="container-sect movie" action="Pelicula.jsp" method="GET">
		        <div class="select-container">
		          <select name="sucursal" id="sucursal" class="select-box">
		          
		            <%      
		               //consulta
		               PreparedStatement consulta_sucursal = conexion.prepareStatement("Select * From sucursal");
		
		               ResultSet resultado_sucursal = consulta_sucursal.executeQuery();
		               
		               while (resultado_sucursal.next()) {
		                   int id_sucursal = resultado_sucursal.getInt("id_sucursal");
		                   String nombre = resultado_sucursal.getString("nombre_sucursal");
		           %>
		           <!-- Imprimir las sucursales que devuelve la consulta -->
		                   <option value="<%= id_sucursal %>"><%= nombre %></option>
		                   
		           <%                        
		               }
		           %>
		          </select>
		          <div class="icon-container">
		            <i class="fa-solid fa-caret-down"></i>
		          </div>
		        </div>
		        <!-- Se envia el id_cliente, necesitamos este valor en todo el flujo para insertar al final -->
		        <input type="hidden" name="id_cliente" value="<%= cliente %>"></input>
		        <button type="submit">Seleccionar</button>
		      </form>
			
			</section>
			
		<%
			}
	    %>
	    
		    <section class="cards movies">
	
		    <% 
		        
		        PreparedStatement consulta_pelicula = conexion.prepareStatement("Select * from exhibicion e join sala s on e.id_sala = s.id_sala join pelicula p on e.id_pelicula = p.id_pelicula WHERE s.id_sucursal = ? AND TRUNC(e.fecha) = TRUNC(SYSDATE) ORDER BY p.id_pelicula, e.horario");
		        consulta_pelicula.setString(1, sucursal);
		        
		        ResultSet resultado = consulta_pelicula.executeQuery();
		        //Hashmap es un mapa que contiene un key y un valor
		        HashMap<Integer, String> lista_nombres = new HashMap<>();//creando un mapa para los nombres de las pelicualas
		        HashMap<Integer, List<Integer>> lista_id = new HashMap<>();//funciona para agrupar por el id de pelicula
		        HashMap<Integer, String> lista_horarios = new HashMap<>();//creando un mapa para los horarios
		        
		        while (resultado.next()) {//guardo los valores del resultado de la consulta
	                 int id_pelicula = resultado.getInt("id_pelicula");
	                 int id_exhibicion = resultado.getInt("id_exhibicion");
	                 String nombre_pelicula = resultado.getString("nombre_pelicula");
	                 String horario = resultado.getString("horario");
	
	                 if (!lista_nombres.containsKey(id_pelicula)){//si la lista de nombres no contiene el key(id_pelicula) entonces lo inserto en el mapa
	                     lista_nombres.put(id_pelicula, nombre_pelicula);
	                 }
	
	                 lista_id.computeIfAbsent(id_pelicula, i -> new ArrayList<>()).add(id_exhibicion);//metodo para verificar si esta ausente el key del mapa crea la lista y si no esta ausente solamente adiciona el valor
	
	                 if (!lista_horarios.containsKey(id_exhibicion)){//verifica si la lista de horarios no contiene el key (id_horarios) entonces lo inserto
		                 lista_horarios.put(id_exhibicion, horario);
	                 }
		        }
	
		        for (Map.Entry<Integer, List<Integer>> entry : lista_id.entrySet()) {//entrySet me devuleve el mapa para iterar, lo itero y cada elemento del mapa tiene una estructura (KEY), value
		        	Integer id_pelicula = entry.getKey();//tomo el valor de la llave
	                List<Integer> lista_id_exhibicion = entry.getValue();//tomo el valor en la posicion de esa llave, getvalue me devuelve la lista
	                
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
	    		    
	                for (Integer id_exhibicion : lista_id_exhibicion){//itero sobre la lista que me devolvio getvalue
	                    String horario = lista_horarios.get(id_exhibicion);//tomo los horarios
	
	                    %>
			                <tr>
			                  <td>
			                  <form action="Boleto.jsp" method="GET">
			                  <!-- Se envian los valores para la siguiente pagina  -->
			                  	<input type="hidden" name="id_cliente" value="<%= cliente %>"></input>
			                  	<input type="hidden" name="id_exhibicion" value="<%= id_exhibicion %>"></input>
			                    <button type="submit" ><%= horario %></button>
			                   </form>  
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
