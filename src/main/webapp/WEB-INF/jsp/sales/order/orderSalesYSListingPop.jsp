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
        
        $("#dpInstallDateFrom").val(new Date().getMonth()+1+"/"+new Date().getFullYear());
        $("#dpInstallDateTo").val(new Date().getMonth()+1+"/"+new Date().getFullYear());
    });
};

function validRequiredField(){
	
	var valid = true;
	var message = "";
	
	if(($("#dpInstallDateFrom").val() == null || $("#dpInstallDateFrom").val().length == 0) || ($("#dpInstallDateTo").val() == null || $("#dpInstallDateTo").val().length == 0)){
		
		valid = false;
		message += "* Please select the Install Date (From & To).\n";
	}
	
	if(valid == false){
        alert(message);
    }
    
    return valid;	
}

function cmbMemberType_SelectedIndexChanged(){
	
	$("#cmbGrpCode").prop("disabled", true);
	$("#cmbDeptCode").prop("disabled", true);
	
	CommonCombo.make('cmbOrgCode', '/sales/order/getOrgCodeList', {memLvl : 1, memType : $("#cmbMemberType").val()} , '');
}

function cmbOrgCode_SelectedIndexChanged(){
	
	CommonCombo.make('cmbGrpCode', '/sales/order/getGrpCodeList', {memLvl : 2, memType : $("#cmbMemberType").val(), upperLineMemberID : $("#cmbOrgCode").val()}, '');

	$("#cmbDeptCode").prop("disabled", false);
    $("#cmbGrpCode").prop("disabled", false);
    $("#cmbDeptCode").prop("disabled", true);
}

function cmbGrpCode_SelectedIndexChanged(){

	CommonCombo.make('cmbDeptCode', '/sales/order/getGrpCodeList', {memLvl : 3, memType : $("#cmbMemberType").val(), upperLineMemberID : $("#cmbGrpCode").val()}, '');

	$("#cmbDeptCode").prop("disabled", false);
}


$("#dpInstallDateFrom").val(new Date().getMonth()+1+"/"+new Date().getFullYear());
$("#dpInstallDateTo").val(new Date().getMonth()+1+"/"+new Date().getFullYear());
CommonCombo.make('cmbOrgCode', '/sales/order/getOrgCodeList', {memLvl : 1, memType : $("#cmbMemberType").val()} , '');

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order Report - Sales YS Listing</h1>
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
    <th scope="row">Member Type</th>
    <td>
    <select class="w100p" id="cmbMemberType" onchange="cmbMemberType_SelectedIndexChanged()">
        <option value="0" selected>All</option>
        <option value="1">Health Planner</option>
        <option value="2">Cody</option>
        <option value="4">Staff</option>
        <option value="3">Coway Technician</option>
    </select>
    </td>
    <th scope="row">Org Code</th>
    <td>
    <select class="w100p" id="cmbOrgCode" onchange="cmbOrgCode_SelectedIndexChanged()">
        <option value="0">All</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">YS Aging</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbYSAging">
        <option value="30" selected>< 31 Days</option>
        <option value="31" selected>31 - 60 Days</option>
        <option value="61" selected>61 - 90 Days</option>
        <option value="91" selected>> 90 Days</option>
        <option value="121" selected>> 120 Days</option>
    </select>
    </td>
    <th scope="row">Grp Code</th>
    <td>
    <select class="w100p" id="cmbGrpCode" onchange="cmbGrpCode_SelectedIndexChanged()" disabled>
        <option value="0">All</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Install Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date2 w100p" id="dpInstallDateFrom"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date2 w100p" id="dpInstallDateTo"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Dept Code</th>
    <td>
    <select class="w100p" id="cmbDeptCode" disabled>
        <option value="0">All</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Customer Type</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbCustType">
        <option value="965" selected>Company</option>
        <option value="964" selected>Individual</option>
    </select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#">Generate PDF</a></p></li>
    <li><p class="btn_blue2"><a href="#">Generate Excel</a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript:$('#form').clearForm();">Clear</a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->