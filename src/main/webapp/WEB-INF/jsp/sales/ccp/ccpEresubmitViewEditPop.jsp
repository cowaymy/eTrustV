
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

//Window Option
var option = {
        width: "1000px", // 창 가로 크기
        height: "520px" // 창 세로 크기
         }

$(document).ready(function(){
    console.log('${ccpEresubmitMap.salesOrdId}');
    console.log('${ccpEresubmitMap.ccpId}');
    if('${ccpEresubmitMap.atchFileGrpId}' != 0){
        fn_loadAtchment('${ccpEresubmitMap.atchFileGrpId}');
    }
    $("#remarks").text('${ccpEresubmitMap.remarks}');

    $("#cbt").attr("style","display:none");
    $("#ORD_NO_P").attr("style","display:none");
    $("#sbt").attr("style","display:none");
    $("#rbt").attr("style","display:inline");
    $("#ORD_NO_RESULT").attr("style","display:inline");
    $("#resultcontens").attr("style","display:inline");

    console.log('auth change ' + '${funcChange}');
    if('${ccpEresubmitMap.stusId}' != 6 || '${isModify}' == 'N' || '${funcChange}' != 'Y'){
        var elements = document.getElementsByClassName("attach_mod");
        for(var i = 0; i < elements.length; i++) {
            elements[i].style.display="none";
        }

        $("#saveBtn").attr("style","display:none");
        $("#remarks").attr({"disabled" : "disabled"});
    }
});

function fn_doReset() {
    $("#newPop").remove();
    fn_eResubmitNew();
}

function fn_close(){
    $("#newPop").remove();
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

    var formData = new FormData();
    formData.append("atchFileGrpId", '${ccpEresubmitMap.atchFileGrpId}');
    formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
    formData.append("salesOrdId",'${ccpEresubmitMap.salesOrdId}');
    formData.append("ccpId",'${ccpEresubmitMap.ccpId}');

    $.each(myFileCaches, function(n, v) {
        console.log(v.file);
        formData.append(n, v.file);
    });

    Common.ajaxFile("/sales/ccp/attachResubmitFileUpdate.do", formData, function(result) {
        if(result.code == 99){
            Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);
        }else{

        	var ordId = '${ccpEresubmitMap.salesOrdId}';
            var ccpId = '${ccpEresubmitMap.ccpId}';
            var remarks = $("#remarks").val();

        	Common.ajax("POST", "/sales/ccp/ccpEresubmitUpdate", {saveOrdId : ordId,saveCcpId : ccpId, eRstatusEdit : 1, remarks : remarks}, function(result) {
                console.log( result);

                if(result == null){
                	Common.alert('Failed to update eResubmit.');
                }else{
                	Common.alert('eResubmit updated.');
                    $('#detailPop').remove();
                }
           });

           // DO SAVE BUTTON ACTION
           /* Common.popupDiv("/sales/membership/updateAction.do", data, function(result){
               if(result.code == 00)
                   Common.alert('Membership successfully saved.' + "<b>" + result.psmSrvMemNo);
               else{
                   Common.alert('Membership failed to save.');
               }
           }); */
        }
    },function(result){
        Common.alert(result.message+"<br/>Upload Failed. Please check with System Administrator.");
    });

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

    function fn_loadAtchment(atchFileGrpId) {
        Common.ajax("Get", "/sales/order/selectAttachList.do", {atchFileGrpId :atchFileGrpId} , function(result) {
            //console.log(result);
           if(result) {
                if(result.length > 0) {
                    $("#attachTd").html("");
                    for ( var i = 0 ; i < result.length ; i++ ) {
                        switch (result[i].fileKeySeq){
                        case '1':
                            sofFrFileId = result[i].atchFileId;
                            sofFrFileName = result[i].atchFileName;
                            $(".input_text[id='sofFrFileTxt']").val(sofFrFileName);
                            break;
                        case '2':
                            softcFrFileId = result[i].atchFileId;
                            softcFrFileName = result[i].atchFileName;
                            $(".input_text[id='softcFrFileTxt']").val(softcFrFileName);
                            break;
                        case '3':
                            nricFrFileId = result[i].atchFileId;
                            nricFrFileName = result[i].atchFileName;
                            $(".input_text[id='nricFrFileTxt']").val(nricFrFileName);
                            break;
                        case '4':
                            msofFrFileId = result[i].atchFileId;
                            msofFrFileName = result[i].atchFileName;
                            $(".input_text[id='msofFrFileTxt']").val(msofFrFileName);
                            break;
                        case '5':
                            msoftcFrFileId = result[i].atchFileId;
                            msoftcFrFileName = result[i].atchFileName;
                            $(".input_text[id='msoftcFrFileTxt']").val(msoftcFrFileName);
                            break;
                        case '6':
                            payFrFileId = result[i].atchFileId;
                            payFrFileName = result[i].atchFileName;
                            $(".input_text[id='payFrFileTxt']").val(payFrFileName);
                            break;
                        case '7':
                            govFrFileId = result[i].atchFileId;
                            govFrFileName = result[i].atchFileName;
                            $(".input_text[id='govFrFileTxt']").val(govFrFileName);
                            break;
                        case '8':
                            letFrFileId = result[i].atchFileId;
                            letFrFileName = result[i].atchFileName;
                            $(".input_text[id='letFrFileTxt']").val(letFrFileName);
                            break;
                        case '9':
                            docFrFileId = result[i].atchFileId;
                            docFrFileName = result[i].atchFileName;
                            $(".input_text[id='docFrFileTxt']").val(docFrFileName);
                            break;
                         default:
                             Common.alert("no files");
                        }
                    }

                    // 파일 다운
                    $(".input_text").dblclick(function() {
                        var oriFileName = $(this).val();
                        var fileGrpId;
                        var fileId;
                        for(var i = 0; i < result.length; i++) {
                            if(result[i].atchFileName == oriFileName) {
                                fileGrpId = result[i].atchFileGrpId;
                                fileId = result[i].atchFileId;
                            }
                        }
                        if(fileId != null) fn_atchViewDown(fileGrpId, fileId);
                    });
                }
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

<div id="popup_wrap" class="popup_wrap "><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Ezy CCP - View & Edit</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="nc_close"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="height:450px"><!-- pop_body start -->


<section id="content"><!-- content start -->

<section>
<div  id="resultcontens"  style="display:none">


<!------------------------------------------------------------------------------
    Basic Info
------------------------------------------------------------------------------->
<%-- <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp" %> --%>



        <section class="tap_wrap"><!-- tap_wrap start -->
        <ul class="tap_type1">
            <li><a href="#" class="on"  >Basic Info</a></li>
            <!-- <li><a href="#">Contact Person</a></li> -->
            <li><a href="#" onclick="javascript:AUIGrid.resize(bsHistoryGridID, 950,380);">Attachment</a></li>
        </ul>

        <article class="tap_area"><!-- tap_area start -->

<!------------------------------------------------------------------------------
    Basic Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/basicInfo.jsp" %>

        <%-- <table class="type1"><!-- table start -->
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
            <td><span id='updDt' ></span><br>(<span id='updUserId' ></span>)${fn:substring(orderDetail.basicInfo.updDt, 0, 19)}<br>( ${orderDetail.basicInfo.updUserId})</td>
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
        </table><!-- table end --> --%>

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
                <div name='uploadfiletest' class='auto_file2'>
                    <input type='file' title='file add'  id='sofFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='sofFrFileTxt'/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("SOF")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Sales Order Form's T&C (SOF T&C)</th>
            <td>
                <div name='uploadfiletest' class='auto_file2'>
                    <input type='file' title='file add'  id='softcFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='softcFrFileTxt'/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("SOFTC")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">NRIC / VISA /Bank Card</th>
            <td>
                <div name='uploadfiletest' class='auto_file2'>
                    <input type='file' title='file add'  id='nricFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='nricFrFileTxt'>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("NRIC")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Mattress Sales ORder Form (MSOF)</th>
            <td>
                <div name='uploadfiletest' class='auto_file2'>
                    <input type='file' title='file add'  id='msofFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='msofFrFileTxt'/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("MSOF")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Mattress Sales Order Form's T&C (MSOF T&C)</th>
            <td>
                <div name='uploadfiletest' class='auto_file2'>
                    <input type='file' title='file add'  id='msoftcFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='msoftcFrFileTxt'/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("MSOFTC")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Payment document / Payment Channel</th>
            <td>
                <div name='uploadfiletest' class='auto_file2'>
                    <input type='file' title='file add'  id='payFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='payFrFileTxt'/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("PAY")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Government (Agreement / SST / LO)</th>
            <td>
                <div name='uploadfiletest' class='auto_file2'>
                    <input type='file' title='file add'  id='govFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='govFrFileTxt'/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("GOV")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Declaration letter</th>
            <td>
                <div name='uploadfiletest' class='auto_file2'>
                    <input type='file' title='file add'  id='letFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='letFrFileTxt'/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("LET")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <th scope="row">Supporting document (Utility bill / SSM / Others)</th>
            <td>
                <div name='uploadfiletest' class='auto_file2'>
                    <input type='file' title='file add'  id='docFrFile' accept='image/*''/>
                    <label style="width: 400px;">
                        <input type='text' class='input_text' readonly='readonly' id='docFrFileTxt'/>
                        <span class='label_text attach_mod'><a href='#'>Upload</a></span>
                        <span class='label_text attach_mod'><a href='#' onclick='fn_removeFile("DOC")'>Remove</a></span>
                    </label>
                </div>
            </td>
        </tr>
        <tr>
        <th scope="row">Remarks :</th>
            <td>
             <!-- <input type="text" title="Remarks" placeholder="" id="remarks" name="remarks"  maxlength="200"/> -->
             <textarea cols="20" name="" id="remarks" rows="5" placeholder="" style="width: 250px;height: 80px;" maxlength="200"></textarea>
            </td>
        </tr>
        <tr>
            <td colspan=2><span class="red_text">Only allow picture format (JPG, PNG, JPEG)</span></td>
        </tr>
        </tbody>
        </table>

        </article><!-- tap_area end -->

        </section><!-- tap_wrap end -->

        <ul class="center_btns">
            <li><p class="btn_blue2" id="saveBtn"><a href="#"  onclick="javascript:fn_save()">Save</a></p></li>
        </ul>

</div>
</section>

</section><!-- content end -->


</section>

</div>
