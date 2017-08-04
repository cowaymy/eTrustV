<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	
	var selCodeCustId = $("#selCodeCustId").val(); // TypeId 
	var selCodeCorpId = $("#selCodeCorpId").val();
	var selCodeNation = $("#selCodeNation").val();
	var selCodeRaceId = $("#selCodeRaceId").val(); //race id
	
	doGetCombo('/common/selectCodeList.do', '95', selCodeCorpId ,'cmbCorpTypeId', 'S', '');     // Company Type Combo Box
	doGetCombo('/common/selectCodeList.do', '8', selCodeCustId ,'cmbCustTypeId', 'S', '');       // Customer Type Combo Box
	doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , selCodeNation,'cmdNationTypeId', 'A', '');        // Nationality Combo Box
	doGetCombo('/common/selectCodeList.do', '2', selCodeRaceId ,'cmdRaceTypeId', 'S', ''); //cmdRaceTypeId
	//TypeId 에 따른 수정항목 Control
	// individual
	if(selCodeCustId == '964'){
		$("#cmbCustTypeId").attr("disabled" , "disabled");
		$("#cmbCorpTypeId").attr({"class" : "disabled w100p" , "disabled" : "disabled"});
		$("#nric").attr({"class":"readonly w100p","readonly" : "readonly"});
		$("input[name='gender']").attr("disabled" , false);
		$("#cmdRaceTypeId").attr("disabled" , false);
		$("#cmdNationTypeId").attr("disabled" , "disabled");
		$("#dob").attr("disabled" , false);
	}
	// company
	if(selCodeCustId == '965'){
		$("#cmbCustTypeId").attr("disabled" , "disabled");
		$("#cmbCorpTypeId").attr({"class" : "w100p" , "disabled" : false});
		$("#nric").attr({"class":"readonly w100p","readonly" : "readonly"});
		$("input[name='gender']").attr("disabled" , "disabled");
		$("#cmdRaceTypeId").attr({"disabled" : "disabled" , "class":"disabled w100p"});
		$("#cmdNationTypeId").attr("disabled" , "disabled");
		$("#dob").attr("disabled" , "disabled");
	}
    
	 // 수정 항목 변경 
    $("#_editCustomerInfo").change(function(){
              
            var stateVal = $(this).val();
            $("#_selectParam").val(stateVal);
    });
	 
    $("#_confirm").click(function () {
        
        var status = $("#_selectParam").val();
        
        if(status == '1'){
            $("#editForm").attr({"target" :"_self" , "action" : "/sales/customer/updateCustomerBasicInfoPop.do" }).submit();
        }
        if(status == '2'){
            $("#editForm").attr({"target" :"_self" , "action" : "/sales/customer/updateCustomerAddressPop.do" }).submit();
        }
        if(status == '3'){
            $("#editForm").attr({"target" :"_self" , "action" : "/sales/customer/updateCustomerContactPop.do" }).submit();
        }
        if(status == '4'){
            $("#editForm").attr({"target" :"_self" , "action" : "/sales/customer/updateCustomerBankAccountPop.do" }).submit();
        }
        if(status == '5'){
            $("#editForm").attr({"target" :"_self" , "action" : "/sales/customer/updateCustomerCreditCardPop.do" }).submit();
        }
        if(status == '6'){
            $("#editForm").attr({"target" :"_self" , "action" : "/sales/customer/updateCustomerBasicInfoLimitPop.do" }).submit();
        }
        
    });
	
    // update Button Click
    $("#_updBtn").click(function(){
       
        /*********** individual ***********/
        if(selCodeCustId == '964'){
        	// 1. validation
        	//Customer Name
        	if('' == $("#name").val() || null == $("#name").val()){
        		Common.alert("<spring:message code='sys.common.alert.validation' arguments='Customer Name'/>");
            	return;
            }
        	//Race
        	if('' == $("#cmdRaceTypeId").val() || null == $("#cmdRaceTypeId").val()){
        		Common.alert("<spring:message code='sys.common.alert.validation' arguments='Race'/>");
        		return;
        	}
        	//Email 
        	if('' != $("#email").val() && null != $("#email").val()){
        		
        		if(FormUtil.checkEmail($("#email").val()) == true){
                    Common.alert("* Invalid email address.");
                    return;
                 }
        	}
        	// 2. update
        	fn_getCustomerBasicAjax();
        }
        
        /*********** company ***********/
        if(selCodeCustId == '965'){
        	// 1. validation
        	//Company Type
        	if('' == $("#cmbCorpTypeId").val() || null == $("#cmbCorpTypeId").val()){
        		Common.alert("<spring:message code='sys.common.alert.validation' arguments='Company Type'/>");
        		return;
        	}
        	//Customer Name
        	if('' == $("#name").val() || null == $("#name").val()){
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='Customer Name'/>");
                return;
            }
        	//Email 
            if('' != $("#email").val() && null != $("#email").val()){
                
                if(FormUtil.checkEmail($("#email").val()) == true){
                    Common.alert("* Invalid email address.");
                    return;
                 }
            }
        	// 2. update
        	fn_getCustomerBasicAjax();
        }
    });
    
    //update
    function fn_getCustomerBasicAjax(){
        Common.ajax("GET", "/sales/customer/updateCustomerBasicInfoAf.do",$("#updForm").serialize(), function(result) {
            Common.alert(result.message, fn_reloadPage);
        });
    }
    
    //reload Page func
    function fn_reloadPage(){
    	
    	$("#editForm").attr({"target" :"_self" , "action" : "/sales/customer/updateCustomerBasicInfoPop.do" }).submit();
    }
});
</script>
<!-- getParams  -->
<input type="hidden" value="${result.typeId }" id="selCodeCustId"> <!-- TypeId : 964(Individual) / 965(Company)  --> 
<input type="hidden" value="${result.corpTypeId}" id="selCodeCorpId">
<input type="hidden" value="${result.nation }" id="selCodeNation">
<input type="hidden" value="${result.raceId }" id="selCodeRaceId">
<!-- move Page Form  -->
<form id="editForm">
    <input type="hidden" name="custId" value="${custId}"/>
    <input type="hidden" name="custAddId" value="${custAddId}"/>
    <input type="hidden" name="custCntcId" value="${custCntcId}" id="custCntcId"> 
    <input type="hidden" name="selectParam"  id="_selectParam"/>
</form>

<section class="pop_body"><!-- pop_body start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">EDIT Type</th>
    <td>
    <select id="_editCustomerInfo">
        <option value="1" <c:if test="${selectParam eq 1}">selected</c:if>>Edit Basic Info</option>
        <option value="2" <c:if test="${selectParam eq 2}">selected</c:if>>Edit Customer Address</option>
        <option value="3" <c:if test="${selectParam eq 3}">selected</c:if>>Edit Contact Info</option>
        <option value="4" <c:if test="${selectParam eq 4}">selected</c:if>>Edit Bank Account</option>
        <option value="5" <c:if test="${selectParam eq 5}">selected</c:if>>Edit Credit Card</option>
    </select>
    <p class="btn_sky"><a href="#" id="_confirm">Confirm</a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Customer Information</h2>
</aside><!-- title_line end -->

<section class="tap_wrap mt10"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Main Address</a></li>
    <li><a href="#">Main Contact</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer ID</th>
    <td><span>${result.custId}</span></td>
    <th scope="row">Customer Type</th>
    <td>
        <span> 
                ${result.codeName1}
                <!-- not Individual -->  
                <c:if test="${ result.typeId ne 964}">
                    (${result.codeName})
                </c:if>
            </span>
    </td>
    <th scope="row">Create At</th>
    <td>${result.crtDt}</td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="3">${result.name}</td>
    <th scope="row">Create By</th>
    <td>
        <c:if test="${result.crtUserId ne 0}">
                ${result.crtUserId}
            </c:if>
    </td>
</tr>
<tr>
    <th scope="row">NRIC/Company Number</th>
    <td><span>${result.nric}</span></td>
    <th scope="row">GST Registration No</th>
    <td>${result.gstRgistNo}</td>
    <th scope="row">Update By</th>
    <td>${result.userName1}</td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><span>${result.email}</span></td>
    <th scope="row">Nationality</th>
    <td>${result.cntyName}</td>
    <th scope="row">Update At</th>
    <td>${result.updDt}</td>
</tr>
<tr>
    <th scope="row">Gender</th>
    <td><span>${result.gender}</span></td>
    <th scope="row">DOB</th>
    <td>
        <c:if test="${result.dob ne '01-01-1900'}">
                ${result.dob}
        </c:if>
    </td>
    <th scope="row">Race</th>
    <td>${result.codeName2 }</td>
</tr>
<tr>
    <th scope="row">Passport Expire</th>
    <td><span>${result.pasSportExpr}</span></td>
    <th scope="row">Visa Expire</th>
    <td>${result.visaExpr}</td>
    <th scope="row">VA Number</th>
    <td>${result.custVaNo}</td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5"><span>${result.rem}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->
<!-- ######### main address info ######### -->
<article class="tap_area"><!-- tap_area start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Full Address</th>
    <td>
        <span>
                ${addresinfo.add1}&nbsp;${addresinfo.add2}&nbsp;${addresinfo.add3}&nbsp;
                ${addresinfo.postCode}&nbsp;${addresinfo.areaName}&nbsp;${addresinfo.name1}&nbsp;${addresinfo.name2}
        </span>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td>${addresinfo.rem}</td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->

<!-- ######### main Contact info ######### -->
<article class="tap_area"><!-- tap_area start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Name</th>
    <td><span>${contactinfo.name1}</span></td>
    <th scope="row">Initial</th>
    <td><span>${contactinfo.code}</span></td>
    <th scope="row">Genders</th>
    <td>
            <c:choose >
                <c:when test="${contactinfo.gender eq 'M'}">
                     Male
                </c:when>
                <c:when test="${contactinfo.gender eq 'F'}">
                     Female
                </c:when>
                <c:otherwise>
                    <!-- korean : 5  -->                    
                </c:otherwise>
            </c:choose>
     </td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><span>${contactinfo.nric}</span></td>
    <th scope="row">DOB</th>
    <td>
        <span>
            <c:if test="${contactinfo.dob ne  '01-01-1900'}">
                ${contactinfo.dob}
            </c:if> 
        </span>
    </td>
    <th scope="row">Race</th>
    <td><span>${contactinfo.codeName}</span></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><span>${contactinfo.email}</span></td>
    <th scope="row">Department</th>
    <td><span>${contactinfo.dept}</span></td>
    <th scope="row">Post</th>
    <td><span>${contactinfo.pos}</span></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td><span>${contactinfo.telM1}</span></td>
    <th scope="row">Tel (Residence)</th>
    <td><span>${contactinfo.telR}</span></td>
    <th scope="row">Tel (Office)</th>
    <td><span>${contactinfo.telO }</span></td>
</tr>
<tr>
    <th scope="row">Tel (Fax)</th>
    <td>${contactinfo.telf}</td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->
</section><!-- tap_wrap end -->
<!-- ########## Basic Info End ##########  -->
<aside class="title_line mt30"><!-- title_line start -->
<h2>Customer Basic Information</h2>
<ul class="right_opt mt10">
    <li><span class="red_text">*Compulsory Field</span> <span class="brown_text">#Compulsory Field(For Indvidual Type)</span></li>
</ul>
</aside><!-- title_line end -->
<!-- ######### Update Field Start  ######### -->
<form id="updForm"><!-- form start -->
<input type="hidden" value="${result.custId}" name="custID">
<input type="hidden" value="${result.typeId }" name="typeID">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:135px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer Type</th>
    <td colspan="3">
    <select name="cmbCustTypeId" id="cmbCustTypeId" class="disabled w100p" ></select>
    </td>
</tr>
<tr>
    <th scope="row">Company Type<span class="must">*</span></th> 
    <td><select name="cmbCorpTypeId" id="cmbCorpTypeId" class="disabled w100p" ></select></td> 
    <th scope="row">NRIC/Company No<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder=""   value="${result.nric}" id="nric"/>
    </td>
</tr>
<tr>
    <th scope="row">Customer Name<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="" class="w100p"  name="name" value="${result.name }" id="name"/> <!-- name  -->
    </td>
    <th scope="row">Nationality <span class="brown_text">#</span></th>
    <td>
        <select class="disabled w100p" disabled="disabled" id="cmdNationTypeId" name="cmdNationTypeId"></select>
    </td>
</tr>
<tr>
    <th scope="row">DOB <span class="brown_text">#</span></th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"   value="${result.dob}" name="dob" id="dob" readonly="readonly"/>
    </td>
    <th scope="row">Passport Expire</th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  value="${result.pasSportExpr}" name="pasSportExpr" readonly="readonly"/>
    </td>
</tr>
<tr>
    <th scope="row">Gender <span class="brown_text">#</span></th>
    <td>
    <label><input type="radio" name="gender"  <c:if test="${result.gender ne 'F'}">checked</c:if>  value="M"/><span>Male</span></label>
    <label><input type="radio" name="gender"  <c:if test="${result.gender eq 'F'}">checked</c:if> value="F" /><span>Female</span></label>
    </td>
    <th scope="row">Visa Expire</th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" value="${result.visaExpr }" name="visaExpr" readonly="readonly"/>
    </td>
</tr>
<tr>
    <th scope="row">Race <span class="brown_text">#</span></th>
    <td>
    <select class="w100p" id="cmdRaceTypeId" name="raceId"></select>
    </td>
    <th scope="row">Email</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p"  value="${result.email}" name="email" id="email"/>
    </td>
</tr>
<tr>
    <th scope="row">Remarks</th>
    <td colspan="3"><textarea cols="20" placeholder="Remarks" rows="5" name="rem">${result.rem}</textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</form><!-- form end -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="_updBtn">Update</a></p></li>
</ul>
</section><!-- pop_body end -->