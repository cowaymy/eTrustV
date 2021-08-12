<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
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
    
    
    doGetCombo('/common/selectCodeList.do', '17', '${dealerCntTop.dealerInitial}', 'cntcCmbInitialTypeId', 'S' , ''); // Customer Initial Type Combo Box
    doGetCombo('/common/selectCodeList.do', '2', '${dealerCntTop.raceId}', 'cntcCmbRaceTypeId', 'S' , ''); // Customer Race Type Combo Box
    
    
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
        if(("" == $("#cntcTelm1").val() || null == $("#cntcTelm1").val()) && ("" == $("#cntcTelr").val() || null == $("#cntcTelr").val())
                && ("" == $("#cntcTelo").val() || null == $("#cntcTelo").val()) && ("" == $("#cntcTelf").val() || null == $("#cntcTelf").val())){
            
            Common.alert('<spring:message code="sal.alert.msg.plzKeyinAtLeastOneConNum" />');
            return;
        }else{
            // telm(Mobile1)
            if("" != $("#cntcTelm1").val() && null != $("#cntcTelm1").val()){
                if(FormUtil.checkNum($("#cntcTelm1"))){
                    Common.alert('<spring:message code="sal.alert.msg.invalidTelNumMob1" />');
                    return;
                }
            }
            // telm(Mobile2)
            if("" != $("#cntcTelm2").val() && null != $("#cntcTelm2").val()){
                if(FormUtil.checkNum($("#cntcTelm2"))){
                    Common.alert('<spring:message code="sal.alert.msg.invalidTelNumMob2" />');
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
        
        // Validation Success
        // 2. Add
      fn_updDealerContactInfo(); 
        
    });
    
    // Call Ajax - DB Update
   function fn_updDealerContactInfo(){
        Common.ajax("GET", "/sales/pst/updDealerCntr.do",$("#insContForm").serialize(), function(result) {

               Common.alert(result.message, fn_parentReload);
            
        });
    }
    
   function fn_parentReload() {
	   if(insContForm.flag.value = 'R'){
		   fn_selectPstRequestDOListAjax();
		   $("#_contClose").click();
		   $("#editClose").click();
	   }else{
		   fn_pstDealerListAjax(); //parent Method (Reload) List
		   $("#_eClose").click();
	   }
	   
       $("#_close2").click();
       
//       Common.popupDiv('/sales/pst/editContDtPop.do' , $('#getParamForm').serializeJSON(), null , true, '_editDiv2'); 
//       Common.popupDiv('/sales/customer/updateCustomerNewAddressPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv2New'); 
   }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.dealerContactAddEdit" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close2"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="insContForm" name="insContForm" method="POST">
    <input type="hidden" id="areaId" name="areaId">
    <input type="hidden" value="${insDealerId}" id="insDealerId" name="insDealerId">
    <input type="hidden" value="${dealerCntId}" id="dealerCntId" name="dealerCntId">
    <input type="hidden" value="${flag}" id="flag" name="flag">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.status" /></th>
    <td colspan="3"><input type="text" title="" readOnly placeholder="Address Status" class="w100p readonly" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.initial" /><span class="must">*</span></th>
    <td>
    <select class="w100p" id="cntcCmbInitialTypeId" name="cntcInitial">
    </select>
    </td>
    <th scope="row"><spring:message code="sal.text.gender" /><span class="must">*</span></th>
    <td>
    <label><input type="radio" name="cntcGender" value="M" <c:if test="${dealerCntTop.gender eq 'M' }">checked</c:if>/><span><spring:message code="sal.title.text.male" /></span></label>
    <label><input type="radio" name="cntcGender" value="F" <c:if test="${detailcontact.gender ne 'M' }">checked</c:if>/><span><spring:message code="sal.title.text.female" /></span></label>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.contactName" /><span class="must">*</span></th>
    <td><input type="text" title="" id="cntcName" name="cntcName" value="${dealerCntTop.cntName}" maxlength="70" placeholder="Contact Name" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.text.race" /><span class="must">*</span></th>
    <td>
    <select class="w100p" id="cntcCmbRaceTypeId" name="cntcCmbRaceTypeId">
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><input type="text" title="" name="cntcNric" id="cntcNric" maxlength="18"  value="${dealerCntTop.nric}" placeholder="NRIC" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.title.text.telMobile1" /><span class="must">*</span></th>
    <td><input type="text" id="cntcTelm1" name="cntcTelm1" maxlength="20"  value="${dealerCntTop.telM1}" title="" placeholder="Telephone Number (Mobile 1)" class="w100p" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telMobile2" /></th>
    <td><input type="text" id="cntcTelm2" name="cntcTelm2" maxlength="20"  value="${dealerCntTop.telM2}" title="" placeholder="Telephone Number (Mobile 2)" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.text.telO" /></th>
    <td><input type="text" id="cntcTelo" name="cntcTelo" maxlength="20"  value="${dealerCntTop.telO}" title="" placeholder="Telephone Number (Office)" class="w100p" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telR" /></th>
    <td><input type="text" id="cntcTelr" name="cntcTelr" maxlength="20" value="${dealerCntTop.telR}" title="" placeholder="Telephone Number (Residence)" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.text.telF" /></th>
    <td><input type="text" id="cntcTelf" name="cntcTelf" maxlength="20" value="${dealerCntTop.telf}" title="" placeholder="Telephone Number (Fax)" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="_saveBtn"><spring:message code="sal.title.text.saveContact" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->