<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$("#dataForm").empty();

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

$.fn.clearForm = function() {
	$("#cmbPaymode").multipleSelect("checkAll");
	$("#cmbBank").multipleSelect("uncheckAll");
	$("#cmbOrderSts").multipleSelect("uncheckAll");
	$("#cmbAppType").multipleSelect("uncheckAll");
	$("#cmbRentalSts").multipleSelect("uncheckAll");
	
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
    });
};

function validRequiredField(){
	
	var valid = true;
	var message = "";
	
	var dpUpdateDateFr = $("#dpUpdateDateFr").val();
	var dpUpdateDateTo = $("#dpUpdateDateTo").val();
    if(!(dpUpdateDateFr == null || dpUpdateDateFr.length == 0) || !(dpUpdateDateTo == null || dpUpdateDateTo.length == 0)){
    	if((dpUpdateDateFr == null || dpUpdateDateFr.length == 0) || (dpUpdateDateTo == null || dpUpdateDateTo.length == 0)){
            
    		valid = false;
    		message +=  "* Please key in the update date (From & To).\n";
        }	
    }
    
    var dpOrderDateFr = $("#dpOrderDateFr").val();
    var dpOrderDateTo = $("#dpOrderDateTo").val();
    if(!(dpOrderDateFr == null || dpOrderDateFr.length == 0) || !(dpOrderDateTo == null || dpOrderDateTo.length == 0)){
        if((dpOrderDateFr == null || dpOrderDateFr.length == 0) || (dpOrderDateTo == null || dpOrderDateTo.length == 0)){
            
            valid = false;
            message +=  "* Please key in the order date (From & To).\n";
        }   
    }
	
    var txtOrderNoFr = $("#txtOrderNoFr").val().trim();
    var txtOrderNoTo = $("#txtOrderNoTo").val().trim();
    if(!(txtOrderNoFr == null || txtOrderNoFr.length == 0) || !(txtOrderNoTo == null || txtOrderNoTo.length == 0)){
        if((txtOrderNoFr == null || txtOrderNoFr.length == 0) || (txtOrderNoTo == null || txtOrderNoTo.length == 0)){
            
            valid = false;
            message +=  "* Please key in the order number (From & To).\n";
        }   
    }
	
	if(valid == true){
		   fn_report();
	}else{
	       Common.alert("Report Generate Summary" + DEFAULT_DELIMITER + message);
	}	
}
 
function fn_report(){
	
	var whereSQL = "";
	
	var runPay = 0;
	if($('#cmbPaymode :selected').length > 0){
		whereSQL = " AND (";
		$('#cmbPaymode :selected').each(function(i, mul){ 
            if(runPay > 0){
            	whereSQL += " OR r.MODE_ID = '"+$(mul).val()+"' ";
            }else{
            	whereSQL += " r.MODE_ID = '"+$(mul).val()+"' ";
            }
            runPay += 1;
        });
        whereSQL += ") ";   
	}
	
	var runBank = 0;
	if($('#cmbBank :selected').length > 0){
        whereSQL = " AND (";
        $('#cmbBank :selected').each(function(i, mul){ 
            if(runBank > 0){
                whereSQL += " OR rb.BANK_ID = '"+$(mul).val()+"' ";
            }else{
                whereSQL += " rb.BANK_ID = '"+$(mul).val()+"' ";
            }
            runBank += 1;
        });
        whereSQL += ") ";   
    }
	
	var runApp = 0;
	if($('#cmbAppType :selected').length > 0){
        whereSQL = " AND (";
        $('#cmbAppType :selected').each(function(i, mul){ 
            if(runApp > 0){
                whereSQL += " OR som.APP_TYPE_ID = '"+$(mul).val()+"' ";
            }else{
                whereSQL += " som.APP_TYPE_ID = '"+$(mul).val()+"' ";
            }
            runApp += 1;
        });
        whereSQL += ") ";   
    }
	
	var runOrd = 0;
	if($('#cmbOrderSts :selected').length > 0){
        whereSQL = " AND (";
        $('#cmbOrderSts :selected').each(function(i, mul){ 
            if(runOrd > 0){
                whereSQL += " OR s.STUS_CODE_ID = '"+$(mul).val()+"' ";
            }else{
                whereSQL += " s.STUS_CODE_ID = '"+$(mul).val()+"' ";
            }
            runOrd += 1;
        });
        whereSQL += ") ";   
    }
	
	var runRen = 0;
	if($('#cmbRentalSts :selected').length > 0 && $("#cmbRentalSts").prop("disabled", false)){
        whereSQL = " AND (";
        $('#cmbRentalSts :selected').each(function(i, mul){ 
            if(runRen > 0){
                whereSQL += " OR rs.STUS_CODE_ID = '"+$(mul).val()+"' ";
            }else{
                whereSQL += " rs.STUS_CODE_ID = '"+$(mul).val()+"' ";
            }
            runRen += 1;
        });
        whereSQL += ") ";   
    }
	
    if(!($("#dpUpdateDateFr").val() == null || $("#dpUpdateDateFr").val().length == 0) && !($("#dpUpdateDateTo").val() == null || $("#dpUpdateDateTo").val().length == 0)){
        
        var frArr = $("#dpUpdateDateFr").val().split("/");
        var toArr = $("#dpUpdateDateTo").val().split("/");
        var dpUpdateDateFr = frArr[1]+"/"+frArr[0]+"/"+frArr[2]; // MM/dd/yyyy
        var dpUpdateDateTo = toArr[1]+"/"+toArr[0]+"/"+toArr[2];
        
        whereSQL += " AND (r.UPD_DT BETWEEN TO_DATE('"+dpUpdateDateFr+"', 'MM/dd/YY') AND TO_DATE('"+dpUpdateDateTo+"', 'MM/dd/YY'))";
    }
    
    if(!($("#txtOrderNoFr").val().trim() == null || $("#txtOrderNoFr").val().trim().length == 0) && !($("#txtOrderNoTo").val().trim() == null || $("#txtOrderNoTo").val().trim().length == 0)){
    	
    	whereSQL += " AND (som.SALES_ORD_NO BETWEEN '"+$("#txtOrderNoFr").val().trim()+"' AND '"+$("#txtOrderNoTo").val().trim()+"')";
    }
    
    if(!($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0) && !($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)){
        
        var frArr = $("#dpOrderDateFr").val().split("/");
        var toArr = $("#dpOrderDateTo").val().split("/");
        var dpOrderDateFr = frArr[1]+"/"+frArr[0]+"/"+frArr[2]; // MM/dd/yyyy
        var dpOrderDateTo = toArr[1]+"/"+toArr[0]+"/"+toArr[2];
        
        whereSQL += " AND (som.SALES_DT BETWEEN TO_DATE('"+dpOrderDateFr+"', 'MM/dd/YY') AND TO_DATE('"+dpOrderDateTo+"', 'MM/dd/YY'))";
    }
    
    if($("#cmbKeyBranch :selected").index() > 0){ 
        whereSQL += " AND som.BRNCH_ID = '"+$("#cmbKeyBranch :selected").val()+"'";       
    }
	
	
	var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    } 
    $("#reportDownFileName").val("RentPaySetUpdateList_"+date+(new Date().getMonth()+1)+new Date().getFullYear());

    $("#viewType").val("EXCEL");
    $("#reportFileName").val("/sales/RentPaySetLastUpdateList.rpt");
    
    $("#V_WHERESQL").val(whereSQL);
    
    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };
    
    Common.report("form", option);
	
}

function cmbAppType_OnItemChecked(){ 
	
	if($("#cmbAppType :selected").length == 0){
		$("#cmbRentalSts").multipleSelect("enable");
	}

	$('#cmbAppType :selected').each(function(i, mul){
	    if($(mul).val() == "67" || $(mul).val() == "1412" || $("#cmbAppType :selected").length > 1){
	    	$('#cmbRentalSts').multipleSelect("disable");
	    	$("#cmbRentalSts").multipleSelect("uncheckAll");
	
	    }else{
	    	$("#cmbRentalSts").multipleSelect("enable");
	    }
	});
	
}
 
 CommonCombo.make('cmbKeyBranch', '/sales/ccp/getBranchCodeList', '' , '');
 CommonCombo.make('cmbBank', '/sales/order/getBankCodeList', '' , '', {type: 'M', isCheckAll: false});
 
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order Report - Rental Pay Setting Update List</h1>
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
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Paymode</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbPaymode">
        <option value="133" selected>AEON Express</option>
        <option value="131" selected>Credit Card</option>
        <option value="132" selected>Direct Debit</option>
        <option value="134" selected>FPX</option>
        <option value="130" selected>Regular (Cash/Cheque)</option>
    </select>
    </td>
    <th scope="row">Update Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpUpdateDateFr"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpUpdateDateTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Order No</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="" placeholder="" class="w100p" id="txtOrderNoFr"/></p>
    <span>To</span>
    <p><input type="text" title="" placeholder="" class="w100p"id="txtOrderNoTo"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Order Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateFr"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Key-In Branch</th>
    <td>
    <select class="w100p" id="cmbKeyBranch"></select>
    </td>
    <th scope="row">Bank</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbBank" data-placeholder="Bank Name"></select>
    </td>
</tr>
<tr>
    <th scope="row">Order App Type</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbAppType" data-placeholder="App Type" onchange="cmbAppType_OnItemChecked()">
        <option value="67">Outright</option>
        <option value="66">Rental</option>
        <option value="1412">Outright Plus</option>
    </select>
    </td>
    <th scope="row">Order Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbOrderSts" data-placeholder="Order Status">
        <option value="1">Active</option>
        <option value="4">Completed</option>
        <option value="10">Cancelled</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Rental Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbRentalSts" data-placeholder="Rental Status">
        <option value="REG">Regular</option>
        <option value="INV">Investigate</option>
        <option value="SUS">Suspend</option>
        <option value="RET">Return</option>
        <option value="TER">Terminated</option>
    </select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript: validRequiredField();">Generate</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="/sales/RentPaySetLastUpdateList.rpt" />
<input type="hidden" id="viewType" name="viewType" value="EXCEL" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" value="" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />
<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" value="" />

</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->