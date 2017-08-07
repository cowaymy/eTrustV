<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
$(document).ready(function() {
    
	var selCodeInitial = $("#selCodeInitial").val();
	var selCodeRace = $("#selCodeRace").val();
	
	doGetCombo('/common/selectCodeList.do', '17', selCodeInitial, 'cmbInitialTypeId', 'S' , ''); // Customer Initial Type Combo Box
	doGetCombo('/common/selectCodeList.do', '2', selCodeRace, 'cmbRaceTypeId', 'S' , ''); // Customer Race Type Combo Box
	
	// main 일 경우 delete 버튼 숨기기
    if($("#stusCodeId").val() == 9){
        $("#_delBtn").css("display", "none" );
    } 
	
	// update Button Click
	$("#_updBtn").click(function() {
		// 1. validation
		//Initial
		if("" == $("#cmbInitialTypeId").val() || null == $("#cmbInitialTypeId").val()){
			Common.alert("<spring:message code='sys.common.alert.validation' arguments='Initial'/>");
			return;
		}
		//Gender
		if("" == $("input[name='gender']").val() || null == $("input[name='gender']").val()){
			Common.alert("<spring:message code='sys.common.alert.validation' arguments='Gender'/>");
			return;
		}
		//Customer Name
		if("" == $("#name").val() || null == $("#name").val()){
			Common.alert("<spring:message code='sys.common.alert.validation' arguments='Customer Name'/>");
			return;
		}
		//Race
		if("" == $("#cmbRaceTypeId").val() || null == $("#name").val()){
			Common.alert("<spring:message code='sys.common.alert.validation' arguments='Race'/>");
			return;
		}
		//Nric
		if("" != $("#nric").val() || null != $("#name").val()){
			if(FormUtil.checkNum($("#nric"))){
				Common.alert("* Invalid nric number.");
				return;
			}
		}
		//Tel
		if(("" == $("#telm").val() || null == $("#telm").val()) && ("" == $("#telr").val() || null == $("#telr").val())
				&& ("" == $("#telo").val() || null == $("#telo").val()) && ("" == $("#telf").val() || null == $("#telf").val())){
			
			Common.alert("* Please key in at least one contact number.");
            return;
		}else{
			// telm(Mobile)
			if("" != $("#telm").val() || null != $("#telm").val()){
				if(FormUtil.checkNum($("#telm"))){
					Common.alert("* Invalid telephone number (Mobile).");
					return;
				}
			}
			// telr(Residence)
			if("" != $("#telr").val() || null != $("#telr").val()){
                if(FormUtil.checkNum($("#telr"))){
                    Common.alert("* Invalid telephone number (Residence).");
                    return;
                }
            }
			// telo(Office)
			if("" != $("#telo").val() || null != $("#telo").val()){
                if(FormUtil.checkNum($("#telo"))){
                    Common.alert("* Invalid telephone number (Office).");
                    return;
                }
            }
			// telf(Fax)
			if("" != $("#telf").val() || null != $("#telf").val()){
                if(FormUtil.checkNum($("#telf"))){
                    Common.alert("* Invalid telephone number (Fax).");
                    return;
                }
            }
			
		}// tel end
		
	    //Ext
	    if(""  != $("#extNo").val() && null != $("#extNo").val()){
	    	
	    	if(FormUtil.checkNum($("#extNo"))){
	    		 Common.alert("* Invalid Ext No. number.");
	    		 return;
	    	}
	    }
		//Email
		if("" != $("#email").val() && null != $("#email").val()){
			
			if(FormUtil.checkEmail($("#email").val())){
				 Common.alert("* Invalid email address.");
                 return;
			}
		}
		
		// Validation Success
		// 2. Update
		fn_customerContactInfoUpdateAjax()();
		
	});
	
	 //Delete
    $("#_delBtn").click(function() {
       Common.confirm("Are you sure want to delete this contact person ?", fn_deleteContactAjax);
    });
}); // Document Ready Func End

/* ####### update Func ########### */
	// Call Ajax - DB Update
	function fn_customerContactInfoUpdateAjax(){
	    Common.ajax("GET", "/sales/customer/updateCustomerContactInfoAf.do",$("#updForm").serialize(), function(result) {
	        Common.alert(result.message, fn_parentReload);
	    });
	}
	
	// Parent Reload Func
	function fn_parentReload() {
	    window.opener.document.location.reload();
	    window.opener.opener.parent.fn_selectPstRequestDOListAjax();
	}
/* ####### update Func  End########### */

/* ####### delete Func ########### */
    //delete
	function fn_deleteContactAjax(){
	    
	    Common.ajax("GET", "/sales/customer/deleteCustomerContact.do", $("#updForm").serialize(), function(result){
	        //result alert and closePage
	        Common.alert(result.message, fn_closePage);
	    });
	}
	
	//Parent Reload and PageClose Func
	function fn_closePage(){
	    //Parent Window Method Call
	    window.opener.opener.parent.fn_selectPstRequestDOListAjax();
	    window.opener.document.location.reload();
	    window.close(); 
	}
/* ####### delete Func End ########### */
</script>

<!-- getParams  -->
<input type="hidden" value="${detailcontact.custInitial}" id="selCodeInitial">
<input type="hidden" value="${detailcontact.raceId}" id="selCodeRace">
<input type="hidden" value="${detailcontact.stusCodeId}" id="stusCodeId">
<section class="pop_body"><!-- pop_body start -->
<form id="updForm"> <!-- Form Start  -->
<input type="hidden" value="${detailcontact.custCntcId }" name="custCntcId">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Initial<span class="must">*</span></th>
    <td>
    <select class="w100p" id="cmbInitialTypeId" name="initial"></select>
    </td>
    <th scope="row">Gender<span class="must">*</span></th>
    <td>
    <label><input type="radio" name="gender"  value="M" <c:if test="${detailcontact.gender eq 'M' }">checked</c:if>/><span>Male</span></label>
    <label><input type="radio" name="gender"  value="F" <c:if test="${detailcontact.gender ne 'M' }">checked</c:if>/><span>Female</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Name<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p"  value="${detailcontact.name1 }" id="name" name="name"/></td>
    <th scope="row">Race<span class="must">*</span></th>
    <td>    
    <select class="w100p" id="cmbRaceTypeId" name="cmbRaceTypeId"></select>
    </td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><input type="text" title="" placeholder="" class="w100p"  value="${detailcontact.nric }" name="nric" id="nric" maxlength="18"/></td>
    <th scope="row">DOB</th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" value="${detailcontact.dob}" name="dob"/>
    </td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p"  value="${detailcontact.telM1}" id="telm" name="telm"/></td>
    <th scope="row">Tel (Office)<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p" value="${detailcontact.telO}" id="telo" name="telo"/></td>
</tr>
<tr>
    <th scope="row">Tel (Residence)<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p"  value="${detailcontact.telR }" id="telr" name="telr"/></td>
    <th scope="row">Tel (Fax)<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="Telephone Number(Fax)" class="w100p"  value="${detailcontact.telf}" id="telf" name="telf"/></td>
</tr>
<tr>
    <th scope="row">Department</th>
    <td><input type="text" title="" placeholder="Department" class="w100p"  value="${detailcontact.dept}" name="dept"/></td>
    <th scope="row">Job Position</th>
    <td><input type="text" title="" placeholder="Job Position" class="w100p"  value="${detailcontact.pos}" name="pos"/></td>
</tr>
<tr>
    <th scope="row">Ext No.</th>
    <td><input type="text" title="" placeholder="Extension Number" class="w100p"  value="${detailcontact.ext}" id="extNo" name="expno"/></td>
    <th scope="row">Email</th>
    <td><input type="text" title="" placeholder="" class="w100p" value="${detailcontact.email}" id="email" name="email"/></td>
</tr>
</tbody>
</table><!-- table end -->
</form> <!--Form End  -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="_updBtn">Update</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="_delBtn">Delete</a></p></li>
</ul>

</section><!-- pop_body end -->