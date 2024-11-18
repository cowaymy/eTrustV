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
            message += "<spring:message code="sal.alert.msg.selectOrdDate" />";
	    }
	}

	if(!($("#mypExpireMonthFr").val() == null || $("#mypExpireMonthFr").val().length == 0) || !($("#mypExpireMonthTo").val() == null || $("#mypExpireMonthTo").val().length == 0)){
        if(($("#mypExpireMonthFr").val() == null || $("#mypExpireMonthFr").val().length == 0) || ($("#mypExpireMonthTo").val() == null || $("#mypExpireMonthTo").val().length == 0)){
            valid = false;
            message += "<spring:message code="sal.alert.msg.expiredMonth" />";
        }
    }

	if(valid == false){
		Common.alert("<spring:message code="sal.alert.title.reportGenSummary" />" + DEFAULT_DELIMITER + message);
	}

	return valid;
}

function fn_insertLog(){
    var data = {
            orderNo : $("#txtOrderNo").val(),
            orderDateFr: $("#dpOrderDateFr").val(),
            orderDateTo: $("#dpOrderDateTo").val(),
            expireMonthFr: $("#mypExpireMonthFr").val(),
            expireMonthTo: $("#mypExpireMonthTo").val(),
            path: "membershipOutrightExpireYearListPop"
    }
    Common.ajax("POST", "/sales/membership/insertGenerateExpireLog.do", data, function(result){
        console.log("Result: >>" + result);
    });
}

function btnGenerate_Click(){
	fn_insertLog();
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

	     // ADDED BY TPY - 25/07/2019 [SCR]
	      var memType = "${SESSION_INFO.userTypeId}";
	      var memLevel = "${SESSION_INFO.memberLevel}";
	      var orgCode =  $('#orgCode').val();
	      var grpCode =  $('#grpCode').val();
	      var deptCode =  $('#deptCode').val();
	      var memCode = $('#memCode').val();

	      if(memType == 2 || memType == 3){ // CHECK MEMBER TYPE

	      if(orgCode == null || orgCode == ""){
	          whereSQL += " ";
	      }else{
	          whereSQL += " AND v.ORG_CODE = '" + orgCode + "' ";
	      }

	      if(grpCode == null || grpCode == ""){
	          whereSQL += " ";
	      }else{
	          whereSQL += " AND v.GRP_CODE = '" + grpCode + "' ";
	      }

	      if(deptCode == null || deptCode == ""){
	          whereSQL += " ";
	      }else{
	          whereSQL += " AND v.DEPT_CODE = '" + deptCode + "' ";
	      }

	       if(memLevel == 4){
	          whereSQL += " AND v.MEM_CODE = '" + memCode + "' ";
	      }else{
	          whereSQL += " ";
	      }

	      }

		if($("#isHc").val() != null && $("#isHc").val() != ''){
		    whereSQL += " AND som.BNDL_ID IS NOT NULL ";
		}else{
		    whereSQL += " AND som.BNDL_ID IS NULL ";
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
<h1><spring:message code="sal.page.title.membershipReport" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
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
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td><input type="text" title="" placeholder="Order Number" class="w100p" id="txtOrderNo"/></td>
    <th scope="row"><spring:message code="sal.text.ordDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateFr"/></p>
    <span><spring:message code="sal.text.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateTo"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.text.expireMonth" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="MM/YYYY" class="j_date2 w100p" id="mypExpireMonthFr"/></p>
    <span><spring:message code="sal.text.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="MM/YYYY" class="j_date2 w100p" id="mypExpireMonthTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <td colspan="6"><p><span class="red_text"><spring:message code="sal.text.onlyListUp5year" /></span><p></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGenerate_Click()"><spring:message code="sal.btn.generate" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input id="isHc" name="isHc" type="hidden" value='${isHc}'/>

</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->