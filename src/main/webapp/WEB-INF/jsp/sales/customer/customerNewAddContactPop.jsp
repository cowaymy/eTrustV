<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
    $(document).ready(function() {
    	
    	/* ##### cust CNTCID ##### */
    	//fn_getCustCntcId();
    
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
        
        // Save Button Click
        $("#_saveBtn").click(function() {
            // 1. validation
            //Initial
            if("" == $("#cntcCmbInitialTypeId").val() || null == $("#cntcCmbInitialTypeId").val()){
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='Initial'/>");
                return;
            }
            //Customer Name
            if("" == $("#cntcName").val() || null == $("#cntcName").val()){
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='Customer Name'/>");
                return;
            }
            //Tel
            if(("" == $("#cntcTelm").val() || null == $("#cntcTelm").val()) && ("" == $("#cntcTelr").val() || null == $("#cntcTelr").val())
                    && ("" == $("#cntcTelo").val() || null == $("#cntcTelo").val()) && ("" == $("#cntcTelf").val() || null == $("#cntcTelf").val())){
                
                Common.alert("* Please key in at least one contact number.");
                return;
            }else{
                // telm(Mobile)
                if("" != $("#cntcTelm").val() && null != $("#cntcTelm").val()){
                    if(FormUtil.checkNum($("#cntcTelm"))){
                        Common.alert("* Invalid telephone number (Mobile).");
                        return;
                    }
                }
                // telr(Residence)
                if("" != $("#cntcTelr").val() && null != $("#cntcTelr").val()){
                    if(FormUtil.checkNum($("#cntcTelr"))){
                        Common.alert("* Invalid telephone number (Residence).");
                        return;
                    }
                }
                // telo(Office)
                if("" != $("#cntcTelo").val() && null != $("#cntcTelo").val()){
                    if(FormUtil.checkNum($("#cntcTelo"))){
                        Common.alert("* Invalid telephone number (Office).");
                        return;
                    }
                }
                // telf(Fax)
                if("" != $("#cntcTelf").val() && null != $("#cntcTelf").val()){
                    if(FormUtil.checkNum($("#cntcTelf"))){
                        Common.alert("* Invalid telephone number (Fax).");
                        return;
                    }
                }
                
            }// tel end
            
            //Ext
            if(""  != $("#cntcExtNo").val() && null != $("#cntcExtNo").val()){
                
                if(FormUtil.checkNum($("#cntcExtNo"))){
                     Common.alert("* Invalid Ext No. number.");
                     return;
                }
            }
            //Email
            if("" != $("#cntcEmail").val() && null != $("#cntcEmail").val()){
                
                if(FormUtil.checkEmail($("#cntcEmail").val())){
                     Common.alert("* Invalid email address.");
                     return;
                }
            }
            // Validation Success
            // 2. Add
          fn_customerContactInfoAddAjax(); 
            
        });    
    }); // Document Ready Func End

   function fn_customerContactInfoAddAjax(){
        Common.ajax("GET", "/sales/customer/insertCareContactInfo.do",$("#addForm").serialize(), function(result) {
            Common.alert(result.message);
            
            if('${callParam}' == 'ORD_REGISTER_CNTC_ADD') {
                fn_loadSrvCntcPerson(result.data);
                $("#_close1").click();
            }
        });
   }
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>ADD CUSTOMER CONTACT</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close1">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<!-- getParams  -->
<section class="pop_body"><!-- pop_body start -->
<form id="addForm"> <!-- Form Start  -->
<input type="hidden" value="${insCustId}" id="_insCustId" name="custId">
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
    <th scope="row">Initial<span class="must">*</span></th>
    <td>
    <select class="w100p" id="cntcCmbInitialTypeId" name="cntcInitial"></select>
    </td>
    <th scope="row">Name<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p"  id="cntcName" name="cntcName" maxlength="70"/></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p"   id="cntcTelm" name="cntcTelm" maxlength="20"/></td>
    <th scope="row">Tel (Office)<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p"  id="cntcTelo" name="cntcTelo" maxlength="20"/></td>
</tr>
<tr>
    <th scope="row">Tel (Residence)<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p"   id="cntcTelr" name="cntcTelr" maxlength="20"/></td>
    <th scope="row">Tel (Fax)<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="Telephone Number(Fax)" class="w100p"   id="cntcTelf" name="cntcTelf" maxlength="20"/></td>
</tr>
<tr>
    <th scope="row">Ext No.</th>
    <td><input type="text" title="" placeholder="Extension Number" class="w100p"  id="cntcExtNo" name="cntcExpno" maxlength="50"/></td>
    <th scope="row">Email</th>
    <td><input type="text" title="" placeholder="" class="w100p"  id="cntcEmail" name="cntcEmail" maxlength="70"/></td>
</tr>
</tbody>
</table><!-- table end -->
</form> <!--Form End  -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="_saveBtn">Save</a></p></li>
</ul>

</section><!-- pop_body end -->
</div>