<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
var date = new Date().getDate();
if(date.toString().length == 1){
    date = "0" + date;
} 
$("#dpOrderDateFr").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
$("#dpOrderDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }
        $("#dpOrderDateFr").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
        $("#dpOrderDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());       
        $("#cmbSorting").prop("selectedIndex", 2);
    });
};

function validRequiredField(){
	
	var valid = true;
	var message = "";
	
	if(($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0) || ($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)){
		   valid = false;
		   message += "* Please key in the order date (From & To).\n";
	}
	
	if($('#cmbPaymode :selected').length < 1){
		valid = false;
		message += "* Please select at least one paymode.\n";
	}
	
	if(!($("#txtOrderNoFr").val().trim() == null || $("#txtOrderNoFr").val().trim().length == 0) || !($("#txtOrderNoTo").val().trim() == null || $("#txtOrderNoTo").val().trim().length == 0)){
		if(($("#txtOrderNoFr").val().trim() == null || $("#txtOrderNoFr").val().trim().length == 0) || ($("#txtOrderNoTo").val().trim() == null || $("#txtOrderNoTo").val().trim().length == 0)){
			valid = false;
			message += "* Please key in the order number (From & To).\n";
		}
	}
	
	if(valid == false){
        alert(message);
    }
    
    return valid;
}

function btnGenerate_PDF_Click(){
	
	if(validRequiredField() == true){
        fn_report("PDF");
    }else{
        return false;
    }	
}

function btnGenerate_Excel_Click(){
	
	if(validRequiredField() == true){
        fn_report("EXCEL");
    }else{
        return false;
    }   
}

function fn_report(viewType){ 
	
	$("#reportFileName").val("");
    $("#reportDownFileName").val("");
    $("#viewType").val("");
	
	var orderNoFrom = "";
	var orderNoTo = "";
	var orderDateFrom = "";
	var orderDateTo = "";
	var branchRegion = "";
	var keyInBranch = "";
	var paymode = "";
	var sortBy = "";
	var whereSQL = "";
	var extraWhereSQL = "";
    var orderBySQL = "";
    
    var runNo = 0;
    
    if($('#cmbPaymode :selected').length > 0){
    	whereSQL += " AND (";
    	
    	$('#cmbPaymode :selected').each(function(i, mul){ 
            if(runNo > 0){
                whereSQL += " OR r.MODE_ID = '"+$(mul).val()+"' ";
                paymode += ", "+$(mul).text();
            
            }else{
                whereSQL += " r.MODE_ID = '"+$(mul).val()+"' ";
                paymode += $(mul).text();
                
            }
            runNo += 1;
        });
        whereSQL += ") ";       
    }
    runNo = 0;
    
    if(!($("#dpOrderDateFr").val() == null || $("#dpOrderDateFr").val().length == 0) || !($("#dpOrderDateTo").val() == null || $("#dpOrderDateTo").val().length == 0)){
    	orderDateFrom = $("#dpOrderDateFr").val();
        orderDateTo = $("#dpOrderDateTo").val();
        
        whereSQL += " AND (som.SALES_DT BETWEEN TO_DATE('"+orderDateFrom+"', 'dd/MM/YY') AND TO_DATE('"+orderDateTo+"', 'dd/MM/YY'))";
    }
    
	if($("#cmbKeyBranch :selected").index() > 0){
		keyInBranch = $("#cmbKeyBranch :selected").text();
		whereSQL += " AND som.BRNCH_ID = '"+$("#cmbKeyBranch :selected").val()+"'";
	}
	    
	if(!($("#txtOrderNoFr").val().trim() == null || $("#txtOrderNoFr").val().trim().length == 0) && !($("#txtOrderNoTo").val().trim() == null || $("#txtOrderNoTo").val().trim().length == 0)){
		orderNoFrom = $("#txtOrderNoFr").val().trim();
		orderNoTo = $("#txtOrderNoTo").val().trim();
		
		whereSQL += " AND som.SALES_ORD_NO BETWEEN '"+orderNoFrom+"' AND '"+orderNoTo+"')";
	}
	
	if($("#cmbUser :selected").index() > 0){
		whereSQL += " AND som.CRT_USER_ID = '"+$("#cmbUser :selected").val()+"'";
	}
	
	if($("#cmbSorting :selected").index() > -1){
		sortBy = $("#cmbSorting :selected").text();
		
		if($("#cmbSorting :selected").val() == "1"){
            orderBySQL = " ORDER BY t2.CODE_NAME, b.CODE, t.CODE_NAME, som.SALES_ORD_NO";
        }else if($("#cmbSorting :selected").val() == "2"){
            orderBySQL = " ORDER BY b.CODE, t.CODE_NAME, som.SALES_ORD_NO";
        }else if($("#cmbSorting :selected").val() == "3"){
            orderBySQL = " ORDER BY som.SALES_DT, t.CODE_NAME, som.SALES_ORD_NO";
        }else if($("#cmbSorting :selected").val() == "4"){
            orderBySQL = " ORDER BY som.SALES_ORD_NO, t.CODE_NAME";
        }else if($("#cmbSorting :selected").val() == "5"){
            orderBySQL = " ORDER BY Issued_Bank, som.SALES_ORD_NO";
        }   
	}

    $("#reportDownFileName").val("OrderDDCRCList_"+date+(new Date().getMonth()+1)+new Date().getFullYear());

    if(viewType == "PDF"){
        $("#viewType").val("PDF");
        $("#reportFileName").val("/sales/OrderDDCRCList.rpt");
    }else if(viewType == "EXCEL"){
        $("#viewType").val("EXCEL");
        $("#reportFileName").val("/sales/OrderDDCRCList_Excel.rpt");
    }

    $("#V_ORDERNOFROM").val(orderNoFrom);
    $("#V_ORDERNOTO").val(orderNoTo);
    $("#V_ORDERDATEFROM").val(orderDateFrom);
    $("#V_ORDERDATETO").val(orderDateTo);
    $("#V_BRANCHREGION").val(branchRegion);
    $("#V_KEYINBRANCH").val(keyInBranch);
    $("#V_PAYMODE").val(paymode);
    $("#V_SORTBY").val(sortBy);
    $("#V_SELECTSQL").val("");
    $("#V_WHERESQL").val(whereSQL);
    $("#V_EXTRAWHERESQL").val(extraWhereSQL);
    $("#V_ORDERBYSQL").val(orderBySQL);
    $("#V_FULLSQL").val("");
     
    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };
    
    Common.report("form", option);
	
}

CommonCombo.make('cmbKeyBranch', '/sales/ccp/getBranchCodeList', '' , '');
CommonCombo.make('cmbUser', '/sales/order/getUserCodeList', '' , '');
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>DD / Credit Card List</h1>
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
        <option value="131" selected>Credit Card</option>
        <option value="132" selected>Direct Debit</option>
    </select>
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
    <th scope="row">Order Number</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="" placeholder="" class="w100p" id="txtOrderNoFr"/></p>
    <span>To</span>
    <p><input type="text" title="" placeholder="" class="w100p" id="txtOrderNoTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Key-In User</th>
    <td>
    <select class="w100p" id="cmbUser"></select>
    </td>
    <th scope="row">Sorting</th>
    <td>
    <select class="w100p" id="cmbSorting">
        <option value="2">By branch</option>
        <option value="3">By order date</option>
        <option value="4" selected>By order number</option>
        <option value="5">By issued bank</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGenerate_PDF_Click();">Generate PDF</a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGenerate_Excel_Click();">Generate Excel</a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript:$('#form').clearForm();">Clear</a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_ORDERNOFROM" name="V_ORDERNOFROM" value="" />
<input type="hidden" id="V_ORDERNOTO" name="V_ORDERNOTO" value="" />
<input type="hidden" id="V_ORDERDATEFROM" name="V_ORDERDATEFROM" value="" />
<input type="hidden" id="V_ORDERDATETO" name="V_ORDERDATETO" value="" />
<input type="hidden" id="V_BRANCHREGION" name="V_BRANCHREGION" value="" />
<input type="hidden" id="V_KEYINBRANCH" name="V_KEYINBRANCH" value="" />
<input type="hidden" id="V_PAYMODE" name="V_PAYMODE" value="" />
<input type="hidden" id="V_SORTBY" name="V_SORTBY" value="" />
<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" value="" />
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_EXTRAWHERESQL" name="V_EXTRAWHERESQL" value="" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />
<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" value="" />

</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->