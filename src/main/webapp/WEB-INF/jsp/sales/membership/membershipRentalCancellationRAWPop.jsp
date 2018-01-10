<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$(document).ready(function() {
    
	$("#cmbOrgCode").prop("disabled", false);
    $("#cmbOrgCode").removeClass("disabled");
    $("#cmbDeptCode").prop("disabled", true);
    $("#cmbDeptCode").addClass("disabled");
	
	CommonCombo.make('cmbOrgCode', '/sales/membership/getOGDCodeList', {memType : $("#cmbMemberType").val(), memLvl : 1, parentID : 31983, deptID : 0}, '');
	CommonCombo.make('cmbReason', '/sales/membership/selectReasonList', '', '', {id: "resnId", name: "resnName", type: 'M', isCheckAll: false});
	
    /* 멀티셀렉트 플러그인 start */
    $('.multy_select').change(function() {
       //console.log($(this).val());
    })
    .multipleSelect({
       width: '100%'
    });

});

$.fn.clearForm = function() {
	$("#cmbReason").multipleSelect("uncheckAll");
	
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
        $("#cmbGrpCode").prop("selectedIndex", -1);
        $("#cmbDeptCode").prop("selectedIndex", -1);
        
        $("#cmbGrpCode").prop("disabled", true);
        $("#cmbGrpCode").addClass("disabled");
        $("#cmbDeptCode").prop("disabled", true);
        $("#cmbDeptCode").addClass("disabled");
    });
};

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
    
    if($("#cmbMemberType :selected").val() == "1"){
        CommonCombo.make('cmbOrgCode', '/sales/membership/getOGDCodeList', {memType : $("#cmbMemberType").val(), memLvl : 1, parentID : 3487, deptID : 0}, '');         
    }else if($("#cmbMemberType :selected").val() == "2"){
        CommonCombo.make('cmbOrgCode', '/sales/membership/getOGDCodeList', {memType : $("#cmbMemberType").val(), memLvl : 1, parentID : 31983, deptID : 0}, '');
    }else if($("#cmbMemberType :selected").val() == "3"){
        CommonCombo.make('cmbOrgCode', '/sales/membership/getOGDCodeList', {memType : $("#cmbMemberType").val(), memLvl : 1, parentID : 23259, deptID : 0}, '');
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

function btnGenerate_Excel_Click(){
	
	$("#reportFileName").val("");
    $("#viewType").val("");
    $("#reportDownFileName").val("");
	
    var whereSQL = "";
    
    if(!($("#txtCanNo").val().trim() == null || $("#txtCanNo").val().trim().length == 0)){
        whereSQL += " AND SCT.TRMNAT_REF_NO = '"+$("#txtCanNo").val().trim()+"' ";          
    }
    if(!($("#txtSrvContract").val().trim() == null || $("#txtSrvContract").val().trim().length == 0)){
        whereSQL += " AND SC.SRV_CNTRCT_REF_NO = '"+$("#txtSrvContract").val().trim()+"' ";          
    }
    if(!($("#txtOrderNo").val().trim() == null || $("#txtOrderNo").val().trim().length == 0)){
        whereSQL += " AND ORM.SALES_ORD_NO = '"+$("#txtOrderNo").val().trim()+"' ";          
    }
    if($("#cmbOrgCode :selected").index() > 0){
    	var orgdesc = $("#cmbOrgCode").text().split("-");
    	var orgcode = orgdesc[0].trim();
    	whereSQL += " AND ORG.ORG_CODE = '"+orgcode+"' ";
    }
    if($("#cmbGrpCode :selected").index() > 0){
        var grpdesc = $("#cmbGrpCode").text().split("-");
        var grpcode = grpdesc[0].trim();
        whereSQL += " AND ORG.GRP_CODE = '"+grpcode+"' ";
    }
    if($("#cmbDeptCode :selected").index() > 0){
        var deptdesc = $("#cmbDeptCode").text().split("-");
        var deptcode = deptdesc[0].trim();
        whereSQL += " AND ORG.DEPT_CODE = '"+deptcode+"' ";
    }
    if(!($("#dpReqDateFr").val() == null || $("#dpReqDateFr").val().length == 0)){
        whereSQL += " AND SCT.TRMNAT_CRT_DT >= TO_DATE('"+$("#dpReqDateFr").val()+"', 'dd/MM/YY') ";
    }
    if(!($("#dpReqDateTo").val() == null || $("#dpReqDateTo").val().length == 0)){
        whereSQL += " AND SCT.TRMNAT_CRT_DT < TO_DATE('"+$("#dpReqDateTo").val()+"', 'dd/MM/YY') ";
    }
    if($("#cmbCustType :selected").index() > 0){
    	whereSQL += " AND C.TYPE_ID = "+$("#cmbCustType :selected").val().trim()+" ";
    }
    
    var runNo1 = 0;
    var reasonList = "";
    if($('#cmbReason :selected').length > 0){
        $('#cmbReason :selected').each(function(j, mul){
        	if($(mul).val() != "0"){
        		if(runNo1 > 0){
        			reasonList += ", '"+$(mul).val()+"' ";
        		}else{
        			reasonList += "'"+$(mul).val()+"' ";
        		}
        		runNo1 += 1;
        	}
        });
    }
    
    if(!(reasonList == null || reasonList.length == 0)){
    	whereSQL += " AND SCT.TRMNAT_RESN_ID IN ("+reasonList+") ";
    }
    
    $("#V_WHERESQL").val(whereSQL);
	
    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    } 
    $("#reportDownFileName").val("MembershipCancellationRaw_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#viewType").val("EXCEL");
    $("#reportFileName").val("/sales/ServiceContract_CancellationRaw.rpt");
            
    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.
    };
        
    Common.report("form", option);
	
}
</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.memberApplicantListing" /></h1>
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
    <th scope="row"><spring:message code="sal.text.cancellationNo" /></th>
    <td><input type="text" title="" placeholder="Cancellation No." class="w100p" id="txtCanNo"/></td>
    <th scope="row"><spring:message code="sal.text.memtype" /></th>
    <td>
    <select class="w100p disabled" id="cmbMemberType" onchange="cmbMemberType_SelectedIndexChanged()"  disabled>
        <option value="1"><spring:message code="sal.text.healthPlanner" /></option>
        <option value="2" selected><spring:message code="sal.text.cowayLady" /></option>
        <option value="3"><spring:message code="sal.text.cowayTechnician" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.requestedDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" placeholder="DD/MM/YYYY" class="j_date" id="dpReqDateFr"/></p>
    <span>To</span>
    <p><input type="text" placeholder="DD/MM/YYYY" class="j_date" id="dpReqDateTo"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.text.orgCode" /></th>
    <td>
    <select class="w100p disabled" id="cmbOrgCode" onchange="cmbOrgCode_SelectedIndexChanged()" disabled>
        <option data-placeholder="true" hidden>Organization</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ordNo" />.</th>
    <td><input type="text" title="" placeholder="Order No" class="w100p" id="txtOrderNo"/></td>
    <th scope="row"><spring:message code="sal.text.grpCode" /></th>
    <td>
    <select class="w100p disabled" id="cmbGrpCode" onchange="cmbGrpCode_SelectedIndexChanged()" disabled>
        <option data-placeholder="true" hidden>Department</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.membershipNo" />.</th>
    <td><input type="text" title="" placeholder="Membership No." class="w100p" id="txtSrvContract"/></td>
    <th scope="row"><spring:message code="sal.text.detpCode" /></th>
    <td>
    <select class="w100p" id="cmbDeptCode">
        <option data-placeholder="true" hidden>Department</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.cancellationReason" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbReason" data-placeholder="Cancellation Reason"></select>
    </td>
    <th scope="row"><spring:message code="sal.text.custType" /></th>
    <td>
    <select class="w100p" id="cmbCustType">
        <option data-placeholder="true" hidden>Customer Type</option>
        <option value="965"><spring:message code="sal.text.company" /></option>
        <option value="964"><spring:message code="sal.text.individual" /></option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->


<ul class="center_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript: btnGenerate_Excel_Click()"><spring:message code="sal.btn.genExcel" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />

</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->