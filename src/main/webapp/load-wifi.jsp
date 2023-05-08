<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
Connection conn2 = DriverManager.getConnection("jdbc:mariadb://192.168.123.106/wifi_db", "wifi_user", "wifi1234");
PreparedStatement pstmt = conn2.prepareStatement("INSERT INTO seoul_wifi(manage_num, district, wifi_name, address, detail_address, floor, installation_type, installation_agency, service_type, network_type, installation_year, indoor_outdoor_type, wifi_access_environment, x_coord, y_coord, work_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

int offset = 1; // 요청 시작 위치
int limit = 1000; // 한 번에 가져올 데이터 건수
int count = 0;

while (true) {
    String apiUrl = "http://openapi.seoul.go.kr:8088/71527a48477375623837754b786965/json/TbPublicWifiInfo/" + offset + "/" + (offset + limit - 1) + "/";
    URL url = new URL(apiUrl);
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");
    conn.setRequestProperty("Content-type", "application/json");

    int responseCode = conn.getResponseCode();
    if (responseCode != 200) {
        System.err.println("Failed to get data from API.");
        System.exit(1);
    }

    Scanner scanner = new Scanner(url.openStream());
    StringBuilder jsonStrBuilder = new StringBuilder();
    while (scanner.hasNext()) {
        jsonStrBuilder.append(scanner.nextLine());
    }
    scanner.close();

    String jsonString = jsonStrBuilder.toString();

    JSONObject jsonObject = new JSONObject(jsonString);
    JSONObject rootObject = jsonObject.getJSONObject("TbPublicWifiInfo");
    JSONArray jsonArray = rootObject.getJSONArray("row");

    for (int i = 0; i < jsonArray.length(); i++) {
    	JSONObject rowObject = jsonArray.getJSONObject(i);        
        String manageNum = rowObject.optString("X_SWIFI_MGR_NO");
        String district = rowObject.optString("X_SWIFI_WRDOFC");
        String wifiName = rowObject.optString("X_SWIFI_MAIN_NM");
        String address = rowObject.optString("X_SWIFI_ADRES1");
        String detailAddress = rowObject.optString("X_SWIFI_ADRES2");
        String floor = rowObject.optString("X_SWIFI_INSTL_FLOOR");
        String installationType = rowObject.optString("X_SWIFI_INSTL_TY");
        String installationAgency = rowObject.optString("X_SWIFI_INSTL_MBY");
        String serviceType = rowObject.optString("X_SWIFI_SVC_SE");
        String networkType = rowObject.optString("X_SWIFI_CMCWR");
        String installationYear = rowObject.optString("X_SWIFI_CNSTC_YEAR");
        String indoorOutdoorType = rowObject.optString("X_SWIFI_INOUT_DOOR");
        String wifiAccessEnvironment = rowObject.optString("X_SWIFI_REMARS3");
        String xCoord = rowObject.optString("LAT");
        String yCoord = rowObject.optString("LNT");
        String workDate = rowObject.optString("WORK_DTTM");

        //pstmt.setString(1, "");
        pstmt.setString(1, manageNum);
        pstmt.setString(2, district);
        pstmt.setString(3, wifiName);
        pstmt.setString(4, address);
        pstmt.setString(5, detailAddress);
        pstmt.setString(6, floor);
        pstmt.setString(7, installationType);
        pstmt.setString(8, installationAgency);
        pstmt.setString(9, serviceType);
        pstmt.setString(10, networkType);
        pstmt.setString(11, installationYear);
        pstmt.setString(12, indoorOutdoorType);
        pstmt.setString(13, wifiAccessEnvironment);
        pstmt.setString(14, xCoord);
        pstmt.setString(15, yCoord);
        pstmt.setString(16, workDate);

        pstmt.executeUpdate();
        count++;
    }
    offset += limit;

    if (jsonArray.length() < limit) {
        break;
    }
}
out.print("<div style='text-align:center; font-size:24px; font-weight:bold;'>" + count + "개의 WIFI 정보를 정상적으로 저장하였습니다.</div><br>");
pstmt.close();
conn2.close();
%>
<div style="text-align: center;"><a href="wifi.jsp">홈으로 가기</a></div>
</body>
</html>
