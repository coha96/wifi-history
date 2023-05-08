# WiFi 위치 기록 및 조회 웹 애플리케이션
이 프로젝트는 WiFi 위치를 기록하고 조회하는 웹 애플리케이션입니다.   
이 애플리케이션은 JSP(Java Server Pages)와 Servlet을 사용하여 구현되었으며, MariaDB 데이터베이스를 사용하여 데이터를 저장합니다.  


### 개발 환경
* Java 1.8
* Apache Tomcat 10.1
* MariaDB 10.4
* Eclipse IDE for Enterprise Java Developers (Version: 2023-03)  
<br/>

## 구현 기능
### 1. WiFi 위치 기록
'wifi.jsp' 페이지에서 현재 위치의 위도와 경도를 입력하면, history_wifi 테이블에 위치 정보를 기록합니다.  
또한, '내 위치 가져오기'를 클릭하면 내 위치 정보를 가져옵니다.   
이때, 데이터는 sequence, x_coord, y_coord, register_date 열로 구성됩니다.

### 2. WiFi 위치 조회
'history.jsp' 페이지에서는 history_wifi 테이블의 위치 정보를 조회할 수 있습니다.  
조회된 데이터는 테이블로 출력되며, 각 데이터는 ID, X좌표, Y좌표, 조회일자, 비고 열로 구성됩니다.  
비고 열에서는 각 데이터의 삭제 버튼이 제공되며, 삭제 버튼을 클릭하면 해당 데이터가 history_wifi 테이블에서 삭제됩니다.

### 3. Open API를 이용한 WiFi 위치 정보 가져오기
'load-wifi.jsp' 페이지에서는 서울시 오픈 API를 가져올 수 있습니다.  
https://data.seoul.go.kr/dataList/OA-20883/S/1/datasetView.do  
이 기능은 Rest API를 이용하여 구현되었습니다.
<br/><br/>
## 구현 방법
### 1. 데이터베이스 구성
MariaDB 데이터베이스에 wifi_db 데이터베이스를 생성하고, history_wifi 테이블을 생성합니다.  
history_wifi 테이블은 sequence, x_coord, y_coord, register_date 열로 구성됩니다. 

### 2. JSP 및 Servlet 구성
* 'wifi.jsp' 페이지에서는 현재 위치의 위도와 경도를 입력할 수 있는 폼을 구성하고, 폼 데이터를 POST 방식으로 전송합니다.
* 'history.jsp' 페이지에서는 history_wifi 테이블의 데이터를 조회하고, 조회된 데이터를 테이블로 출력합니다. 또한, 삭제 버튼을 클릭하면 해당 데이터를 삭제할 수 있습니다.
* 'load-wifi.jsp' 페이지에서는 Rest API를 이용하여 서울시 오픈 API WiFi 위치 정보를 가져옵니다.

### 3. JDBC 드라이버 연결
JDBC 드라이버를 이용하여 MariaDB 데이터베이스에 접속합니다.

### 4. SQL 쿼리 실행
Statement나 PreparedStatement를 이용하여 MariaDB 데이터베이스에서 SQL 쿼리를 실행합니다.

<br/><br/>
## 수행 결과
기한 내에 마스터반 추가과제(“와이파이 정보 북마크 추가 기능 개발")는 수행하지 못하였습니다.  
공부를 위하여 빠른 시일내에 완료 하겠습니다.
README.md는 다시 정리해서 수정 예정
