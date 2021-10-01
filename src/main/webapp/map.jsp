<%@ page import="rws.WSproject.MapCoordinate" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
	</style>
</head>

<body>
	<a href="http://localhost:8080/WSproject/"><p name="title">CAFE SEARCHER</p></a>
	
	<%String UPSO = request.getParameter("UPSO");%>
	<div><p name="path">위치 검색 > <%=UPSO %></p></div>
	
	<div id="map" style="margin:5px auto;"></div>	<!-- 지도를 표시할 영역 -->
	
	<script type="text/javascript" src="http://openapi.map.naver.com/openapi/naverMap.naver?ver=2.0&key=8cc72f4c86ad7cf81f2ba5c992f04533&coord=latlng"></script> 
	<script type="text/javascript">
		nhn.api.map.setDefaultPoint('LatLng');
		
		<%request.setCharacterEncoding("UTF-8");
		String ADDR = request.getParameter("ADDR");
		
		//클래스 객체 생성
		MapCoordinate m=new MapCoordinate();
		m.getCoordinate(ADDR);	//함수 호출. 주소를 줄테니 좌표로 변환해라!
		
		//MapCoordinate 클래스의 getCoordinate 함수에서 구한 좌표값을 가져옴
		String lat=m.getY();
		String lon=m.getX();%>
		
		var oMap = new nhn.api.map.Map(document.getElementById('map'), {
		      point : new nhn.api.map.LatLng(<%=lat%>, <%=lon%>),	
		      zoom : 12,                                                                        
		      enableWheelZoom : true,                                                  
		      enableDragPan : true,                                                      
		      enableDblClickZoom : false,                                            
		      mapMode : 0,                                                               
		      activateTrafficMap : false,                                              
		      activateBicycleMap : false,                                            
		      minMaxLevel : [ 5, 13 ],                                                  
		      size : new nhn.api.map.Size(800, 450)	//지도 크기 
		});  
		 
		var oSlider = new nhn.api.map.ZoomControl();
		oMap.addControl(oSlider);
		oSlider.setPosition({
		      top : 10,
		      left : 10
		});
		  
		var oSize = new nhn.api.map.Size(30, 40);	//마커 크기
		var oOffset = new nhn.api.map.Size(30, 40);
		var oPoint = new nhn.api.map.LatLng(<%=lat%>, <%=lon%>);
		var oIcon = new nhn.api.map.Icon('http://static.naver.com/maps2/icons/pin_spot2.png', oSize, oOffset);	//마커 이미지
		
		var oMarker = new nhn.api.map.Marker(oIcon, {
		      point:oPoint,
		      zIndex:1,
		      //title: ""
		});
		    
		var oLabel = new nhn.api.map.MarkerLabel();
		
		oMap.addOverlay(oLabel); 
		oMap.addOverlay(oMarker);
		oLabel.setVisible(true,oMarker);
		  
		oMap.attach('mouseenter',function(oCustomEvent){    //마우스엔터,휠,클릭 등
		      var oTarget = oCustomEvent.target;
		      if(oTarget instanceof nhn.api.map.Marker){
		            var oMarker = oTarget;
		            oLabel.setVisible(true,oMarker);
		      }
		  });
	</script>
</body>
</html>
