<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javascript">


$(document).ready(function() {
	/* 멀티셀렉트 플러그인 start */
	$('.multy_select').change(function() {
	   //console.log($(this).val());
	})
	.multipleSelect({
	   width: '100%'
	});

	CommonCombo.make('cmbBranch', '/sales/ccp/getBranchCodeList', '' , '');
//	CommonCombo.make('cmbCreateBy', '/sales/trBook/getCreateByList', '' , ''); 
	
	setDefaultValue();
	
});

function setDefaultValue(){
	$("#cboDepartment").multipleSelect("disable");
    $("#cboGroup").multipleSelect("disable");
    $("#cboOrganization").multipleSelect("disable");
    $("#cboMember").prop("disabled", true);
    $("#cboMember").addClass("disabled");
    
}

function ddlHolderType_SelectedIndexChanged(){

	if($("#ddlHolderType :selected").text() == "Member"){
		$("#cboMember").prop("disabled", false);
        $("#cboMember").removeClass("disabled");

	}else{
		$("#cboMember").prop("disabled", true);
	    $("#cboMember").addClass("disabled");
        $("#cboOrganization").multipleSelect("uncheckAll");
	    $("#cboOrganization").multipleSelect("disable");
	    $("#cboGroup").multipleSelect("uncheckAll");
	    $("#cboGroup").multipleSelect("disable");	
	    $("#cboDepartment").multipleSelect("uncheckAll");
        $("#cboDepartment").multipleSelect("disable");  
	}	
}

function validRequiredField(){
	
	var valid = true;
	var message = "";
	
	if(($("#dpUpdateFromDate").val() == null || $("#dpUpdateFromDate").val().length == 0) || ($("#dpUpdateToDate").val() == null || $("#dpUpdateToDate").val().length == 0)){
		valid = false;
        message += "<spring:message code="sal.alert.msg.keyInDateFromTo" /></br>";
	}
	
	/* 
	if($("#cmbBranch :selected").index() <= -1){
		valid = false;
        message += "* Please select the key-in branch.\n";
	}
	*/	
	
	if(valid == false){
		Common.alert("<spring:message code="sal.alert.title.warning" />" + DEFAULT_DELIMITER + message);
	}
	
	return valid;
	
}

function btnGenerateExcel_Click(){
	
	if(validRequiredField()){
		if($("#ddlHolderType :selected").text() == "Branch"){
			fn_report("EXCEL");
		}else if($("#cboMember :selected").index() > -1){
			if($('#cboOrganization :selected').length > 0){
				fn_report("EXCEL");
			}else{
				Common.alert("<spring:message code="sal.alert.msg.organisationCodeToPrint" />");
			}
		}
	}
}

function btnGeneratePDF_Click(){
	
	if(validRequiredField()){
        if($("#ddlHolderType :selected").text() == "Branch"){
            fn_report("PDF");
        }else if($("#cboMember :selected").index() > -1){
            if($('#cboOrganization :selected').length > 0){
                fn_report("PDF");
            }else{
                Common.alert("<spring:message code="sal.alert.msg.organisationCodeToPrint" />");
            }
        }
    }
}

function fn_report(viewType){
	
	$("#reportFileName").val("");
	$("#viewType").val("");
	$("#reportDownFileName").val("");
	
	var whereSQL = "";
	var showDateFrom = "";
	
	if(!($("#dpUpdateFromDate").val() == null || $("#dpUpdateFromDate").val().length == 0) && !($("#dpUpdateToDate").val() == null || $("#dpUpdateToDate").val().length == 0)){
		whereSQL += " WHERE M.TR_BOOK_UPD_DT BETWEEN TO_DATE('"+$("#dpUpdateFromDate").val()+"', 'dd/MM/YY') AND TO_DATE('"+$("#dpUpdateToDate").val()+"', 'dd/MM/YY')";
		showDateFrom = $("#dpUpdateFromDate").val()+" To "+$("#dpUpdateToDate").val();
	
	}
	
	var showKeyInBranch = "";
	if($("#cmbBranch :selected").index() > 0){
		if($("#cmbBranch :selected").text() != ""){
			whereSQL += " AND M.TR_BOOK_CRT_BRNCH_CODE = '"+$("#cmbBranch :selected").val()+"' ";
		}
		showKeyInBranch = $("#cmbBranch :selected").text();
	}
	
	var showKeyDepartment = "-";
	if($("#cboMember :selected").index() > 0){
		var mbrID = "";
		var mbrID1 = "";
		var mbrID2 = "";
		var mbrID3 = "";
		
		if(parseInt($("#cboMember :selected").val()) == 4){
			var cnt = 0;
			$('#cboDepartment :selected').each(function(j, mul){ 
				if(cnt == 0){
					mbrID += $(mul).val(); 	
				}else{
					mbrID += ", "+$(mul).val();
				}
				cnt += 1;
				
			});
			whereSQL += " AND mbr.MEM_ID IN ("+mbrID+") ";
			
		}else{
			var cnt = 0;
			if($('#cboOrganization :selected').length > 0){
				$('#cboDepartment :selected').each(function(j, mul){
					if(cnt == 0){
						mbrID1 += " '"+$(mul).val().substring(0, 7)+"' ";
					}else{
						mbrID1 += ", '"+$(mul).val().substring(0, 7)+"' ";
					}
					cnt += 1;
				});
			//	whereSQL += " AND mbr.MEM_ID IN ("+mbrID+") ";
			}
			
			if($('#cboGroup :selected').length > 0){
				$('#cboGroup :selected').each(function(j, mul){
                    if(cnt == 0){
                        mbrID2 += " '"+$(mul).val().substring(0, 7)+"' ";
                    }else{
                        mbrID2 += ", '"+$(mul).val().substring(0, 7)+"' ";
                    }
                    cnt += 1;
                });
            //  whereSQL += " AND mbr.MEM_ID IN ("+mbrID+") ";
			}
			
		    if($('#cboDepartment :selected').length > 0){
		    	$('#cboDepartment :selected').each(function(j, mul){
                    if(cnt == 0){
                        mbrID3 += " '"+$(mul).val().substring(0, 7)+"' ";
                    }else{
                        mbrID3 += ", '"+$(mul).val().substring(0, 7)+"' ";
                    }
                    cnt += 1;
                });
            //  whereSQL += " AND mbr.MEM_ID IN ("+mbrID+") ";
            }
		    
		    showKeyDepartment = $("#cboDepartment :selected").text();
		    whereSQL += " AND mbrOrg.DEPT_CODE IN ("+mbrID1+mbrID2+mbrID3+") ";
		}
	}
	
	/* 
	if($("#cboDepartment :selected").index() > 0){
		if(parseInt($("#cboMember :selected").val()) == 4){
			whereSQL += " AND mbr.MEM_ID = '"+$("#cboDepartment :selected").val()+"' ";
		}else{
			whereSQL += " AND mbrOrg.DEPT_CODE = '"+$("#cboDepartment :selected").text().substring(0, 7)+"' ";
			showKeyDepartment = $("#cboDepartment :selected").text();
		
		}
	}
	*/
	
	var showHolderType = "-";
	if($("#ddlHolderType :selected").index() > 0){
		if($("#ddlHolderType :selected").text() == "Branch"){
			whereSQL += " AND br.CODE IS NOT NULL";
		}else{
			whereSQL +=  " AND mbr.MEM_CODE IS NOT NULL";
		}
		showHolderType = $("#ddlHolderType :selected").text();
	}
	
	var showCreateBy = "-";
	if($("#txtCreator").val().trim() != ""){
		whereSQL += " AND usr.USER_NAME = '"+$("#txtCreator").val()+"' ";
		showCreateBy = $("#txtCreator").val();
	}
	
	if($("#txtTRBookHolder").val().trim() != ""){
        whereSQL += " AND Grp1.TR_HOLDER = '"+$("#txtTRBookHolder").val()+"' ";
    }
	
	var showStatus = "-";
	if($('#ddlBookStatus :selected').length > 0){
		
		var result = "";
		$('#ddlBookStatus :selected').each(function(j, mul){
			result += $(mul).val();
		});
		
		if(result == "ACTCLOLOST"){
			whereSQL += " AND (SC.CODE='ACT' OR SC.CODE='CLO' OR SC.CODE='LOST')";
			showStatus = "ACT/CLO/LOST";	
			
		}else if(result == "ACTCLO"){
			whereSQL += " AND (SC.CODE='ACT' OR SC.CODE='CLO')";
            showStatus = "ACT/CLO";
            
        }else if(result == "ACTLOST"){
        	whereSQL += " AND (SC.CODE='ACT' OR SC.CODE='LOST')";
            showStatus = "ACT/LOST";
            
        }else if(result == "CLOLOST"){
        	whereSQL += " AND (SC.CODE='CLO' OR SC.CODE='LOST')";
            showStatus = "CLO/LOST";
            
        }else if(result == "ACT"){
        	whereSQL += " AND SC.CODE='ACT'";
            showStatus = "ACT";
            
        }else if(result == "CLO"){
        	whereSQL += " AND SC.CODE='CLO'";
            showStatus = "CLO";
            
        }else if(result == "LOST"){
        	whereSQL += " AND SC.CODE='LOST'";
            showStatus = "LOST";
            
        }	
	}
	
	var showBookNo = "-";
	if($("#txtTRBookNo").val().trim() != ""){
        whereSQL += " AND M.TR_BOOK_NO = '"+$("#txtTRBookNo").val()+"' ";
        showBookNo = $("#txtTRBookNo").val();
    }
	
	var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    } 
    $("#reportDownFileName").val("TR Book Management Summary Listing_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    if(viewType == "PDF"){
    	$("#viewType").val("PDF");
        $("#reportFileName").val("/sales/CRGenerateTRBook_SummaryListing_PDF_1.rpt");
    	
    }else{
    	$("#viewType").val("EXCEL");
        $("#reportFileName").val("/sales/CRGenerateTRBook_SummaryListing_Excel.rpt");
    	
    }
    
    
    console.log(whereSQL);
    
    $("#V_SHOWDATEFROM").val(showDateFrom);
    $("#V_SHOWKEYINBRANCH").val(showKeyInBranch);
    $("#V_SHOWSTATUS").val(showStatus);
    $("#V_SHOWHOLDERTYPE").val(showHolderType);
    $("#V_SHOWDEPARTMENTCODE").val(showKeyDepartment);
    $("#V_WHERESQL").val(whereSQL); 
    
    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };
    
    Common.report("form", option);
}

function cboMember_SelectedIndexChanged(){
	
 	setDefaultValue();
    $("#cboOrganization").multipleSelect("uncheckAll");
    $("#cboGroup").multipleSelect("uncheckAll");
    $("#cboDepartment").multipleSelect("uncheckAll");
    
    if(parseInt($("#cboMember :selected").val()) < 4){

    	var arrparentID0 = 3487;
        var arrparentID1 = 31983;
        var arrparentID2 = 23259;
        
        if($("#cboMember :selected").val() == "1"){
            CommonCombo.make('cboOrganization', '/sales/trBook/getOrganizationCodeList', {memType : $("#cboMember").val(), memLvl : 1, parentID : arrparentID0}, '', {type:'M', isCheckAll:false});         
        }else if($("#cboMember :selected").val() == "2"){
            CommonCombo.make('cboOrganization', '/sales/trBook/getOrganizationCodeList', {memType : $("#cboMember").val(), memLvl : 1, parentID : arrparentID1}, '', {type:'M', isCheckAll:false});
        }else if($("#cboMember :selected").val() == "3"){
            CommonCombo.make('cboOrganization', '/sales/trBook/getOrganizationCodeList', {memType : $("#cboMember").val(), memLvl : 1, parentID : arrparentID2}, '', {type:'M', isCheckAll:false});
        }
        
        $("#cboOrganization").multipleSelect("enable");
        $("#cboMember").prop("disabled", false);
        $("#cboMember").removeClass("disabled");
        $("#cboGroup").multipleSelect("disable");
        $("#cboGroup").multipleSelect("uncheckAll");
        $("#cboDepartment").multipleSelect("uncheckAll");
        
    }else{
    	
    	var arrparentID0 = 0;  
        CommonCombo.make('cboDepartment', '/sales/trBook/getOrganizationCodeList', {memType : $("#cboMember").val(), memLvl : 4, parentID : arrparentID0}, '', {type:'M', isCheckAll:false});
        
        $("#cboDepartment").multipleSelect("enable");
        $("#cboMember").prop("disabled", false);
        $("#cboMember").removeClass("disabled");
        $("#cboGroup").multipleSelect("uncheckAll");
        $("#cboDepartment").multipleSelect("uncheckAll");
        
    } 
}

function cboOrganization_SelectedIndexChanged(){
	
	$("#cboDepartment").multipleSelect("disable");
	
    var total_item = new Array();
    var i = 0;
    $('#cboOrganization :selected').each(function(j, mul){ 
        total_item[i] = $(mul).val();
        i++;
    });
    
    CommonCombo.make('cboGroup', '/sales/trBook/getOrganizationCodeList', {memType : $("#cboMember").val(), memLvl : 2, parentID : total_item}, '', {type:'M', isCheckAll:false});
    
    if($('#cboOrganization :selected').length > 0){
        $("#cboGroup").multipleSelect("enable");
    }
     
}

function cboGroup_SelectedIndexChanged(){
	
    var total_item = new Array();
    var i = 0;
    $('#cboGroup :selected').each(function(j, mul){ 
       total_item[i] = $(mul).val();
        i++;
    });
  
    CommonCombo.make('cboDepartment', '/sales/trBook/getOrganizationCodeList', {memType : $("#cboMember").val(), memLvl : 3, parentID : total_item}, '', {type:'M', isCheckAll:false});
    
    if($('#cboGroup :selected').length > 0){
        $("#cboDepartment").multipleSelect("enable");
    }
	
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.trBookMgmtSummaryListing" /></h1>
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
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.bookNo" /></th>
    <td><input type="text" title="" placeholder="Book No" class="w100p" id="txtTRBookNo"/></td>
    <th scope="row"><spring:message code="sal.text.returnToBranch" /></th>
    <td>
        <select class="w100p" id="cmbBranch"></select>
    </td>
    <th scope="row"><spring:message code="sal.text.updateDate" /></th>
    <td>
        <div class="date_set w100p"><!-- date_set start -->
        <p><input type="text"  placeholder="DD/MM/YYYY" class="j_date" id="dpUpdateFromDate"/></p>
        <span>To</span>
        <p><input type="text"  placeholder="DD/MM/YYYY" class="j_date" id="dpUpdateToDate"/></p>
        </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.createBy" /></th>
    <td><input type="text" title="" placeholder="Create By" class="w100p" id="txtCreator"/></td>
    <th scope="row"><spring:message code="sal.text.bookHolder" /></th>
    <td><input type="text" title="" placeholder="Book Holder" class="w100p" id="txtTRBookHolder"/></td>
    <th scope="row"><spring:message code="sal.text.holderType" /></th>
    <td>
        <select class="w100p" id="ddlHolderType" onchange="ddlHolderType_SelectedIndexChanged()">
            <option data-placeholder="true" hidden><spring:message code="sal.text.holderType" /></option>
            <option value="Branch"><spring:message code="sal.text.branch" /></option>
            <option value="Member"><spring:message code="sal.text.member" /></option>
        </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.status" /></th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="ddlBookStatus" data-placeholder="Status">
            <option value="ACT" selected><spring:message code="sal.text.active" /></option>
            <option value="CLO" selected><spring:message code="sal.text.close" /></option>
            <option value="LOST" selected><spring:message code="sal.text.lost" /></option>
        </select>
    </td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.memtype" /></th>
    <td>
        <select class="w100p" id="cboMember" onchange="cboMember_SelectedIndexChanged()">
            <option data-placeholder="true" hidden value="0"><spring:message code="sal.text.memtype" /></option>
            <option value="1"><spring:message code="sal.text.healthPlanner" /></option>
            <option value="2"><spring:message code="sal.text.cowayLady" /></option>
            <option value="3"><spring:message code="sal.text.cowayTechnician" /></option>
            <option value="4"><spring:message code="sal.text.staff" /></option>
        </select>
    </td>
    <th scope="row"><spring:message code="sal.text.organizationCode" /></th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="cboOrganization" data-placeholder="Organization Code" onchange="cboOrganization_SelectedIndexChanged()"></select>
    </td>
    <th scope="row"><spring:message code="sal.text.GroupCode" /></th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="cboGroup" data-placeholder="Group Code" onchange="cboGroup_SelectedIndexChanged()"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.departmentCode" /></th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="cboDepartment" data-placeholder="Department Code"></select>
    </td>
    <td colspan="4"></td>
</tr>
</tbody>
</table><!-- table end -->


<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript: btnGeneratePDF_Click()"><spring:message code="sal.btn.genToPdf" /></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript: btnGenerateExcel_Click()"><spring:message code="sal.btn.getToExcel" /></a></p></li>
</ul>


<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_SHOWDATEFROM" name="V_SHOWDATEFROM" value="" />
<input type="hidden" id="V_SHOWKEYINBRANCH" name="V_SHOWKEYINBRANCH" value="" />
<input type="hidden" id="V_SHOWSTATUS" name="V_SHOWSTATUS" value="" />
<input type="hidden" id="V_SHOWHOLDERTYPE" name="V_SHOWHOLDERTYPE" value="" />
<input type="hidden" id="V_SHOWDEPARTMENTCODE" name="V_SHOWDEPARTMENTCODE" value="" />
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />


</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->