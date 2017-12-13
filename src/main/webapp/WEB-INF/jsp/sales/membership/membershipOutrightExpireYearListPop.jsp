<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">


$(document).ready(function() {
    
    $("#reportInvoiceForm").empty();
    
});

function validRequiredField(){
	
	var valid = true;
	var message = "";
	
	if(!($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0) || !($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)){
		if(($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0) || ($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)){
			valid = false;
            message += "* Please select the order date (From & To).\n";
	    }
	}
	
	if(!($("#mypExpireMonthFr").val() == null || $("#mypExpireMonthFr").val().length == 0) || !($("#mypExpireMonthTo").val() == null || $("#mypExpireMonthTo").val().length == 0)){
        if(($("#mypExpireMonthFr").val() == null || $("#mypExpireMonthFr").val().length == 0) || ($("#mypExpireMonthTo").val() == null || $("#mypExpireMonthTo").val().length == 0)){
            valid = false;
            message += "* Please select the expired month (From & To).\n";
        }
    }
	
	if(valid == false){
		Common.alert("Report Generate Summary" + DEFAULT_DELIMITER + message);
	}
	
	return valid;
}

function btnGenerate_Click(){
	
	if(validRequiredField()){
	
		$("#reportFileName").val("");
        $("#viewType").val("");
        $("#reportDownFileName").val("");
		
		var whereSQL = "";
		
		if(!($("#txtOrderNo").val().trim() == null || $("#txtOrderNo").val().trim().length == 0)){
            whereSQL += " AND som.SALES_ORD_NO = '"+$("#txtOrderNo").val().trim()+"' ";          
        }
		if(!($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0) && !($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)){
            whereSQL += " AND som.SALES_DT BETWEEN TO_DATE('"+$("#dpOrderDateFr").val()+"', 'dd/MM/YY') AND TO_DATE('"+$("#dpOrderDateTo").val()+"', 'dd/MM/YY')";
        }
		if(!($("#mypExpireMonthFr").val() == null || $("#mypExpireMonthFr").val().length == 0)){
            whereSQL += " AND TRUNC(sm.SRV_EXPR_DT, 'month') >= TRUNC(TO_DATE('"+$("#mypExpireMonthFr").val()+"','MM/yyyy'), 'month')"; //GetFirstDayOfMonth
        }
		if(!($("#mypExpireMonthTo").val() == null || $("#mypExpireMonthTo").val().length == 0)){
            whereSQL += " AND TRUNC(sm.SRV_EXPR_DT, 'month') <= TRUNC(TO_DATE('"+$("#mypExpireMonthTo").val()+"','MM/yyyy'), 'month')";
        }
		
        $("#V_WHERESQL").val(whereSQL);
            
        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        } 
        $("#reportDownFileName").val("MembershipExpireListMoreThanYear_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#viewType").val("EXCEL");
        $("#reportFileName").val("/membership/MembershipExpireList_Year.rpt");
                    
        // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
        var option = {
                isProcedure : true // procedure 로 구성된 리포트 인경우 필수.
        };
                
        Common.report("form", option);
		
	}
}


</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Membership Report - Key-In List</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:90px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No</th>
    <td><input type="text" title="" placeholder="Order Number" class="w100p" id="txtOrderNo"/></td>
    <th scope="row">Order Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateFr"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateTo"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Expire Month</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="MM/YYYY" class="j_date2 w100p" id="mypExpireMonthFr"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="MM/YYYY" class="j_date2 w100p" id="mypExpireMonthTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <td colspan="6"><p><span class="red_text">* Only list up the order which is rental case more than 5 year and membership are expired</span><p></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGenerate_Click()">Generate</a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />

</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->