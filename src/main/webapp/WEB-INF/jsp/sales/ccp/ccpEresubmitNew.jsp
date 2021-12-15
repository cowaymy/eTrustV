
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<style>

/* 커스텀 행 스타일 */
.my-row-style {
    background:#FFB2D9;
    font-weight:bold;
    color:#22741C;
}

.auto_file2 {
        width:100%!important;
    }
</style>
<script type="text/javaScript" language="javascript">

var oListGridID;
var bsHistoryGridID;

var resultBasicObject;
var resultSrvconfigObject;
var resultInstallationObject;

//Window Option
var option = {
        width: "1000px", // 창 가로 크기
        height: "520px" // 창 세로 크기
         }

$(document).ready(function(){
    //$("#cPromo").prop("disabled", true);
    //$("#cPromo").attr("class", "disabled");

    $("#rbt").attr("style","display:none");
    $("#ORD_NO_RESULT").attr("style","display:none");

    var elements = document.getElementsByClassName("attach_mod");
    for(var i = 0; i < elements.length; i++) {
        elements[i].style.display="none";
    }

    //special for attachment area
    var elements = document.getElementsByClassName("auto_file3");
    for(var i = 0; i < elements.length; i++) {
        elements[i].className = "auto_file3 auto_file2";
        elements[i].style.width
    }
    //document.getElementById("uploadfiletest").className = "auto_file3 auto_file2";



    $("#ORD_NO_P").keydown(function(key)  {
            if (key.keyCode == 13) {
                fn_doConfirm();
            }
     });

});


function fn_goCustSearch() {
    Common.popupDiv('/homecare/sales/ccp/searchOrderNoPop.do', null, null, true, '_searchDiv');
  }

function fn_callbackOrdSearchFunciton(item) {
    console.log(item);
    $("#ORD_NO").val(item.ordNo);
    fn_doConfirm();

}
function fn_doConfirm (){

    Common.ajax("GET", "/sales/ccp/ccpEresubmitNewConfirm", {ORD_NO : $("#ORD_NO_P").val()}, function(result) {
         console.log( result);


         if(result.length == 0)  {

             $("#cbt").attr("style","display:inline");
             $("#ORD_NO_P").attr("style","display:inline");
             $("#sbt").attr("style","display:inline");
             $("#rbt").attr("style","display:none");
             $("#ORD_NO_RESULT").attr("style","display:none");

             $("#resultcontens").attr("style","display:none");

             Common.alert("No order found or this order had resubmitted.");
             return ;

         }else{
             console.log( result[0].salesOrdId);
             /* if(fn_isActiveMembershipQuotationInfoByOrderNo()){
                 return ;
             } */
             //Common.popupDiv("/sales/ccp/ccpCalCCpViewPop.do", {salesOrdId : result[0].salesOrdId}, null , true , '_viewDiv');

             Common.ajax("GET", "/sales/ccp/ccpEresubmitViewPop.do",{salesOrdId : result[0].salesOrdId}, function(result) {
                 console.log("성공.");
                 console.log("fn_getOrderDetailListAjax data :: " + result);

                 //Installation Checklist - Get the stock category id
                 stkCtgry = "${orderDetail.basicInfo.stkCtgryId}";
                 stkId1 = "${orderDetail.basicInfo.stockId}";
                 console.log ("prod_code :::" + stkId1);
                 console.log ("stkCtgry :::" + stkCtgry);

                 setText(result);

                 if('${eSvmInfo.atchFileGrpId}' != 0){
                     fn_loadAtchment('${eSvmInfo.atchFileGrpId}');
                 }

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

function fn_getDataInfo (_ordid){
    Common.ajax("GET", "/sales/membership/selectMembershipFreeDataInfo",    {ORD_ID : _ordid }, function(result) {
        console.log( result);
    });
 }

function fn_outspro (_ordid){
    Common.ajax("GET", "/sales/membership/callOutOutsProcedure", {ORD_ID : _ordid }, function(result) {
        console.log("fn_outspro===>" +result);
        console.log(result);

        if(result.outSuts.length >0 ){
            $("#ordoutstanding").html(result.ordOtstnd);
            $("#asoutstanding").html(result.asOtstnd);
        }
    });
 }

function setText(result){

    var date = new Date(Date.now());
    console.log(date.toLocaleString('en-GB', { hour12:false } ));

    var time1 = result.orderDetail.basicInfo.ordDt;
    var myDate = new Date(time1);
    console.log(result.orderDetail.basicInfo.ordDt);
    console.log("datedate " + myDate);
    console.log("datedate1 " + myDate.toLocaleString('en-GB', { hour12:false }));

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
}

function fn_doReset() {
    $("#newPop").remove();
    fn_eResubmitNew();
}

function fn_doClearPersion(){

    $("#name").html("");
    $("#gender").html("");
    $("#nric").html("");
    $("#codename1").html("");
    $("#telM1").html("");
    $("#telO").html("");
    $("#telR").html("");
    $("#telf").html("");
    $("#email").html("");
    $("#SAVE_CUST_CNTC_ID").val("");
}


 function fn_back(){
     $("#newPop").remove();
}

function fn_save(){

    //if(fn_validRequiredField_Save() ==false ) return ;
    fn_unconfirmSalesPerson();

}

    function fn_validRequiredField_Save() {

        var rtnMsg = "";
        var rtnValue = true;

        if (FormUtil.checkReqValue($("#cTPackage"))) {
            rtnMsg += "* Please select the type of package.<br />";
            rtnValue = false;
        }

        if (!FormUtil.checkReqValue($("#SALES_PERSON"))) {
            if ($("#hiddenSalesPersonID").val() == "") {
                rtnMsg += "* You must confirm the sales person since you have key-in sales person code.<br />";
                rtnValue = false;
            }
        }

        //20190925 Vannie add checking on Cust Area ID
        if (FormUtil.isNotEmpty(resultInstallationObject.areaId)) {

            if ("DM" == resultInstallationObject.areaId.substring(0, 2)) {

                rtnMsg += "<spring:message code="sal.alert.msg.customerAddrChange" /><br>";
                rtnValue = false;

            }
        }

        if (rtnValue == false) {
            Common.alert("Save Quotation Summary" + DEFAULT_DELIMITER + rtnMsg);
        }

        return rtnValue;
    }

    function fn_unconfirmSalesPerson() {
        var ordId = $("#ORD_ID").val();
        var ccpId = $("#CCP_ID").val();
        Common.ajax("POST", "/sales/ccp/ccpEresubmitSave", {ordId : ordId,ccpId : ccpId}, function(result) {
             console.log( result);

             if(result == null){
                 Common.alert("No order found or this order had resubmitted.");
             }else{
                 Common.alert("Order resubmitted");
                 $('#newPop').remove();
                 //window.close();
             }
        });
    }
</script>

<form id="getDataForm" method="post">
<div style="display:inline">
    <input type="text" name="ORD_ID"     id="ORD_ID"/>
    <input type="text" name="CCP_ID"     id="CCP_ID"/>
    <input type="text" name="CUST_ID"    id="CUST_ID"/>

</div>
</form>

<div id="popup_wrap" class="popup_wrap "><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>eResubmit (CCP) - New</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="nc_close"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="height:450px"><!-- pop_body start -->


<section id="content"><!-- content start -->


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


<!------------------------------------------------------------------------------
    Basic Info
------------------------------------------------------------------------------->
<%-- <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp" %> --%>

<!------------------------------------------------------------------------------
    Basic Info
------------------------------------------------------------------------------->
<%-- <%@ include file="/WEB-INF/jsp/sales/order/include/basicInfo.jsp" %> --%>

        <section class="tap_wrap"><!-- tap_wrap start -->
        <ul class="tap_type1">
            <li><a href="#" class="on"  >Basic Info</a></li>
            <!-- <li><a href="#">Contact Person</a></li> -->
            <li><a href="#" onclick="javascript:AUIGrid.resize(bsHistoryGridID, 950,380);">Attachment</a></li>
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
                <div id='uploadfiletest' class='auto_file3'>
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
                <div id='uploadfiletest1' class='auto_file3'>
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
                <div id='uploadfiletest2' class='auto_file3'>
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
                <div id='uploadfiletest3' class='auto_file3'>
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
                <div id='uploadfiletest4' class='auto_file3'>
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
                <div id='uploadfiletest5' class='auto_file3'>
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
                <div id='uploadfiletest6' class='auto_file3'>
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
                <div id='uploadfiletest7' class='auto_file3'>
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
                <div id='uploadfiletest8' class='auto_file3'>
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
            <td colspan=2><span class="red_text">Only allow picture format (JPG, PNG, JPEG)</span></td>
        </tr>
        </tbody>
        </table>

        </article><!-- tap_area end -->

        <!-- <article class="tap_area">tap_area start
        <article class="grid_wrap">grid_wrap start
           <div id="oList_grid_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
        </article>grid_wrap end

        </article>tap_area end -->


        </section><!-- tap_wrap end -->



        <ul class="center_btns">
            <li><p class="btn_blue2"><a href="#"  onclick="javascript:fn_save()">Save</a></p></li>
        </ul>

</div>
</section>

</section><!-- content end -->


</section>

</div>
