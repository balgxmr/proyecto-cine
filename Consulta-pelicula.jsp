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
        <a href="https://www.google.com/"><i class="fa-solid fa-magnifying-glass"></i></a>
        <a href="https://www.instagram.com/"><i class="fa-brands fa-instagram"></i></a>
        <a href="https://www.facebook.com/?locale=es_LA"><i class="fa-brands fa-facebook"></i></a>
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
		
		if (pelicula != ""){//verificar si ya el usuario ingreso el valor
		
			
		%>
			<section class="cards movies">
			
			<% 
			    PreparedStatement consulta_pelicula = conexion.prepareStatement("select p.id_pelicula, p.nombre_pelicula from pelicula p WHERE nombre_pelicula LIKE ? AND ROWNUM = 1");
				consulta_pelicula.setString(1, "%" + pelicula + "%");
		        
		        ResultSet resultado = consulta_pelicula.executeQuery();
			
		        if (resultado.next()){
		        	int id_pelicula = resultado.getInt("id_pelicula");
		        	String nombre_pelicula = resultado.getString("nombre_pelicula");
		        	
				    PreparedStatement consulta_pelicula_exibicion = conexion.prepareStatement("select e.id_exhibicion, suc.nombre_sucursal, e.horario, s.id_sala from pelicula p join exhibicion e on p.id_pelicula = e.id_pelicula join sala s on e.id_sala = s.id_sala join sucursal suc on s.id_sucursal = suc.id_sucursal WHERE p.id_pelicula = ? AND TRUNC(e.fecha) = TRUNC(SYSDATE) ORDER BY id_sala, horario");
				    consulta_pelicula_exibicion.setInt(1, id_pelicula);
			        
			        ResultSet resultado_exhibicion = consulta_pelicula_exibicion.executeQuery();
			        //Hashmap es un mapa que contiene un key y un valor
			        HashMap<Integer, List<Integer>> lista_id = new HashMap<>();//funciona para agrupar por el id de pelicula
			        HashMap<Integer, String> lista_sucursal = new HashMap<>();//creando un mapa para los nombres de las sucursales
			        HashMap<Integer, String> lista_horarios = new HashMap<>();//creando un mapa para los horarios
			        
			        List<String> lista_pelicula = new ArrayList<>();
			        while (resultado_exhibicion.next()) {//guardo los valores del resultado de la consulta
		                 int id_sala = resultado_exhibicion.getInt("id_sala");
			        	 int id_exhibicion = resultado_exhibicion.getInt("id_exhibicion");
		                 String nombre_sucursal = resultado_exhibicion.getString("nombre_sucursal");
		                 String horario = resultado_exhibicion.getString("horario");
		
		                 lista_id.computeIfAbsent(id_sala, i -> new ArrayList<>()).add(id_exhibicion);//metodo para verificar si esta ausente el key del mapa crea la lista y si no esta ausente solamente adiciona el valor

		                 if (!lista_sucursal.containsKey(id_sala)){//si la lista de nombres no contiene el key(id_pelicula) entonces lo inserto en el mapa
		                	 lista_sucursal.put(id_sala, nombre_sucursal);
		                 }
		
		                 if (!lista_horarios.containsKey(id_exhibicion)){//verifica si la lista de horarios no contiene el key (id_horarios) entonces lo inserto
			                 lista_horarios.put(id_exhibicion, horario);
		                 }
			        }
		
			        for (Map.Entry<Integer, List<Integer>> entry : lista_id.entrySet()) {//entrySet me devuleve el mapa para iterar, lo itero y cada elemento del mapa tiene una estructura (KEY), value
			        	Integer id_sala = entry.getKey();//tomo el valor de la llave
		                List<Integer> lista_id_exhibicion = entry.getValue();//tomo el valor en la posicion de esa llave, getvalue me devuelve la lista
	                    String nombre_sucursal = lista_sucursal.get(id_sala);
		                
		                %>
							<div class="card movie">
					          <img src="img/imagen_peliculas.jpg" width="250px" height="400px"/>
					          <div class="card-info movie">
					            <h2><%= nombre_pelicula%></h2>
					            <h2>SALA: <%= id_sala%></h2>
					            <h2><%= nombre_sucursal%></h2>
					            <hr />
					            <h3>Horarios</h3>
					            <table>
		    		    <% 
		    		    
		                for (Integer id_exhibicion : lista_id_exhibicion){//itero sobre la lista que me devolvio getvalue
		                    String horario = lista_horarios.get(id_exhibicion);//tomo los horarios
		
		                    %>
				                <tr>
				                  <td>
				                  <div >
				                    <button><%= horario %></button>
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
