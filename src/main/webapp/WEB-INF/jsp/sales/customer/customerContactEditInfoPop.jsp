<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
$(document).ready(function() {

    //j_date
    var pickerOpts={
            changeMonth:true,
            changeYear:true,
            dateFormat: "dd/mm/yy"
    };
    
    $(".j_date").datepicker(pickerOpts);

    var monthOptions = {
        pattern: 'mm/yyyy',
        selectedYear: 2017,
        startYear: 2007,
        finalYear: 2027
    };

    $(".j_date2").monthpicker(monthOptions);
    
    var selCodeInitial = $("#selCodeInitial").val();
    var selCodeRace = $("#selCodeRace").val();
    
    doGetCombo('/common/selectCodeList.do', '17', selCodeInitial, 'cntcCmbInitialTypeId', 'S' , ''); // Customer Initial Type Combo Box
    doGetCombo('/common/selectCodeList.do', '2', selCodeRace, 'cntcCmbRaceTypeId', 'S' , ''); // Customer Race Type Combo Box
    
    // main 일 경우 delete 버튼 숨기기
    if($("#stusCodeId").val() == 9){
        $("#_delBtn").css("display", "none" );
    } 
    
    // update Button Click
    $("#_updBtn").click(function() {
        // 1. validation
        //Initial
        if("" == $("#cntcCmbInitialTypeId").val() || null == $("#cntcCmbInitialTypeId").val()){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Initial'/>");
            return;
        }
        //Gender
        if("" == $("input[name='cntcGender']").val() || null == $("input[name='cntcGender']").val()){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Gender'/>");
            return;
        }
        //Customer Name
        if("" == $("#cntcName").val() || null == $("#cntcName").val()){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Customer Name'/>");
            return;
        }
        //Race
        if("" == $("#cntcCmbRaceTypeId").val() || null == $("#cntcCmbRaceTypeId").val()){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Race'/>");
            return;
        }
        //Nric
        if("" != $("#cntcNric").val() && null != $("#cntcNric").val()){
            //console.log("log : " + FormUtil.checkNum($("#cntcNric")));
            if(FormUtil.checkNum($("#cntcNric"))){
                Common.alert("<spring:message code='sal.msg.invalidNric' />");
                return;
            }
        }
        //Tel
        if(("" == $("#cntcTelm").val() || null == $("#cntcTelm").val()) && ("" == $("#cntcTelr").val() || null == $("#cntcTelr").val())
                && ("" == $("#cntcTelo").val() || null == $("#cntcTelo").val()) && ("" == $("#cntcTelf").val() || null == $("#cntcTelf").val())){
            
            Common.alert("<spring:message code='sal.msg.keyInContactNum' />");
            return;
        }else{
            // telm(Mobile)
            if("" != $("#cntcTelm").val() && null != $("#cntcTelm").val()){
                if(FormUtil.checkNum($("#cntcTelm"))){
                    Common.alert("<spring:message code='sal.alert.msg.invalidTelNumMobile' />");
                    return;
                }
            }
            // telr(Residence)
            if("" != $("#cntcTelr").val() && null != $("#cntcTelr").val()){
                if(FormUtil.checkNum($("#cntcTelr"))){
                    Common.alert("<spring:message code='sal.alert.msg.invalidTelNumResidence' />");
                    return;
                }
            }
            // telo(Office)
            if("" != $("#cntcTelo").val() && null != $("#cntcTelo").val()){
                if(FormUtil.checkNum($("#cntcTelo"))){
                    Common.alert("<spring:message code='sal.alert.msg.invalidTelNumOffice' />");
                    return;
                }
            }
            // telf(Fax)
            if("" != $("#cntcTelf").val() && null != $("#cntcTelf").val()){
                if(FormUtil.checkNum($("#cntcTelf"))){
                    Common.alert("<spring:message code='sal.alert.msg.invalidTelNumFax' />");
                    return;
                }
            }
            
        }// tel end
        
        //Ext
        if(""  != $("#cntcExtNo").val() && null != $("#cntcExtNo").val()){
            
            if(FormUtil.checkNum($("#cntcExtNo"))){
                 Common.alert("<spring:message code='sal.alert.msg.invalidExtNoNumber' />");
                 return;
            }
        }
        //Email
        if("" != $("#cntcEmail").val() && null != $("#cntcEmail").val()){
            
            if(FormUtil.checkEmail($("#cntcEmail").val())){
                 Common.alert("<spring:message code='sal.msg.invalidEmail' />");
                 return;
            }
        }
        
        // Validation Success
        // 2. Update
        fn_customerContactInfoUpdateAjax();
        
    });
    
     //Delete
    $("#_delBtn").click(function() {
       Common.confirm("<spring:message code='sal.alert.msg.areYouSureWantToDelContPerson' />", fn_deleteContactAjax);
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
        fn_selectPstRequestDOListAjax(); //parent Method (Reload)
        $("#_close1").click();
        $("#_close").click();
        $("#_selectParam").val('3');
        Common.popupDiv('/sales/customer/updateCustomerContactPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv3');
        Common.popupDiv("/sales/customer/updateCustomerContactInfoPop.do", $('#editForm').serializeJSON(), null , true, '_editDiv3Pop');
        
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
        fn_selectPstRequestDOListAjax(); //parent Method (Reload)
        $("#_close1").click();
        $("#_close").click();
        $("#_selectParam").val('3');
        Common.popupDiv('/sales/customer/updateCustomerContactPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv3');
    }
/* ####### delete Func End ########### */
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.editCustContactInfo" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close1"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<!-- getParams  -->
<input type="hidden" value="${detailcontact.custInitial}" id="selCodeInitial">
<input type="hidden" value="${detailcontact.raceId}" id="selCodeRace">
<input type="hidden" value="${detailcontact.stusCodeId}" id="stusCodeId">
<section class="pop_body"><!-- pop_body start -->
<form id="updForm"> <!-- Form Start  -->
<input type="hidden" value="${detailcontact.custCntcId }" name="cntcCustCntcId">
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
    <th scope="row"><spring:message code="sal.text.initial" /><span class="must">*</span></th>
    <td>
    <select class="w100p" id="cntcCmbInitialTypeId" name="cntcInitial"></select>
    </td>
    <th scope="row"><spring:message code="sal.text.gender" /><span class="must">*</span></th>
    <td>
    <label><input type="radio" name="cntcGender"  value="M" <c:if test="${detailcontact.gender eq 'M' }">checked</c:if>/><span>Male</span></label>
    <label><input type="radio" name="cntcGender"  value="F" <c:if test="${detailcontact.gender ne 'M' }">checked</c:if>/><span>Female</span></label>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.name" /><span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p"  value="${detailcontact.name1 }" id="cntcName" name="cntcName" maxlength="70"/></td>
    <th scope="row"><spring:message code="sal.text.race" /><span class="must">*</span></th>
    <td>    
    <select class="w100p" id="cntcCmbRaceTypeId" name="cntcCmbRaceTypeId"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><input type="text" title="" placeholder="" class="w100p"  value="${detailcontact.nric}" name="cntcNric" id="cntcNric" maxlength="18"/></td>
    <th scope="row"><spring:message code="sal.text.dob" /></th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" value="${detailcontact.dob}" name="cntcDob" readonly="readonly"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telM" /><span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p"  value="${detailcontact.telM1}" id="cntcTelm" name="cntcTelm" maxlength="20"/></td>
    <th scope="row"><spring:message code="sal.text.telO" /><span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p" value="${detailcontact.telO}" id="cntcTelo" name="cntcTelo" maxlength="20"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telR" /><span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p"  value="${detailcontact.telR }" id="cntcTelr" name="cntcTelr" maxlength="20"/></td>
    <th scope="row"><spring:message code="sal.text.telF" /><span class="must">*</span></th>
    <td><input type="text" title="" placeholder="Telephone Number(Fax)" class="w100p"  value="${detailcontact.telf}" id="cntcTelf" name="cntcTelf" maxlength="20"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.dept" /></th>
    <td><input type="text" title="" placeholder="Department" class="w100p"  value="${detailcontact.dept}" name="cntcDept"/></td>
    <th scope="row"><spring:message code="sal.text.jobPosition" /></th>
    <td><input type="text" title="" placeholder="Job Position" class="w100p"  value="${detailcontact.pos}" name="cntcPos" maxlength="50"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.extNo" /></th>
    <td><input type="text" title="" placeholder="Extension Number" class="w100p"  value="${detailcontact.ext}" id="cntcExtNo" name="cntcExpno" maxlength="50"/></td>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><input type="text" title="" placeholder="" class="w100p" value="${detailcontact.email}" id="cntcEmail" name="cntcEmail" maxlength="70"/></td>
</tr>
</tbody>
</table><!-- table end -->
</form> <!--Form End  -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="_updBtn"><spring:message code="sal.btn.update" /></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="_delBtn"><spring:message code="sal.btn.delete" /></a></p></li>
</ul>

</section><!-- pop_body end -->
</div>