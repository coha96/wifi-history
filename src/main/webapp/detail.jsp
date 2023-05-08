<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>와이파이 정보 구하기</title>
<style>
	table {
		display: flex;
		flex-direction: left;
		align-items: center;
		font-size: 14px;
		width: 100%;
	}

	th {
		background-color: #00cc44; 
		color: white;
		padding: 10px 170px;
		width: 100%;
	}

	td {
		padding: 10px;
	}

	tr:nth-child(2n) td{
		background-color: rgb(255, 255, 255);
	}

	tr:nth-child(2n-1) td{
		background-color: rgb(230, 230, 230);
	}    

</style>
</head>
<body>
    <div class="container">
        <h1>와이파이 정보 구하기</h1>
        <a href="wifi.jsp">홈</a> |
        <a href="history.jsp">위치 히스토리 목록</a> |
        <a href="load-wifi.jsp">Open API 와이파이 정보 가져오기</a> |
		<a href="history.jsp">북마크 보기</a> |
        <a href="bookmark-group.jsp">북마크 그룹 관리</a>
    </div>
	    <div style="margin-bottom: 1em;"></div> 
<table>
	<tr>
		<th>거리(Km)</th>
	</tr>
	<tr>
		<th>관리번호</th>
	</tr>
	<tr>
		<th>자치구</th>
	</tr>
	<tr>
		<th>와이파이명</th>
	</tr>
	<tr>
		<th>도로명주소</th>
	</tr>
	<tr>
		<th>상세주소</th>
	</tr>
	<tr>
		<th>설치위치(층)</th>
	</tr>
	<tr>
		<th>설치유형</th>
	</tr>
	<tr>
		<th>설치기관</th> 
	</tr>
	<tr>
		<th>서비스구분</th>
	</tr>
	<tr>
		<th>망종류</th>
	</tr>
	<tr>
		<th>설치년도</th>
	</tr>
	<tr>
		<th>실내외구분</th>
	</tr>
	<tr>
		<th>WIFI접속환경</th>
	</tr>
	<tr>
		<th>X좌표</th>
	</tr>
		<tr>
		<th>Y좌표 </th>
	</tr>
		<tr>
		<th>작업일자</th>
	</tr>
	</table>
</body>
</html>