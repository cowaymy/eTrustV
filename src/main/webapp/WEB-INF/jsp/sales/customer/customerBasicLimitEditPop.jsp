<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var selCodeCustId;  
var selCodeCorpId;

$(document).ready(function() {
    
    //Select Value
    selCodeCustId = $("#selCodeCustId").val(); // TypeId 
    selCodeCorpId = $("#selCodeCorpId").val();
    
    doGetCombo('/common/selectCodeList.do', '8', selCodeCustId ,'basicCmbCustTypeId', 'S', '');       // Customer Type Combo Box
    doGetCombo('/common/selectCodeList.do', '95', selCodeCorpId ,'basicCmbCorpTypeId', 'S', '');     // Company Type Combo Box
    
    //visible  _selVisible
    if( null != $("#_selVisible").val() && '' != $("#_selVisible").val()){
        $("#_visibleDiv").css("display" , "none");
    }
    
    $("#_editCustomerInfo").change(function(){
        
        var stateVal = $(this).val();
        $("#_selectParam").val(stateVal);
     });
    
     $("#_confirm").click(function (currPage) {
            var status = $("#_selectParam").val();
           
            if(status == '1'){
                Common.popupDiv('/sales/customer/updateCustomerBasicInfoPop.do', $('#popForm').serializeJSON(), null , true , '_editDiv1');
                $("#_close").click();
            }
            if(status == '2'){
                Common.popupDiv('/sales/customer/updateCustomerAddressPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv2');
                $("#_close").click();
            }
            if(status == '3'){
                Common.popupDiv('/sales/customer/updateCustomerContactPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv3');
                $("#_close").click();
            }
            if(status == '4'){
                Common.popupDiv('/sales/customer/updateCustomerBankAccountPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv4');
                $("#_close").click();
            }
            if(status == '5'){
                Common.popupDiv('/sales/customer/updateCustomerCreditCardPop.do', $('#popForm').serializeJSON(), null , true , '_editDiv5');
                $("#_close").click();
            }
            if(status == '6'){ 
               Common.popupDiv("/sales/customer/updateCustomerBasicInfoLimitPop.do", $("#popForm").serializeJSON(), null , true , '_editDiv6');
               $("#_close").click();
            }
            
        });
     
     //Display Controll
     if(selCodeCustId == '965'){
           $("#basicCmbCorpTypeId").attr("disabled" , false);
           $("#basicCmbCustTypeId").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
           $("#_gstRgstNo").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
     }else{
           $("#basicCmbCorpTypeId").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
           $("#basicCmbCustTypeId").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
           $("#_gstRgstNo").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
     }
     
    $("#_update").click(function() {
           
        //Validation
        if( null == $("#basicCmbCustTypeId").val() || '' == $("#basicCmbCustTypeId").val()){ 
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Customer Type'/>");
            return;
        }
        
        if( $("#basicCmbCustTypeId").val() == '965'){
            
            if(null == $("#basicCmbCorpTypeId").val() || '' == $("basicCmbCorpTypeId").val()){
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='Company Type'/>");
                return;
            }
        }
        //Update
        
        fn_updateLimitBasicInfo();
        
    });
});//Doc Ready Func End

function fn_updateLimitBasicInfo(){
    $("#_tempCustTypeId").val($("#basicCmbCustTypeId").val());
    Common.ajax("POST", "/sales/customer/updateLimitBasicInfo", $("#_limUpdForm").serializeJSON(), function(result){
           
        Common.alert(result.message, fn_reloadPage);
    });
    //
}

//reload Page func
function fn_reloadPage(){
    //Parent Window Method Call
    if($("#_selVisible").val() == null || $("#_selVisible").val() == ''){
        console.log("sleVisible == null");
        fn_selectPstRequestDOListAjax();
        $("#_selectParam").val('6');
        Common.popupDiv("/sales/customer/updateCustomerBasicInfoLimitPop.do", $("#popForm").serializeJSON(), null , true , '_editDiv6');
        $("#_close").click();
    }else{
        console.log("sleVisible == 1");
        $("#_calSearch").click();
    }
    
    $("#_close").click();
}

//close Func
function fn_closeFunc(){
    $("#_selectParam").val('1');
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<!-- getParams  -->
<input type="hidden" value="${result.typeId }" id="selCodeCustId"> <!-- TypeId : 964(Individual) / 965(Company)  --> 
<input type="hidden" value="${result.corpTypeId}" id="selCodeCorpId">
<input type="hidden" value="${result.nation }" id="selCodeNation">
<input type="hidden" value="${result.raceId }" id="selCodeRaceId">
<!-- Select ComboMenu Show/Hide -->
<input type="hidden" value="${selVisible}" id="_selVisible">

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.custBasicInfoMaintenanceLimit" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_close" onclick="javascript: fn_closeFunc()"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<div id="_visibleDiv">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.editType" /></th>
    <td>
    <select id="_editCustomerInfo">
        <option value="1" <c:if test="${selectParam eq 1}">selected</c:if>><spring:message code="sal.combo.text.editBasicInfo" /></option>
        <option value="2" <c:if test="${selectParam eq 2}">selected</c:if>><spring:message code="sal.combo.text.editCustAddr" /></option>
        <option value="3" <c:if test="${selectParam eq 3}">selected</c:if>><spring:message code="sal.combo.text.editContactInfo" /></option>
        <option value="4" <c:if test="${selectParam eq 4}">selected</c:if>><spring:message code="sal.combo.text.editBankAcc" /></option>
        <option value="5" <c:if test="${selectParam eq 5}">selected</c:if>><spring:message code="sal.combo.text.editCreditCard" /></option>
        <option value="6" <c:if test="${selectParam eq 6}">selected</c:if>><spring:message code="sal.combo.text.editBasicInfoLimit" /></option>
    </select>
    <p class="btn_sky"><a href="#" id="_confirm"><spring:message code="sal.btn.confirm" /></a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</div>
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.page.title.custInformation" /></h2>
</aside><!-- title_line end -->
<section class="tap_wrap mt10"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on"><spring:message code="sal.tap.title.basicInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.tap.title.mainAddr" /></a></li>
    <li><a href="#"><spring:message code="sal.tap.title.mainContact" /></a></li>
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
    <th scope="row"><spring:message code="sal.text.customerId" /></th>
    <td><span>${result.custId}</span></td>
    <th scope="row"><spring:message code="sal.text.custType" /></th>
    <td>
        <span> 
                ${result.codeName1}
                <!-- not Individual -->  
                <c:if test="${ result.typeId ne 964}">
                    (${result.codeName})
                </c:if>
            </span>
    </td>
    <th scope="row"><spring:message code="sal.text.createAt" /></th>
    <td>${result.crtDt}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td colspan="3">${result.name}</td>
    <th scope="row"><spring:message code="sal.text.createBy" /></th>
    <td>
        <c:if test="${result.crtUserId ne 0}">
                ${result.crtUserId}
            </c:if>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nricCompanyNum" /></th>
    <td><span>${result.nric}</span></td>
    <th scope="row"><spring:message code="sal.text.gstRegistrationNo" /></th>
    <td>${result.gstRgistNo}</td>
    <th scope="row"><spring:message code="sal.text.updateBy" /></th>
    <td>${result.userName1}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><span>${result.email}</span></td>
    <th scope="row"><spring:message code="sal.text.nationality" /></th>
    <td>${result.cntyName}</td>
    <th scope="row"><spring:message code="sal.text.updateAt" /></th>
    <td>${result.updDt}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><span>${result.gender}</span></td>
    <th scope="row"><spring:message code="sal.text.dob" /></th>
    <td>
        <c:if test="${result.dob ne '01-01-1900'}">
                ${result.dob}
        </c:if>
    </td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td>${result.codeName2 }</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.passportExpire" /></th>
    <td><span>${result.pasSportExpr}</span></td>
    <th scope="row"><spring:message code="sal.text.visaExpire" /></th>
    <td>${result.visaExpr}</td>
    <th scope="row"><spring:message code="sal.text.vaNumber" /></th>
    <td>${result.custVaNo}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
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
    <th scope="row"><spring:message code="sal.text.fullAddr" /></th>
    <td><span>${addresinfo.fullAddress}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
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
    <th scope="row"><spring:message code="sal.text.name" /></th>
    <td><span>${contactinfo.name1}</span></td>
    <th scope="row"><spring:message code="sal.text.initial" /></th>
    <td><span>${contactinfo.code}</span></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
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
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><span>${contactinfo.nric}</span></td>
    <th scope="row"><spring:message code="sal.text.dob" /></th>
    <td>
        <span>
            <c:if test="${contactinfo.dob ne  '01-01-1900'}">
                ${contactinfo.dob}
            </c:if> 
        </span>
    </td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><span>${contactinfo.codeName}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td><span>${contactinfo.email}</span></td>
    <th scope="row"><spring:message code="sal.text.dept" /></th>
    <td><span>${contactinfo.dept}</span></td>
    <th scope="row"><spring:message code="sal.text.post" /></th>
    <td><span>${contactinfo.pos}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telM" /></th>
    <td><span>${contactinfo.telM1}</span></td>
    <th scope="row"><spring:message code="sal.text.telR" /></th>
    <td><span>${contactinfo.telR}</span></td>
    <th scope="row"><spring:message code="sal.text.telO" /></th>
    <td><span>${contactinfo.telO}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telF" /></th>
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

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.page.title.custBasicInformation" /></h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p><span class="red_text">* <spring:message code="sal.text.compulsoryField" /></span> <span class="brown_text"># <spring:message code="sal.text.compulsoryFieldForIndType" /></span></p></li>
</ul>
<form id="_limUpdForm" method="post">
<input type="hidden" id="_tempCustTypeId" name="tempCustTypeId">
<input type="hidden" value="${result.custId}" name="basicCustId">  
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.custType" /></th>
    <td>
    <select class="w100p" id="basicCmbCustTypeId"></select>
    </td>
    <th scope="row"><spring:message code="sal.text.companyType" /></th>
    <td>
    <select class="w100p" id="basicCmbCorpTypeId" name="basicCmbCorpTypeId"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.gstRegistrationNo" /></th>
    <td colspan="3"><input type="text" title="" placeholder="GST Registration No" class="w100p"  id="_gstRgstNo"/>${result.gstRgistNo}</td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="_update"><spring:message code="sal.btn.update" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->