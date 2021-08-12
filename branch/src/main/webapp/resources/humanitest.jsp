<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page import="java.text.* , java.util.* , java.io.*"%>
<%@ page import="java.sql.* ,java.text.Format.*"%>
<%@ page import="java.util.Calendar" %>
<% request.setCharacterEncoding("euc-kr"); %>
<%!
private String dateFunc(int str){
    if (str < 10){
        return "0"+Integer.toString(str);
    }else{
        return Integer.toString(str);
    }
}
private boolean resorveFunc(String str , String str2){
    if (Integer.parseInt(str) <= Integer.parseInt(str2) ){
        return true;
    }else{
        return false;
    }
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title></title>
<style type="text/css">
BODY { font-size:9pt; font-family:gulim; }
A         { text-decoration:none; color:black; }
A:visited { text-decoration:none; color:black; }
A:active  { text-decoration:none; color:black; }
A:hover   { text-decoration:none; color:black; }
</style>
</head>
<body>

<%
Calendar cal = Calendar.getInstance();
int year  = request.getParameter("selected_year") ==null ? cal.get(Calendar.YEAR)    : Integer.parseInt(request.getParameter("selected_year")); 
int month = request.getParameter("selected_month")==null ? cal.get(Calendar.MONTH)+1 : Integer.parseInt(request.getParameter("selected_month")); 
%>
<%
String docUrl = "";
String dbDate = "";
String webToday = "";
boolean resorvation = true;
%>
<%
//////////// 전월, 다음월 셋팅 /////////////
int previous_year  = year;
int previous_month = month - 1; 
int next_year      = year;
int next_month     = month + 1;

if(previous_month < 1){ // 1월인 경우 전월값을 전년도 12월 값으로 설정  
 previous_year  = previous_year - 1;
 previous_month = 12;
}

if(next_month > 12){ // 12월인 경우 다음년도의 1월 값으로 설정 
 next_year  = next_year + 1; 
 next_month = 1;  
}
//////////////////////////////////////////
%>
<center>
<table border="1" cellpadding="3" cellspacing="0" style="border-collapse:collapse;">
<tr>
 <td colspan="7" align="center">  
  <table width="200" border="0" cellpadding="1" cellspacing="0">
  <tr>  
  <td align="right">
   <a href="humanitest.jsp?selected_year=<%=previous_year%>&selected_month=<%=previous_month%>">◀</a>   
     </td>
       
     <form method="post" target="_top" style="margin:0px;" action="calendar1.jsp">
  <td align="center">
   <select name="selected_year" onChange="locFunc();">
   <%
   String selected = "";
   for(int y=year-10; y<=year+10; y++){
    if(year == y){ selected=" selected"; }else{ selected=""; }
    %><option value="<%=y%>"<%=selected%>><%=y%>년</option><%
   } // for 
   %>
   </select>
   <select name="selected_month" onChange="locFunc();">
   <%
   selected = "";
   for(int m=1; m<=12; m++){
    if(month == m){ selected=" selected"; }else{ selected=""; }
    %><option value="<%=m%>"<%=selected%>><%=m%>월</option><%
   } // for 
      %>
   </select>
  </td>
  </form>
  
  <td>
   <a href="humanitest.jsp?selected_year=<%=next_year%>&selected_month=<%=next_month%>">▶</a>
     </td>  
  </tr>
  </table>
 </td>
</tr>
<tr>
 <td colspan="7" align="right">
 <%
 ///////////////////////////////////////////////
 int year_of_today  = cal.get(Calendar.YEAR);
 int month_of_today = cal.get(Calendar.MONTH)+1;
 int today          = cal.get(Calendar.DATE);
 webToday = Integer.toString(year_of_today)+dateFunc(month_of_today)+dateFunc(today);
 ///////////////////////////////////////////////
 %>
 <a href="humanitest.jsp?selected_year=<%=year_of_today%>&selected_month=<%=month_of_today%>"><b>오늘 : <%=year_of_today%>년 <%=month_of_today%>월 <%=today%>일</b></a>
 &nbsp;
 </td>
</tr> 
<tr>
 <td align="center"><font color="#DE4332">일</font></td>
 <td align="center">월</td>
 <td align="center">화</td>
 <td align="center">수</td>
 <td align="center">목</td>
 <td align="center">금</td>
 <td align="center"><font color="blue">토</font></td>  
</tr>
<tr>
<%
cal.set(year, month-1, 1);

int last_of_date = cal.getActualMaximum(Calendar.DATE); // 해당월의 마지막 날짜
int week         = cal.get(Calendar.DAY_OF_WEEK);       // 해당월의 시작요일 

for(int i=1; i<week; i++){ %><td>&nbsp;</td><% } // for 

String font_color = "";   
String bg_color   = "";
String str_start_date = "";
//str_start_date = Integer.toString(year)+dateFunc(month)+dateFunc(i);
for(int i=1; i<=last_of_date; i++){
 ///////////////////////////////////////////////
 if(week%7 == 1)     { font_color = "#DE4332"; } // 일요일은  빨간색
 else if(week%7 == 0){ font_color = "blue"; }    // 토요일
 else                { font_color = "#000000"; }
 ///////////////////////////////////////////////
 str_start_date = Integer.toString(year)+dateFunc(month)+dateFunc(i);
 if(year==year_of_today && month_of_today==month && today==i){ bg_color="bgColor='#ffebeb'"; }else{ bg_color=""; }
 %><td style="width:80px; height:50px; vertical-align:top;" id="<%=str_start_date%>" <%=bg_color %> align="left" style="cursor:hand" onClick="javascript:dateFunc()"><font color="<%=font_color%>"><%=i %></font></td>
<%
 if(week%7 == 0){ %></tr><tr><% } // 다음줄로 
 week++;
} // for

////////////////////////////////////////////// 빈칸 채우기 ///////////////////////////////////////////////////////
int starting_point_of_blank_cell = (week%7 == 0) ? 7 : week%7;    
if(starting_point_of_blank_cell!=1){ for(int i=starting_point_of_blank_cell; i<=7; i++){ %><td>&nbsp;</td><% } } // 빈칸 채우기
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%>
</tr>
</table>
[
SELECT SUN, MON, TUE, WED, THU, FRI, SAT <br>
  FROM ( <br>
        SELECT TRUNC(DT + LEVEL-1, 'D') AS WEEK -- 현재 날짜 주의 시작 요일로 잘라버림 <br> 
             , TO_CHAR(DT + LEVEL-1, 'D') AS DW -- 17-06-01부터 DAY값 일-토 1-7 값 매김<br>
             , LPAD(LEVEL, 2, '0') AS DD -- LEVEL의 1-9까지 0 채워줌<br>
          FROM (<br>
--                SELECT TRUNC(SYSDATE,'MM') AS DT -- 현재 달의 첫번째 날 구함<br><br>
                SELECT TO_DATE('20170901','YYYYMMDD') AS DT<br>
                  FROM DUAL<br>
               )<br>
       CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE),'DD') -- 현재 날짜의 마지막 날인 YYYY-MM-DD를 구해 DD만 뽑음 30<br>
       )<br>
 PIVOT (MAX(DD) FOR DW IN ('1' AS SUN, '2' AS MON, '3' AS TUE, '4' AS WED, '5' AS THU, '6' AS FRI, '7' AS SAT)) -- 그룹으로 관리할 컬럼 지정 그룹함수 사용가능 MAX(DD), 기준이 되는 컬럼 DW, 기준이 되는 컬럼 구성하기 위한 값 정의 IN()<br>
-- PIVOT (MAX(DD) FOR DW IN (1 SUN, 2 MON, 3 TUE, 4 WED, 5 THU, 6 FRI, 7 SAT)) <br>
 ORDER BY WEEK;<br>
 ]
</center>
</body>
<script language="JavaScript" type="text/JavaScript">
var reValue = '<%=webToday%>';
var revalue_1 ="";
function locFunc(){
   // alert(document.getElementById("selected_year").value);
    //alert(document.getElementById("selected_month").value);
    location.href="humanitest.jsp?selected_year="+document.getElementById("selected_year").value+"&selected_month="+document.getElementById("selected_month").value;
}
function dateFunc(){
    var idValue = window.event.srcElement.id;
    var idValue_1 = window.event.srcElement;
    
    if (revalue_1 != "")
    {
        revalue_1.style.backgroundColor = '#FFFFFF';
    }
    reValue = idValue
    idValue_1.style.backgroundColor = '#E4E2E2';
    revalue_1 = idValue_1;
    parent.frameFunc(idValue);
    
}
parent.frameFunc('<%=webToday%>');
</script>
</html>
