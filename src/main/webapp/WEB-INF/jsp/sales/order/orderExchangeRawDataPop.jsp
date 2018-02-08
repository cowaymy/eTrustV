<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var date = new Date().getDate();
if(date.toString().length == 1){
    date = "0" + date;
} 
$("#dpReqDateFrom").val("01/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
$("#dpReqDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

function btnGenerate_Click(){

	var whereSQL = "";
	var runNo = 0;
	
	if($("#cmbType :selected").length > 0){
        whereSQL += " AND (";
        
        $('#cmbType :selected').each(function(i, mul){ 
            if(runNo == 0){
                whereSQL += " e.SO_EXCHG_TYPE_ID = '"+$(mul).val()+"' ";
            }else{
                whereSQL += " OR e.SO_EXCHG_TYPE_ID = '"+$(mul).val()+"' ";
            }
            runNo += 1;
        });
        whereSQL += ") ";
        runNo = 0;      
    }
	
	if($("#cmbStatus :selected").length > 0){
        whereSQL += " AND (";
        
        $('#cmbStatus :selected').each(function(i, mul){ 
            if(runNo == 0){
                whereSQL += " e.SO_EXCHG_STUS_ID = '"+$(mul).val()+"' ";
            }else{
                whereSQL += " OR e.SO_EXCHG_STUS_ID = '"+$(mul).val()+"' ";
            }
            runNo += 1;
        });
        whereSQL += ") ";
        runNo = 0;      
    }
	
	if(!($("#dpReqDateFrom").val() == null || $("#dpReqDateFrom").val().length == 0)){
        whereSQL += " AND e.SO_EXCHG_CRT_DT >= TO_DATE('"+$("#dpReqDateFrom").val()+"', 'dd/MM/YY') ";
    }
	
	if(!($("#dpReqDateTo").val() == null || $("#dpReqDateTo").val().length == 0)){
        whereSQL += " AND e.SO_EXCHG_CRT_DT < TO_DATE('"+$("#dpReqDateTo").val()+"', 'dd/MM/YY') ";
    }
	
	if(!($("#txtOrderNo").val().trim() == null || $("#txtOrderNo").val().trim().length == 0)){
        whereSQL += " AND som.SALES_ORD_NO = '"+$("#txtOrderNo").val().trim().replace("'", "''")+"' ";
    }
	
	if(!($("#txtRequestBy").val().trim() == null || $("#txtRequestBy").val().trim().length == 0)){
        whereSQL += " AND u.USER_NAME = '"+$("#txtRequestBy").val().trim().replace("'", "''")+"' ";
    }
	
	$("#viewType").val("EXCEL");
    $("#V_WHERESQL").val(whereSQL);
    
    $("#reportDownFileName").val("OrderExchangeRawData_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#reportFileName").val("/sales/OrderExchangeRawData.rpt");
    
    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };
    
    Common.report("form", option);
      
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.exchangeRawData" /></h1>
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
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.exchangeType" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbType" data-placeholder="Exchange Type">
        <option value="282"><spring:message code="sal.combo.text.appTypeExchange" /></option>
        <option value="283"><spring:message code="sal.combo.text.productExchange" /></option>
        <option value="284"><spring:message code="sal.combo.text.ownershipTransfer" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.exchangeStatus" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbStatus" data-placeholder="Exchange Status">
        <option value="1"><spring:message code="sal.btn.active" /></option>
        <option value="4"><spring:message code="sal.combo.text.complete" /></option>
        <option value="10"><spring:message code="sal.combo.text.cancel" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.requestDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpReqDateFrom"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpReqDateTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ordNum" /></th>
    <td><input type="text" title="" placeholder="Order Number" class="w100p" id="txtOrderNo"/></td>
    <th scope="row"><spring:message code="sal.title.text.requestor" /></th>
    <td><input type="text" title="" placeholder="Requestor (Username)" class="w100p" id="txtRequestBy"/></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGenerate_Click()"><spring:message code="sal.btn.generate" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="EXCEL" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="">

</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->