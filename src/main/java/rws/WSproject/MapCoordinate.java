package rws.WSproject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.net.URL;
import javax.servlet.ServletException;


public class MapCoordinate {
    
    public String lat = "";     //위도
    public String lon = "";     //경도
    public String murl = "";    //연결할 URL
    public String mapxml = "";  //받아올 xml
    
    public void getCoordinate(String addr) throws IOException, ServletException{
        
        //인자로 전달받은 주소 정보를 UTF-8로 인코딩
        String enaddr = URLEncoder.encode(addr, "UTF-8");
        
        //검색 url 설정
        murl = "http://openapi.map.naver.com/api/geocode?key=8cc72f4c86ad7cf81f2ba5c992f04533&encoding=utf-8&coord=latlng&output=xml&query="+enaddr;

        //url 연결
        URL mapXmlUrl = new URL(murl);
        HttpURLConnection urlConn = (HttpURLConnection)mapXmlUrl.openConnection();
        urlConn.setDoOutput(true);
        urlConn.setRequestMethod("POST");

        int len = urlConn.getContentLength();   //받아온 xml의 길이

        if(len > 0){ 
            BufferedReader br=new BufferedReader(new InputStreamReader(urlConn.getInputStream(), "EUC-KR"));
            String inputLine="";
              
            while((inputLine=br.readLine())!=null)
                mapxml += inputLine;      //한글자씩 읽어옴
              
            if(mapxml != null){
                if(mapxml.indexOf("</item>") > -1 ){   //item이 있으면 좌표를 받아옴 
                    lon = mapxml.substring( mapxml.indexOf("<x>")+3, mapxml.indexOf("</x>") ) ; //경도값 저장
                    lat = mapxml.substring( mapxml.indexOf("<y>")+3, mapxml.indexOf("</y>") ) ; //위도값 저장
                }
            }
            br.close();   
        }
    }
    
    public String getX(){   //경도값 반환
        return lon;
    }
    
    public String getY(){   //위도값 반환
        return lat;
    }
}
