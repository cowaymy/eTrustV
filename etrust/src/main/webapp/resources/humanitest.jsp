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
//////////// ����, ������ ���� /////////////
int previous_year  = year;
int previous_month = month - 1; 
int next_year      = year;
int next_month     = month + 1;

if(previous_month < 1){ // 1���� ��� �������� ���⵵ 12�� ������ ����  
 previous_year  = previous_year - 1;
 previous_month = 12;
}

if(next_month > 12){ // 12���� ��� �����⵵�� 1�� ������ ���� 
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
   <a href="humanitest.jsp?selected_year=<%=previous_year%>&selected_month=<%=previous_month%>">��</a>   
     </td>
       
     <form method="post" target="_top" style="margin:0px;" action="calendar1.jsp">
  <td align="center">
   <select name="selected_year" onChange="locFunc();">
   <%
   String selected = "";
   for(int y=year-10; y<=year+10; y++){
    if(year == y){ selected=" selected"; }else{ selected=""; }
    %><option value="<%=y%>"<%=selected%>><%=y%>��</option><%
   } // for 
   %>
   </select>
   <select name="selected_month" onChange="locFunc();">
   <%
   selected = "";
   for(int m=1; m<=12; m++){
    if(month == m){ selected=" selected"; }else{ selected=""; }
    %><option value="<%=m%>"<%=selected%>><%=m%>��</option><%
   } // for 
      %>
   </select>
  </td>
  </form>
  
  <td>
   <a href="humanitest.jsp?selected_year=<%=next_year%>&selected_month=<%=next_month%>">��</a>
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
 <a href="humanitest.jsp?selected_year=<%=year_of_today%>&selected_month=<%=month_of_today%>"><b>���� : <%=year_of_today%>�� <%=month_of_today%>�� <%=today%>��</b></a>
 &nbsp;
 </td>
</tr> 
<tr>
 <td align="center"><font color="#DE4332">��</font></td>
 <td align="center">��</td>
 <td align="center">ȭ</td>
 <td align="center">��</td>
 <td align="center">��</td>
 <td align="center">��</td>
 <td align="center"><font color="blue">��</font></td>  
</tr>
<tr>
<%
cal.set(year, month-1, 1);

int last_of_date = cal.getActualMaximum(Calendar.DATE); // �ش���� ������ ��¥
int week         = cal.get(Calendar.DAY_OF_WEEK);       // �ش���� ���ۿ��� 

for(int i=1; i<week; i++){ %><td>&nbsp;</td><% } // for 

String font_color = "";   
String bg_color   = "";
String str_start_date = "";
//str_start_date = Integer.toString(year)+dateFunc(month)+dateFunc(i);
for(int i=1; i<=last_of_date; i++){
 ///////////////////////////////////////////////
 if(week%7 == 1)     { font_color = "#DE4332"; } // �Ͽ�����  ������
 else if(week%7 == 0){ font_color = "blue"; }    // �����
 else                { font_color = "#000000"; }
 ///////////////////////////////////////////////
 str_start_date = Integer.toString(year)+dateFunc(month)+dateFunc(i);
 if(year==year_of_today && month_of_today==month && today==i){ bg_color="bgColor='#ffebeb'"; }else{ bg_color=""; }
 %><td style="width:80px; height:50px; vertical-align:top;" id="<%=str_start_date%>" <%=bg_color %> align="left" style="cursor:hand" onClick="javascript:dateFunc()"><font color="<%=font_color%>"><%=i %></font></td>
<%
 if(week%7 == 0){ %></tr><tr><% } // �����ٷ� 
 week++;
} // for

////////////////////////////////////////////// ��ĭ ä��� ///////////////////////////////////////////////////////
int starting_point_of_blank_cell = (week%7 == 0) ? 7 : week%7;    
if(starting_point_of_blank_cell!=1){ for(int i=starting_point_of_blank_cell; i<=7; i++){ %><td>&nbsp;</td><% } } // ��ĭ ä���
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%>
</tr>
</table>
[
SELECT SUN, MON, TUE, WED, THU, FRI, SAT <br>
  FROM ( <br>
        SELECT TRUNC(DT + LEVEL-1, 'D') AS WEEK -- ���� ��¥ ���� ���� ���Ϸ� �߶���� <br> 
             , TO_CHAR(DT + LEVEL-1, 'D') AS DW -- 17-06-01���� DAY�� ��-�� 1-7 �� �ű�<br>
             , LPAD(LEVEL, 2, '0') AS DD -- LEVEL�� 1-9���� 0 ä����<br>
          FROM (<br>
--                SELECT TRUNC(SYSDATE,'MM') AS DT -- ���� ���� ù��° �� ����<br><br>
                SELECT TO_DATE('20170901','YYYYMMDD') AS DT<br>
                  FROM DUAL<br>
               )<br>
       CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE),'DD') -- ���� ��¥�� ������ ���� YYYY-MM-DD�� ���� DD�� ���� 30<br>
       )<br>
 PIVOT (MAX(DD) FOR DW IN ('1' AS SUN, '2' AS MON, '3' AS TUE, '4' AS WED, '5' AS THU, '6' AS FRI, '7' AS SAT)) -- �׷����� ������ �÷� ���� �׷��Լ� ��밡�� MAX(DD), ������ �Ǵ� �÷� DW, ������ �Ǵ� �÷� �����ϱ� ���� �� ���� IN()<br>
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
