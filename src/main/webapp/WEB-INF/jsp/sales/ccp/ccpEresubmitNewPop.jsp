<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 행 스타일 */
.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
</style>
<script type="text/javascript">

var update = new Array();
var remove = new Array();
var myFileCaches = {};
var sofFrFileId = 0;
var softcFrFileId = 0;
var nricFrFileId = 0;
var msofFrFileId = 0;
var msoftcFrFileId = 0;
var payFrFileId = 0;
var govFrFileId = 0;
var letFrFileId = 0;
var docFrFileId = 0;

var sofFrFileName = "";
var softcFrFileName = "";
var nricFrFileName = "";
var msofFrFileName = "";
var msoftcFrFileName = "";
var payFrFileName = "";
var govFrFileName = "";
var letFrFileName = "";
var docFrFileName = "";

function fn_closePop() {
    $("#chsFileUploadClose").click();
}

$(document).ready(function(){

	$("#rbt").attr("style","display:none");
	$("#ORD_NO_RESULT").attr("style","display:none");

    var elements = document.getElementsByName("uploadfiletest");
    for(var i = 0; i < elements.length; i++) {
        elements[i].className = "auto_file2";
    }

	$("#ORD_NO_P").keydown(function(key)  {
        if (key.keyCode == 13) {
            fn_doConfirm();
        }
 });


	var salesmanCode = '${SESSION_INFO.userName}';
	console.log("salesmanCode " + salesmanCode);
});

function fn_doConfirm(){

	var salesmanCode = '${SESSION_INFO.userName}';

    Common.ajax("GET", "/sales/ccp/ccpEresubmitNewConfirm", {ORD_NO : $("#ORD_NO_P").val(),SalesmanCode : salesmanCode}, function(result) {
         console.log( result);


         if(result.length == 0)  {

             //$("#cbt").attr("style","display:inline");
             //$("#ORD_NO_P").attr("style","display:inline");
             //$("#sbt").attr("style","display:inline");
             //$("#rbt").attr("style","display:none");
             //$("#ORD_NO_RESULT").attr("style","display:none");

             //$("#resultcontens").attr("style","display:none");

             Common.alert("No order found / this order had resubmitted / this order not under own sales.");
             return ;

         }else{
             console.log( result[0].salesOrdId);
             Common.ajax("GET", "/sales/ccp/ccpEresubmitViewPop.do",{salesOrdId : result[0].salesOrdId}, function(result) {
                 console.log("성공.");
                 console.log("fn_getOrderDetailListAjax data :: " + result);

                 setText(result);

                 $("#cbt").attr("style","display:none");
                 $("#ORD_NO_P").attr("style","display:none");
                 $("#sbt").attr("style","display:none");
                 $("#rbt").attr("style","display:inline");
                 $("#ORD_NO_RESULT").attr("style","display:inline");
                 $("#resultcontens").attr("style","display:inline");
               });

             $("#ORD_NO_RESULT").val( result[0].salesOrdNo);
             $("#ORD_ID").val( result[0].salesOrdId);
             $("#CCP_ID").val( result[0].ccpId);
         }
   });
}

function setText(result){

    var date = new Date(Date.now());
    console.log(date.toLocaleString('en-GB', { hour12:false } ));

    var time1 = result.orderDetail.basicInfo.ordDt;
    var myDate = new Date(time1);

    resultBasicObject = result.basic;
    resultSrvconfigObject = result.srvconfig;

    $("#prgrs").html(result.orderDetail.logView.prgrs);
    if(result.orderDetail.agreementView != null){
        $("#govAgItmBatchNo").html(result.orderDetail.agreementView.govAgItmBatchNo);
        $("#govAgEndDt").html(result.orderDetail.agreementView.govAgEndDt);
    }
    if(result.orderDetail.basicInfo.custNric == result.orderDetail.salesmanInfo.nric){
        var ordNo = result.orderDetail.basicInfo.ordNo + " " + result.orderDetail.salesmanInfo.memCode
        $("#ordNo").html(ordNo);
    }else{
        $("#ordNo").html(result.orderDetail.basicInfo.ordNo);
    }
    var myDate = new Date(result.orderDetail.basicInfo.ordDt);
    $("#ordDt").html(myDate.toLocaleString('en-GB', { hour12:false }));
    $("#ordStusName").html(result.orderDetail.basicInfo.ordStusName);
    $("#voucher").html(result.orderDetail.basicInfo.voucher);
    if(result.orderDetail.basicInfo.redeemHs > 0){
        if(result.orderDetail.basicInfo.redeemMth > 0 && result.orderDetail.basicInfo.redeemYear > 0){
            var redeemHs = result.orderDetail.basicInfo.redeemMth + "-" + result.orderDetail.basicInfo.redeemYear;
            $("#redeemHs").html(redeemHs);
        }
    }
    //checkbox
    if(result.orderDetail.basicInfo.redeemWarranty > 0){
    //checkbox
    }
    $("#appTypeDesc").html(result.orderDetail.basicInfo.appTypeDesc);
    $("#ordRefNo").html(result.orderDetail.basicInfo.ordRefNo);
    $("#ordCrtUserId").html(result.orderDetail.basicInfo.ordCrtUserId);
    $("#stockDesc").html(result.orderDetail.basicInfo.stockDesc);
    $("#ordPoNo").html(result.orderDetail.basicInfo.ordPoNo);
    var keyinBrnchCode = "(" + result.orderDetail.basicInfo.keyinBrnchCode + ")" + result.orderDetail.basicInfo.keyinBrnchName;
    $("#keyinBrnchCode").html(keyinBrnchCode);
    $("#ordPv").html(result.orderDetail.basicInfo.ordPv);
    $("#norAmt").html(result.orderDetail.basicInfo.norAmt);
    $("#ordAmt").html(result.orderDetail.basicInfo.ordAmt);
    $("#pormoPeriodType").html(result.orderDetail.basicInfo.pormoPeriodType);
    $("#norRntFee").html(result.orderDetail.basicInfo.norRntFee);
    $("#mthRentalFees").html(result.orderDetail.basicInfo.mthRentalFees);
    $("#installmentDuration").html(result.orderDetail.basicInfo.installmentDuration);
    var ordPvMonth = result.orderDetail.basicInfo.ordPvMonth + "/" + result.orderDetail.basicInfo.ordPvYear;
    $("#ordPvMonth").html(ordPvMonth);
    $("#rentalStatus").html(result.orderDetail.basicInfo.rentalStatus);
    if(result.orderDetail.basicInfo.ordPromoId > 0){
        var ordPromoId = "(" + result.orderDetail.basicInfo.ordPromoCode + ")" +  " " + result.orderDetail.basicInfo.ordPromoDesc;
        $("#ordPromoId").html(ordPromoId);
    }
    $("#ordPromoRelatedNo").html(result.orderDetail.basicInfo.ordPromoRelatedNo);
    if(result.orderDetail.basicInfo.advDisc == 1){
        $("#advDisc").html("Yes");
    }else if(result.orderDetail.basicInfo.advDisc == 2){
        $("#advDisc").html("No");
    }
    $("#lastInstallSerialNo").html(result.orderDetail.installationInfo.lastInstallSerialNo);
    $("#lastInstallSirimNo").html(result.orderDetail.installationInfo.lastInstallSirimNo);
    var updDt = new Date(result.orderDetail.basicInfo.updDt);
    $("#updDt").html(updDt.toLocaleString('en-GB', { hour12:false }) + " (" + result.orderDetail.basicInfo.updUserId + ")");
    $("#obligtYear").html(result.orderDetail.basicInfo.obligtYear);
    $("#addCmpt").html(result.orderDetail.basicInfo.addCmpt);
    if(result.orderDetail.basicInfo.pckageBindingId > 0){
        $("#pckageBindingId").html(result.orderDetail.basicInfo.pckageBindingId);
    }
    $("#ekeyCrtUser").html(result.orderDetail.basicInfo.ekeyCrtUser);
    $("#ekeyBrnchName").html(result.orderDetail.basicInfo.ekeyBrnchName);
    $("#ordRem").html(result.orderDetail.basicInfo.ordRem);
    var resnDesc = result.orderDetail.ccpFeedbackCode.code + "-" + result.orderDetail.ccpFeedbackCode.resnDesc;
    $("#resnDesc").html(resnDesc);
    $("#ccpRem").html(result.orderDetail.ccpInfo.ccpRem);
    $("#corpCustType").html(result.orderDetail.basicInfo.corpCustType);
    $("#agreementType").html(result.orderDetail.basicInfo.agreementType);
    if(result.orderDetail.prodUsgMthInfo != null){
        $("#productUsageMonth").html(result.orderDetail.prodUsgMthInfo.productUsageMonth);
    }
    $("#remarks").text('${ccpEresubmitMap.remarks}');
}

function fn_save(){

	 if($('#sofFrFile').val().trim() == '' &&  $('#softcFrFile').val().trim() == '' && $('#nricFrFile').val().trim() == '' && $('#msofFrFile').val().trim() == '' && $('#msoftcFrFile').val().trim() == ''
		&& $('#payFrFile').val().trim() == '' && $('#govFrFile').val().trim() == '' && $('#letFrFile').val().trim() == '' && $('#docFrFile').val().trim() == ''){
		Common.alert("No attachment. Unable to save.");
        return ;
	}

	var formData = new FormData();
    formData.append("atchFileGrpId", '${result.ccpEresubmitMap.atchFileGrpId}');
	formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
    formData.append("salesOrdId",'${result.ccpEresubmitMap.salesOrdId}');
    formData.append("ccpId",'${result.ccpEresubmitMap.ccpId}');
    var remarks = $("#remarks").val();

    var salesmanCode = '${SESSION_INFO.userName}';

	Common.ajax("GET", "/sales/ccp/ccpEresubmitNewConfirm", {ORD_NO : $("#ORD_NO_P").val(),SalesmanCode : salesmanCode}, function(result) {
        console.log( result);
        if(result.length == 0)  {
            Common.alert("No order found / this order had resubmitted / this order not under own sales.");
            return ;

        }else{
        	var ordId = $("#ORD_ID").val();
            var ccpId = $("#CCP_ID").val();

            $.each(myFileCaches, function(n, v) {
                console.log(v.file);
                formData.append(n, v.file);
            });

            Common.ajaxFile("/sales/ccp/attachResubmitFileUpload.do", formData, function(result) {
                if(result.code == 99){
                    Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);
                }else{
                   // DO SAVE BUTTON ACTION
                   var atchFileGrpId = result.data.fileGroupKey;
                    Common.ajax("POST", "/sales/ccp/ccpEresubmitSave", {ordId : ordId,ccpId : ccpId, atchFileGrpId : atchFileGrpId, remarks : remarks}, function(result) {
                        console.log( result);

                        if(result == null){
                            Common.alert("No order found or this order had resubmitted.");
                        }else{
                            Common.alert("Order resubmitted");
                            $('#ccpResubmitClose').click();
                        }
                   });
                }
            },function(result){
                Common.alert(result.message+"<br/>Upload Failed. Please check with System Administrator.");
            });


        }
  });

}

function fn_atchViewDown(fileGrpId, fileId) {
    var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
    };

    console.log(data);
    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
        console.log(result)
        var fileSubPath = result.fileSubPath;
        fileSubPath = fileSubPath.replace('\', '/'');

        if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
            console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
        } else {
            console.log("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
        }
    });
}

$(function(){
    $('#sofFrFile').change( function(evt) {
        var file = evt.target.files[0];
        if(file == null){
            remove.push(sofFrFileId);
        }else if(file.name != sofFrFileName){
             myFileCaches[1] = {file:file};
             if(sofFrFileName != ""){
                 update.push(sofFrFileId);
             }
         }
    });
    $('#softcFrFile').change( function(evt) {
        var file = evt.target.files[0];
        if(file == null){
            remove.push(softcFrFileId);
        }else if(file.name != softcFrFileName){
            myFileCaches[2] = {file:file};
            if(softcFrFileName != ""){
                update.push(softcFrFileId);
            }
        }
    });
    $('#nricFrFile').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null){
            remove.push(nricFrFileId);
        }else if(file.name != nricFrFileName){
            myFileCaches[3] = {file:file};
            if(nricFrFileName != ""){
                update.push(nricFrFileId);
            }
        }
    });

    $('#msofFrFile').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null){
            remove.push(msofFrFileId);
        }else if(file.name != msofFrFileName){
            myFileCaches[4] = {file:file};
            if(msofFrFileName != ""){
                update.push(msofFrFileId);
           }
        }
    });

    $('#msoftcFrFile').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null){
            remove.push(msoftcFrFileId);
        }else if(file.name != msoftcFrFileName){
            myFileCaches[5] = {file:file};
            if(msoftcFrFileName != ""){
                update.push(msoftcFrFileId);
            }
        }
    });

    $('#payFrFile').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null){
            remove.push(payFrFileId);
        }else if(file.name != payFrFileName){
            myFileCaches[6] = {file:file};
            if(payFrFileName != ""){
                update.push(payFrFileId);
            }
        }
    });

    $('#govFrFile').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null){
            remove.push(govFrFileId);
        }else if(file.name != govFrFileName){
            myFileCaches[7] = {file:file};
            if(govFrFileName != ""){
                update.push(govFrFileId);
            }
        }
    });

    $('#letFrFile').change( function(evt) {
        var file = evt.target.files[0];
        if(file == null){
            remove.push(letFrFileId);
        }else if(file.name != letFrFileName){
             myFileCaches[8] = {file:file};
             if(letFrFileName != ""){
                 update.push(letFrFileId);
             }
         }
    });

    $('#docFrFile').change( function(evt) {
        var file = evt.target.files[0];
        if(file == null){
            remove.push(docFrFileId);
        }else if(file.name != docFrFileName){
             myFileCaches[9] = {file:file};
             if(docFrFileName != ""){
                 update.push(docFrFileId);
             }
         }
    });
});

/* function fn_goCustSearch() {
    Common.popupDiv('/homecare/sales/ccp/searchOrderNoPop.do', null, null, true, '_searchDiv');
  } */

function fn_removeFile(name){
    if(name == "SOF") {
        console.log("SOF in");
         $("#sofFrFile").val("");
         $(".input_text[id='sofFrFileTxt']").val("");
         $('#sofFrFile').change();
    }else if(name == "SOFTC"){
        $("#softcFrFile").val("");
        $(".input_text[id='softcFrFileTxt']").val("");
        $('#softcFrFile').change();
    }else if(name == "NRIC"){
        $("#nricFrFile").val("");
        $(".input_text[id='nricFrFileTxt']").val("");
        $('#nricFrFile').change();
    }else if(name == "MSOF"){
        $("#msofFrFile").val("");
        $(".input_text[id='msofFrFileTxt']").val("");
        $('#msofFrFile').change();
    }else if(name == "MSOFTC"){
        $("#msoftcFrFile").val("");
        $(".input_text[id='msoftcFrFileTxt']").val("");
        $('#msoftcFrFile').change();
    }else if(name == "PAY") {
        $("#payFrFile").val("");
        $(".input_text[id='payFrFileTxt']").val("");
        $('#payFrFile').change();
    }else if(name == "GOV") {
        $("#govFrFile").val("");
        $(".input_text[id='govFrFileTxt']").val("");
        $('#govFrFile').change();
    }else if(name == "LET") {
        $("#letFrFile").val("");
        $(".input_text[id='letFrFileTxt']").val("");
        $('#letFrFile').change();
    }else if(name == "DOC") {
        $("#docFrFile").val("");
        $(".input_text[id='docFrFileTxt']").val("");
        $('#docFrFile').change();
    }
}
</script>


<form id="getDataForm" method="post">
<div style="display:inline">
    <input type="text" name="ORD_ID"     id="ORD_ID"/>
    <input type="text" name="CCP_ID"     id="CCP_ID"/>
    <input type="text" name="CUST_ID"    id="CUST_ID"/>

</div>
</form>

<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Ezy CCP - New</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="ccpResubmitClose" href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#"   id="sForm"  name="sForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No</th>
    <td>
           <input type="text" title="" id="ORD_NO_P" name="ORD_NO_P" placeholder="" class="" /><p class="btn_sky"  id='cbt'> <a href="#" onclick="javascript: fn_doConfirm()"> Confirm</a></p>   <p class="btn_sky" id='sbt'><a href="#" onclick="javascript: fn_goCustSearch()">Search</a></p>
           <input type="text" title="" id="ORD_NO_RESULT" name="ORD_NO_RESULT"   placeholder="" class="readonly " readonly="readonly" /><p class="btn_sky" id="rbt"> <a href="#" onclick="javascript :fn_doReset()">Reselect</a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<section>
<div  id="resultcontens"  style="display:none">
        <section class="tap_wrap"><!-- tap_wrap start -->
        <ul class="tap_type1">
            <li><a href="#" class="on"  >Basic Info</a></li>
            <!-- <li><a href="#">Contact Person</a></li> -->
            <li><a href="#">Attachment</a></li>
        </ul>

        <article class="tap_area"><!-- tap_area start -->

        <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:130px" />
            <col style="width:*" />
            <col style="width:130px" />
            <col style="width:*" />
            <col style="width:110px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row"><spring:message code="sal.title.text.prgssStus" /></th>
            <td><span id='prgrs' ></span></td>
            <th scope="row"><spring:message code="sal.title.text.agrNo" /></th>
            <td><span id='govAgItmBatchNo' ></span></td>
            <th scope="row"><spring:message code="sal.title.text.agrExpiry" /></th>
            <td><span id='govAgEndDt' ></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.ordNo" /></th>
            <td><span id='ordNo' ></span></td>
            <th scope="row"><spring:message code="sal.text.ordDate" /></th>
            <td><span id='ordDt' ></span>
            </td>
            <th scope="row"><spring:message code="sal.text.status" /></th>
            <td><span id='ordStusName' ></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.evoucher" /></th>
            <td><span id='voucher' ></span></td>
            <th scope="row"><spring:message code="sal.text.evoucher.hs"/></th>
            <td><span id='redeemHs' ></span>
                <c:choose>
                    <c:when test="${orderDetail.basicInfo.redeemHs > 0}">
                        <input type="checkbox" onClick="return false" checked/>
                        <c:if test="${orderDetail.basicInfo.redeemMth > 0 && orderDetail.basicInfo.redeemYear > 0}">
                               <span>&nbsp;(${orderDetail.basicInfo.redeemMth}-${orderDetail.basicInfo.redeemYear})</span>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                       <input type="checkbox" disabled/>
                    </c:otherwise>
                </c:choose>
            </td>
            <th scope="row"><spring:message code="sal.text.evoucher.ext.warr"/></th>
            <td><span id='redeemWarranty' ></span>
                <c:choose>
                    <c:when test="${orderDetail.basicInfo.redeemWarranty > 0}">
                           <input type="checkbox" onClick="return false" checked/>
                    </c:when>
                    <c:otherwise>
                       <input type="checkbox" disabled/>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.appType" /></th>
            <td><span id='appTypeDesc' ></span></td>
            <th scope="row"><spring:message code="sal.text.refNo" /></th>
            <td><span id='ordRefNo' ></span></td>
            <th scope="row"><spring:message code="sal.title.text.keyAtBy" /></th>
            <td><span id='ordCrtUserId' ></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.product" /></th>
            <td><span id='stockDesc' ></span></td>
            <th scope="row"><spring:message code="sal.title.text.poNumber" /></th>
            <td><span id='ordPoNo' ></span></td>
            <th scope="row"><spring:message code="sal.text.keyInBranch" /></th>
            <td><span id='keyinBrnchCode' ></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.title.text.pv" /></th>
            <td><span id='ordPv' ></span></td>
            <th scope="row"><spring:message code="sal.title.text.normalPrcRpf" /></th>
            <td><span id='norAmt' ></span></td>
            <th scope="row"><spring:message code="sal.title.text.finalPrcRpf" /></th>
            <td><span id='ordAmt' ></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sales.promo.discPeriod" /></th>
            <td><span id='pormoPeriodType' ></span></td>
            <th scope="row"><spring:message code="sal.title.text.normalRentalFees" /></th>
            <td><span id='norRntFee' ></span></td>
            <th scope="row"><spring:message code="sal.title.text.finalRentalFees" /></th>
            <td><span id='mthRentalFees' ></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.title.text.instDuration" /></th>
            <td><span id='installmentDuration' ></span></td>
            <th scope="row"><spring:message code="sal.title.text.pvMth" /></br>(<spring:message code="sal.title.text.mthYear" />)</th>
            <td><span id='ordPvMonth' ></span></td>
            <th scope="row"><spring:message code="sal.text.rentalStatus" /></th>
            <td><span id='rentalStatus' ></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.title.text.promo" /></th>
            <td colspan="3"><span id='ordPromoId' ></span></td>
            <th scope="row"><spring:message code="sal.title.text.relatedNo" /></th>
            <td><span id='ordPromoRelatedNo' ></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sales.eligiAdvDisc" /></th>
            <td colspan="5">
            <span id='advDisc' ></span>
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sales.SeriacNo" /></th>
            <td><span id='lastInstallSerialNo' ></span></td>
            <th scope="row"><spring:message code="sales.SirimNo" /></th>
            <td><span id='lastInstallSirimNo' ></span></td>
            <th scope="row"><spring:message code="sal.title.text.updAtBy" /></th>
            <td><span id='updDt' ></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.obligationPeriod" /></th>
            <td colspan="1"><span id='obligtYear' ></span></td>
            <th scope="row"><spring:message code="sal.text.AddCmpt" /></th>
            <td colspan="1"><span id='addCmpt' ></span></td>
            <th scope="row"><spring:message code="sal.title.text.cboBindOrdNo" /></th>
            <td colspan="1"><p class="w100p">
            <span style="float:left" id='pckageBindingId' ></span>
            </p></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.ekeyCrtUser" /></th>
            <td colspan="1"><span id='ekeyCrtUser' ></span></td>
            <th scope="row"><spring:message code="sal.text.ekeyBrnchName" /></th>
            <td colspan="3"><span id='ekeyBrnchName' ></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.remark" /></th>
            <td colspan="5"><span id='ordRem' ></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.title.text.ccpFeedbackCode" /></th>
            <td colspan="5"><span id='resnDesc' ></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.title.text.ccpRem" /></th>
            <td colspan="5"><span id='ccpRem' ></span></td>
        </tr>
        <tr>
            <th scope="row">SST Type</th>
            <td colspan="1"><span id='corpCustType' ></span></td>
            <th scope="row">Agreement Type</th>
            <td colspan="1"><span id='agreementType' ></span></td>
            <th scope="row">Product Usage Month</th>
            <td colspan="1"><span id='productUsageMonth' ></span></td>
        </tr>
        </tbody>
        </table><!-- table end -->

        </article><!-- tap_area end -->


        <article class="tap_area"><!-- tap_area start -->
        <aside class="title_line"><!-- title_line start -->
        <h3>Attachment area</h3>
        </aside><!-- title_line end -->


        <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:350px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row">Sales Order Form (SOF)</th>
            <td>
                <div name='uploadfiletest' class='auto_file3'>
                    <input type='file' title='file add'  id='sofFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='sofFrFileTxt'  name=''/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("SOF")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Sales Order Form's T&C (SOF T&C)</th>
            <td>
                <div name='uploadfiletest' class='auto_file3'>
                    <input type='file' title='file add'  id='softcFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='softcFrFileTxt'  name=''/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("SOFTC")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">NRIC / VISA /Bank Card</th>
            <td>
                <div name='uploadfiletest' class='auto_file3'>
                    <input type='file' title='file add'  id='nricFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='nricFrFileTxt'  name=''/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("NRIC")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Mattress Sales ORder Form (MSOF)</th>
            <td>
                <div name='uploadfiletest' class='auto_file3'>
                    <input type='file' title='file add'  id='msofFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='msofFrFileTxt'  name=''/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("MSOF")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Mattress Sales Order Form's T&C (MSOF T&C)</th>
            <td>
                <div name='uploadfiletest' class='auto_file3'>
                    <input type='file' title='file add'  id='msoftcFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='msoftcFrFileTxt'  name=''/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("MSOFTC")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Payment document / Payment Channel</th>
            <td>
                <div name='uploadfiletest' class='auto_file3'>
                    <input type='file' title='file add'  id='payFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='payFrFileTxt'  name=''/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("PAY")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Government (Agreement / SST / LO)</th>
            <td>
                <div name='uploadfiletest' class='auto_file3'>
                    <input type='file' title='file add'  id='govFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='govFrFileTxt'  name=''/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("GOV")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Declaration letter</th>
            <td>
                <div name='uploadfiletest' class='auto_file3'>
                    <input type='file' title='file add'  id='letFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='letFrFileTxt'  name=''/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("LET")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Supporting document (Utility bill / SSM / Others)</th>
            <td>
                <div name='uploadfiletest' class='auto_file3'>
                    <input type='file' title='file add'  id='docFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='docFrFileTxt'  name=''/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("DOC")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
		<th scope="row">Remarks :</th>
			<td>
			 <input type="text" title="Remarks" placeholder="" id="remarks" name="remarks"  maxlength="200"/>
			</td>
		</tr>
        <tr>
            <td colspan=2><span class="red_text">Only allow picture format (JPG, PNG, JPEG, PDF)</span></td>
        </tr>
        </tbody>
        </table>

        </article><!-- tap_area end -->
        </section><!-- tap_wrap end -->



        <ul class="center_btns">
            <li><p class="btn_blue2"><a href="#"  onclick="javascript:fn_save()">Save</a></p></li>
        </ul>

</div>
</section>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->