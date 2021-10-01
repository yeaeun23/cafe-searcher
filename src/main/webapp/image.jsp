<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.w3c.dom.*"%>
<%@ page import="javax.xml.parsers.*"%>
<%@ page import="java.util.*"%>
<%
	String UPSO = request.getParameter("UPSO");
	
	//XML 데이터를 호출할 URL
	String url = "http://openapi.naver.com/search?key=92598f5d8da0fede511b86aefa037f27&target=image&query="+UPSO;
	
	//XML에서 가져올 데이터의 필드명을 배열에 저장
	String[] fieldNames ={"link"};
	
	//아이템 하나에 해당하는 XML 노드를 담을 리스트
	ArrayList<Map> imageList = new ArrayList<Map>();
	
	try {
		//XML 파싱 준비
		DocumentBuilderFactory f = DocumentBuilderFactory.newInstance();
		DocumentBuilder b = f.newDocumentBuilder();
		
		//파싱 시작
		Document doc = b.parse(url);
		doc.getDocumentElement().normalize();
		
		//아이템 하나에 해당하는 필드명을 이용하여 나눔
		NodeList items = doc.getElementsByTagName("item");
		
		for (int i = 0; i < items.getLength(); i++) 
		{
			//i번째 item 태그를 가져와서
			Node n = items.item(i);
			
			//노드타입이 엘리먼트가 아닐 경우
			if (n.getNodeType() != Node.ELEMENT_NODE)
				continue;
			
			Element e = (Element) n;
			HashMap image = new HashMap();
			
			for(String name : fieldNames){
				//fieldNames에 해당하는 값을 XML 노드에서 가져옴
				NodeList titleList = e.getElementsByTagName(name);
				Element titleElem = (Element) titleList.item(0);
				Node titleNode = titleElem.getChildNodes().item(0);
				
				//가져온 값을 맵에 엘리먼트 이름-값 쌍으로 넣음
				image.put(name, titleNode.getNodeValue());
			}
			//데이터를 넣은 맵을 리스트에 추가
			imageList.add(image);
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
	
		p[name="path"]{
			font-size:25px;
			text-align: left;
			font-weight: bold;
		}
		
		table{ 
			margin: auto;
		}
		td{
			padding: 5px;
		}
	</style>
</head>

<body>
	<a href="http://localhost:8080/WSproject/"><p name="title">CAFE SEARCHER</p></a>
	
	<div><p name="path">이미지 검색 > <%=UPSO %></p></div>
	
	<div>
		<table>	
			<tr>
	<%	int i=1;
		
		for(Map image : imageList){
			if(i%3==0){		//3개씩 출력
			    %></tr><tr><%
			}	    %>
				<td><img src='<%=image.get("link") %>' width="260px"/></td>
	<%		i++;
		}
		
		//i의 값이 변하지 않았다면, List에 item이 없다는 것
		if(i==1){%>	
		    <td><br><br>검색된 이미지가 없습니다.</td>
		<%}
			%></tr>
		</table>
	</div>

</body>
</html>