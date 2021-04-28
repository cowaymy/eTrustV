<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
</style>
<script type="text/javascript">
console.log("vendorRequestViewPop");
var myGridID;
var myGridData = $.parseJSON('${appvInfoAndItems}');
var vendorInfo = "${vendorInfo}";
var attachmentList = new Array();

var attachList = null;

//그리드 속성 설정
var myGridPros = {
    // 페이징 사용
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    headerHeight : 40,
    height : 160,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

//그리드 속성 설정
var mGridPros = {
    rowIdField : "clmSeq",
    headerHeight : 40,
    height : 160,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var mGridID;


var mileageGridID;

$(document).ready(function () {

    console.log('vendorRequestViewPop: '+ myGridData);

    var appvPrccNo = "${vendorInfo.appvPrcssNo}";
    var vendorCountry = "${vendorInfo.addCountry}";
    var bankCountry = "${vendorInfo.bankCountry}";
    var bankList = "${vendorInfo.bank}";
    var paymentMethod = "${vendorInfo.payType}";
    var designation = "${vendorInfo.contactDesignation}";
   $("#keyDate").val("${vendorInfo.updDate}");


    doGetCombo('/common/selectCodeList.do', '17', designation, 'designation', 'S' , ''); // Customer Initial Type Combo Box
    $("#vendorCountry option[value='"+ vendorCountry +"']").attr("selected", true);
    $("#bankCountry option[value='"+ bankCountry +"']").attr("selected", true);
    $("#bankList option[value='"+ bankList +"']").attr("selected", true);
    $("#paymentMethod option[value='"+ paymentMethod +"']").attr("selected", true);

    $('#vendorCountry').attr("disabled", true);
    $('#bankCountry').attr("disabled", true);
    $('#bankList').attr("disabled", true);
    $('#paymentMethod').attr("disabled", true);
    $('#vendorGroup').attr("disabled", true);
    $('#designation').attr("disabled", true);

    var costCenterName =  $("#costCenterName").val();
    var costCenter =  $("#costCenter").val();
    console.log(costCenterName);
    console.log(costCenter);
    $("#viewClmNo").text(myGridData[0].clmNo);
    $("#viewClmType").text(myGridData[0].clmType);
    //$("#viewCostCentr").text(myGridData[0].costCentr + "/" + myGridData[0].costCentrName);
    $("#viewInvcDt").text(myGridData[0].invcDt);
    $("#viewReqstDt").text(myGridData[0].reqstDt);
    $("#viewReqstUserId").text(myGridData[0].reqstUserId);
    var clmNo = myGridData[0].clmNo
    var clmType = clmNo.substr(0, 2);
    if(clmType == "J3") {
        $("#viewMemAccNameTh").html('<spring:message code="crditCardNewReim.crditCardNo" />');
        $("#viewMemAccNameTd").text(myGridData[0].crditCardNo);
        $("#paydueDtLbl").empty();
        $("#viewPayDueDt").empty();
        $("#invcDtLbl").html("Claim Month");
        $("#viewInvcDt").text(myGridData[0].clmMonth);
    } else {
        $("#viewMemAccNameTh").html('<spring:message code="invoiceApprove.member" />');
        $("#viewMemAccId").val(myGridData[0].memAccId);
        $("#viewMemAccNameTd").text(myGridData[0].memAccId + " / " + myGridData[0].memAccName);

        if(clmType == "J2") {
            $("#paydueDtLbl").empty();
            $("#viewPayDueDt").empty();
            $("#invcDtLbl").html("Claim Month");
            $("#viewInvcDt").text(myGridData[0].clmMonth);
        }
    }
    $("#viewPayDueDt").text(myGridData[0].payDueDt);

    if(myGridData[0].appvPrcssStus == "A" || myGridData[0].appvPrcssStus == "J") {
        $("#pApprove_btn").hide();
        $("#pReject_btn").hide();

        $("#finApprAct").show();

        Common.ajax("GET", "/eAccounting/webInvoice/getFinalApprAct.do", {appvPrcssNo: myGridData[0].appvPrcssNo}, function(result) {
            console.log(result);

            $("#viewFinAppr").text(result.finalAppr);
        });
    } else {
        $("#finApprAct").hide();
    }

    AUIGrid.setGridData(myGridID, myGridData);
});

function fn_approvalSubmit() {
    var rows = AUIGrid.getRowIndexesByValue(invoAprveGridID, "clmNo", [$("#viewClmNo").text()]);
    // isActive
    AUIGrid.setCellValue(invoAprveGridID, rows, "isActive", "Active");
    fn_approveRegistPop();
}

function fn_RejectSubmit() {
    var rows = AUIGrid.getRowIndexesByValue(invoAprveGridID, "clmNo", [$("#viewClmNo").text()]);
    AUIGrid.setCellValue(invoAprveGridID, rows, "isActive", "Active");
    fn_rejectRegistPop();
}

function fn_getAppvItemOfClmUn(clmNo, appvItmSeq, clamUn) {
    var url = "";
    var obj = {
            clmNo : clmNo
            ,clmSeq : appvItmSeq
            ,clamUn : clamUn
    };
    var clmType = clmNo.substr(0, 2);
    if(clmType == "J1") {
        url = "/eAccounting/webInvoice/getAppvItemOfClmUn.do?_cacheId=" + Math.random();
    } else if(clmType == "J2") {
        url = "/eAccounting/pettyCash/getAppvItemOfClmUn.do?_cacheId=" + Math.random();
    } else if(clmType == "J3") {
        url = "/eAccounting/creditCard/getAppvItemOfClmUn.do?_cacheId=" + Math.random();
    } else {
        // same table, same query
        url = "/eAccounting/staffClaim/getAppvItemOfClmUn.do?_cacheId=" + Math.random();
    }
    Common.ajax("POST", url, obj, function(result) {
        console.log(result);
        console.log(result.data);

        console.log("expGrp : " + result.data.expGrp);
        if(result.data.expGrp == "1") {
            $("#noMileage").hide();

            fn_destroyMGrid();
            fn_createMileageAUIGrid(result.data.itemGrp);

            // TODO attachFile
            attachList = result.data.attachList;
            console.log(attachList);
            if(attachList) {
                if(attachList.length > 0) {
                    for(var i = 0; i < attachList.length; i++) {
                        result.data.itemGrp[i].atchFileId = attachList[i].atchFileId;
                        result.data.itemGrp[i].atchFileName = attachList[i].atchFileName;
                        var str = attachList[i].atchFileName.split(".");
                        result.data.itemGrp[i].fileExtsn = str[1];
                        result.data.itemGrp[i].fileCnt = 1;
                    }
                }
            }
        } else {
            $("#noMileage").show();

            if(clmType == "J1") {
                $("#viewInvcDt").text(result.data.invcDt);
                $("#supplirTh").html('');
                $("#supplirTd").text("");
                $("#crcInfo").hide();
                $("#payInfo1").show();
                $("#payInfo2").show();
                $("#expDesc").text(result.data.invcRem);
                $("#utilNo").text(result.data.utilNo);
                $("#jPayNo").text(result.data.jPayNo);
                var bilPeriod = "";
                if(!FormUtil.isEmpty(result.data.bilPeriodF) && !FormUtil.isEmpty(result.data.bilPeriodT)) {
                	bilPeriod = result.data.bilPeriodF + " - " + result.data.bilPeriodT;
                } else {
                	if(!FormUtil.isEmpty(result.data.bilPeriodF) && FormUtil.isEmpty(result.data.bilPeriodT)) {
                		bilPeriod = result.data.bilPeriodF + " - ";
                	}
                	if(FormUtil.isEmpty(result.data.bilPeriodF) && !FormUtil.isEmpty(result.data.bilPeriodT)) {
                        bilPeriod = " - " + result.data.bilPeriodT;
                    }
                }
                $("#bilPeriod").text(bilPeriod);
                mGridColumnLayout[4].visible = false;
            } else if(clmType == "J2") {
                $("#supplirTh").html('<spring:message code="pettyCashNewExp.supplierName" />');
                $("#supplirTd").text(result.data.supplier);
                $("#crcInfo").hide();
                $("#payInfo3").show();
                $("#payInfo3InvcDt").text(result.data.invcDt);
                var bilPeriod = "";
                if(!FormUtil.isEmpty(result.data.bilPeriodF) && !FormUtil.isEmpty(result.data.bilPeriodT)) {
                    bilPeriod = result.data.bilPeriodF + " - " + result.data.bilPeriodT;
                } else {
                    if(!FormUtil.isEmpty(result.data.bilPeriodF) && FormUtil.isEmpty(result.data.bilPeriodT)) {
                        bilPeriod = result.data.bilPeriodF + " - ";
                    }
                    if(FormUtil.isEmpty(result.data.bilPeriodF) && !FormUtil.isEmpty(result.data.bilPeriodT)) {
                        bilPeriod = " - " + result.data.bilPeriodT;
                    }
                }
                $("#payInfo3bilPeriod").text(bilPeriod);
                $("#payInfo4").show();
                $("#payInfo4utilNo").text(result.data.utilNo);
            } else if(clmType == "J3"){
                $("#ccInvcInfo").hide();
                $("#crcInfo").show();
                $("#crcCostCentr").text(result.data.sCostCentr + "/" + result.data.sCostCentrName);
                $("#crcInvcDt").text(result.data.invcDt);
                $("#supplirTh").html('<spring:message code="pettyCashNewExp.supplierName" />');
                $("#supplirTd").text(result.data.supplier);
                $("#payInfo1").hide();
                $("#payInfo2").hide();
            } else {
                $("#viewInvcDt").text(result.data.invcDt);
                $("#supplirTh").html('<spring:message code="pettyCashNewExp.supplierName" />');
                $("#supplirTd").text(result.data.supplier);
                $("#payInfo1").hide();
                $("#payInfo2").hide();
            }
            $("#invcType").text(result.data.invcType);
            $("#invcNo").text(result.data.invcNo);
            $("#gstRgistNo").text(result.data.gstRgistNo);
            $("#expDesc").text(result.data.expDesc);

            fn_destroyMileageGrid();
            fn_createMGrid(result.data.itemGrp);

            // TODO attachFile
            attachList = result.data.attachList;
            console.log(attachList);
            if(attachList) {
                if(attachList.length > 0) {
                    $("#attachTd").html("");
                    for(var i = 0; i < attachList.length; i++) {
                        //$("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' value='" + attachList[i].atchFileName + "'/></div>");
                        var atchTdId = "atchId" + (i+1);
                        $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' name='" + atchTdId + "'/></div>");
                        $(".input_text[name='" + atchTdId + "']").val(attachList[i].atchFileName);
                    }

                    // 파일 다운
                    $(".input_text").dblclick(function() {
                        var oriFileName = $(this).val();
                        var fileGrpId;
                        var fileId;
                        for(var i = 0; i < attachList.length; i++) {
                            if(attachList[i].atchFileName == oriFileName) {
                                fileGrpId = attachList[i].atchFileGrpId;
                                fileId = attachList[i].atchFileId;
                            }
                        }
                        fn_atchViewDown(fileGrpId, fileId);
                    });
                }
            }
        }

        //fn_setGridData(mGridID, result.itemGrp);
    });
}

//AUIGrid 를 생성합니다.
function fn_createMileageAUIGrid(gridData) {
    // 이미 생성되어 있는 경우
    console.log("isCreated : " + AUIGrid.isCreated("#mileage_grid_wrap"));
    if(AUIGrid.isCreated("#mileage_grid_wrap")) {
        fn_destroyMileageGrid();
    }

    $("#mileage_grid_wrap").show();

    // 실제로 #grid_wrap 에 그리드 생성
    mileageGridID = AUIGrid.create("#mileage_grid_wrap", mileageGridColumnLayout, mileageGridPros);
    // AUIGrid 에 데이터 삽입합니다.
    AUIGrid.setGridData(mileageGridID, gridData);
}

// 그리드를 제거합니다.
function fn_destroyMileageGrid() {
    $("#mileage_grid_wrap").hide();
    AUIGrid.destroy("#mileage_grid_wrap");
    mileageGridID = null;
}

//AUIGrid 를 생성합니다.
function fn_createMGrid(gridData) {
    // 이미 생성되어 있는 경우
    console.log("isCreated : " + AUIGrid.isCreated("#mGrid_wrap"));
    if(AUIGrid.isCreated("#mGrid_wrap")) {
        fn_destroyMGrid();
    }

    $("#mGrid_wrap").show();

    // 실제로 #grid_wrap 에 그리드 생성
    mGridID = AUIGrid.create("#mGrid_wrap", mGridColumnLayout, mGridPros);
    // AUIGrid 에 데이터 삽입합니다.
    AUIGrid.setGridData(mGridID, gridData);

    //fn_myGridSetEvent();
}

// 그리드를 제거합니다.
function fn_destroyMGrid() {
    $("#mGrid_wrap").hide();
    AUIGrid.destroy("#mGrid_wrap");
    mGridID = null;
}

function fn_atchViewDown(fileGrpId, fileId) {
    var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
    };
    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
        console.log(result);
        if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
            // TODO View
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
        } else {
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log("/file/fileDownWeb.do?subPath=" + fileSubPath
                    + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            window.open("/file/fileDownWeb.do?subPath=" + fileSubPath
                + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
        }
    });
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>View Submit</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_approveView">
<input type="hidden" id="viewMemAccId">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Vendor Request No</th>
    <td><span id="viewClmNo"></span></td>
    <th scope="row">Module</th>
    <td><span id="viewClmType"></span></td>
</tr>
<tr id="ccInvcInfo">
    <th scope="row">Cost Center Code</th>
    <td id="viewCostCentr">${costCenter} / ${costCenterName}</td>
    <th scope="row"><spring:message code="approveView.requester" /></th>
    <td id="viewReqstUserId"></td>
</tr>
<tr>
    <th scope="row"><spring:message code="webInvoice.requestDate" /></th>
    <td id="viewReqstDt"></td>

</tr>
<tr>
    <th scope="row"><spring:message code="approveView.approveStatus" /></th>
    <td colspan="3" style="height:60px" id="viewAppvStus">${appvPrcssStus}</td>
</tr>
<tr>
    <th scope="row">Reject</th>
    <td colspan="3">${rejctResn}</td>
</tr>
<tr id="finApprAct">
    <th scope="row">Final Approver</th>
    <td colspan="3" id="viewFinAppr"></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Claim No / Vendor Code<span class="must">*</span></th>
    <td colspan=3><input type="text" title="" id="newVendorCode" name="vendorCode" placeholder="" class="readonly w100p" readonly="readonly" value="${vendorInfo.vendorReqNo}"/></td><!--  value="${claimNo}"-->
</tr>
<tr>
    <th scope="row">Vendor Group<span class="must">*</span></th>
        <td>
           <select class="w100p" id=vendorGroup name="vendorGroup">
                  <!--  <option value="VM02"<c:if test="${vendorInfo.vendorGrp eq 'VM02'}">selected="selected"</c:if>>VM02 - Coway_Supplier_Foreign</option>-->
                  <option value="VM02"<c:if test="${vendorInfo.vendorGrp eq 'VM02'}">selected="selected"</c:if>>VM02 - Coway_Supplier_Foreign</option>
                  <option value="VM03"<c:if test="${vendorInfo.vendorGrp eq 'VM03'}">selected="selected"</c:if>>VM03 - Coway_Supplier_Foreign (Related Company)</option>
                  <option value="VM11"<c:if test="${vendorInfo.vendorGrp eq 'VM11'}">selected="selected"</c:if>>VM11 - Coway_Suppliers_Local</option>
           </select>
        </td>
    <th scope="row">Key in date</th>
    <td>
    <input type="text" title="" id="keyDate" name="keyDate" placeholder="DD/MM/YYYY" class="readonly w100p" readonly="readonly"/>
    </td>
</tr>
<tr>
      <th scope="row">Cost Center</th>
      <td><input type="text" title="" placeholder="" class="readonly w100p" id="newCostCenter" name="costCentr" value="${vendorInfo.costCenter}" readonly="readonly"/></td>
    <th scope="row">Create User ID</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" id="userName" readonly="readonly" value="${vendorInfo.userName}" /></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2></h2>
</aside><!-- title_line end -->


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th colspan=2 scope="row">Registered Company/Individual Name</th>
    <td colspan=3><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="regCompName" name="regCompName" value="${vendorInfo.vendorName}"/></td>
</tr>
<tr>
    <th colspan = 2 scope="row">Company Registration No/IC No</th>
    <td colspan="3"><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="regCompNo" name="regCompNo" value="${vendorInfo.vendorRegNoNric}"/></td>
</tr>
<tr>
    <th colspan = 2 scope="row">Email Address (payment advice)<span class="must">*</span></th>
    <td colspan="3"><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="emailPayAdv" name="emailPayAdv"/></td>
</tr>
<tr>
    <th colspan = 2 scope="row">Email Address 2 (payment advice)</th>
    <td colspan="3"><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="emailPayAdv2" name="emailPayAdv2"/></td>
</tr>

</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Vendor Address</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Street</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="street" name="street" value="${vendorInfo.addStreet}"/></td>
    <th scope="row">House/Lot Number</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="houseNo" name="houseNo" value="${vendorInfo.addHouseLotNo}"/></td>
</tr>
<tr>
    <th scope="row">Postal Code</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="postalCode" name="postalCode" value="${vendorInfo.addPostalCode}"/></td>
    <th scope="row">City</th>
        <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="city" name="city" value="${vendorInfo.addCity}"/></td>
</tr>
<tr>
    <th scope="row">Country</th>
        <td colspan=3>
           <select  style="text-transform:uppercase" class="readonly w100p" id="vendorCountry" name="vendorCountry">
            <c:forEach var="list" items="${countryList}" varStatus="status">
               <option value="${list.code}">${list.name}</option>
            </c:forEach>
        </select>
        </td>
</tr>

</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Payment Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th>Payment Terms <b>(Days)</b></th>
    <td><input type="text" min="1"  title="" placeholder="" class="readonly w100p" readonly='readonly' id="paymentTerms" name="paymentTerms" value="${vendorInfo.payTerm}"/></td>
    <th>Payment Method</th>
    <td>
        <select class="readonly w100p" id=paymentMethod name="paymentMethod">
                  <!--  <option value="CASH">CASH</option>-->
                  <option value="CASH"<c:if test="${vendorInfo.payType eq 'CASH'}">selected="selected"</c:if>>CASH</option>
                  <option value="CHEQ"<c:if test="${vendorInfo.payType eq 'CHEQ'}">selected="selected"</c:if>>CHEQUE</option>
                  <option value="OTRX"<c:if test="${vendorInfo.payType eq 'OTRX'}">selected="selected"</c:if>>ONLINE TRANSFER</option>
                  <option value="TTRX"<c:if test="${vendorInfo.payType eq 'TTRX'}">selected="selected"</c:if>>TELEGRAPHIC TRANSFER</option>
           </select>
    </td>
</tr>
<tr>
    <th>Others (Please State)</th>
    <td colspan=3><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="others" name="others" value="${vendorInfo.payOth}" /></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Vendor Bank Details</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Country</th>
    <td>
        <select  style="text-transform:uppercase" class="readonly w100p" id="bankCountry" name="bankCountry">
            <c:forEach var="list" items="${countryList}" varStatus="status">
               <option value="${list.code}">${list.name}</option>
            </c:forEach>
        </select>
    </td>
    <th scope="row">Account Holder<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="bankAccHolder" name="bankAccHolder" value="${vendorInfo.bankAccHolder}"/></td>
</tr>
<tr>
    <th scope="row"> Bank<span class="must">*</span></th>
    <td>
        <select class="readonly w100p" id="bankList" name="bankList">
            <c:forEach var="list" items="${bankList}" varStatus="status">
               <option value="${list.code}">${list.name}</option>
            </c:forEach>
        </select>
    </td>
    <th scope="row">Bank Account Number<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="bankAccNo" name="bankAccNo" value="${vendorInfo.bankAccNo}"/></td>
</tr>
<tr>
    <th>Branch</th>
    <td colspan=3><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="branch" name="branch" value="${vendorInfo.bankBranch}"/></td>
</tr>
<tr>
    <th scope="row">Swift Code</th>
    <td colspan=3><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="swiftCode" name="swiftCode" value="${vendorInfo.swiftCode}"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Vendor Contact Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Designation</th>
    <td>
    <select class="w100p" id="designation" name="designation"></select>
    </td>
    <th scope="row"> Name</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="vendorEmail" name="email" value="${vendorInfo.contactName}"/></td>
</tr>
<tr>
    <th>Phone Number</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="vendorPhoneNo" name="phoneNo" value="${vendorInfo.contactPhoneNo}"/></td>
    <th>Email Address</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly='readonly' id="vendorEmail" name="email" value="${vendorInfo.contactEmail}"/></td>
</tr>

</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Attachment</th>
    <td colspan="3" id="attachTd">
        <c:forEach var="files" items="${attachmentList}" varStatus="st">
            <div class="auto_file2 attachment_file w100p"><!-- auto_file start -->
                <c:if test="${webInvoiceInfo.appvPrcssNo eq null or webInvoiceInfo.appvPrcssNo eq ''}">
                <label>
                </c:if>
                <input type='text' class='input_text' readonly='readonly' value="${files.atchFileName}" />
                <c:if test="${webInvoiceInfo.appvPrcssNo eq null or webInvoiceInfo.appvPrcssNo eq ''}">
                </c:if>
                <c:if test="${webInvoiceInfo.appvPrcssNo eq null or webInvoiceInfo.appvPrcssNo eq ''}">
                </label>
                 </c:if>
             </div>
        </c:forEach>
    </td>
</tr>

</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->


<article class="grid_wrap" id="approveView_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->