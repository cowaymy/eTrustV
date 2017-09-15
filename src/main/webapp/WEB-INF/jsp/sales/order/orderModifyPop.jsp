<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    
    var ORD_ID = '${salesOrderId}';
    var CUST_ID = '${custId}';
    var TAB_NM = '${ordEditType}';
    
    $(document).ready(function(){
        doGetComboData('/common/selectCodeList.do', {groupCode :'335'}, TAB_NM, 'ordEditType', 'S'); //Order Edit Type
        doGetComboSepa('/common/selectBranchCodeList.do',  '1', ' - ', '', 'modKeyInBranch', 'S'); //Branch Code
        
        if(FormUtil.isNotEmpty(TAB_NM)) {
            changeTab(TAB_NM);
        }
    });
    
    $(function(){
        $('#btnEditType').click(function() {
            var tabNm = $('#ordEditType').val();
            changeTab(tabNm);
        });
        $('#btnSaveBasicInfo').click(function() {            
            if(!fn_validBasicInfo()) return false;            
            fn_doSaveBasicInfo();
        });
        $('#btnSaveMailingAddress').click(function() {            
            if(!fn_validMailingAddress()) return false;            
            fn_doSaveMailingAddress();
        });
        $('#btnSaveCntcPerson').click(function() {            
            if(!fn_validCntcPerson()) return false;
            fn_doSaveCntcPerson();
        });
        $('#btnSaveNric').click(function() {            
            if(fn_validNric()) fn_doSaveNric();
        });
        $('#btnSalesmanPop').click(function() {
            Common.popupDiv("/common/memberPop.do", { callPrgm : "ORD_MODIFY_BSC_INF" }, null, true);
        });
        $('#modSalesmanCd').change(function() {
            fn_loadOrderSalesman(null, $('#modSalesmanCd').val())
        });
        $('#btnBillNewAddr').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {custId : $('#modCustId').val(), callParam : "ORD_MODIFY_MAIL_ADR"}, null , true);
        });
        $('#btnBillSelAddr').click(function() {
            Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {custId : $('#modCustId').val(), callPrgm : "ORD_MODIFY_MAIL_ADR"}, null, true);
        });
        $('#mstCntcNewAddBtn').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewContactPop.do", {custId:$('#modCustId2').val(), callParam : "ORD_MODIFY_CNTC_OWN"}, null , true);
        });
        $('#mstCntcSelAddBtn').click(function() {
            Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {custId : $('#modCustId2').val(), callPrgm : "ORD_MODIFY_CNTC_OWN"}, null, true);
        });
    });
    
    function fn_loadMailAddr(custAddId){
        console.log("fn_loadMailAddr START");

        Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {custAddId : custAddId}, function(billCustInfo) {

            if(billCustInfo != null) {

                console.log("성공.");
                console.log("hiddenBillAddId : " + billCustInfo.custAddId);

                $("#modNewAddress").text(billCustInfo.fullAddress);
                $("#modCustAddId").val(billCustInfo.custAddId);
                
                Common.alert("Address Selected" + DEFAULT_DELIMITER + "<b>New address selected.<br />Click save to confirm change address.</b>");
            }
        });
    }
    
    function fn_loadOrderSalesman(memId, memCode) {

        console.log('fn_loadOrderSalesman memId:'+memId);
        console.log('fn_loadOrderSalesman memCd:'+memCode);

        fn_clearOrderSalesman();

        Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

            if(memInfo == null || memInfo == 'undefined') {
                Common.alert('<b>Member not found.</br>Your input member code : '+memCd+'</b>');
            }
            else {
                $('#modSalesmanId').val(memInfo.memId);
                $('#modSalesmanCd').val(memInfo.memCode);
                $('#modSalesmanType').val(memInfo.codeName);
                $('#modSalesmanTypeId').val(memInfo.memType);
                $('#modSalesmanName').val(memInfo.name);
                $('#modSalesmanIc').val(memInfo.nric);
                $('#modOrderDeptCode').val(memInfo.deptCode);
                $('#modDeptMemId').val(memInfo.lvl3UpId);
                $('#modOrderGrpCode').val(memInfo.grpCode);
                $('#modGrpMemId').val(memInfo.lvl2UpId);
                $('#modOrderOrgCode').val(memInfo.orgCode);
                $('#modOrgMemId').val(memInfo.lvl1UpId);
            }
        });
    }
    
    function isEditableNRIC() {
        var isEditable;
        
        Common.ajax("GET", "/sales/order/checkNricEdit.do", {custId : CUST_ID}, function(result) {

            if(result != null) {
                console.log('result.isEditable:'+result.isEditable);

                isEditable = result.isEditable;

                if(isEditable == false) {
                    Common.alert("Action Restriction" + DEFAULT_DELIMITER + "<b>Customer NRIC/Company No. for Customer ID : " + CUST_ID + " is disallowed to edit.</b>");
                }

                return isEditable;
            }
        });
    }
    
    function changeTab(tabNm) {
        
        if(tabNm == 'NRC' && isEditableNRIC() == false) {
            return false;
        }
    
        var vTit = 'Order Edit';
        
        if($("#ordEditType option:selected").index() > 0) {
            vTit += ' - '+$('#ordEditType option:selected').text();
        }
                
        $('#hTitle').text(vTit);

        if(tabNm == 'BSC') {
            $('#scBI').removeClass("blind");
            $('#aTabMI').click();
            fn_loadUpdateInfo(ORD_ID);
        } else {
            $('#scBI').addClass("blind");
        }
        if(tabNm == 'MAL') {
            $('#scMA').removeClass("blind");
            $('#aTabMA').click();
            fn_loadBillGrpMailAddr(ORD_ID);
        } else {
            $('#scMA').addClass("blind");
        }
        if(tabNm == 'CNT') {
            $('#scCP').removeClass("blind");
            $('#aTabMA').click();
            fn_loadBillGrpCntcPerson(ORD_ID);
        } else {
            $('#scCP').addClass("blind");
        }
        if(tabNm == 'NRC') {
            $('#scIC').removeClass("blind");
            $('#aTabCI').click();
            fn_loadNric(CUST_ID);
        } else {
            $('#scIC').addClass("blind");
        }
    }

    function fn_loadNric(custId){
        console.log("fn_loadNric START");

        Common.ajax("GET", "/sales/order/selectCustomerInfo.do", {custId : custId}, function(resultInfo) {

            if(resultInfo != null) {

                $("#modCustNricOld").val(resultInfo.nric);
                $("#modCustNric").val(resultInfo.nric);
                $("#modCustGender").val(resultInfo.gender);
                $("#modNationality").val(resultInfo.nation);
                $("#modCustType").val(resultInfo.typeId);
            }
        });
    }
    
    function fn_loadCntcPerson(custCntcId){
        console.log("fn_loadCntcPerson START");

        Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {custCntcId : custCntcId}, function(custCntcInfo) {

            if(custCntcInfo != null) {
                console.log('custCntcInfo.custCntcId:'+custCntcInfo.custCntcId);

                var vInit = FormUtil.isEmpty(custCntcInfo.code) ? "" : custCntcInfo.code;

                $("#modCntcPersonNew").text(vInit + ' ' + custCntcInfo.name1);
                $("#modCntcMobNoNew").text(custCntcInfo.telM1);
                $("#modCntcResNoNew").text(custCntcInfo.telR);
                $("#modCntcOffNoNew").text(custCntcInfo.telO);
                $("#modCntcFaxNoNew").text(custCntcInfo.telf);

                $("#modCustCntcId").val(custCntcInfo.custCntcId);
                
                Common.alert("Contact Person Selected" + DEFAULT_DELIMITER + "<b>New contact person selected.<br />Click save to confirm change contact person.</b>");
            }
        });
    }
    
    function fn_loadBillGrpCntcPerson(ordId) {
        Common.ajax("GET", "/sales/order/selectBillGrpCntcPersonJson.do", {salesOrdId : ordId}, function(cntcPerInfo) {

            if(cntcPerInfo != null) {
                
                $('#modCustId2').val(cntcPerInfo.custBillCustId);
                $('#modBillGroupId2').val(cntcPerInfo.custBillId);
                $('#modBillGroupNo2').text(cntcPerInfo.custBillGrpNo);
                $('#modTotalOrder2').text(cntcPerInfo.totOrder);
                
                $('#modCntcPerson').text(cntcPerInfo.custAddInfo.code + ' ' + cntcPerInfo.custAddInfo.name1);
                $('#modCntcMobNo').text(cntcPerInfo.custAddInfo.telM1);
                $('#modCntcOffNo').text(cntcPerInfo.custAddInfo.telO);
                $('#modCntcResNo').text(cntcPerInfo.custAddInfo.telR);
                $('#modCntcFaxNo').text(cntcPerInfo.custAddInfo.telf);
                
                $('#modCustCntcIdOld').val(cntcPerInfo.custAddInfo.custCntcId);     
            }
        });
    }

    function fn_loadBillGrpMailAddr(ordId) {
        Common.ajax("GET", "/sales/order/selectBillGrpMailingAddrJson.do", {salesOrdId : ordId}, function(mailAddrInfo) {

            if(mailAddrInfo != null) {
                
                $('#modCustId').val(mailAddrInfo.custBillCustId);
                $('#modBillGroupId').val(mailAddrInfo.custBillId);
                $('#modBillGroupNo').text(mailAddrInfo.custBillGrpNo);
                $('#modTotalOrder').text(mailAddrInfo.totOrder);
                $('#modAddress').text(mailAddrInfo.fullAddress);
                
                $('#modCustAddIdOld').val(mailAddrInfo.custBillAddId);                
            }
        });
    }

    function fn_loadUpdateInfo(ordId) {
        Common.ajax("GET", "/sales/order/selectBasicInfoJson.do", {salesOrderId : ordId}, function(basicInfo) {

            if(basicInfo != null) {
                
                if(basicInfo.appTypeId == '68') {
                    $('#modInstallDur').removeAttr("disabled").val(basicInfo.instlmtPriod);
                }
                
                $('#modSalesOrdNo').val(basicInfo.ordNo);
                
                $('#modAppTypeId').val(basicInfo.appTypeId);
                $('#modOrdRefNo').val(basicInfo.ordRefNo);
                $('#modOrdPoNo').val(basicInfo.ordPoNo);
                $('#modOrdRem').val(basicInfo.ordRem);
                
                $('#modSalesmanId').val(basicInfo.ordMemId);
                $('#modSalesmanCd').val(basicInfo.ordMemCode);
                $('#modSalesmanType').val(basicInfo.ordMemTypeName);
                $('#modSalesmanTypeId').val(basicInfo.ordMemTypeId);
                $('#modSalesmanName').val(basicInfo.ordMemName);
                $('#modSalesmanIc').val(basicInfo.ordMemNric);
                $('#modOrderDeptCode').val(basicInfo.ordDeptCode);
                $('#modDeptMemId').val(basicInfo.ordHmId);
                $('#modOrderGrpCode').val(basicInfo.ordGrpCode);
                $('#modGrpMemId').val(basicInfo.ordSmId);
                $('#modOrderOrgCode').val(basicInfo.ordOrgCode);
                $('#modOrgMemId').val(basicInfo.ordGmId);
                
                $('#modKeyInBranch').val(basicInfo.keyinBrnchId);
            }
        });
    }

    function fn_validNric() {
        var isValid = true, msg = "";

        if(FormUtil.isEmpty($('#modCustNric').val().trim())) {
            isValid = false;
            msg += "Please key in Cutomer NRIC / Company No";
        }
        else {
            
            var existNric = fn_validNricExist();

            console.log('existNric:'+existNric);
            
            if(existNric > 0) {
                isValid = false;
                msg += "This is existing customer. Customer ID : "+existNric;

            }
            else {
                if($('#modCustType').val().trim() == '964') {            
                    var ic = $('#modCustNric').val().trim();
                    var lastDigit = parseInt(ic.charAt(ic.length - 1));
                    
                    if(lastDigit != null) {
                        if($('#modCustGender').val() == "F") {
                            if (lastDigit % 2 != 0) {
                                isValid = false;
                                msg += "Invalid NRIC.";
                            }
                        }
                        else {
                            if (lastDigit % 2 == 0) {
                                isValid = false;
                                msg += "Invalid NRIC.";
                            }
                        }
                    }
                }
            }
        }        
        
        if(!isValid) Common.alert("Save Validation" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        
        console.log('msg:'+msg);
        console.log('isValid:'+isValid);
        
        return isValid;
    }
    
    function fn_validNricExist() {

        var exCustId = 0;
        
        Common.ajax("GET", "/sales/order/checkNricExist.do", $('#frmNric').serializeJSON(), function(result) {
            
            console.log('result:'+result);
            
            if(result != null) {
                console.log('result.custId:'+result.custId);

                exCustId = result.custId;
            }
            
       }, null, {async : false});

       return exCustId;
    }
    
    function fn_validCntcPerson() {
        var isValid = true, msg = "";

        if(FormUtil.isEmpty($('#modCustCntcId').val().trim())) {
            isValid = false;
            msg += "* Please select the contact person.<br/>";
        }

        if(FormUtil.isEmpty($('#modRem2').val().trim())) {
            isValid = false;
            msg += "* Please key in the reason to update.<br/>";
        }
        else {
            if(FormUtil.byteLength($('#modRem2').val().trim()) > 200) {            
                isValid = false;
                msg += "* Reason to update cannot more than 200 characters.<br/>";
            }
        }

        if(!isValid) Common.alert("Update Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }
    
    function fn_validMailingAddress() {
        var isValid = true, msg = "";

        if(FormUtil.isEmpty($('#modCustAddId').val().trim())) {
            isValid = false;
            msg += "* Please select the address.<br/>";
        }

        if(FormUtil.isEmpty($('#modRem').val().trim())) {
            isValid = false;
            msg += "* Please key in the reason to update.<br/>";
        }
        else {
            if(FormUtil.byteLength($('#modRem').val().trim()) > 200) {            
                isValid = false;
                msg += "* Reason to update cannot more than 200 characters.<br/>";
            }
        }

        if(!isValid) Common.alert("Update Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }
    
    function fn_validBasicInfo() {
        var isValid = true, msg = "";

        if($('#modAppTypeId').val() == '68' && FormUtil.isEmpty($('#modInstallDur').val().trim())) {
            isValid = false;
            msg += "* Please key in the installment duration.<br/>";
        }

        if(FormUtil.isNotEmpty($('#modSalesmanTypeId').val().trim())) {
            if($('#modSalesmanTypeId').val().trim() == 1 || $('#modSalesmanTypeId').val().trim() == 2) {
                if(FormUtil.isEmpty($('#modOrderDeptCode').val().trim())
                || FormUtil.isEmpty($('#modOrderGrpCode').val().trim())
                || FormUtil.isEmpty($('#modOrderOrgCode').val().trim())) {
                    isValid = false;
                    var memType = "";
                    
                    if($('#modSalesmanTypeId').val().trim() == 1) {
                        memType = "HP";
                    }
                    else if($('#modSalesmanTypeId').val().trim() == 2) {
                        memType = "Cody";
                    }
                    
                    msg += "* The " + memType + " department/group/organization code is missing.<br/>";
                }
            }
        }
        else {
            if($('#modAppTypeId').val() != '143') {
                isValid = false;
                msg += "* Please select a salesman.<br/>";
            }
        }
        
        if($("#modKeyInBranch option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the key-in branch.<br/>";
        }

        if(!isValid) Common.alert("Order Update Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }
    
    function fn_doSaveBasicInfo() {
        console.log('!@# fn_doSaveBasicInfo START');
        
        $('#hiddenOrdEditType').val($('#ordEditType').val());
        
        Common.ajax("POST", "/sales/order/updateOrderBasinInfo.do", $('#frmBasicInfo').serializeJSON(), function(result) {
                
                Common.alert("Update Summary" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_reloadPage);
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        );
    }

    function fn_doSaveMailingAddress() {
        console.log('!@# fn_doSaveMailingAddress START');

        Common.ajax("POST", "/sales/order/updateMailingAddress.do", $('#frmMailAddr').serializeJSON(), function(result) {
                
                Common.alert("Mailing Address Updated" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_reloadPage);
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("Failed To Update" + DEFAULT_DELIMITER + "<b>Failed to update mailing address.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        );
    }

    function fn_doSaveCntcPerson() {
        console.log('!@# fn_doSaveCntcPerson START');

        Common.ajax("POST", "/sales/order/updateCntcPerson.do", $('#frmCntcPer').serializeJSON(), function(result) {
                
                Common.alert("Mailing Address Updated" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_reloadPage);
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("Failed To Update" + DEFAULT_DELIMITER + "<b>Failed to update mailing address.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        );
    }

    function fn_doSaveNric() {
        console.log('!@# fn_doSaveNric START');

        Common.ajax("POST", "/sales/order/updateNric.do", $('#frmNric').serializeJSON(), function(result) {
                
                Common.alert("Success To Update" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_reloadPage);
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("Failed To Saved" + DEFAULT_DELIMITER + "<b>Failed to save. Please try again later.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        );
    }

	function fn_reloadPage(){
	    Common.popupDiv("/sales/order/orderModifyPop.do", { salesOrderId : ORD_ID, ordEditType : $('#ordEditType').val(), custId : CUST_ID }, null , true);
	    $('#btnCloseModify').click();
	}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1 id="hTitle">Order Edit</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="btnCloseModify" href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Edit Type</th>
	<td>
	<select id="ordEditType" class="mr5"></select>
	<p class="btn_sky"><a id="btnEditType" href="#">Confirm</a></p>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp" %>

<!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------
    Basic Info Edit START
------------------------------------------------------------------------------->
<section id="scBI" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3>Basic Information</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->

<form id="frmBasicInfo" method="post">
<input id="modSalesOrdId" name="salesOrdId" type="hidden" value="${salesOrderId}"/>
<input id="modSalesOrdNo" name="salesOrdNo" type="hidden" />
<input id="modAppTypeId" name="appTypeId" type="hidden" />
<input id="modSalesmanId" name="salesmanId" type="hidden" />
<input id="modSalesmanTypeId" name="salesmanTypeId" type="hidden" />
<input id="modDeptMemId" name="deptMemId" type="hidden" />
<input id="modGrpMemId" name="grpMemId" type="hidden" />
<input id="modOrgMemId" name="orgMemId" type="hidden" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:200px" />
	<col style="width:*" />
	<col style="width:170px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Installment Duration<span class="must">*</span></th>
	<td><input id="modInstallDur" name="installDur" type="text" title="" placeholder="Installment Duration (1-36 Months)" class="w100p" disabled /></td>
	<th scope="row">Salesman Code<span class="must">*</span></th>
	<td><input id="modSalesmanCd" name="salesmanCd" type="text" title="" placeholder="Salesman Code" class="" /><a id="btnSalesmanPop" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
	<th scope="row">Reference No</th>
	<td><input id="modOrdRefNo" name="ordRefNo" type="text" title="" placeholder="Reference Number" class="w100p" /></td>
	<th scope="row">Salesman Type</th>
	<td><input id="modSalesmanType" name="salesmanType" type="text" title="" placeholder="Salesman Type" class="" /></td>
</tr>
<tr>
	<th scope="row">PO No</th>
	<td><input id="modOrdPoNo" name="ordPoNo" type="text" title="" placeholder="PO Number" class="w100p" /></td>
	<th scope="row">Salesman Name</th>
	<td><input id="modSalesmanName" name="salesmanName" type="text" title="" placeholder="Salesman Name" class="" /></td>
</tr>
<tr>
	<th scope="row">Key-In Branch<span class="must">*</span></th>
	<td>
	<select id="modKeyInBranch" name="keyInBranch" class="w100p"></select>
	</td>
	<th scope="row">Salesman NRIC</th>
	<td><input id="modSalesmanIc" name="salesmanIc" type="text" title="" placeholder="Salesman NRIC" class="" /></td>
</tr>
<tr>
	<th scope="row" rowspan="3">Remark</th>
	<td rowspan="3"><textarea id="modOrdRem" name="ordRem" cols="20" rows="5"></textarea></td>
	<th scope="row">Department Code</th>
	<td><input id="modOrderDeptCode" name="orderDeptCode" type="text" title="" placeholder="Department Code" class="" /></td>
</tr>
<tr>
	<th scope="row">Group Code</th>
	<td><input id="modOrderGrpCode" name="orderGrpCode" type="text" title="" placeholder="Group Code" class="" /></td>
</tr>
<tr>
	<th scope="row">Organization Code</th>
	<td><input id="modOrderOrgCode" name="orderOrgCode" type="text" title="" placeholder="Organization Code" class="" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->
<ul class="center_btns">
	<li><p class="btn_blue2"><a id="btnSaveBasicInfo" name="btnSaveBasicInfo" href="#">SAVE</a></p></li>
</ul>
</section>
<!------------------------------------------------------------------------------
    Basic Info Edit END
------------------------------------------------------------------------------->
<!------------------------------------------------------------------------------
    Mailing Address Edit START
------------------------------------------------------------------------------->
<section id="scMA" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3>Billing Group Maintenance - Mailing Address</h3>
</aside><!-- title_line end -->
<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="btnBillNewAddr" href="#">Add New Address</a></p></li>
    <li><p class="btn_grid"><a id="btnBillSelAddr" href="#">Select Mailing Address</a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form id="frmMailAddr" method="post">
<input name="salesOrdId" type="hidden" value="${salesOrderId}"/>
<input id="modCustId" name="custId" type="hidden" />
<input id="modBillGroupId" name="billGroupId" type="hidden" />
<input id="modCustAddId" name="custAddId" type="hidden" />
<input id="modCustAddIdOld" name="custAddIdOld" type="hidden" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:190px" />
	<col style="width:*" />
	<col style="width:190px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Billing Group</th>
	<td><span id="modBillGroupNo"></span></td>
	<th scope="row">Total Order In Group</th>
	<td><span id="modTotalOrder"></span></td>
</tr>
<tr>
	<th scope="row">Current Address</th>
	<td colspan="3"><span id="modAddress"></span></td>
</tr>
<tr>
	<th scope="row">New Address</th>
	<td colspan="3"><span id="modNewAddress"></span></td>
</tr>
<tr>
	<th scope="row">Reason Update</th>
	<td colspan="3"><textarea id="modRem" name="sysHistRem" cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->
<ul class="center_btns">
	<li><p class="btn_blue2"><a id="btnSaveMailingAddress" href="#">SAVE</a></p></li>
</ul>
</section>
<!------------------------------------------------------------------------------
    Mailing Address Edit END
------------------------------------------------------------------------------->
<!------------------------------------------------------------------------------
    Contact Person Edit START
------------------------------------------------------------------------------->
<section id="scCP" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3>Billing Group Maintenance - Contact Person</h3>
</aside><!-- title_line end -->
<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="mstCntcNewAddBtn" href="#">Add New Contact</a></p></li>
    <li><p class="btn_grid"><a id="mstCntcSelAddBtn" href="#">Select Contact Person</a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form id="frmCntcPer" method="post">
<input name="salesOrdId" type="hidden" value="${salesOrderId}"/>
<input id="modCustId2" name="custId" type="hidden" />
<input id="modBillGroupId2" name="billGroupId" type="hidden" />
<input id="modCustCntcId" name="custCntcId" type="hidden" />
<input id="modCustCntcIdOld" name="custCntcIdOld" type="hidden" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Billing Group</th>
	<td><span id="modBillGroupNo2"></span></td>
	<th scope="row">Total Order In Group</th>
	<td><span id="modTotalOrder2"></span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Current Contact Person</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Contact Person</th>
	<td colspan="3"><span id="modCntcPerson"></span></td>
</tr>
<tr>
	<th scope="row">Mobile Number</th>
	<td><span id="modCntcMobNo"></span></td>
	<th scope="row">Office Number</th>
	<td><span id="modCntcOffNo"></span></td>
</tr>
<tr>
	<th scope="row">Residence Number</th>
	<td><span id="modCntcResNo"></span></td>
	<th scope="row">Fax Number</th>
	<td><span id="modCntcFaxNo"></span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>New Contact Person</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Contact Person</th>
	<td colspan="3"><span id="modCntcPersonNew"></td>
</tr>
<tr>
	<th scope="row">Mobile Number</th>
	<td><span id="modCntcMobNoNew"></span></td>
	<th scope="row">Office Number</th>
	<td><span id="modCntcOffNoNew"></span></td>
</tr>
<tr>
	<th scope="row">Residence Number</th>
	<td><span id="modCntcResNoNew"></span></td>
	<th scope="row">Fax Number</th>
	<td><span id="modCntcFaxNoNew"></span></td>
</tr>
<tr>
	<th scope="row">Reason Update</th>
	<td colspan="3"><textarea id="modRem2" name="sysHistRem" cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->
<ul class="center_btns">
	<li><p class="btn_blue2 big"><a id="btnSaveCntcPerson" href="#">SAVE</a></p></li>
</ul>
</section>
<!------------------------------------------------------------------------------
    Contact Person Edit END
------------------------------------------------------------------------------->
<!------------------------------------------------------------------------------
    NRIC/Company No. Edit START
------------------------------------------------------------------------------->
<section id="scIC" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3>NRIC/Company No.</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="frmNric" method="post">
<input name="custId" value="${custId}" type="hidden" />
<input id="modCustNricOld" name="custNricOld" type="hidden" />
<input id="modCustGender" name="custGender" type="hidden" />
<input id="modNationality" name="nationality" type="hidden" />
<input id="modCustType" name="custType" type="hidden" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:190px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">NRIC/Company No.</th>
	<td><input id="modCustNric" name="custNric" type="text" title="" placeholder="NRIC/Company No." class="" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->
<ul class="center_btns">
	<li><p class="btn_blue2"><a id="btnSaveNric" href="#">SAVE</a></p></li>
</ul>
</section>
<!------------------------------------------------------------------------------
    NRIC/Company No. Edit END
------------------------------------------------------------------------------->
<!------------------------------------------------------------------------------
    Installation Edit START
------------------------------------------------------------------------------->
<section id="scIC" class="blind">
<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Order Edit - Installation</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
	<li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
	<li><a href="#" class="on">Basic Info</a></li>
	<li><a href="#">HP / Cody</a></li>
	<li><a href="#">Customer Info</a></li>
	<li><a href="#">Installation Info</a></li>
	<li><a href="#">Mailling Info</a></li>
	<li><a href="#">Payment Channel</a></li>
	<li><a href="#">Membership Info</a></li>
	<li><a href="#">Document Submission</a></li>
	<li><a href="#">Call Log</a></li>
	<li><a href="#">Guarantee Info</a></li>
	<li><a href="#">Payment Listing</a></li>
	<li><a href="#">Last 6 Months Transaction</a></li>
	<li><a href="#">Order Configuration</a></li>
	<li><a href="#">Auto Debit Result</a></li>
	<li><a href="#">Relief Certificate</a></li>
	<li><a href="#">Discount</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:200px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Progress Status</th>
	<td><span>text</span></td>
	<th scope="row">Agreement No</th>
	<td><span>text</span></td>
	<th scope="row">Agreement Expiry</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Order No</th>
	<td></td>
	<th scope="row">Order Date</th>
	<td></td>
	<th scope="row">Status</th>
	<td></td>
</tr>
<tr>
	<th scope="row">Application Type</th>
	<td></td>
	<th scope="row">Reference No</th>
	<td></td>
	<th scope="row">Key At(By)</th>
	<td></td>
</tr>
<tr>
	<th scope="row">Product</th>
	<td></td>
	<th scope="row">PO Number</th>
	<td></td>
	<th scope="row">Key-inBranch</th>
	<td></td>
</tr>
<tr>
	<th scope="row">PV</th>
	<td></td>
	<th scope="row">Price/RPF</th>
	<td></td>
	<th scope="row">Rental Fees</th>
	<td></td>
</tr>
<tr>
	<th scope="row">Installment Duration</th>
	<td></td>
	<th scope="row">PV Month(Month/Year)</th>
	<td></td>
	<th scope="row">Rental Status</th>
	<td></td>
</tr>
<tr>
	<th scope="row">Promotion</th>
	<td colspan="3"></td>
	<th scope="row">Related No</th>
	<td></td>
</tr>
<tr>
	<th scope="row">Serial Number</th>
	<td></td>
	<th scope="row">Sirim Number</th>
	<td></td>
	<th scope="row">Update At(By)</th>
	<td></td>
</tr>
<tr>
	<th scope="row">Obligation Period</th>
	<td colspan="5"></td>
</tr>
<tr>
	<th scope="row">Remark</th>
	<td colspan="5"></td>
</tr>
<tr>
	<th scope="row">CCP Feedback Code</th>
	<td colspan="5"></td>
</tr>
<tr>
	<th scope="row">CCP Remark</th>
	<td colspan="5"></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="divine2"><!-- divine3 start -->

<article>
<h3>Salesman Info</h3>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th rowspan="3" scope="row">Order Made By</th>
	<td><span>text</span></td>
</tr>
<tr>
	<td><span>text</span></td>
</tr>
<tr>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Salesman Code</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Salesman Name</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Salesman NRIC</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Mobile No</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Office No</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">House No</th>
	<td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article>

<article>
<h3>Cody Info</h3>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th rowspan="3" scope="row">Service By</th>
	<td><span>text</span></td>
</tr>
<tr>
	<td><span>text</span></td>
</tr>
<tr>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Cody Code</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Cody Name</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Cody NRIC</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Mobile No</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Office No</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">House No</th>
	<td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article>

</section><!-- divine2 start -->


</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:140px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Customer ID</th>
	<td><span>text</span></td>
	<th scope="row">Customer Name</th>
	<td colspan="3"><span>text</span></td>
</tr>
<tr>
	<th scope="row">Customer Type</th>
	<td><span>text</span></td>
	<th scope="row">NRIC/Company No</th>
	<td><span>text</span></td>
	<th scope="row">JomPay Ref-1</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Nationality</th>
	<td><span>text</span></td>
	<th scope="row">Gender</th>
	<td><span>text</span></td>
	<th scope="row">Race</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">VA Number</th>
	<td><span>text</span></td>
	<th scope="row">Passport Exprire</th>
	<td><span>text</span></td>
	<th scope="row">Visa Exprire</th>
	<td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Same Rental Group Order(s)</h2>
</aside><!-- title_line end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EDIT</a></p></li>
	<li><p class="btn_grid"><a href="#">NEW</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:140px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th rowspan="3" scope="row">Installation Address</th>
	<td colspan="3"><span>text</span></td>
	<th scope="row">Country</th>
	<td><span>text</span></td>
</tr>
<tr>
	<td colspan="3"><span>text</span></td>
	<th scope="row">State</th>
	<td><span>text</span></td>
</tr>
<tr>
	<td colspan="3"><span>text</span></td>
	<th scope="row">Area</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Prefer Install Date</th>
	<td><span>text</span></td>
	<th scope="row">Prefer Install Time</th>
	<td><span>text</span></td>
	<th scope="row">Postcode</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Instruction</th>
	<td colspan="5"><span>text</span></td>
</tr>
<tr>
	<th scope="row">DSC Verification Remark</th>
	<td colspan="5"><span>text</span></td>
</tr>
<tr>
	<th scope="row">DSC Branch</th>
	<td colspan="3"><span>text</span></td>
	<th scope="row">Installed Date</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">CT Code</th>
	<td><span>text</span></td>
	<th scope="row">CT Name</th>
	<td colspan="3"><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt40"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:140px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Contact Name</th>
	<td colspan="3"><span>text</span></td>
	<th scope="row">Gender</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Contact NRIC</th>
	<td><span>text</span></td>
	<th scope="row">Email</th>
	<td><span>text</span></td>
	<th scope="row">Fax No</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Mobile No</th>
	<td><span>text</span></td>
	<th scope="row">Office No</th>
	<td><span>text</span></td>
	<th scope="row">House No</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Post</th>
	<td><span>text</span></td>
	<th scope="row">Department</th>
	<td><span>text</span></td>
	<th scope="row"></th>
	<td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:100px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th rowspan="3" scope="row">Mailing Address</th>
	<td colspan="3"><span>text</span></td>
	<th scope="row">Country</th>
	<td><span>text</span></td>
</tr>
<tr>
	<td colspan="3"><span>text</span></td>
	<th scope="row">State</th>
	<td><span>text</span></td>
</tr>
<tr>
	<td colspan="3"><span>text</span></td>
	<th scope="row">Area</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Billing Group</th>
	<td><span>text</span></td>
	<th scope="row">Billing Type</th>
	<td>
	<label><input type="checkbox" /><span>SMS</span></label>
	<label><input type="checkbox" /><span>Post</span></label>
	<label><input type="checkbox" /><span>E-statement</span></label>
	</td>
	<th scope="row">Postcode</th>
	<td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt40"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Contact Name</th>
	<td colspan="3"><span>text</span></td>
	<th scope="row">Gender</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Contact NRIC</th>
	<td><span>text</span></td>
	<th scope="row">Email</th>
	<td><span>text</span></td>
	<th scope="row">Fax No</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Mobile No</th>
	<td><span>text</span></td>
	<th scope="row">Office No</th>
	<td><span>text</span></td>
	<th scope="row">House No</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Post</th>
	<td><span>text</span></td>
	<th scope="row">Departiment</th>
	<td><span>text</span></td>
	<th scope="row"></th>
	<td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Rental Paymode</th>
	<td><span>text</span></td>
	<th scope="row">Direct Debit Mode</th>
	<td><span>text</span></td>
	<th scope="row">Auto Debit Limit</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Issue Bank</th>
	<td><span>text</span></td>
	<th scope="row">Card Type</th>
	<td><span>text</span></td>
	<th scope="row">Claim Bill Date</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Credit Card No</th>
	<td><span>text</span></td>
	<th scope="row">Name On Card</th>
	<td><span>text</span></td>
	<th scope="row">Expiry Date</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Bank Account No</th>
	<td><span>text</span></td>
	<th scope="row">Account Name</th>
	<td><span>text</span></td>
	<th scope="row">Issure NRIC</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Apply Date</th>
	<td><span>text</span></td>
	<th scope="row">Submit Date</th>
	<td><span>text</span></td>
	<th scope="row">Start Date</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Reject Date</th>
	<td><span>text</span></td>
	<th scope="row">Reject Code</th>
	<td><span>text</span></td>
	<th scope="row">Payment Team</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Pay By Third Party</th>
	<td><span>text</span></td>
	<th scope="row">Third Party ID</th>
	<td><span>text</span></td>
	<th scope="row">Third Party Type</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Third Party Name</th>
	<td colspan="3"><span>text</span></td>
	<th scope="row">Third Party NRIC</th>
	<td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Guarantee Status</th>
	<td colspan="3"><span>text</span></td>
</tr>
<tr>
	<th scope="row">HP Code</th>
	<td><span>text</span></td>
	<th scope="row">HP Name(NRIC)</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">HM Code</th>
	<td><span>text</span></td>
	<th scope="row">HM Name(NRIC)</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">SM Code</th>
	<td><span>text</span></td>
	<th scope="row">SM Name(NRIC)</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">GM Code</th>
	<td><span>text</span></td>
	<th scope="row">GM Name(NRIC)</th>
	<td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">BS Availability</th>
	<td><span>text</span></td>
	<th scope="row">BS Frequency</th>
	<td><span>text</span></td>
	<th scope="row">Last BS Date</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">BS Cody Code</th>
	<td colspan="5"><span>text</span></td>
</tr>
<tr>
	<th scope="row">Config Remark</th>
	<td colspan="5"><span>text</span></td>
</tr>
<tr>
	<th scope="row">Happy Call Service</th>
	<td colspan="5">
	<label><input type="checkbox" /><span>Installation Type</span></label>
	<label><input type="checkbox" /><span>BS Type</span></label>
	<label><input type="checkbox" /><span>AS Type</span></label>
	</td>
</tr>
<tr>
	<th scope="row">Prefer BS Week</th>
	<td colspan="5">
	<label><input type="radio" name="week" /><span>None</span></label>
	<label><input type="radio" name="week" /><span>Week1</span></label>
	<label><input type="radio" name="week" /><span>Week2</span></label>
	<label><input type="radio" name="week" /><span>Week3</span></label>
	<label><input type="radio" name="week" /><span>Week4</span></label>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Reference No</th>
	<td><span>text</span></td>
	<th scope="row">Certificate Date</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">GST Registration No</th>
	<td colspan="3"><span>text</span></td>
</tr>
<tr>
	<th scope="row">Remark</th>
	<td colspan="3"><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h3>Installation Address</h3>
<ul class="right_btns">
	<li><p class="btn_blue2"><a href="#">Add New Address</a></p></li>
	<li><p class="btn_blue2"><a href="#">Select Another Contact</a></p></li>
</ul>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row" rowspan="3">Address<span class="must">*</span></th>
	<td colspan="3"><span>text</span></td>
</tr>
<tr>
	<td colspan="3"><span>text</span></td>
</tr>
<tr>
	<td colspan="3"><span>text</span></td>
</tr>
<tr>
	<th scope="row">Postcode</th>
	<td><span>text</span></td>
	<th scope="row">Area</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">State</th>
	<td><span>text</span></td>
	<th scope="row">Country</th>
	<td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Installation Contact Person</h3>
<ul class="right_btns">
	<li><p class="btn_blue2"><a href="#">Add New Address</a></p></li>
	<li><p class="btn_blue2"><a href="#">Select Another Contact</a></p></li>
</ul>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Name<span class="must">*</span></th>
	<td><span>text</span></td>
	<th scope="row">Initial</th>
	<td><span>text</span></td>
	<th scope="row">Gender</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">NRIC</th>
	<td><span>text</span></td>
	<th scope="row">DOB</th>
	<td><span>text</span></td>
	<th scope="row">Race</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Email</th>
	<td><span>text</span></td>
	<th scope="row">Department</th>
	<td><span>text</span></td>
	<th scope="row">Post</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Tel (Mobile)</th>
	<td><span>text</span></td>
	<th scope="row">Tel (Residence)</th>
	<td><span>text</span></td>
	<th scope="row">Tel (Office)</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Tel (Fax)</th>
	<td><span>text</span></td>
	<th scope="row"></th>
	<td><span></span></td>
	<th scope="row"></th>
	<td><span></span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Installation Information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:190px" />
	<col style="width:*" />
	<col style="width:190px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">DSC Branch<span class="must">*</span></th>
	<td colspan="3">
	<select class="w100p">
		<option value="">11</option>
		<option value="">22</option>
		<option value="">33</option>
	</select>
	</td>
</tr>
<tr>
	<th scope="row">Prefer Install Date<span class="must">*</span></th>
	<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
	<th scope="row">Prefer Install Time<span class="must">*</span></th>
	<td>
	<div class="time_picker w100p"><!-- time_picker start -->
	<input type="text" title="" placeholder="" class="time_date w100p" />
	<ul>
		<li>Time Picker</li>
		<li><a href="#">12:00 AM</a></li>
		<li><a href="#">01:00 AM</a></li>
		<li><a href="#">02:00 AM</a></li>
		<li><a href="#">03:00 AM</a></li>
		<li><a href="#">04:00 AM</a></li>
		<li><a href="#">05:00 AM</a></li>
		<li><a href="#">06:00 AM</a></li>
		<li><a href="#">07:00 AM</a></li>
		<li><a href="#">08:00 AM</a></li>
		<li><a href="#">09:00 AM</a></li>
		<li><a href="#">10:00 AM</a></li>
		<li><a href="#">11:00 AM</a></li>
		<li><a href="#">12:00 PM</a></li>
		<li><a href="#">01:00 PM</a></li>
		<li><a href="#">02:00 PM</a></li>
		<li><a href="#">03:00 PM</a></li>
		<li><a href="#">04:00 PM</a></li>
		<li><a href="#">05:00 PM</a></li>
		<li><a href="#">06:00 PM</a></li>
		<li><a href="#">07:00 PM</a></li>
		<li><a href="#">08:00 PM</a></li>
		<li><a href="#">09:00 PM</a></li>
		<li><a href="#">10:00 PM</a></li>
		<li><a href="#">11:00 PM</a></li>
	</ul>
	</div><!-- time_picker end -->
	</td>
</tr>
<tr>
	<th scope="row">Special Instruction<span class="must">*</span></th>
	<td colspan="3"><textarea cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#">SAVE</a></p></li>
</ul>
</section>
<!------------------------------------------------------------------------------
    Installation Edit END
------------------------------------------------------------------------------->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->