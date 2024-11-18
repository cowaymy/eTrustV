<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$(document).ready(function() {
	
	$("#reportInvoiceForm").empty();
	
    CommonCombo.make('cmbBranch', '/sales/ccp/getBranchCodeList', '' , '', {type:'M', isCheckAll:false});

    /* 멀티셀렉트 플러그인 start */
    $('.multy_select').change(function() {
       //console.log($(this).val());
    })
    .multipleSelect({
       width: '100%'
    });
    

});


$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || tag === 'textarea'){
            this.value = '';
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }
        $("#cmbBranch").multipleSelect("uncheckAll");
        $("#cmbYSAging").multipleSelect("uncheckAll");
        
        $("#cmbOrgCode").prop("selectedIndex", -1);
        $("#cmbGrpCode").prop("selectedIndex", -1);
        $("#cmbDeptCode").prop("selectedIndex", -1);
        
        $("#cmbOrgCode").prop("disabled", true);
        $("#cmbOrgCode").addClass("disabled");
        $("#cmbGrpCode").prop("disabled", true);
        $("#cmbGrpCode").addClass("disabled");
        $("#cmbDeptCode").prop("disabled", true);
        $("#cmbDeptCode").addClass("disabled");
    });
};


function SQL(){
    
    var whereSQL = "";
    
    if($("#cmbMemberType :selected").index() > 0){
        whereSQL += " AND A.MEMBER_TYPE = '"+$("#cmbMemberType :selected").text()+"' ";
    }
    if($("#cmbOrgCode :selected").index() > 0){
        var orgdesc = $("#cmbOrgCode").text().split("-");
        var orgCode = orgdesc[0].trim();
        whereSQL += " AND A.ORG_CODE = '"+orgCode+"' ";
    }
    if($("#cmbGrpCode :selected").index() > 0){
        var grpdesc = $("#cmbGrpCode").text().split("-");
        grpCode = grpdesc[0].trim();
        whereSQL += " AND A.GRP_CODE = '"+grpCode+"' ";
    }
    if($("#cmbDeptCode :selected").index() > 0){
        var deptdesc = $("#cmbDeptCode").text().split("-");
        deptCode = deptdesc[0].trim();
        whereSQL += " AND A.DEPT_CODE = '"+deptCode+"' ";
    }
    if($("#cmbMembershipType :selected").index() > 0){
        whereSQL += " AND A.MEMBERSHIP_TYPE = '"+$("#cmbMembershipType :selected").val()+"' ";
    }
    if(!($("#dpKeyDateFr").val() == null || $("#dpKeyDateFr").val().length == 0)){
        whereSQL += " AND A.CREATE_DATE >= TO_DATE('"+$("#dpKeyDateFr").val()+"', 'dd/MM/YY') ";
    }
    if(!($("#dpKeyDateTo").val() == null || $("#dpKeyDateTo").val().length == 0)){
        whereSQL += " AND A.CREATE_DATE < TO_DATE('"+$("#dpKeyDateTo").val()+"', 'dd/MM/YY')+1 "; //AddDays(1)
    }
    
    var runNo1 = 0;
    var branchList = "";
    
    if($('#cmbBranch :selected').length > 0){
        $('#cmbBranch :selected').each(function(i, mul){
            if($(mul).val() != "0"){
                if(runNo1 > 0){
                    branchList += ", '"+$(mul).val()+"' ";
                }else{
                    branchList += " '"+$(mul).val()+"' ";
                }
                runNo1 += 1;
            }
        }); 
    }
    if(!(branchList == null || branchList.length == 0)){
        whereSQL += " AND A.KEYIN_BRANCHID IN ("+branchList+") ";
    }
    if($("#cmbOutstanding :selected").index() > 0){
        if($("#cmbOutstanding :selected").val() == "OUT"){
            whereSQL += " AND A.OUTSTANDING_AMT > 0";
        }else if($("#cmbOutstanding :selected").val() == "OVER"){
            whereSQL += " AND A.OUTSTANDING_AMT < 0";
        }
    }
    
    var runNo2 = 0;
    var ysAgingList = "";
    if($('#cmbYSAging :selected').length > 0){
        $('#cmbYSAging :selected').each(function(i, mul){
            if($(mul).val() != "0"){
                if(runNo2 > 0){
                    ysAgingList += ", '"+$(mul).val()+"' ";
                }else{
                    ysAgingList += " '"+$(mul).val()+"' ";
                }
                runNo2 += 1;
            }
        }); 
    }
    
    if(!(ysAgingList == null || ysAgingList.length == 0)){
        whereSQL += " AND A.YSSTAGE IN ("+ysAgingList+") ";
    }
    
    return whereSQL;
    
}


var date = new Date().getDate();
if(date.toString().length == 1){
    date = "0" + date;
} 

function btnGenerate_PDF_Click(){
	
	$("#reportFileName").val("");
    $("#viewType").val("");
    $("#reportDownFileName").val("");
    
    var whereSQL = SQL();
    var memberType = "";
    var orgCode = "";
    var grpCode = "";
    var deptCode = "";
    var keyInBranch = "";
    var printBy = $("#userName").val();
    var membershipType = "";
    var createdDate = "";
    
    
    if($("#cmbMemberType :selected").index() > 0){
    	memberType = $("#cmbMemberType :selected").text();
    }
    if($("#cmbOrgCode :selected").index() > 0){
    	var orgdesc = $("#cmbOrgCode").text().split("-");
    	orgCode = orgdesc[0].trim();
    }
    if($("#cmbGrpCode :selected").index() > 0){
    	var grpdesc = $("#cmbGrpCode").text().split("-");
    	grpCode = grpdesc[0].trim();
    }
    if($("#cmbDeptCode :selected").index() > 0){
    	var deptdesc = $("#cmbDeptCode").text().split("-");
    	deptCode = deptdesc[0].trim();
    }
    if($("#cmbBranch :selected").index() > 0){
    	keyInBranch = $("#cmbBranch :selected").text();
    }
    if($("#cmbMembershipType :selected").index() > 0){
    	membershipType = $("#cmbMembershipType :selected").val();
    }
    if(!($("#dpKeyDateFr").val() == null || $("#dpKeyDateFr").val().length == 0) && !($("#dpKeyDateTo").val() == null || $("#dpKeyDateTo").val().length == 0)){
    	createdDate = $("#dpKeyDateFr").val()+" - "+$("#dpKeyDateTo").val();
    }else{
    	if(!($("#dpKeyDateFr").val() == null || $("#dpKeyDateFr").val().length == 0)){
    		createdDate = $("#dpKeyDateFr").val()+" - ";
    	}else if(!($("#dpKeyDateTo").val() == null || $("#dpKeyDateTo").val().length == 0)){
    		createdDate = " - "+$("#dpKeyDateTo").val();
    	}else{
    		createdDate = " - ";
    	}
    }

    if($("#isHc").val() != null && $("#isHc").val() != ''){
        whereSQL += " AND A.BNDL_ID IS NOT NULL ";
    }else{
        whereSQL += " AND A.BNDL_ID IS NULL ";
    }

    $("#V_WHERESQL").val(whereSQL);
    $("#V_MEMBERTYPE_SHOW").val(memberType);
    $("#V_ORGCODE_SHOW").val(orgCode);
    $("#V_GRPCODE_SHOW").val(grpCode);
    $("#V_DEPTCODE_SHOW").val(deptCode);
    $("#V_KEYINBRANCH_SHOW").val(keyInBranch);
    $("#V_PRINTBY_SHOW").val(printBy);
    $("#V_MEMBERSHIPTYPE_SHOW").val(membershipType);
    $("#V_CREATEDDATE_SHOW").val(createdDate);
    
    $("#reportDownFileName").val("MembershipYSListinge_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#viewType").val("PDF");
    $("#reportFileName").val("/membership/MembershipSales_YS_PDF.rpt");
        
    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.
    };
    
    Common.report("form", option);
    
}

function btnGenerate_Excel_Click(){
	
	$("#reportFileName").val("");
    $("#viewType").val("");
    $("#reportDownFileName").val("");
    
    var whereSQL = SQL();
    
    $("#V_WHERESQL").val(whereSQL);
    $("#V_MEMBERTYPE_SHOW").val("");
    $("#V_ORGCODE_SHOW").val("");
    $("#V_GRPCODE_SHOW").val("");
    $("#V_DEPTCODE_SHOW").val("");
    $("#V_KEYINBRANCH_SHOW").val("");
    $("#V_PRINTBY_SHOW").val("");
    $("#V_MEMBERSHIPTYPE_SHOW").val("Membership");
    $("#V_CREATEDDATE_SHOW").val("");
    
    $("#reportDownFileName").val("MembershipYSListing_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#viewType").val("EXCEL");
    $("#reportFileName").val("/membership/MembershipSales_YS_Excel.rpt");
        
    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.
    };
    
    Common.report("form", option);
    
}
    
function cmbMemberType_SelectedIndexChanged(){
	
	$("#cmbOrgCode").prop("selectedIndex", -1);
	$("#cmbGrpCode").prop("selectedIndex", -1);
	$("#cmbDeptCode").prop("selectedIndex", -1);
	
	$("#cmbOrgCode").prop("disabled", true);
    $("#cmbOrgCode").addClass("disabled");
    $("#cmbGrpCode").prop("disabled", true);
    $("#cmbGrpCode").addClass("disabled");
    $("#cmbDeptCode").prop("disabled", true);
    $("#cmbDeptCode").addClass("disabled");
	
    if($("#cmbMemberType :selected").val() != "4"){
    	if($("#cmbMemberType :selected").val() == "1"){
            CommonCombo.make('cmbOrgCode', '/sales/membership/getOGDCodeList', {memType : $("#cmbMemberType").val(), memLvl : 1, parentID : 124, deptID : 0}, '');         
        }else if($("#cmbMemberType :selected").val() == "2"){
            CommonCombo.make('cmbOrgCode', '/sales/membership/getOGDCodeList', {memType : $("#cmbMemberType").val(), memLvl : 1, parentID : 31983, deptID : 0}, '');
        }else if($("#cmbMemberType :selected").val() == "3"){
            CommonCombo.make('cmbOrgCode', '/sales/membership/getOGDCodeList', {memType : $("#cmbMemberType").val(), memLvl : 1, parentID : 23259, deptID : 0}, '');
        }
    }
    
    $("#cmbOrgCode").prop("disabled", false);
    $("#cmbOrgCode").removeClass("disabled");
}    
    
function cmbOrgCode_SelectedIndexChanged(){
	
	$("#cmbGrpCode").prop("selectedIndex", -1);
    $("#cmbDeptCode").prop("selectedIndex", -1);
	
	$("#cmbGrpCode").prop("disabled", true);
    $("#cmbGrpCode").addClass("disabled");
    $("#cmbDeptCode").prop("disabled", true);
    $("#cmbDeptCode").addClass("disabled");
	
    if($("#cmbOrgCode :selected").index() > 0){
    	CommonCombo.make('cmbGrpCode', '/sales/membership/getOGDCodeList', {memType : $("#cmbMemberType").val(), memLvl : 2, parentID : $("#cmbOrgCode :selected").val(), deptID : 0}, '');
    }
    
    $("#cmbGrpCode").prop("disabled", false);
    $("#cmbGrpCode").removeClass("disabled");
}

function cmbGrpCode_SelectedIndexChanged(){
	
	$("#cmbDeptCode").prop("selectedIndex", -1);
	
	$("#cmbDeptCode").prop("disabled", true);
    $("#cmbDeptCode").addClass("disabled");
    
    if($("#cmbGrpCode :selected").index() > 0){
        CommonCombo.make('cmbDeptCode', '/sales/membership/getOGDCodeList', {memType : $("#cmbMemberType").val(), memLvl : 3, parentID : $("#cmbGrpCode :selected").val(), deptID : 0}, '');
    }
    
    $("#cmbDeptCode").prop("disabled", false);
    $("#cmbDeptCode").removeClass("disabled");
    
}

</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.ysListing" /></h1>
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
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.membershipType" /></th>
    <td>
    <select class="w100p" id="cmbMembershipType">
        <option data-placeholder="true" hidden><spring:message code="sal.text.membershipType" /></option>
        <option value="Rental Membership"><spring:message code="sal.text.rentalMembership" /></option>
        <option value="Outright Membership"><spring:message code="sal.text.outrightMembership" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.text.memtype" /></th>
    <td>
    <select class="w100p" id="cmbMemberType" onchange="cmbMemberType_SelectedIndexChanged()">
        <option data-placeholder="true" hidden><spring:message code="sal.text.memtype" /></option>
        <option value="1"><spring:message code="sal.text.healthPlanner" /></option>
        <option value="2"><spring:message code="sal.text.cowayLady" /></option>
        <option value="3"><spring:message code="sal.text.cowayTechnician" /></option>
        <option value="4"><spring:message code="sal.text.staff" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ysAging" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbYSAging" data-placeholder="YS Aging">
        <option value="1"><spring:message code="sal.text.31Days" /></option>
        <option value="2"><spring:message code="sal.text.60Days" /></option>
        <option value="3"><spring:message code="sal.text.61Days" /></option>
        <option value="4"><spring:message code="sal.text.90Days" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.text.orgCode" /></th>
    <td>
    <select class="w100p disabled" disabled="disabled" id="cmbOrgCode" onchange="cmbOrgCode_SelectedIndexChanged()">
        <option><spring:message code="sal.text.organization" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.crtDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpKeyDateFr"/></p>
    <span><spring:message code="sal.text.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpKeyDateTo"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.text.grpCode" /></th>
    <td>
    <select class="w100p disabled" disabled="disabled" id="cmbGrpCode" onchange="cmbGrpCode_SelectedIndexChanged()">
        <option><spring:message code="sal.text.dept" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.branch" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbBranch" data-placeholder="Branch"></select>
    </td>
    <th scope="row"><spring:message code="sal.text.detpCode" /></th>
    <td>
    <select class="w100p disabled" disabled="disabled" id="cmbDeptCode">
        <option><spring:message code="sal.text.dept" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.outstanding" /></th>
    <td>
    <select class="w100p" id="cmbOutstanding">
        <option data-placeholder="true" hidden><spring:message code="sal.text.outstanding" /></option>
        <option value="OUT"><spring:message code="sal.combo.text.withOutstanding" /></option>
        <option value="OVER"><spring:message code="sal.combo.text.overPaid" /></option>
    </select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->


<ul class="center_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript: btnGenerate_PDF_Click()"><spring:message code="sal.btn.genPDF" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript: btnGenerate_Excel_Click()"><spring:message code="sal.btn.genExcel" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />


<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_MEMBERTYPE_SHOW" name="V_MEMBERTYPE_SHOW" value="" />
<input type="hidden" id="V_ORGCODE_SHOW" name="V_ORGCODE_SHOW" value="" />
<input type="hidden" id="V_GRPCODE_SHOW" name="V_GRPCODE_SHOW" value="" />
<input type="hidden" id="V_DEPTCODE_SHOW" name="V_DEPTCODE_SHOW" value="" />
<input type="hidden" id="V_KEYINBRANCH_SHOW" name="V_KEYINBRANCH_SHOW" value="" />
<input type="hidden" id="V_PRINTBY_SHOW" name="V_PRINTBY_SHOW" value="" />
<input type="hidden" id="V_MEMBERSHIPTYPE_SHOW" name="V_MEMBERSHIPTYPE_SHOW" value="" />
<input type="hidden" id="V_CREATEDDATE_SHOW" name="V_CREATEDDATE_SHOW" value="" />

<input type="hidden" id="userName" name="userName" value="${SESSION_INFO.userName}">
<input id="isHc" name="isHc" type="hidden" value='${isHc}'/>

</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->