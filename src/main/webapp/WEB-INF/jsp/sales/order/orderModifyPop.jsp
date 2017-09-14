<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    
    var ORD_ID = '${salesOrderId}';
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
    
    function changeTab(tabNm) {
        
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

	function fn_reloadPage(){
	    Common.popupDiv("/sales/order/orderModifyPop.do", { salesOrderId : ORD_ID, ordEditType : $('#ordEditType').val() }, null , true);
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
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->