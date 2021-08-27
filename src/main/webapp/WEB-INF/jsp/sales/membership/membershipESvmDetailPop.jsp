<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var listGiftGridID;
    var update = new Array();
    var remove = new Array();
    var svmFrFileId = 0;
    var svmTncFileId = 0;
    var poFileId = 0;
    var nricFrFileId = 0;
    var nricBcFileId = 0;
    var slipFileId2 = 0;
    var chqFileId = 0;
    var otherFileId = 0;
    var otherFileId2 = 0;
    var otherFileId3 = 0;

    var svmFrFileName = "";
    var svmTncFileName = "";
    var poFileName = "";
    var nricFrFileName = "";
    var nricBcFileName = "";
    var slipFileName2 = "";
    var chqFileName = "";
    var otherFileName = "";
    var otherFileName2 = "";
    var otherFileName3 = "";

    $(document).ready(function(){

        /* doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID',   '${preOrderInfo.appTypeId}', 'appType',     'S', ''); //Common Code
        doGetComboOrder('/common/selectCodeList.do', '19', 'CODE_NAME', '${preOrderInfo.rentPayModeId}', 'rentPayMode', 'S', ''); //Common Code
        doGetComboSepa ('/common/selectBranchCodeList.do', '5',  ' - ', '', 'dscBrnchId',  'S', ''); //Branch Code
        doGetComboSepa ('/common/selectBranchCodeList.do', '1',  ' - ', '', 'keyinBrnchId',  'S', ''); //Branch Code

        doGetComboData('/common/selectCodeList.do', {groupCode :'325'}, '${preOrderInfo.exTrade}', 'exTrade', 'S'); //EX-TRADE
        doGetComboOrder('/common/selectCodeList.do', '415', 'CODE_ID',   '', 'corpCustType',     'S', ''); //Common Code
        doGetComboOrder('/common/selectCodeList.do', '416', 'CODE_ID',   '', 'agreementType',     'S', ''); //Common Code

        //Attach File
        //$(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>Upload</a></span></label>");
        fn_loadPreOrderInfo('${preOrderInfo.custId}', null);

        if('${preOrderInfo.stusId}' == 4 || '${preOrderInfo.stusId}' == 10 ){
            $('#scPreOrdArea').find("input,textarea,button,select").attr("disabled",true);
            $("#scPreOrdArea").find("p.btn_grid").hide();
            $('#btnSave').hide();
            $(".input_text").attr('disabled',false).addClass("readonly");;
        } */

    	if('${eSvmInfo.atchFileGrpId}' != 0){
            fn_loadAtchment('${eSvmInfo.atchFileGrpId}');
        }

    });

    $(function(){
        $('#btnSave').click(function() {

            if(!fn_validFile()) {
                $('#aTabFL').click();
                return false;
            }

            var formData = new FormData();
            formData.append("atchFileGrpId", '${eSvmInfo.atchFileGrpId}');
            formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
            formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
            console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
            console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
            $.each(myFileCaches, function(n, v) {
                console.log(v.file);
                formData.append(n, v.file);
            });

            fn_doSaveESvmOrder();

        });
        $('#svmFrFile').change( function(evt) {
            var file = evt.target.files[0];
             if(file.name != svmFrFileName){
                 myFileCaches[1] = {file:file};
                 if(svmFrFileName != ""){
                     update.push(svmFrFileId);
                 }
             }
        });
        $('#svmTncFile').change( function(evt) {
            var file = evt.target.files[0];
            if(file.name != svmTncFileName){
                myFileCaches[2] = {file:file};
                if(svmTncFileName != ""){
                    update.push(svmTncFileId);
                }
            }
        });
        $('#poFile').change(function(evt) {
            var file = evt.target.files[0];
            if(file == null){
                remove.push(poFileId);
            }else if(file.name != poFileName){
                myFileCaches[3] = {file:file};
                if(poFileName != ""){
                    update.push(poFileId);
                }
            }
        });

        $('#nricFrFile').change(function(evt) {
            var file = evt.target.files[0];

            if(file == null){
                remove.push(nricFrFileId);
            }else if(file.name != nricFrFileName){
                myFileCaches[4] = {file:file};
                if(nricFrFileName != ""){
                    update.push(nricFrFileId);
               }
            }
        });

        $('#nricBcFile').change(function(evt) {
            var file = evt.target.files[0];
            if(file == null){
                remove.push(nricBcFileId);
            }else if(file.name != nricBcFileName){
                myFileCaches[5] = {file:file};
                if(nricBcFileName != ""){
                    update.push(nricBcFileId);
                }
            }
        });

        $('#slipFile').change(function(evt) {
            var file = evt.target.files[0];
            if(file == null){
                remove.push(slipFileId);
            }else if(file.name != slipFileName){
                myFileCaches[6] = {file:file};
                if(slipFileName != ""){
                    update.push(slipFileId);
                }
            }
        });

        $('#chqFile').change(function(evt) {
            var file = evt.target.files[0];
            if(file == null){
                remove.push(chqFileId);
            }else if(file.name != chqFileName){
                myFileCaches[7] = {file:file};
                if(chqFileName != ""){
                    update.push(chqFileId);
                }
            }
        });

        $('#otherFile').change( function(evt) {
            var file = evt.target.files[0];
            if(file == null){
                remove.push(otherFileId);
            }else if(file.name != otherFileName){
                 myFileCaches[8] = {file:file};
                 if(otherFileName != ""){
                     update.push(otherFileId);
                 }
             }
        });

        $('#otherFile2').change( function(evt) {
            var file = evt.target.files[0];
            if(file == null){
                remove.push(otherFileId2);
            }else if(file.name != otherFileName2){
                 myFileCaches[8] = {file:file};
                 if(otherFileName2 != ""){
                     update.push(otherFileId2);
                 }
             }
        });

        $('#otherFile3').change( function(evt) {
            var file = evt.target.files[0];
            if(file == null){
                remove.push(otherFileId3);
            }else if(file.name != otherFileName3){
                 myFileCaches[8] = {file:file};
                 if(otherFileName3 != ""){
                     update.push(otherFileId3);
                 }
             }
        });

    });


    function fn_doSaveESvmOrder() {

        //Save attachment first
        var vAppType    = $('#appType').val();
        var vCustCRCID  = $('#rentPayMode').val() == '131' ? $('#hiddenRentPayCRCId').val() : 0;
        var vCustAccID  = $('#rentPayMode').val() == '132' ? $('#hiddenRentPayBankAccID').val() : 0;
        var vBankID     = $('#rentPayMode').val() == '131' ? $('#hiddenRentPayCRCBankId').val() : $('#rentPayMode').val() == '132' ? $('#hiddenAccBankId').val() : 0;
        var vIs3rdParty = $('#thrdParty').is(":checked") ? 1 : 0;
        var vCustomerId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
        var vCustBillId = vAppType == '66' ? $('input:radio[name="grpOpt"]:checked').val() == 'exist' ? $('#hiddenBillGrpId').val() : 0 : 0;
        var vStusId = ('${preOrderInfo.stusId}' != 1) ? 104 : 1;

        var orderVO = {
                /* preOrdId             : $('#frmPreOrdReg #hiddenPreOrdId').val().trim(),
                sofNo                : $('#sofNo').val().trim(),
                custPoNo             : $('#poNo').val().trim(),
                appTypeId            : vAppType,
                srvPacId             : $('#srvPacId').val(),
                custId               : $('#hiddenCustId').val(),
                empChk               : 0,
                gstChk               : $('#gstChk').val(),
                custCntcId           : $('#hiddenCustCntcId').val(),
                keyinBrnchId         : $('#keyinBrnchId').val(),
                instAddId            : $('#hiddenCustAddId').val(),
                dscBrnchId           : $('#dscBrnchId').val(),
                preDt                : $('#prefInstDt').val().trim(),
                preTm                : $('#prefInstTm').val().trim(),
                instct               : $('#speclInstct').val().trim(),
                exTrade              : $('#exTrade').val(),
                itmStkId             : $('#ordProudct').val(),
                itmCompId          : $('#compType').val(),
                promoId              : $('#ordPromo').val(),
                mthRentAmt           : $('#ordRentalFees').val().trim(),
                totAmt               : $('#ordPrice').val().trim(),
                norAmt               : $('#normalOrdPrice').val().trim(),
                discRntFee           : $('#ordRentalFees').val().trim(),
                totPv                : $('#ordPv').val().trim(),
                totPvGst             : $('#ordPvGST').val().trim(),
                prcId                : $('#ordPriceId').val(),
                memCode              : $('#salesmanCd').val(),
                advBill              : $('input:radio[name="advPay"]:checked').val(),
                custCrcId            : vCustCRCID,
                bankId               : vBankID,
                custAccId            : vCustAccID,
                is3rdParty           : vIs3rdParty,
                rentPayCustId        : vCustomerId,
                rentPayModeId        : $('#rentPayMode').val(),
                custBillId           : vCustBillId,
                custBillCustId       : $('#hiddenCustId').val(),
                custBillCntId        : $("#hiddenCustCntcId").val(),
                custBillAddId        : $("#hiddenBillAddId").val(),
                custBillEmail        : $('#billMthdEmailTxt1').val().trim(),
                custBillIsSms        : $('#billMthdSms1').is(":checked") ? 1 : 0,
                custBillIsPost       : $('#billMthdPost').is(":checked") ? 1 : 0,
                custBillEmailAdd     : $('#billMthdEmailTxt2').val().trim(),
                custBillIsWebPortal  : $('#billGrpWeb').is(":checked")   ? 1 : 0,
                custBillWebPortalUrl : $('#billGrpWebUrl').val().trim(),
                custBillIsSms2       : $('#billMthdSms2').is(":checked") ? 1 : 0,
                custBillCustCareCntId: $("#hiddenBPCareId").val(),
                stusId                     : vStusId,
                corpCustType         : $('#corpCustType').val(),
                agreementType         : $('#agreementType').val(),
                salesOrdIdOld          : $('#txtOldOrderID').val(),
                relatedNo               : $('#relatedNo').val()
                */
        		atchFileGrpId        : '${eSvmInfo.atchFileGrpId}'
            };

        var formData = new FormData();
        formData.append("atchFileGrpId", '${eSvmInfo.atchFileGrpId}');
        formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
        formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
        console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
        console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
        $.each(myFileCaches, function(n, v) {
            console.log(v.file);
            formData.append(n, v.file);
        });

        Common.ajaxFile("/sales/membership/attachESvmFileUpdate.do", formData, function(result) {
            if(result.code == 99){
                Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);
                //myFileCaches = {};
            }else{

                /* Common.ajax("POST", "/sales/membership/modifyPreOrder.do", orderVO, function(result) {
                    Common.alert("Order Saved" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_closePreOrdModPop);
                },
                function(jqXHR, textStatus, errorThrown) {
                    try {
                        Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save order.</b>");
                    }
                    catch (e) {
                        console.log(e);
                    }
                }); */
                //myFileCaches = {};
            }
        },function(result){
            Common.alert(result.message+"<br/>Upload Failed. Please check with System Administrator.");
        });
    }

    function fn_closePreOrdModPop() {
        fn_getPreOrderList();
        myFileCaches = {};
        delete update;
        delete remove;
        $('#_divESvmSavePop').remove();
    }

    function fn_closePreOrdModPop2(){
        myFileCaches = {};
        delete update;
        delete remove;
        $('#_divESvmSavePop').remove();
    }

    function fn_setOptGrpClass() {
        $("optgroup").attr("class" , "optgroup_text")
    }

    function chgTab(tabNm) {
        console.log('tabNm:'+tabNm);

        switch(tabNm) {
            case 'ord' :
                AUIGrid.resize(listGiftGridID, 980, 180);

                if(MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7" ){
                    $('#memBtn').addClass("blind");
                    $('#salesmanCd').prop("readonly",true).addClass("readonly");;
                    //$('#salesmanCd').val("${SESSION_INFO.userName}");
                    //$('#salesmanCd').change();
                }

                //$('#appType').val("66");
                $('#appType').prop("disabled", true);

                if($('#ordProudct').val() == null){
                       $('#appType').change();
                }

                $('[name="advPay"]').prop("disabled", true);
                $('#advPayNo').prop("checked", true);
                $('#poNo').prop("disabled", true);

                break;
            case 'pay' :
                if($('#appType').val() == '66'){
                    //$('#rentPayMode').val('131') //to show the correct info for rentPayMode
                    $('#rentPayMode').change();
                    $('#rentPayMode').prop("disabled", true);
                    $('#thrdParty').prop("disabled", true);
                }
            default :
                break;
        }
    }

    function fn_atchViewDown(fileGrpId, fileId) {
        var data = {
                atchFileGrpId : fileGrpId,
                atchFileId : fileId
        };
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

    function fn_loadAtchment(atchFileGrpId) {
        Common.ajax("Get", "/sales/order/selectAttachList.do", {atchFileGrpId :atchFileGrpId} , function(result) {
            console.log(result);
           if(result) {
                if(result.length > 0) {
                    $("#attachTd").html("");
                    for ( var i = 0 ; i < result.length ; i++ ) {
                        switch (result[i].fileKeySeq){
                        case '1':
                        	svmFrId = result[i].atchFileId;
                        	svmFrName = result[i].atchFileName;
                            $(".input_text[id='svmFrFileTxt']").val(svmFrName);
                            break;
                        case '2':
                        	svmTncFileId = result[i].atchFileId;
                        	svmTncFileName = result[i].atchFileName;
                            $(".input_text[id='svmTncFileTxt']").val(svmTncFileName);
                            break;
                        case '3':
                            poFileId = result[i].atchFileId;
                            poFileName = result[i].atchFileName;
                            $(".input_text[id='poFileTxt']").val(poFileName);
                            break;
                        case '4':
                        	nricFrFileId = result[i].atchFileId;
                        	nricFrFileName = result[i].atchFileName;
                            $(".input_text[id='nricFrFileTxt']").val(nricFrFileName);
                            break;
                        case '5':
                        	nricBcFileId = result[i].atchFileId;
                        	nricBcFileName = result[i].atchFileName;
                            $(".input_text[id='nricBcFileTxt']").val(nricBcFileName);
                            break;
                        case '6':
                        	slipFileId = result[i].atchFileId;
                            slipFileName = result[i].atchFileName;
                            $(".input_text[id='slipFileTxt']").val(slipFileName);
                            break;
                        case '7':
                        	chqFileId = result[i].atchFileId;
                        	chqFileName = result[i].atchFileName;
                            $(".input_text[id='chqFileTxt']").val(chqFileName);
                            break;
                        case '8':
                        	otherFileId = result[i].atchFileId;
                        	otherFileName = result[i].atchFileName;
                            $(".input_text[id='otherFileTxt']").val(otherFileName);
                            break;
                        case '9':
                            otherFileId2 = result[i].atchFileId;
                            otherFileName2 = result[i].atchFileName;
                            $(".input_text[id='otherFileTxt2']").val(otherFileName2);
                            break;
                        case '10':
                            otherFileId3 = result[i].atchFileId;
                            otherFileName3 = result[i].atchFileName;
                            $(".input_text[id='otherFileTxt3']").val(otherFileName3);
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

    function fn_removeFile(name){
        if(name == "FRO") {
        	console.log("FRO in");
             $("#svmFrFile").val("");
             $(".input_text[id='svmFrFileTxt']").val("");
             $('#svmFrFile').change();
        }else if(name == "TNC"){
            $("#svmTncFile").val("");
            $(".input_text[id='svmTncFileTxt']").val("");
            $('#svmTncFile').change();
        }else if(name == "POF"){
            $("#poFile").val("");
            $(".input_text[id='poFileTxt']").val("");
            $('#poFile').change();
        }else if(name == "ICF"){
            $("#nricFrFile").val("");
            $(".input_text[id='nricFrFileTxt']").val("");
            $('#nricFrFile').change();
        }else if(name == "ICB"){
            $("#nricBcFile").val("");
            $(".input_text[id='nricBcFileTxt']").val("");
            $('#nricBcFile').change();
        }else if(name == "SLP") {
            $("#slipFile").val("");
            $(".input_text[id='slipFileTxt']").val("");
            $('#slipFile').change();
        }else if(name == "CHQ") {
            $("#chqFile").val("");
            $(".input_text[id='chqFileTxt']").val("");
            $('#chqFile').change();
        }else if(name == "OTH") {
            $("#otherFile").val("");
            $(".input_text[id='otherFileTxt']").val("");
            $('#otherFile').change();
        }else if(name == "OTH2") {
            $("#otherFile2").val("");
            $(".input_text[id='otherFileTxt2']").val("");
            $('#otherFile2').change();
        }else if(name == "OTH3") {
            $("#otherFile3").val("");
            $(".input_text[id='otherFileTxt3']").val("");
            $('#otherFile3').change();
        }
    }

    function fn_validFile() {
        var isValid = true, msg = "";

        /* if(sofFileId == null) {
            isValid = false;
            msg += "* Please upload copy of SOF<br>";
        }
        if(nricFileId == null) {
            isValid = false;
            msg += "* Please upload copy of NRIC<br>";
        }

        if(!isValid) Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>"); */

        return isValid;
    }

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>eKey-in</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnPreOrdClose" onClick="javascript:fn_closePreOrdModPop2();" href="#">CLOSE | TUTUP</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
    <li><p class="btn_blue blind"><a id="btnConfirm" href="#">Confirm</a></p></li>
    <li><p class="btn_blue blind"><a href="#">Clear</a></p></li>
</ul>
</aside><!-- title_line end -->
<form id="frmCustSearch" name="frmCustSearch" action="#" method="post">
    <input id="selType" name="selType" type="hidden" value="1" />
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No</th>
    <td><input id="salesOrdNo" name="salesOrdNo" type="text" value="${eSvmInfo.salesOrdNo}" title="" placeholder="" class="w100p readonly" readonly /></td>
    <th scope="row">Order Date</th>
    <td><input id="ordCrtDt" name=""ordCrtDt"" type="text" value="${eSvmInfo.ordCrtDt}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">SMQ No</th>
    <td><input id="smqNo" name="smqNo" type="text" value="${eSvmInfo.smqNo}" title="" placeholder="" class="w100p readonly" readonly /></td>
    <th scope="row">Quotation Date</th>
    <td><input id="quoCrtDt" name="quoCrtDt" type="text" value="${eSvmInfo.quoCrtDt}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Pre Sales No</th>
    <td><input id="psmNo" name="psmNo" type="text" value="${eSvmInfo.psmNo}" title="" placeholder="" class="w100p readonly" readonly /></td>
    <th scope="row">Pre Sales Date</th>
    <td><input id="crtDt" name="crtDt" type="text" value="${eSvmInfo.crtDt}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<!------------------------------------------------------------------------------
    Pre-Order Regist Content START
------------------------------------------------------------------------------->
<section id="scPreOrdArea" class="">

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a href="aTabSL" class="on">Pre Sales Info</a></li>
    <li><a href="aTabPY" onClick="javascript:chgTab('ord');">Payment</a></li>
    <li><a href="aTabFL" >Attachment</a></li>
    <li><a href="aTabST" onClick="javascript:chgTab('pay');">Update Status</a></li>
</ul>

<!------------------------------------------------------------------------------
                Pre Sales Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/basicInfoIncludeViewLedger.jsp" %>
<!------------------------------------------------------------------------------
                Payment Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/basicInfoIncludeViewLedger.jsp" %>
<!------------------------------------------------------------------------------
                Attachment Area
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/membership/eSvmAttachment.jsp" %>
<!------------------------------------------------------------------------------
                Update Status Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/basicInfoIncludeViewLedger.jsp" %>



</section><!-- tap_wrap end -->

<ul class="center_btns mt20">
    <li><p class="btn_blue2 big"><a id="btnSave" href="#">Save</a></p></li>
</ul>

</section>
<!------------------------------------------------------------------------------
    Pre-Order Regist Content END
------------------------------------------------------------------------------->
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
