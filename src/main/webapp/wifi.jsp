<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String latitude = "";
String longitude = "";

if(request.getParameter("latitude") == null) latitude = "0.0";  
else latitude = request.getParameter("latitude");

if(request.getParameter("longitude") == null) longitude = "0.0";  
else longitude = request.getParameter("longitude");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>와이파이 정보 구하기</title>
<style>
	table {
  	width: 100%;
  	}

            th{width: 100px; background-color: #00cc44; color:white;}
            tr:nth-child(2n) td{background-color: rgb(255, 255, 255);}
            tr:nth-child(2n-1) td{background-color: rgb(230, 230, 230);}    

            .no_data td{height: 50px; text-align: center;}  
</style>
</head>
<body>

    <div class="container">
        <h1>와이파이 정보 구하기</h1>
        <a href="wifi.jsp">홈</a> |
        <a href="history.jsp">위치 히스토리 목록</a> |
        <a href="load-wifi.jsp">Open API 와이파이 정보 가져오기</a> |
		<a href="bookmark.jsp">북마크 보기</a> |
        <a href="bookmark-group.jsp">북마크 그룹 관리</a>
    </div>
    	
    <div style="margin-bottom: 1em;"></div>
    <div style="display: flex; align-items: center;">
    
	<form name="search_form" method="post">
	<input type="hidden" name="mode" value="search">
  	<label for="latitude" style="margin-right: 0.3em;">LAT:</label>
  	<input type="text" id="latitude" name="latitude" value="<%=latitude%>" style="margin-right: 0.1em; padding: 0.1em;"> 
  	<label for="longitude" style="margin-right: 0.3em;">, LNT:</label>
  	<input type="text" id="longitude" name="longitude" value="<%=longitude%>" style="margin-right: 0.1em; padding: 0.1em;">
  	<input type="button" onclick="getLocation()" value="내 위치 가져오기"> 	
    <input type="submit" value="근처 WIFI 정보 보기">
    <div style="width: 0.3em"></div>
    </form>

    </div>

    <div style="margin-bottom: 1em;"></div> 
    <script>
    function getLocation() {
    	if (navigator.geolocation) {
    		navigator.geolocation.getCurrentPosition(showPosition);
   		} else {
   			document.getElementById("demo").innerHTML = "Geolocation is not supported by this browser.";
		}
   	}
    
    function showPosition(position) {
        var latitude = position.coords.latitude;
        var longitude = position.coords.longitude;

        document.getElementById("latitude").value = latitude;
        document.getElementById("longitude").value = longitude;

        // AJAX 요청 생성

        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                console.log("DB에 위치 정보를 저장했습니다.");
            }
        };
        xhttp.open("POST", "history.jsp", true);
        xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhttp.send("latitude=" + latitude + "&longitude=" + longitude);
    }
  </script>    

<%
    // 2. 데이터베이스 연결 정보 설정
    String driver = "org.mariadb.jdbc.Driver";
    String url = "jdbc:mariadb://192.168.123.106/wifi_db";
    String user = "wifi_user";
    String password = "wifi1234";

    // 3. 데이터베이스 연결 객체 생성
    Connection conn = null;
    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, user, password);

        //String latitude = "";
		//String longitude = "";
		
        // 4. SQL 쿼리 작성
            String sql = "SELECT *, ROUND(6371 * 2 * ASIN(SQRT(POWER(SIN((? - x_coord) * PI()/180 / 2), 2) + " +
                    "COS(? * PI()/180) * COS(x_coord * PI()/180) * POWER(SIN((? - y_coord) * PI()/180 / 2), 2))), 4) AS distance " +
                    "FROM seoul_wifi " +
                    "ORDER BY distance ASC " +
                    "LIMIT 20";
        
        // 5. PreparedStatement 객체 생성 및 SQL 쿼리 실행
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, latitude);
        pstmt.setString(2, latitude);
        pstmt.setString(3, longitude);
        ResultSet rs = pstmt.executeQuery();
%>
		<table>
		<tr>
			<th>거리(Km)</th>
			<th>관리번호</th>
			<th>자치구</th>
			<th>와이파이명</th>
			<th>도로명주소</th>
			<th>상세주소</th>
			<th>설치위치(층)</th>
			<th>설치유형</th>
			<th>설치기관</th> 
			<th>서비스구분</th>
			<th>망종류</th>
			<th>설치년도</th>
			<th>실내외구분</th>
			<th>WIFI접속환경</th>
			<th>X좌표</th>
			<th>Y좌표</th> 
			<th>작업일자</th>  
		</tr>

<%
String mode = request.getParameter("mode");
if(mode == "" || mode == null) {%>
	<tr class="no_data">
		<td colspan="17">위치 정보를 입력한 후에 조회해 주세요.</td>
	</tr>
<%}%>

<%
        // 6. ResultSet 객체에서 데이터 가져오기
        while (rs.next() && !(mode == null || mode == "") ) {
            double distance = rs.getDouble("distance");
            String manage_num = rs.getString("manage_num");
            String district = rs.getString("district");
            String wifiName = rs.getString("wifi_name");
            String address = rs.getString("address");
            String detail_address = rs.getString("detail_address");
            String floor = rs.getString("floor");
            String installation_type = rs.getString("installation_type");
            String installation_agency = rs.getString("installation_agency");
            String service_type = rs.getString("service_type");
            String network_type = rs.getString("network_type");
            String installation_year = rs.getString("installation_year");
            String indoor_outdoor_type = rs.getString("indoor_outdoor_type");
            String wifi_access_environment = rs.getString("wifi_access_environment");
            double xCoord = rs.getDouble("x_coord");
            double yCoord = rs.getDouble("y_coord");
            String work_date = rs.getString("work_date");

            // 7. 데이터 출력
            %>
            <tr>
              <td><%=distance%></td>
              <td><%=manage_num%></td>
              <td><%=district%></td>
              <td><a href="detail.jsp"><%=wifiName%></a></td>
              <td><%=address%></td>
              <td><%=detail_address%></td>
              <td><%=floor%></td>
              <td><%=installation_type%></td>
              <td><%=installation_agency%></td>
              <td><%=service_type%></td>
              <td><%=network_type%></td>
              <td><%=installation_year%></td>
              <td><%=indoor_outdoor_type%></td>
              <td><%=wifi_access_environment%></td>
              <td><%=xCoord%></td>
              <td><%=yCoord%></td>
              <td><%=work_date%></td>
            </tr>
            <%
            }

%>
</table>  
<%      
         
        // 8. 데이터베이스 연결 종료
        rs.close();
        pstmt.close();
        conn.close();
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
</body>
</html>