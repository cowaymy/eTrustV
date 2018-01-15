<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function() {
	
	//Common.combo
	CommonCombo.make("_appTypePop", "/sales/rcms/getAppTypeList", {codeMasterId : '10'}, "66", optionModule);
	
	$('#salesmanCd').change(function(event) {

        var memCd = $('#salesmanCd').val().trim();

        if(FormUtil.isNotEmpty(memCd)) {
            fn_loadOrderSalesman(0, memCd);
        }
    });
	
	$('#memBtn').click(function() {
        Common.popupDiv("/common/memberPop.do", $("#searchForm").serializeJSON(), null, true);
    });
	
	//Generate Report
	$("#_rptGen").click(function() {
		
		//Validation
		if($("#_keyStartDate").val() == null || $("#_keyStartDate").val() == '' || $("#_keyEndDate").val() == null || $("#_keyEndDate").val() == ''){
			Common.alert("* Please select the key-in date (From & To).<br />");
			return;
		}
		
		if($("#_appTypePop").val() == null || $("#_appTypePop").val() == ''){
			Common.alert("* Please select at least one application type.<br />");
			return;
		}
		
		if($("#_actionType").val() == null || $("#_actionType").val() == ''){
            Common.alert("* Please select at least one action.<br />");
            return;
        }
		
		if(($("#_ordNoStr").val() != null && $("#_ordNoStr").val() != '') || ($("#_ordNoEnd").val() != null && $("#_ordNoEnd").val() != '')){
			if($("#_ordNoStr").val() == null || $("#_ordNoStr").val() == '' || $("#_ordNoEnd").val() == null || $("#_ordNoEnd").val() == ''){
				Common.alert("* Please key in the order number (From & To).<br />");
				return;
			}
		}
		
		if(($("#_ordStrdate").val() != null && $("#_ordStrdate").val() != '') || ($("#_ordEnddate").val() != null && $("#_ordEnddate").val() != '')){
            if($("#_ordStrdate").val() == null || $("#_ordStrdate").val() == '' || $("#_ordEnddate").val() == null || $("#_ordEnddate").val() == ''){
                Common.alert("* Please key in the order date (From & To).<br />");
                return;
            }
        }
		
		//Validation Pass
		//Gen Report
		var whereSql = '';
		var orderSql = '';
		var cnt = 0;
		
		if($("#_keyStartDate").val() != null && $("#_keyStartDate").val() != '' && $("#_keyEndDate").val() != null && $("#_keyEndDate").val() != ''){
			whereSql += " AND cr.CALL_CRT_DT BETWEEN TO_DATE('"+$("#_keyStartDate").val()+"', 'DD/MM/YYYY') AND TO_DATE('"+$("#_keyEndDate").val()+"', 'DD/MM/YYYY')";
        }
		
		if($("#hiddenSalesmanId").val() != null && $("#hiddenSalesmanId").val() != ''){
			whereSql += " AND cr.CALL_CRT_USER_ID = " + $("#hiddenSalesmanId").val();
		}
		
		//som.APP_TYPE_ID
		var runCnt = 0;
		var appStr = '';
		if($("#_appTypePop :selected").length > 0){
			$("#_appTypePop :selected").each(function(idx, el) {
				if(runCnt > 0){
					appStr += ',' +$(el).val();
				}else{
					appStr += $(el).val();
				}
				runCnt++;
			});
		}
		
		if(appStr != null && appStr != ''){
			whereSql += ' AND som.APP_TYPE_ID IN (' +appStr+')';
			runCnt = 0;
		}
		
		//cr.CALL_STUS_ID
		var actionStr = '';
		if($("#_actionType :selected").length > 0){
			$("#_actionType :selected").each(function(idx, el) {
				if(runCnt > 0){
					actionStr += ',' + $(el).val();
				}else{
					actionStr += $(el).val();
				}
				runCnt++;
			});
		}
		
		if(actionStr != null && actionStr != ''){
			whereSql += ' AND cr.CALL_STUS_ID IN ('+actionStr+')';
			runCnt = 0;
		}
		
		//Order Number
		if($("#_ordNoStr").val() != null && $("#_ordNoStr").val() != '' && $("#_ordNoEnd").val() != null && $("#_ordNoEnd").val() != ''){
			whereSql += " AND som.SALES_ORD_NO BETWEEN '"+$("#_ordNoStr").val().trim()+"' AND '"+$("#_ordNoEnd").val().trim()+"'";
		}
		
		//Order Date
		if($("#_ordStrdate").val() != null && $("#_ordStrdate").val() != '' && $("#_ordEnddate").val() != null && $("#_ordEnddate").val() != ''){
			whereSql += " AND som.SALES_DT BETWEEN TO_DATE('"+$("#_ordStrdate").val()+"', 'DD/MM/YYYY') AND TO_DATE('"+$("#_ordEnddate").val()+"' , 'DD/MM/YYYY')";
		}
		
		//Cust ID
		if($("#_feedCustId").val() != null && $("#_feedCustId").val() != ''){
			whereSql += ' AND c.CUST_ID = ' + $("#_feedCustId").val().trim(); 
		}
		
		//Cust Name (Like Search)
		if($("#_feedCustName").val() != null && $("#_feedCustName").val() != ''){
			whereSql += " AND UPPER(c.NAME) LIKE '%'||UPPER('"+$("#_feedCustName").val()+"')||'%''";
		}
		
		//NRIC
		if($("#_feedNric").val() != null && $("#_feedNric").val() != ''){
			whereSql += " AND UPPER(c.NRIC) LIKE '%'||UPPER('"+$("#_feedNric").val()+"')||'%''";
		}
		
		//Order By
		if($("#_sortBy").val() != null && $("#_sortBy").val() != ''){
			
			if($("#_sortBy").val() == '1'){
				orderSql = " ORDER BY cr.CALL_CRT_DT , som.SALES_ORD_NO";
			}else if($("#_sortBy").val() == '2'){
				orderSql = " ORDER BY u.USER_NAME, cr.CALL_CRT_DT, som.SALES_ORD_NO";
			}else if($("#_sortBy").val() == '3'){
				orderSql = " ORDER BY som.SALES_ORD_NO, cr.CALL_CRT_DT";
            }else if($("#_sortBy").val() == '4'){
            	orderSql = " ORDER BY t.CODE, som.SALES_ORD_NO, cr.CALL_CRT_DT";
            }else if($("#_sortBy").val() == '5'){
            	orderSql = " ORDER BY s2.NAME, som.SALES_ORD_NO, cr.CALL_CRT_DT";
            }else{
            	orderSql = " ";
            }
		}
		
		//Generate Report
		$("#reportFileName").val("/sales/ROSFeedbackKeyList.rpt");
		$("#viewType").val("EXCEL");
		//title
	    var date = new Date().getDate();
	    if(date.toString().length == 1){
	        date = "0" + date;
	    }
	    var title = "ROSFeedbackKeyInList_"+date+(new Date().getMonth()+1)+new Date().getFullYear();
	    $("#reportDownFileName").val(title); //Download File Name
		
	    /* Procedure Params */
	    $("#V_SELECTSQL").val(" ");
	    $("#V_WHERESQL").val(whereSql);
	    $("#V_ORDERBYSQL").val(orderSql);
	    $("#V_SELECTSQL").val(" ");
	    
	    console.log("whereSql : " + whereSql);
	    console.log("orderSql : " + orderSql);
	    
	  //Gen Report
	    var option = {
	            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
	    };
	    Common.report("_feedRptForm", option);
	    
	});//Gen End
});


function fn_loadOrderSalesman(memId, memCode) {

    Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

        if(memInfo == null) {
            Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
            $("#salesmanPopCd").val('');
            $("#hiddenSalesmanPopId").val('');
        }
        else{
       	    $('#hiddenSalesmanId').val(memInfo.memId);
            $('#salesmanCd').val(memInfo.memCode);
            $('#salesmanCd').removeClass("readonly");
        }
    });
}

 //Multy Select
$('.multy_select').change(function() {
  //console.log($(this).val());
      })
      .multipleSelect({
      width: '100%'
});
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<form id="_feedRptForm">
    <!-- Essential Params -->
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/AccumulatedAccReport_PDF.rpt" />
    <input type="hidden" id="viewType" name="viewType" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName"  />
    
    <!-- Procedure Params -->
    <input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL">
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL">
    <input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL">
    <input type="hidden" id="V_FULLSQL" name="V_FULLSQL">
    
</form>

<header class="pop_header"><!-- pop_header start -->
<h1>EDIT RCMS Remark</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<form  id="searchForm">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>         
<tr>
    <th scope="row">Key-In Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  id="_keyStartDate" /></p>  
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="_keyEndDate" /></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Key User</th>
    <td>    
        <div class="search_100p"><!-- search_100p start -->
        <input id="salesmanCd" name="salesmanCd" type="text" title="" placeholder="" class="w100p" />
        <input id="hiddenSalesmanId" name="salesmanId" type="hidden"  />
        <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Application Type</th>
    <td>
        <select id="_appTypePop" name="appType" class="multy_select w100p" multiple="multiple"></select>
    </td>
    <th scope="row">Action</th>
    <td>
        <select id="_actionType" name="actionType" class="multy_select w100p" multiple="multiple">
            <option value="56">Call-In</option>
            <option value="57">Call-Out</option>
            <option value="58">Internal Feedback</option>
        </select>
    </td>
</tr>
<tr>
    <th scope="row">Order Number</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" style="width: 100%" id="_ordNoStr"/></p>  
    <span>To</span>
    <p><input type="text" style="width: 100%" id="_ordNoEnd"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Order Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="_ordStrdate" /></p>  
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="_ordEnddate"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Customer ID</th>
    <td><input type="text" class="w100p" id="_feedCustId"></td>
    <th scope="row">Customer Name</th>
    <td><input type="text" class="w100p" id="_feedCustName"></td>
</tr>
<tr>
    <th scope="row">NRIC / Co. No</th>
    <td><input type="text" class="w100p" id="_feedNric"></td>
    <th scope="row">Sort By</th>
    <td>
        <select id="_sortBy" name="sortBy" class="w100p">
            <option value="1">By Key In Date</option>
            <option value="2">By Key In User</option>
            <option value="3">By Order Number</option>
            <option value="4">By Application Type</option>
            <option value="5">By Action</option>
        </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<ul class="center_btns">
    <li><p class="btn_blue2"><a id="_rptGen" >Generate</a></p></li>
    <li><p class="btn_blue2"><a onclick="javascript:$('#searchForm').clearForm();">Clear</a></p></li>
</ul>
</section>
</div>