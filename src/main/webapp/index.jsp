<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.w3c.dom.*"%>
<%@ page import="javax.xml.parsers.*"%>
<%@ page import="java.util.*"%>

<%
	//XML 데이터를 호출할 URL
	String url = "http://openapi.gwangjin.go.kr:8088/5962646c4879656139364c6c566c4c/xml/GwangjinFoodHygieneBizRestRestaurant/1471/2470";
	
	//XML에서 가져올 데이터의 필드명을 배열에 저장
	String[] fieldNames ={"UPSO_NM", "SITE_ADDR", "ADMDNG_NM", "SNT_UPTAE_NM"};
	
	//아이템 하나에 해당하는 XML 노드를 담을 리스트
	ArrayList<Map> cafeList = new ArrayList<Map>();
	
	try {
		//XML 파싱 준비
		DocumentBuilderFactory f = DocumentBuilderFactory.newInstance();
		DocumentBuilder b = f.newDocumentBuilder();
		
		//파싱 시작
		Document doc = b.parse(url);
		doc.getDocumentElement().normalize();
		
		//아이템 하나에 해당하는 필드명을 이용하여 나눔
		NodeList items = doc.getElementsByTagName("row");
		
		for (int i = 0; i < items.getLength(); i++) 
		{
			//i번째 row 태그를 가져와서
			Node n = items.item(i);
			
			//노드타입이 엘리먼트가 아닐 경우
			if (n.getNodeType() != Node.ELEMENT_NODE)
				continue;
			
			Element e = (Element) n;
			HashMap cafe = new HashMap();
			
			for(String name : fieldNames){
				//fieldNames에 해당하는 값을 XML 노드에서 가져옴
				NodeList titleList = e.getElementsByTagName(name);
				Element titleElem = (Element) titleList.item(0);
				Node titleNode = titleElem.getChildNodes().item(0);
				
				//가져온 값을 맵에 엘리먼트 이름-값 쌍으로 넣음
				cafe.put(name, titleNode.getNodeValue());
			}
			//데이터를 넣은 맵을 리스트에 추가
			cafeList.add(cafe);
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>CAFE SEARCHER</title>
	
	<style type="text/css">
		@import url(https://fonts.googleapis.com/css?family=Oswald);
		body{
			background-image: url('./image/bg1.png');
			width: 850px;
			margin: 100px auto;
			text-align: center;
			color: white;
		}
		
		a{
			text-decoration: none;
			color: white;
		}

		p[name="title"]{
			font-family: 'Oswald';
			font-size: 70px;
			font-weight: bold;
		}
	
		table{ 
			border : white solid 1px;
			width: 100%;
		}
		th{
			background-color: white;
			color: black;
			height: 25px;
		}
		tr:hover {
			background-color: gray;
		}
		
		.selectbox-div{
			text-align : right; 
			margin-bottom: 15px;
		}
		select{
			width:150px;
			height :25px;
			padding-left: 5px;
		}
		input{
			height: 25px;
			background-color: white;
			color: black;
			font-weight: bold;
		}
		
		.textbox-div{
			text-align : center; 
			margin-top: 15px;
		}
		input[type="text"]{
			width:200px;
			height: 20px;
			padding-left: 10px;
		}
	</style>
	
	<script>
		function refresh(){
			var sel = document.getElementById('selectBox');
			
			if(sel.value=="")
				location.href='http://localhost:8080/WSproject/index.jsp';
			else				//지역 선택시
				location.href='http://localhost:8080/WSproject/index.jsp?ADMDNG=' + sel.value;
		}
		
		function refresh2(){
			var sel = document.getElementById('textBox');
			
			if(sel.value=="")	
				location.href='http://localhost:8080/WSproject/index.jsp';
			else				//특정 카페 검색
				location.href='http://localhost:8080/WSproject/index.jsp?NAMESEARCH=1&UPSO=' + sel.value;
		}
	</script>
</head>

<body>
	<a href="http://localhost:8080/WSproject/"><p name="title">CAFE SEARCHER</p></a>
	
	<div class="selectbox-div" >
		<select id="selectBox">
			<option value="">지역 선택</option>
			<option value="광장동">광장동</option>
			<option value="구의동">구의동</option>
			<option value="군자동">군자동</option>
			<option value="능동">능동</option>
			<option value="자양동">자양동</option>
			<option value="중곡동">중곡동</option>
			<option value="화양동">화양동</option>
		</select>
		<input type="button" value="검색" onclick="refresh()"/>
	</div>
	
	<div>
		<table>
			<tr class="table-title">
				<th width='40px'>번호</th>
				<th width='200px'>카페 이름</th>
				<th>주소</th>
				<th width='40px'>위치</th>
				<th width='40px'>사진</th>
				<th width='40px'>리뷰</th>
			</tr>		
	<%	
	int i=1;
	String ADMDNG = request.getParameter("ADMDNG");
	String UPSO = request.getParameter("UPSO");
	String NAMESEARCH = request.getParameter("NAMESEARCH");
	
	//XML의 모든 노드가 맵으로 변환되어 cafeList에 들어가고, 선택 지역별로 값 출력
	if("광장동".equals(ADMDNG)){
		for(Map cafe : cafeList){
		    if(!cafe.get("ADMDNG_NM").equals("광장동"))
		        continue;       
		    if(!cafe.get("SNT_UPTAE_NM").equals("커피숍"))
		        continue;
	%>	
			<tr>
				<td><%=i %></td>
				<td><%=cafe.get("UPSO_NM") %></td>
				<td><%=cafe.get("SITE_ADDR") %></td>
				<td><a href='./map.jsp?UPSO=<%=cafe.get("UPSO_NM") %>&ADDR=<%=cafe.get("SITE_ADDR") %>'><img src='./image/map.png' width='30px'></a></td>
				<td><a href='./image.jsp?UPSO=<%=cafe.get("UPSO_NM") %>'><img src='./image/image.png' width='30px'></a></td>
				<td><a href='./blog.jsp?UPSO=<%=cafe.get("UPSO_NM") %>'><img src='./image/blog.png' width='30px'></a></td>
			</tr>
	<%		i++;
		}
	}
	else if("구의동".equals(ADMDNG)){
		for(Map cafe : cafeList){
		    if(!(cafe.get("ADMDNG_NM").equals("구의제1동") || cafe.get("ADMDNG_NM").equals("구의제2동") || cafe.get("ADMDNG_NM").equals("구의제3동")))
		        continue;       
		    if(!cafe.get("SNT_UPTAE_NM").equals("커피숍"))
		        continue;
	%>	
			<tr>
				<td><%=i %></td>
				<td><%=cafe.get("UPSO_NM") %></td>
				<td><%=cafe.get("SITE_ADDR") %></td>
				<td><a href='./map.jsp?UPSO=<%=cafe.get("UPSO_NM") %>&ADDR=<%=cafe.get("SITE_ADDR") %>'><img src='./image/map.png' width='30px'></a></td>
				<td><a href='./image.jsp?UPSO=<%=cafe.get("UPSO_NM") %>'><img src='./image/image.png' width='30px'></a></td>
				<td><a href='./blog.jsp?UPSO=<%=cafe.get("UPSO_NM") %>'><img src='./image/blog.png' width='30px'></a></td>
			</tr>
	<%		i++;
		}
	}
	else if("군자동".equals(ADMDNG)){
		for(Map cafe : cafeList){
		    if(!cafe.get("ADMDNG_NM").equals("군자동"))
		        continue;       
		    if(!cafe.get("SNT_UPTAE_NM").equals("커피숍"))
		        continue;
	%>	
			<tr>
				<td><%=i %></td>
				<td><%=cafe.get("UPSO_NM") %></td>
				<td><%=cafe.get("SITE_ADDR") %></td>
				<td><a href='./map.jsp?UPSO=<%=cafe.get("UPSO_NM") %>&ADDR=<%=cafe.get("SITE_ADDR") %>'><img src='./image/map.png' width='30px'></a></td>
				<td><a href='./image.jsp?UPSO=<%=cafe.get("UPSO_NM") %>'><img src='./image/image.png' width='30px'></a></td>
				<td><a href='./blog.jsp?UPSO=<%=cafe.get("UPSO_NM") %>'><img src='./image/blog.png' width='30px'></a></td>
			</tr>
	<%		i++;
		}
	}
	else if("능동".equals(ADMDNG)){
		for(Map cafe : cafeList){
		    if(!cafe.get("ADMDNG_NM").equals("능동"))
		        continue;       
		    if(!cafe.get("SNT_UPTAE_NM").equals("커피숍"))
		        continue;
	%>	
			<tr>
				<td><%=i %></td>
				<td><%=cafe.get("UPSO_NM") %></td>
				<td><%=cafe.get("SITE_ADDR") %></td>
				<td><a href='./map.jsp?UPSO=<%=cafe.get("UPSO_NM") %>&ADDR=<%=cafe.get("SITE_ADDR") %>'><img src='./image/map.png' width='30px'></a></td>
				<td><a href='./image.jsp?UPSO=<%=cafe.get("UPSO_NM") %>'><img src='./image/image.png' width='30px'></a></td>
				<td><a href='./blog.jsp?UPSO=<%=cafe.get("UPSO_NM") %>'><img src='./image/blog.png' width='30px'></a></td>
			</tr>
	<%		i++;
		}
	}
	else if("자양동".equals(ADMDNG)){
		for(Map cafe : cafeList){
		    if(!(cafe.get("ADMDNG_NM").equals("자양제1동") || cafe.get("ADMDNG_NM").equals("자양제2동") || cafe.get("ADMDNG_NM").equals("자양제3동") || cafe.get("ADMDNG_NM").equals("자양제4동")))
		        continue;       
		    if(!cafe.get("SNT_UPTAE_NM").equals("커피숍"))
		        continue;
	%>	
			<tr>
				<td><%=i %></td>
				<td><%=cafe.get("UPSO_NM") %></td>
				<td><%=cafe.get("SITE_ADDR") %></td>
				<td><a href='./map.jsp?UPSO=<%=cafe.get("UPSO_NM") %>&ADDR=<%=cafe.get("SITE_ADDR") %>'><img src='./image/map.png' width='30px'></a></td>
				<td><a href='./image.jsp?UPSO=<%=cafe.get("UPSO_NM") %>'><img src='./image/image.png' width='30px'></a></td>
				<td><a href='./blog.jsp?UPSO=<%=cafe.get("UPSO_NM") %>'><img src='./image/blog.png' width='30px'></a></td>
			</tr>
	<%		i++;
		}
	}
	else if("중곡동".equals(ADMDNG)){
		for(Map cafe : cafeList){
		    if(!(cafe.get("ADMDNG_NM").equals("중곡제1동") || cafe.get("ADMDNG_NM").equals("중곡제2동") || cafe.get("ADMDNG_NM").equals("중곡제3동") || cafe.get("ADMDNG_NM").equals("중곡제4동")))
		        continue;       
		    if(!cafe.get("SNT_UPTAE_NM").equals("커피숍"))
		        continue;
	%>	
			<tr>
				<td><%=i %></td>
				<td><%=cafe.get("UPSO_NM") %></td>
				<td><%=cafe.get("SITE_ADDR") %></td>
				<td><a href='./map.jsp?UPSO=<%=cafe.get("UPSO_NM") %>&ADDR=<%=cafe.get("SITE_ADDR") %>'><img src='./image/map.png' width='30px'></a></td>
				<td><a href='./image.jsp?UPSO=<%=cafe.get("UPSO_NM") %>'><img src='./image/image.png' width='30px'></a></td>
				<td><a href='./blog.jsp?UPSO=<%=cafe.get("UPSO_NM") %>'><img src='./image/blog.png' width='30px'></a></td>
			</tr>
	<%		i++;
		}
	}
	else if("화양동".equals(ADMDNG)){
		for(Map cafe : cafeList){
		    if(!cafe.get("ADMDNG_NM").equals("화양동"))
		        continue;       
		    if(!cafe.get("SNT_UPTAE_NM").equals("커피숍"))
		        continue;
	%>	
			<tr>
				<td><%=i %></td>
				<td><%=cafe.get("UPSO_NM") %></td>
				<td><%=cafe.get("SITE_ADDR") %></td>
				<td><a href='./map.jsp?UPSO=<%=cafe.get("UPSO_NM") %>&ADDR=<%=cafe.get("SITE_ADDR") %>'><img src='./image/map.png' width='30px'></a></td>
				<td><a href='./image.jsp?UPSO=<%=cafe.get("UPSO_NM") %>'><img src='./image/image.png' width='30px'></a></td>
				<td><a href='./blog.jsp?UPSO=<%=cafe.get("UPSO_NM") %>'><img src='./image/blog.png' width='30px'></a></td>
			</tr>
	<%		i++;
		}
	}
	else if("1".equals(NAMESEARCH)){	//카페 이름으로 검색
		for(Map cafe : cafeList){      
		    if(!cafe.get("SNT_UPTAE_NM").equals("커피숍"))
		        continue;
		    if(!cafe.get("UPSO_NM").equals(UPSO))
		        continue; 
	%>	
			<tr>
				<td><%=i %></td>
				<td><%=cafe.get("UPSO_NM") %></td>
				<td><%=cafe.get("SITE_ADDR") %></td>
				<td><a href='./map.jsp?UPSO=<%=cafe.get("UPSO_NM") %>&ADDR=<%=cafe.get("SITE_ADDR") %>'><img src='./image/map.png' width='30px'></a></td>
				<td><a href='./image.jsp?UPSO=<%=cafe.get("UPSO_NM") %>'><img src='./image/image.png' width='30px'></a></td>
				<td><a href='./blog.jsp?UPSO=<%=cafe.get("UPSO_NM") %>'><img src='./image/blog.png' width='30px'></a></td>
			</tr>
	<%		i++;
		}
	}
	else{ %>
	    	<tr>
	    		<td colspan='6' height='150px'>검색할 지역을 선택해 주세요.</td>
	    	</tr>
	<%} %>
		</table>
	</div>
	
	<div class="textbox-div" >
		<input type="text" id="textBox" placeholder="카페 이름 입력"/>
		<input type="button" value="검색" onclick="refresh2()"/>
	</div>
</body>
</html>