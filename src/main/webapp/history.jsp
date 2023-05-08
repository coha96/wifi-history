<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
String latitude = request.getParameter("latitude");
String longitude = request.getParameter("longitude");

try {
    // DB 연결
    Class.forName("org.mariadb.jdbc.Driver");
    String url = "jdbc:mariadb://192.168.123.106/wifi_db";
    String user = "wifi_user";
    String password = "wifi1234";
    Connection conn = DriverManager.getConnection(url, user, password);

 // 데이터 존재 여부 확인
    String checkSql = "SELECT COUNT(*) FROM history_wifi";
    Statement checkStmt = conn.createStatement();
    ResultSet rs = checkStmt.executeQuery(checkSql);
    rs.next();
    int count = rs.getInt(1);
    checkStmt.close();

    // sequence 값 설정
    int sequence;
    if (count == 0) {
        sequence = 1;
    } else {
        String getLastSeqSql = "SELECT sequence FROM history_wifi ORDER BY sequence DESC LIMIT 1";
        Statement getLastSeqStmt = conn.createStatement();
        ResultSet getLastSeqRs = getLastSeqStmt.executeQuery(getLastSeqSql);
        getLastSeqRs.next();
        sequence = getLastSeqRs.getInt("sequence") + 1;
        getLastSeqStmt.close();
    }

    // 데이터 삽입
    String insertSql = "INSERT INTO history_wifi (sequence, x_coord, y_coord, register_date) VALUES (?, ?, ?, NOW())";
    PreparedStatement insertStmt = conn.prepareStatement(insertSql);
    insertStmt.setInt(1, sequence);
    insertStmt.setDouble(2, Double.parseDouble(latitude));
    insertStmt.setDouble(3, Double.parseDouble(longitude));
    insertStmt.executeUpdate();
    insertStmt.close();
    conn.close();
} catch (Exception e) {
    e.printStackTrace();
}

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

            th{width: 100px; background-color: rgb(43, 224, 43); color:white;}
            tr:nth-child(2n) td{background-color: rgb(255, 255, 255);}
            tr:nth-child(2n-1) td{background-color: rgb(230, 230, 230);}    

            .no_data td{height: 50px; text-align: center;}  
</style>
</head>
<body>
    <div class="container">
        <h1>위치 히스토리 목록</h1>
        <a href="wifi.jsp">홈</a> |
        <a href="history.jsp">위치 히스토리 목록</a> |
        <a href="load-wifi.jsp">Open API 와이파이 정보 가져오기</a>
    </div>	
    
    	<table>
			<tr>
				<th style="width: 30px;">ID</th>
            	<th style="width: 100px;">X좌표</th>
            	<th style="width: 100px;">Y좌표</th>
        		<th style="width: 150px;">조회일자</th>
            	<th style="width: 30px;">비고</th>

			</tr>
		<%
			try {
				// DB 연결
			    Class.forName("org.mariadb.jdbc.Driver");
			    String url = "jdbc:mariadb://192.168.123.106/wifi_db";
			    String user = "wifi_user";
			    String password = "wifi1234";
			    Connection conn = DriverManager.getConnection(url, user, password);
			    
			    // 삭제 실행
			    String deleteSql = "DELETE FROM history_wifi WHERE sequence=?";
			    PreparedStatement deletePstmt = conn.prepareStatement(deleteSql);
			    String deleteId = request.getParameter("deleteId");
			    if (deleteId != null) {
			        deletePstmt.setInt(1, Integer.parseInt(deleteId));
			        deletePstmt.executeUpdate();
			    }
			    deletePstmt.close();
			    // 쿼리 실행
			    String sql = "SELECT * FROM history_wifi ORDER BY sequence DESC";
			    PreparedStatement pstmt = conn.prepareStatement(sql);
			    ResultSet rs = pstmt.executeQuery();
			
			    // 결과 출력
			    while(rs.next()) {
			        int sequence = rs.getInt("sequence");
			        double x_coord = rs.getDouble("x_coord");
			        double y_coord = rs.getDouble("y_coord");
			        String register_date = rs.getString("register_date");
		%>
			<tr>
				<td><%= sequence %></td>
				<td><%= x_coord %></td>
				<td><%= y_coord %></td>
				<td><%= register_date %></td>
				<td style="text-align: center;">
            	<form method="post" action="history.jsp">
                <input type="hidden" name="deleteId" value="<%= sequence %>">
                <button type="submit">삭제</button>
            	</form>
        		</td>
        	</tr>
<%
	    }
			    rs.close();
			    pstmt.close();
			    conn.close();
			    } catch (Exception e) {
			    	e.printStackTrace();
}
%>
	</table>

</body>
</html>