<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
$(document).ready(function() {
    
    /* ##### cust CNTCID ##### */
    fn_getCustCntcId();
    /* ###  Page Param #### */
    fn_selectPage();
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
    
    
    doGetCombo('/common/selectCodeList.do', '17', '', 'cntcCmbInitialTypeId', 'S' , ''); // Customer Initial Type Combo Box
    doGetCombo('/common/selectCodeList.do', '2', '', 'cntcCmbRaceTypeId', 'S' , ''); // Customer Race Type Combo Box
    
    
    // Save Button Click
    $("#_saveBtn").click(function() {
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
            if(FormUtil.checkNum($("#cntcNric"))){
                Common.alert('<spring:message code="sal.msg.invalidNric" />');
                return;
            }
        }
        //Tel
        if(("" == $("#cntcTelm").val() || null == $("#cntcTelm").val()) && ("" == $("#cntcTelr").val() || null == $("#cntcTelr").val())
                && ("" == $("#cntcTelo").val() || null == $("#cntcTelo").val()) && ("" == $("#cntcTelf").val() || null == $("#cntcTelf").val())){
            
            Common.alert('<spring:message code="sal.alert.msg.plzKeyinAtLeastOneConNum" />');
            return;
        }else{
            // telm(Mobile)
            if("" != $("#cntcTelm").val() && null != $("#cntcTelm").val()){
                if(FormUtil.checkNum($("#cntcTelm"))){
                    Common.alert('<spring:message code="sal.alert.msg.invaildTelNumM" />');
                    return;
                }
            }
            // telr(Residence)
            if("" != $("#cntcTelr").val() && null != $("#cntcTelr").val()){
                if(FormUtil.checkNum($("#cntcTelr"))){
                    Common.alert('<spring:message code="sal.alert.msg.invaildTelNumR" />');
                    return;
                }
            }
            // telo(Office)
            if("" != $("#cntcTelo").val() && null != $("#cntcTelo").val()){
                if(FormUtil.checkNum($("#cntcTelo"))){
                    Common.alert('<spring:message code="sal.alert.msg.invaildTelNumO" />');
                    return;
                }
            }
            // telf(Fax)
            if("" != $("#cntcTelf").val() && null != $("#cntcTelf").val()){
                if(FormUtil.checkNum($("#cntcTelf"))){
                    Common.alert('<spring:message code="sal.alert.msg.invaildTelNumF" />');
                    return;
                }
            }
            
        }// tel end
        
        //Ext
        if(""  != $("#cntcExtNo").val() && null != $("#cntcExtNo").val()){
            
            if(FormUtil.checkNum($("#cntcExtNo"))){
                 Common.alert('<spring:message code="sal.alert.msg.invaildExtNoNum" />');
                 return;
            }
        }
        //Email
        if("" != $("#cntcEmail").val() && null != $("#cntcEmail").val()){
            
            if(FormUtil.checkEmail($("#cntcEmail").val())){
                 Common.alert('<spring:message code="sal.alert.msg.invaildEmailAddr" />');
                 return;
            }
        }
        // Validation Success
        // 2. Add
      fn_customerContactInfoAddAjax(); 
        
    });
    
    $("#_copyBtn").click(function() {
        
        //custAddrId
        var cntcId = $("#_tempContactId").val();
        
        $.ajax({
            type : "GET",
            url : getContextPath() + "/sales/customer/selectCustomerCopyContactJson",
            data : { getparam : cntcId}, 
            dataType: "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
                   $("#cntcCmbInitialTypeId").val(data.custInitial);
                   $("input[name='cntcGender']").val(data.gender);
                   $("#cntcName").val(data.name1);
                   $("#cntcCmbRaceTypeId").val(data.raceId);
                   $("#cntcNric").val(data.nric);
                   $("input[name='cntcDob']").val(data.dob);
                   $("#cntcTelm").val(data.telM1);
                   $("#cntcTelo").val(data.telO);
                   $("#cntcTelr").val(data.telR);
                   $("#cntcTelf").val(data.telf);
                   $("input[name='cntcDept']").val(data.dept);
                   $("input[name='cntcPos']").val(data.pos);
                   $("#cntcExtNo").val(data.ext);
                   $("#cntcEmail").val(data.email);
            },
            error: function(){
               alert("Get Contact Detail was Failed!");
            },
            complete: function(){
            }
            
        });
   });
    
}); // Document Ready Func End

/* ####### update Func ########### */
    // Call Ajax - DB Update
   function fn_customerContactInfoAddAjax(){
        Common.ajax("GET", "/sales/customer/insertCustomerContactAddAf.do",$("#addForm").serialize(), function(result) {
            
            if("" != $("#_callParam").val() && null != $("#_callParam").val()){
               Common.alert(result.message);    
            }else{
               Common.alert(result.message, fn_parentReload);
            }
            if('${callParam}' == 'ORD_REGISTER_CNTC_OWN' || '${callParam}' == 'PRE_ORD_CNTC') {
                fn_loadCntcPerson(result.data);
                $("#_close1").click();
            }
        });
    }
    
    // Parent Reload Func
    function fn_parentReload() {
        fn_selectPstRequestDOListAjax(); //parent Method (Reload)
        $("#_close1").click();
        $("#_close").click();
        $("#_selectParam").val('3');
        Common.popupDiv('/sales/customer/updateCustomerContactPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv3');
        Common.popupDiv('/sales/customer/updateCustomerNewContactPop.do', $("#popForm").serializeJSON(), null , true ,'_editDiv3New');
        
    }
/* ####### update Func  End########### */

    function fn_getCustCntcId(){
        
        var getparam = $("#_insCustId").val();
        $.ajax({
            
            type: "GET",
            url : getContextPath() + "/sales/customer/selectCustomerMainContact",
            data : {getparam : getparam},
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
                   
                    $("#_tempContactId").val(data.custCntcId);
                    
            },
            error: function(){
                alert("Get Contact Id was Failed!");
            },
            complete: function(){
            }
        });
        
    }
    
    function fn_selectPage(){
        
        if("" != $("#_callParam").val() && null != $("#_callParam").val()){
             $("#_copyBtn").css("display" , "");
        }
    }
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.addCustContact" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close1"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<!-- getParams  -->
<section class="pop_body"><!-- pop_body start -->
<form id="addForm"> <!-- Form Start  -->
<input type="hidden" value="${insCustId}" id="_insCustId" name="insCustId">
<!-- Temp Contact Id -->
<input type="hidden" id="_tempContactId" name="tempContactId">
<!-- Page Param -->
<input type="hidden" name="callParam" id="_callParam" value="${callParam}">
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
    <label><input type="radio" name="cntcGender"  value="M" checked="checked" /><span><spring:message code="sal.title.text.male" /></span></label>
    <label><input type="radio" name="cntcGender"  value="F" /><span><spring:message code="sal.title.text.female" /></span></label>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.name" /><span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p"  id="cntcName" name="cntcName" maxlength="70"/></td>
    <th scope="row"><spring:message code="sal.text.race" /><span class="must">*</span></th>
    <td>    
    <select class="w100p" id="cntcCmbRaceTypeId" name="cntcCmbRaceTypeId"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><input type="text" title="" placeholder="" class="w100p"   name="cntcNric" id="cntcNric" maxlength="18"/></td>
    <th scope="row"><spring:message code="sal.text.dob" /></th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date3 w100p"   name="cntcDob" readonly="readonly"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telM" /><span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p"   id="cntcTelm" name="cntcTelm" maxlength="20"/></td>
    <th scope="row"><spring:message code="sal.text.telO" /><span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p"  id="cntcTelo" name="cntcTelo" maxlength="20"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telR" /><span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p"   id="cntcTelr" name="cntcTelr" maxlength="20"/></td>
    <th scope="row"><spring:message code="sal.text.telF" /><span class="must">*</span></th>
    <td><input type="text" title="" placeholder="Telephone Number(Fax)" class="w100p"   id="cntcTelf" name="cntcTelf" maxlength="20"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.dept" /></th>
    <td><input type="text" title="" placeholder="Department" class="w100p"   name="cntcDept"/></td>
    <th scope="row"><spring:message code="sal.title.text.jonPosition" /></th>
    <td><input type="text" title="" placeholder="Job Position" class="w100p"   name="cntcPos" maxlength="50"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.extNo" /></th>
    <td><input type="text" title="" placeholder="Extension Number" class="w100p"  id="cntcExtNo" name="cntcExpno" maxlength="50"/></td>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><input type="text" title="" placeholder="" class="w100p"  id="cntcEmail" name="cntcEmail" maxlength="70"/></td>
</tr>
<tr>
    <td>
        <ul class="center_btns">
            <li><p class="btn_blue big"><a href="#" id="_copyBtn" style="display: none;"><spring:message code="sal.title.text.copy" /></a></p></li>
        </ul>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form> <!--Form End  -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="_saveBtn"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</section><!-- pop_body end -->
</div>