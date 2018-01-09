<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javascript">

var date = new Date().getDate();
if(date.toString().length == 1){
    date = "0" + date;
} 
$("#dpRequestDtFrom").val("01/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
$("#dpRequestDtTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

$.fn.clearForm = function() {
	$("#cmbReqStage").multipleSelect("checkAll");
	$("#cmbAppType").multipleSelect("checkAll");
    $("#cmbKeyBranch").multipleSelect("uncheckAll");
	
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
        $("#dpRequestDtFrom").val("01/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
        $("#dpRequestDtTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());

    });
};

function btnGenerate_Click(){
	
    var whereSQL = "";
    var runNo = 0;
	
    if($("#cmbReqStage :selected").length > 0){
    	whereSQL += " AND (";
    	
    	$('#cmbReqStage :selected').each(function(i, mul){ 
    		if(runNo > 0){
    			whereSQL += " OR c.SO_REQ_CUR_STUS_ID = '"+$(mul).val()+"' ";
    		}else{
    			whereSQL += " c.SO_REQ_CUR_STUS_ID = '"+$(mul).val()+"' ";
    		}
    		runNo += 1;
    	});
    	
    	whereSQL += ") ";
        runNo = 0;    	
    }
    
    if($("#cmbAppType :selected").length > 0){
        whereSQL += " AND (";
        
        $('#cmbAppType :selected').each(function(i, mul){ 
            if(runNo > 0){
                whereSQL += " OR som.APP_TYPE_ID = '"+$(mul).val()+"' ";
            }else{
                whereSQL += " som.APP_TYPE_ID = '"+$(mul).val()+"' ";
            }
            runNo += 1;
        });
        whereSQL += ") ";
        runNo = 0;      
    }
    
    if(!($("#dpRequestDtFrom").val() == null || $("#dpRequestDtFrom").val().length == 0)){
    	whereSQL += " AND c.SO_REQ_CRT_DT >= TO_DATE('"+$("#dpRequestDtFrom").val()+"', 'dd/MM/YY') ";
    }
    
    if(!($("#dpRequestDtTo").val() == null || $("#dpRequestDtTo").val().length == 0)){
    	whereSQL += " AND c.SO_REQ_CRT_DT < TO_DATE('"+$("#dpRequestDtTo").val()+"', 'dd/MM/YY')+1 "; //AddDays(1)
    }
    
    if(!($("#txtRequestNo").val().trim() == null || $("#txtRequestNo").val().trim().length == 0)){
    	whereSQL += " AND c.SO_REQ_NO = '"+$("#txtRequestNo").val().trim().replace("'", "''")+"' ";
    }
    
    if(!($("#txtOrderNumber").val().trim() == null || $("#txtOrderNumber").val().trim().length == 0)){
    	whereSQL += " AND som.SALES_ORD_NO = '"+$("#txtOrderNumber").val().trim().replace("'", "''")+"' ";
    }
    
    if($("#cmbKeyBranch :selected").length > 0){
        whereSQL += " AND (";
        
        $('#cmbKeyBranch :selected').each(function(i, mul){ 
            if(runNo > 0){
                whereSQL += " OR som.BRNCH_ID = '"+$(mul).val()+"' ";
            }else{
                whereSQL += " som.BRNCH_ID = '"+$(mul).val()+"' ";
            }
            runNo += 1;
        });
        whereSQL += ") ";
        runNo = 0;      
    }
    
    if(!($("#txtCustomerId").val().trim() == null || $("#txtCustomerId").val().trim().length == 0)){
    	whereSQL += " AND cust.CUST_ID = '"+$("#txtCustomerId").val().trim()+"' ";
    }
    
    if(!($("#txtCustomerName").val().trim() == null || $("#txtCustomerName").val().trim().length == 0)){
    	whereSQL += " AND cust.NAME LIKE '%"+$("#txtCustomerName").val().trim().replace("'", "''")+"%' ";
    }
    
    if(!($("#txtICNumber").val().trim() == null || $("#txtICNumber").val().trim().length == 0)){
    	whereSQL += " AND cust.NRIC LIKE '%"+$("#txtICNumber").val().trim().replace("'", "''")+"%' ";
    }
    
    
    $("#V_WHERESQL").val(whereSQL);
    
    $("#reportDownFileName").val("OrderCancellationRequestRaw_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#reportFileName").val("/sales/OrderCancellationRequestRawData.rpt");
    $("#viewType").val("EXCEL");
    
    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };
    
    Common.report("form", option);
    
}

CommonCombo.make('cmbAppType', '/sales/order/getApplicationTypeList', {codeId : 10} , '', {type: 'M'});
CommonCombo.make('cmbKeyBranch', '/sales/ccp/getBranchCodeList', '' , '', {type: 'M', isCheckAll: false});

</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order Cancellation Request Raw Data</h1>
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
    <col style="width:140px" />
    <col style="width:175px" />
    <col style="width:140px" />
    <col style="width:175px" />
    <col style="width:135px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Request Stage</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbReqStage">
        <option value="24" selected>Before Install</option>
        <option value="25" selected>After Install</option>
    </select>
    </td>
    <th scope="row">Application Type</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbAppType"></select>
    </td>
    <th scope="row">Request Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpRequestDtFrom"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpRequestDtTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Request No</th>
    <td><input type="text" title="" placeholder="Request Number" class="w100p" id="txtRequestNo"/></td>
    <th scope="row">Order No</th>
    <td><input type="text" title="" placeholder="Order Number" class="w100p" id="txtOrderNumber"/></td>
    <th scope="row">Sales Branch</th>
    <td>
    <select class="w100p" id="cmbKeyBranch" data-placeholder="Key-In Branch"></select>
    </td>
</tr>
<tr>
    <th scope="row">Customer ID</th>
    <td><input type="text" title="" placeholder="Customer ID (Number Only)" class="w100p" id="txtCustomerId"/></td>
    <th scope="row">Customer Name</th>
    <td><input type="text" title="" placeholder="Customer Name" class="w100p" id="txtCustomerName"/></td>
    <th scope="row">NRIC/Company No</th>
    <td><input type="text" title="" placeholder="NRIC/Company Number" class="w100p" id="txtICNumber"/></td>
</tr>
</tbody>
</table><!-- table end -->



<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="EXCEL" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="">

</form>



<div style="height: 80px">
</div>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript: btnGenerate_Click()">Generate</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>
</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->