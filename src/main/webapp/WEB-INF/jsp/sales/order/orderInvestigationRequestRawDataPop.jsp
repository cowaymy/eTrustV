<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var date = new Date().getDate();
if(date.toString().length == 1){
    date = "0" + date;
} 
$("#dpReqDateFr").val("01/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
$("#dpReqDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

$.fn.clearForm = function() {
	$("#cmbReqStatus").multipleSelect("uncheckAll");
    $("#cmbAppType").multipleSelect("uncheckAll");
    $("#cmbRejectReason").multipleSelect("uncheckAll");
	
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }
        $("#dpReqDateFr").val("01/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
        $("#dpReqDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
    });
};

function btnGenerate_Click(){
	
	var whereSQL = "";
	var runNo = 1;
	
	if(!($("#txtReqNo").val().trim() == null || $("#txtReqNo").val().trim().length == 0)){
        whereSQL += " AND m.INV_REQ_NO = '"+$("#txtReqNo").val().trim()+"' ";
    }
	
	if(!($("#txtOrderNo").val().trim() == null || $("#txtOrderNo").val().trim().length == 0)){
        whereSQL += " AND som.SALES_ORD_NO = '"+$("#txtOrderNo").val().trim()+"' ";
    }
	
	if(!($("#dpReqDateFr").val() == null || $("#dpReqDateFr").val().length == 0)){
        whereSQL += " AND m.INV_REQ_CRT_DT >= TO_DATE('"+$("#dpReqDateFr").val()+"', 'dd/MM/YY') ";
    }
	
	if(!($("#dpReqDateTo").val() == null || $("#dpReqDateTo").val().length == 0)){
        whereSQL += " AND m.INV_REQ_CRT_DT <= TO_DATE('"+$("#dpReqDateTo").val()+"', 'dd/MM/YY') ";
    }
	
	if($("#cmbReqStatus :selected").length > 0){
        whereSQL += " AND (";
        
        $('#cmbReqStatus :selected').each(function(i, mul){ 
            if(runNo == 1){
                whereSQL += " m.INV_REQ_STUS_ID = '"+$(mul).val()+"' ";
            }else{
                whereSQL += " OR m.INV_REQ_STUS_ID = '"+$(mul).val()+"' ";
            }
            runNo += 1;
        });
        whereSQL += ") ";
        runNo = 1;      
    }
	
	if(!($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0)){
        whereSQL += " AND som.SALES_DT >= TO_DATE('"+$("#dpOrderDateFr").val()+"', 'dd/MM/YY') ";
    }
	
	if(!($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)){
        whereSQL += " AND som.SALES_DT <= TO_DATE('"+$("#dpOrderDateTo").val()+"', 'dd/MM/YY') ";
    }
	
	if(!($("#txtRequestor").val().trim() == null || $("#txtRequestor").val().trim().length == 0)){
        whereSQL += " AND u.USER_NAME = '"+$("#txtRequestor").val().trim()+"' ";
    }
	
	if($("#cmbAppType :selected").length > 0){
        whereSQL += " AND (";
        
        $('#cmbAppType :selected').each(function(i, mul){ 
            if(runNo == 1){
                whereSQL += " som.APP_TYPE_ID = '"+$(mul).val()+"' ";
            }else{
                whereSQL += " OR som.APP_TYPE_ID = '"+$(mul).val()+"' ";
            }
            runNo += 1;
        });
        whereSQL += ") ";
        runNo = 1;      
    }
	
	if($("#cmbRejectReason :selected").length > 0){
        whereSQL += " AND (";
        
        $('#cmbRejectReason :selected').each(function(i, mul){ 
            if(runNo == 1){
                whereSQL += " m.INV_REQ_REJCT_RESN_ID = '"+$(mul).val()+"' ";
            }else{
                whereSQL += " OR m.INV_REQ_REJCT_RESN_ID = '"+$(mul).val()+"' ";
            }
            runNo += 1;
        });
        whereSQL += ") ";
        runNo = 1;      
    }
    
	if(!($("#txtCustName").val().trim() == null || $("#txtCustName").val().trim().length == 0)){
		whereSQL += " AND c.NAME LIKE '%"+$("#txtCustName").val().trim().replace("'", "''")+"%' ";
    }
	
	if(!($("#txtCustIC").val().trim() == null || $("#txtCustIC").val().trim().length == 0)){
        whereSQL += " AND c.NRIC LIKE '%"+$("#txtCustIC").val().trim().replace("'", "''")+"%' ";
    }
	
    $("#V_WHERESQL").val(whereSQL);
    $("#viewType").val("EXCEL");
    $("#reportDownFileName").val("InvestigateRequestRawData");
    $("#reportFileName").val("/sales/InvestigateRequestRawData.rpt");
    
    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };
    
    Common.report("form", option);
	
}

CommonCombo.make('cmbAppType', '/sales/order/getApplicationTypeList', {codeId : 10} , '', {type: 'M', isCheckAll: false});
CommonCombo.make('cmbRejectReason', '/sales/ccp/getReasonCodeList', '' , '', {type: 'M', isCheckAll: false});

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.investigateRequestRawData" /></h1>
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
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.requestNo" /></th>
    <td><input type="text" title="" placeholder="Request Number" class="w100p" id="txtReqNo"/></td>
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td><input type="text" title="" placeholder="Order Number" class="w100p" id="txtOrderNo"/></td>
    <th scope="row"><spring:message code="sal.text.requestDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpReqDateFr"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpReqDateTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.requestStatus" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbReqStatus" data-placeholder="Request Status">
        <option value="1"><spring:message code="sal.combo.text.active" /></option>
        <option value="44"><spring:message code="sal.text.pending" /></option>
        <option value="5"><spring:message code="sal.combo.text.approv" /></option>
        <option value="6"><spring:message code="sal.combo.text.rej" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.text.ordDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateFr"/></p>
    <span><spring:message code="sal.text.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateTo"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.text.requestor" /></th>
    <td><input type="text" title="" placeholder="Requestor (Username)" class="w100p" id="txtRequestor"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.appType" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbAppType" data-placeholder="Application Type"></select>
    </td>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td><input type="text" title="" placeholder="Customer Name" class="w100p" id="txtCustName"/></td>
    <th scope="row"><spring:message code="sal.text.customerNRIC" /></th>
    <td><input type="text" title="" placeholder="NRIC/Company Number" class="w100p" id="txtCustIC"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.rejReason" /></th>
    <td colspan="3">
    <select class="multy_select w100p" multiple="multiple" id="cmbRejectReason" data-placeholder="Reject Reason"></select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript: btnGenerate_Click()"><spring:message code="sal.btn.generate" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="EXCEL" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="">

</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->