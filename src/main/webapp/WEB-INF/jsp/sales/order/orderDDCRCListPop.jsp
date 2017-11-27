<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

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

function fn_report(viewType){ //////////
	
	
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

</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->