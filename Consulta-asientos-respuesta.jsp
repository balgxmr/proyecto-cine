<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.lang.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- CSS -->
    <link rel="stylesheet" href="style.css" />
    <!-- Iconos: Font-Awesome -->
    <script src="https://kit.fontawesome.com/5ddbd215bf.js" crossorigin="anonymous"></script>
    <title>Consultar-asientos-respuesta</title>
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
    	<% String sala = request.getParameter("sala"); %>
      <section class="cards">
      	<div class="card form">
          <div class="card-info form">
            <h2>ASIENTOS</h2>
            <h3>Ocupados del dia de hoy en la sala: <%= sala %></h3>

            <div class="asiento-contexto">
              <td>
                <img class="asiento-disp" src="img/chair_disponible_24dp_FILL0_wght400_GRAD0_opsz24.svg" alt="" />
                <h4>Disponible</h4>
              </td>
              <td>
                <img class="asiento-ocup" src="img/chair_ocupado_24dp_FILL0_wght400_GRAD0_opsz24.svg" alt="" />
                <h4>Ocupado</h4>
                <br>
                <br>
                <br>
                <br>
                  
                
              </td>
            </div>

            <div class="asiento-seleccion">
              <table>
              
              <%-- Inicializar variables de conexion --%>
		    <% Connection conexion = null; %>
		    <% CallableStatement llamada = null; %>
              
        <% // captura de los valores que vienen desde el formulario.
        	
	        	        
	      //creamos la conexion
            // Cargar el driver de Oracle
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Establecer la conexion con la base de datos Oracle
            String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:xe";
            String username = "jose";
            String password = "123";
            conexion = DriverManager.getConnection(jdbcUrl, username, password);
	        
	        PreparedStatement consulta_sucursal = conexion.prepareStatement("Select a.id_asiento, a.fila, a.columna, MAX(r.id_asiento) as reserva from asiento a join sala s on a.id_sala = s.id_sala join exhibicion e on s.id_sala = e.id_sala LEFT JOIN reserva r on a.id_asiento = r.id_asiento AND e.id_exhibicion = r.id_exhibicion WHERE s.id_sala = ? AND TRUNC(e.fecha) = TRUNC(SYSDATE) GROUP BY a.id_asiento, a.fila, a.columna ORDER BY a.fila, a.columna");
	        consulta_sucursal.setString(1, sala);
	        
	        ResultSet resultado = consulta_sucursal.executeQuery();
	        
	        HashMap<String, List<Integer>> lista_asientos = new HashMap<>();//funciona para agrupar por el id de asientos
	        HashMap<Integer, Boolean> lista_reserva = new HashMap<>();//creando un mapa para la lista de reservas

	        while (resultado.next()) {//guardo los valores del resultado de la consulta
	        	String fila = resultado.getString("fila");
	        	int id_asiento = resultado.getInt("id_asiento");
				int reserva = resultado.getInt("reserva");
				
                lista_asientos.computeIfAbsent(fila, i -> new ArrayList<>()).add(id_asiento);//metodo para verificar si esta ausente el key del mapa crea la lista y si no esta ausente solamente adiciona el valor
                
                if (!lista_reserva.containsKey(id_asiento)){//si la lista de reservas no contiene el key(id_asiento) entonces lo inserto en el mapa
                    lista_reserva.put(id_asiento, reserva != 0);
                }
	        }
	        
	        for (Map.Entry<String, List<Integer>> entry : lista_asientos.entrySet()) {//entrySet me devuleve el mapa para iterar, lo itero y cada elemento del mapa tiene una estructura (KEY), value
	        	String fila = entry.getKey();//tomo el valor de la llave
                List<Integer> lista_id_asiento = entry.getValue();//tomo el valor en la posicion de esa llave, getvalue me devuelve la lista
                
                %>
					<tr>
    		 	<% 
    		 
                for (Integer id_asiento : lista_id_asiento){//itero sobre la lista que me devolvio getvalue
                    Boolean reserva_asiento = lista_reserva.get(id_asiento);//si el asiento existe significa que esta reservado, eso lo guardo en un booleano

                	%>
						<td>
							<div class="card form">
								<div class="asiento-contexto">


								<%
									if(reserva_asiento){//imprimir el asiento ocupado
								%>		
										<img class="asiento-ocup" src="img/chair_ocupado_24dp_FILL0_wght400_GRAD0_opsz24.svg" alt="" />		
								<%
									}
									else{//imprimir el asiento desocupado
								%>		
										<img class="asiento-disp" src="img/chair_disponible_24dp_FILL0_wght400_GRAD0_opsz24.svg" alt="" />		
								<%
									}
								%>
								
								</div>							
							</div>	
						</td>
   		 			<%
   		 			
                }
    		 	
    		 	%>
		 			</tr>               		 
		 		<%
		 		
	        }
        	%>
      		
      			</table>
            
            </div>

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
