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

    var MEM_TYPE = '${SESSION_INFO.userTypeId}';
    var BranchId = '${SESSION_INFO.userBranchId}';
    var SAFlg =  0; //0:No need to check
    var SpecInstr =  0; //0:No need to check
    var POFlg = 0; //0: No need to check

    $(document).ready(function(){
console.log("esvmDetailPop");
        if(MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7") {
            var elements = document.getElementsByClassName("attach_mod");
            for(var i = 0; i < elements.length; i++) {
                elements[i].style.display="none";
            }
            $("#btnSave").hide();
        }

        if('${eSvmInfo.atchFileGrpId}' != 0){
            fn_loadAtchment('${eSvmInfo.atchFileGrpId}');
        }

        var payMode = '${paymentInfo.payMode}';
        if(payMode == '6506') {
            $("#aTabPayment").hide();
            POFlg = 1;
        } else {
            $("#aTabBilling").hide();
        }

        //fn_displaySpecialInst();
        var stus = '${eSvmInfo.stus}';
        var flg = '${paymentInfo.allowComm}';
        var specialInst = '${eSvmInfo.appvInstrct}';
        var cardModeCode = '${paymentInfo.cardModeCode}';
        var issuBankCode = '${paymentInfo.issuBankCode}';
        var cardBrandCode = '${paymentInfo.cardBrandCode}';
        var merchantBankCode = '${paymentInfo.merchantBankCode}';

        if(payMode == '6528') {
            if(stus == '5') {
                $("#payment_cardNo").replaceWith('<input id=payment_cardNo name="payment_cardNo" type="text" title=""  value="${paymentInfo.cardNo}" placeholder="" class="w100p readonly" readyonly creditCardText" maxlength=19 />');
                $("#payment_approvalNo").replaceWith('<input id=payment_approvalNo name="payment_approvalNo" type="text" title="" value="${paymentInfo.approvalNo}" placeholder="" class="w100p readonly" readyonly "  />');
                $("#payment_expDt").replaceWith('<input id=payment_expDt name="payment_expDt" type="text" title="" value="${paymentInfo.expiryDate}" placeholder="" class="w100p readonly" readyonly maxlength=4  />');
                //$("#payment_transactionDt").replaceWith('<input id=payment_transactionDt name="payment_transactionDt" type="text" title="" value="${paymentInfo.transactionDate}" placeholder="" class="w100p readonly" readyonly  />');
                $("#payment_ccHolderName").replaceWith('<input id=payment_ccHolderName name="payment_ccHolderName" type="text" title="" value="${paymentInfo.crcName}" placeholder="" class="w100p readonly" readyonly  />');
                $("#SARefNo").replaceWith('<input id=SARefNo name="SARefNo" value="${eSvmInfo.saRef}" type="text" title="" placeholder="" class="w100p readonly" readonly />');
                $("#PONo").replaceWith('<input id=PONo name="PONo" value="${eSvmInfo.poNo}" type="text" title="" placeholder="" class="w100p readonly" readonly />');

                $("#action option[value='"+ stus +"']").attr("selected", true);
                $("#payment_cardMode option[value='"+ cardModeCode +"']").attr("selected", true);
                $("#payment_issuedBank option[value='"+ issuBankCode +"']").attr("selected", true);
                $("#payment_cardType option[value='"+ cardBrandCode +"']").attr("selected", true);
                $("#payment_merchantBank option[value='"+ merchantBankCode +"']").attr("selected", true);
                $("#action").attr("disabled", true);
                $("#payment_cardMode").attr("disabled", true);
                $("#payment_issuedBank").attr("disabled", true);
                $("#payment_cardType").attr("disabled", true);
                $("#payment_merchantBank").attr("disabled", true);
                $("#specInst").hide();
                $("#btnSave").hide();

                var trxDt = $("#payment_transactionDt").val();
                if(trxDt.length != 10) {
                    trxDt = trxDt.substr(0,2) + '/' + trxDt.substr(2,2) + '/' + trxDt.substr(4,4);
                    $("#payment_transactionDt").val(trxDt);
                }
                $("#payment_transactionDt").attr("disabled", true);

            } else if(stus == '1') {
                $("#payment_cardMode option[value='"+ cardModeCode +"']").attr("selected", true);
                $("#payment_issuedBank option[value='"+ issuBankCode +"']").attr("selected", true);
                $("#payment_cardType option[value='"+ cardBrandCode +"']").attr("selected", true);
                $("#payment_merchantBank option[value='"+ merchantBankCode +"']").attr("selected", true);
                $('#action').val(stus);
                $("#action option[value='"+ stus +"']").attr("selected", true);

                var trxDt = $("#payment_transactionDt").val();
                if(trxDt.length != 10) {
                    trxDt = trxDt.substr(0,2) + '/' + trxDt.substr(2,2) + '/' + trxDt.substr(4,4);
                    $("#payment_transactionDt").val(trxDt);
                }
            } else if(stus == '6') {
                $("#SARefNo").replaceWith('<input id=SARefNo name="SARefNo" value="${eSvmInfo.saRef}" type="text" title="" placeholder="" class="w100p readonly" readonly />');
                $("#PONo").replaceWith('<input id=PONo name="PONo" value="${eSvmInfo.poNo}" type="text" title="" placeholder="" class="w100p readonly" readonly />');
                $("#action option[value='"+ stus +"']").attr("selected", true);
                $("#action").attr("disabled", true);
                $("#specialInstruction option[value='"+ specialInst +"']").attr("selected", true);
                $("#specialInstruction").attr("disabled", true);

                $("#btnSave").hide();

                var trxDt = $("#payment_transactionDt").val();
                if(trxDt != null && trxDt != "" && trxDt.length != 10) {
                    trxDt = trxDt.substr(0,2) + '/' + trxDt.substr(2,2) + '/' + trxDt.substr(4,4);
                    $("#payment_transactionDt").val(trxDt);
                }
            }
        } else {
            if(stus == '5') {
                $("#payment_transactionID").replaceWith('<input id=payment_transactionID name="payment_transactionID" value="${paymentInfo.trxId}" type="text" title="" placeholder="" class="w100p readonly" readyonly />');
                $("#payment_trRefNo").replaceWith('<input id=payment_trRefNo name="payment_trRefNo" value="${paymentInfo.trRefNo}" type="text" title="" placeholder="" class="w100p readonly" readyonly />');
                $("#payment_trIssuedDt").replaceWith('<input id=payment_trIssuedDt name="payment_trIssuedDt" value="${paymentInfo.trIssuedDt}" type="text" title="" placeholder="" class="w100p readonly" readyonly />');
                if('${paymentInfo.allowComm}' == '1') {
                    $("#payment_allowCommFlg").replaceWith('<input id=payment_allowCommFlg name="payment_allowCommFlg" type="checkBox" checked />');
                    $("input:checkbox").click(function() { return false; });
                }
                $('#attchFrm .label_text').hide();
                $("#SARefNo").replaceWith('<input id=SARefNo name="SARefNo" value="${eSvmInfo.saRef}" type="text" title="" placeholder="" class="w100p readonly" readonly />');
                $("#PONo").replaceWith('<input id=PONo name="PONo" value="${eSvmInfo.poNo}" type="text" title="" placeholder="" class="w100p readonly" readonly />');
                $("#action option[value='"+ stus +"']").attr("selected", true);
                $("#action").attr("disabled", true);
                //$("#specialInstruction").replaceWith('<input id=specialInstruction name="specialInstruction" value="${eSvmInfo.appvInstrct}" type="text" title="" placeholder="" class="w100p readonly" readonly />');
                $("#specInst").hide();

                $("#btnSave").hide();

                $("#payment_cardMode option[value='"+ cardModeCode +"']").attr("selected", true);
                $("#payment_issuedBank option[value='"+ issuBankCode +"']").attr("selected", true);
                $("#payment_cardType option[value='"+ cardBrandCode +"']").attr("selected", true);
                $("#payment_merchantBank option[value='"+ merchantBankCode +"']").attr("selected", true);
                $("#payment_cardMode").attr("disabled", true);
                $("#payment_issuedBank").attr("disabled", true);
                $("#payment_cardType").attr("disabled", true);
                $("#payment_merchantBank").attr("disabled", true);

                var trxDt = $("#payment_transactionDt").val();
                if(trxDt != null && trxDt != "" && trxDt.length != 10) {
                    trxDt = trxDt.substr(0,2) + '/' + trxDt.substr(2,2) + '/' + trxDt.substr(4,4);
                    $("#payment_transactionDt").val(trxDt);
                }

            } else if(stus == '1') {
                if(specialInst != '') {
                    $("#payment_transactionID").replaceWith('<input id=payment_transactionID name="payment_transactionID" value="${paymentInfo.trxId}" type="text" title="" placeholder="" class="w100p"  />');
                    $("#payment_trRefNo").replaceWith('<input id=payment_trRefNo name="payment_trRefNo" value="${paymentInfo.trRefNo}" type="text" title="" placeholder="" class="w100p"  />');
                    //$("#payment_trIssuedDt").replaceWith('<input id=payment_trIssuedDt name="payment_trIssuedDt" value="${paymentInfo.trIssuedDt}" type="text" title="" placeholder="" class="w100p"  />');
                    $("#payment_trIssuedDt").replaceWith('<input id=payment_trIssuedDt name="payment_trIssuedDt" type="text" title="" placeholder="" class="j_date" />');
                    $('#action').val(stus);
                    $('#specialInstruction').val('${eSvmInfo.appvInstrct}');
                    console.log('specialInstruction', $('#specialInstruction').val());
                    $("#SARefNo").replaceWith('<input id=SARefNo name="SARefNo" value="${eSvmInfo.saRef}" type="text" title="" placeholder="" class="w100p" />');
                    $("#PONo").replaceWith('<input id=PONo name="PONo" value="${eSvmInfo.poNo}" type="text" title="" placeholder="" class="w100p readonly" readonly />');
                    if(payMode == '6506') { //Company PO allow to edit PO field
                        $("#PONo").replaceWith('<input id=PONo name="PONo" value="${eSvmInfo.poNo}" type="text" title="" placeholder="" class="w100p" />');
                    }
                    $("#action option[value='"+ stus +"']").attr("selected", true);
                    $("#specialInstruction option[value='"+ specialInst +"']").attr("selected", true);

                    $("#payment_cardMode option[value='" + cardModeCode+ "']").attr("selected", true);
                    $("#payment_issuedBank option[value='"+ issuBankCode +"']").attr("selected", true);
                    $("#payment_cardType option[value='"+ cardBrandCode +"']").attr("selected", true);
                    $("#payment_merchantBank option[value='"+ merchantBankCode +"']").attr("selected", true);

                } else {
                    $('#action').val(stus);
                    $("#action option[value='"+ stus +"']").attr("selected", true);
                    $("#payment_cardMode option[value='" + cardModeCode+ "']").attr("selected", true);
                    $("#payment_issuedBank option[value='"+ issuBankCode +"']").attr("selected", true);
                    $("#payment_cardType option[value='"+ cardBrandCode +"']").attr("selected", true);
                    $("#payment_merchantBank option[value='"+ merchantBankCode +"']").attr("selected", true);
                }
            } else if (stus == '6') {
                $("#SARefNo").replaceWith('<input id=SARefNo name="SARefNo" value="${eSvmInfo.saRef}" type="text" title="" placeholder="" class="w100p readonly" readonly />');
                $("#PONo").replaceWith('<input id=PONo name="PONo" value="${eSvmInfo.poNo}" type="text" title="" placeholder="" class="w100p readonly" readonly />');
                $("#action option[value='"+ stus +"']").attr("selected", true);
                $("#action").attr("disabled", true);
                $("#specialInstruction option[value='"+ specialInst +"']").attr("selected", true);
                $("#specialInstruction").attr("disabled", true);

                $("#btnSave").hide();

                var trxDt = $("#payment_transactionDt").val();
                if(trxDt != null && trxDt != "" && trxDt.length != 10){
                    trxDt = trxDt.substr(0,2) + '/' + trxDt.substr(2,2) + '/' + trxDt.substr(4,4);
                    $("#payment_transactionDt").val(trxDt);
                }
            }
           }

        //if($("#action").val() == '5') //5:Approved
          //  $("#specInst").hide();
    });

    $('.creditCardText').keyup(function() {
          var foo = $(this).val().split("-").join(""); // remove hyphens
          if (foo.length > 0) {
            foo = foo.match(new RegExp('.{1,4}', 'g')).join("-");
          }
          $(this).val(foo);
    });

    $(function(){
        $('#btnSave').click(function() {

            console.log("btnSave clicked")
            var checkResult = fn_checkEmpty();
            if(!checkResult) {
                return false;
            }

            if(!fn_validFile()) {
                $('#aTabFL').click();
                return false;
            }

            var formData = new FormData();
            formData.append("atchFileGrpId", '${eSvmInfo.atchFileGrpId}');
            formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
            formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
            //console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
            //console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
            $.each(myFileCaches, function(n, v) {
                console.log(v.file);
                formData.append(n, v.file);
            });

            fn_doSaveESvmOrder();

        });
        $('#svmFrFile').change( function(evt) {
            var file = evt.target.files[0];
             if(file.name != svmFrFileName) {
                 myFileCaches[1] = {file:file};
                 if(svmFrFileName != "") {
                     update.push(svmFrFileId);
                 }
             }
        });
        $('#svmTncFile').change( function(evt) {
            var file = evt.target.files[0];
            if(file.name != svmTncFileName) {
                myFileCaches[2] = {file:file};
                if(svmTncFileName != "") {
                    update.push(svmTncFileId);
                }
            }
        });
        $('#poFile').change(function(evt) {
            var file = evt.target.files[0];
            if(file == null) {
                remove.push(poFileId);
            } else if(file.name != poFileName) {
                myFileCaches[3] = {file:file};
                if(poFileName != "") {
                    update.push(poFileId);
                }
            }
        });

        $('#nricFrFile').change(function(evt) {
            var file = evt.target.files[0];
            if(file == null) {
                remove.push(nricFrFileId);
            } else if(file.name != nricFrFileName) {
                myFileCaches[4] = {file:file};
                if(nricFrFileName != "") {
                    update.push(nricFrFileId);
               }
            }
        });

        $('#nricBcFile').change(function(evt) {
            var file = evt.target.files[0];
            if(file == null) {
                remove.push(nricBcFileId);
            } else if(file.name != nricBcFileName) {
                myFileCaches[5] = {file:file};
                if(nricBcFileName != "") {
                    update.push(nricBcFileId);
                }
            }
        });

        $('#slipFile').change(function(evt) {
            var file = evt.target.files[0];
            if(file == null) {
                remove.push(slipFileId);
            } else if(file.name != slipFileName) {
                myFileCaches[6] = {file:file};
                if(slipFileName != "") {
                    update.push(slipFileId);
                }
            }
        });

        $('#chqFile').change(function(evt) {
            var file = evt.target.files[0];
            if(file == null) {
                remove.push(chqFileId);
            } else if(file.name != chqFileName) {
                myFileCaches[7] = {file:file};
                if(chqFileName != "") {
                    update.push(chqFileId);
                }
            }
        });

        $('#otherFile').change( function(evt) {
            var file = evt.target.files[0];
            if(file == null) {
                remove.push(otherFileId);
            } else if(file.name != otherFileName) {
                 myFileCaches[8] = {file:file};
                 if(otherFileName != "") {
                     update.push(otherFileId);
                 }
             }
        });

        $('#otherFile2').change( function(evt) {
            var file = evt.target.files[0];
            if(file == null) {
                remove.push(otherFileId2);
            } else if(file.name != otherFileName2) {
                 myFileCaches[8] = {file:file};
                 if(otherFileName2 != "") {
                     update.push(otherFileId2);
                 }
             }
        });

        $('#otherFile3').change( function(evt) {
            var file = evt.target.files[0];
            if(file == null) {
                remove.push(otherFileId3);
            } else if(file.name != otherFileName3) {
                 myFileCaches[8] = {file:file};
                 if(otherFileName3 != "") {
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

        /*var data = {
                action : $('#action').val(),
                specialInstruction : $('#specialInst').val(),
                remark : $("#remark").val(),
                srvMemQuotId :   '${eSvmInfo.srvMemQuotId}',
                atchFileGrpId        : '${eSvmInfo.atchFileGrpId}',
                SARefNo : $("#SARefNo").val(),
                PONo : $("#PONo").val(),
                psmId : '${eSvmInfo.psmId}'
            };*/

        var data = {
                //Update SAL0298D & PAY0312D
                action : $('#action').val(),
                specialInstruction : $('#specialInstruction').val(),
                remark : $("#remark").val(),
                srvMemQuotId :   '${eSvmInfo.srvMemQuotId}',
                atchFileGrpId        : '${eSvmInfo.atchFileGrpId}',
                SARefNo : $("#SARefNo").val(),
                PONo : $("#PONo").val(),
                psmId : '${eSvmInfo.psmId}',
                psmSrvMemNo : '${eSvmInfo.psmSrvMemNo}',
                payment_cardMode : $("#payment_cardMode").val(),
                payment_cardNo : $("#payment_cardNo").val(),
                payment_approvalNo : $("#payment_approvalNo").val(),
                payment_expDt : $("#payment_expDt").val(),
                payment_transactionDt : $("#payment_transactionDt").val(),
                payment_ccHolderName : $("#payment_ccHolderName").val(),
                payment_issuedBank : $("#payment_issuedBank").val(),
                payment_cardType : $("#payment_cardType").val(),
                payment_merchantBank : $("#payment_merchantBank").val(),

                // LaiKW - Added Payment Mode for PO
                payment_mode : '${paymentInfo.payMode}',
                mnlBill_refNo : $("#SARefNo").val(),
                mnlBill_remark : $("#advBilRemRemark").val(),
                mnlBill_invcRemark : $("#advBilRemInvcRemark").val(),

                // Insert SAL0095D Data
                srvMemQuotId :   '${eSvmInfo.srvMemQuotId}'  ,
                srvSalesOrdId: '${quotInfo.ordId}' ,
                srvSalesOrdNo: '${eSvmInfo.salesOrdNo}' ,
                srvMemQuotNo: '${preSalesInfo.smqNo}',
                srvMemQuotCntName:"${quotInfo.cntName}",
                srvMemQuotCustName:"${preSalesInfo.custName}",
                srvMemPacId: '${quotInfo.pacId}',
                srvMemPacAmt: '${quotInfo.pacAmt}',
                srvMemBsAmt: '${quotInfo.totAmt}',
                srvMemPv: '0',
                srvFreq: '${quotInfo.bsFreq}',
                srvStartDt: '01/01/1900',
                srvExprDt: '01/01/1900',
                srvStusCodeId: '1',
                srvDur: '${quotInfo.dur}',
                srvRem: '',
                srvMemBs12Amt: '0',
                srvMemIsSynch : '0',
                srvMemSalesMemId:'',
                srvMemCustCntId: '${quotInfo.cntId}',
                srvMemQty : Number('${quotInfo.dur}') / 12,
                srvBsQty: ((12 / Number('${quotInfo.dur}') ) * ( Number('${quotInfo.dur}')  / 12)),
                srvMemPromoId : '${quotInfo.promoId}',
                srvMemPvMonth : '0',
                srvMemPvYear : '0',
                srvMemIsMnl : '0',
                srvMemBrnchId : BranchId,
                srvMemPacPromoId :'${quotInfo.pacPromoId}',
                srvMemFormNo:'',
                trType:  '' ,
                srvStockCode :  '${quotInfo.stkCode}',
                srvStockDesc :  '${quotInfo.stkDesc}',
                poNo : $("#poNo").val(),
                refNo : $("#SARefNo").val(),
                trxId : $("#payment_transactionID").val(),
                allowCommFlg : $("#payment_allowCommFlg").val(),
                trRefNo : $("#payment_trRefNo").val(),
                trIssuedDt : $("#payment_trIssuedDt").val()
        };

        console.log(data);

        var formData = new FormData();
        formData.append("atchFileGrpId", '${eSvmInfo.atchFileGrpId}');
        formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
        formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
        $.each(myFileCaches, function(n, v) {
            formData.append(n, v.file);
        });

        Common.ajaxFile("/sales/membership/attachESvmFileUpdate.do", formData, function(result) {
            console.log(result);
            if(result.code == 99){
                Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);

            } else {
               // DO SAVE BUTTON ACTION
               //Common.popupDiv("/sales/membership/updateAction.do", data, function(result){
               Common.ajax("POST", "/sales/membership/updateAction.do", data, function(result1) {
                   console.log("result1 :: " + result1);
                   if('${paymentInfo.payMode}' != "6506") {
                       if(result1.messageCode == 00){
                           if(result1.data.psmSrvMemNo == null)
                               Common.alert('Membership successfully saved.' + "<b>");
                           else
                               Common.alert('Membership successfully saved.' + "<b>" + result1.psmSrvMemNo);
                           fn_close();

                       } else {
                           Common.alert('Membership failed to save.');
                       }
                   } else {
                       Common.alert(result1.message);
                       fn_close();
                   }

               });
            }
        }, function(result) {
            Common.alert(result.message+"<br/>Upload Failed. Please check with System Administrator.");
        });
    }

    function fn_close() {
        $("#popup_wrap").remove();
    }

    function fn_closePreOrdModPop() {
        fn_getPreOrderList();
        myFileCaches = {};
        delete update;
        delete remove;
        $('#_divESvmSavePop').remove();
    }

    function fn_closePreOrdModPop2() {
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
            //console.log(result)
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');

            if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
                //console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            } else {
                //console.log("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
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

    function fn_GetSpecialInstruction(){
        console.log('Action: ' + $("#action").val());
        console.log('spec: ' + $("#specialInstruction").val());
        var action =  $("#action").val();
        doGetComboData('/sales/membership/selectActionOption.do', {action : $("#action").val()}, '', 'specialInstruction', 'S', ''); //Special Instruction for Update Status page
    }

    function fn_displaySpecialInst(){
        fn_GetSpecialInstruction();
        if($("#action").val() == '5' || $("#action").val() == '') { //5:Approved
            $("#specInst").hide();
            SpecInstr = 0;
            $("#SARefNo_header").replaceWith('<th id="SARefNo_header" scope="row">SA Reference No<span class="must">*</span></th>');
            SAFlg = 1;
        } else {
            $("#specInst").show();
            $("#specialInst_header").replaceWith('<th id="specialInst_header" scope="row">Special Instruction<span class="must">*</span></th>');
            SpecInstr = 1;
            $("#SARefNo_header").replaceWith('<th id="SARefNo_header" scope="row">SA Reference No</th>');
            SAFlg = 0;
        }
    }

    function fn_checkEmpty(){
        var checkResult = true;

        console.log("fn_checkEmpty");
        console.log("SARefNo: " + $("#SARefNo").val());
        console.log("Action: " + $("#action").val());
        console.log("specialInst: " + $("#specialInstruction").val());
        console.log("SAFlg: " + SAFlg);
        console.log("payMode: " + '${paymentInfo.payMode}');
        console.log("payMode: " + '${preSalesInfo.packageAmt}');

        if('${preSalesInfo.packageAmt}' == '0') {
            Common.alert('Please enter Package Amount.');
            checkResult = false;
            return checkResult;

        } else if(FormUtil.isEmpty($("#SARefNo").val()) && SAFlg == 1) {
            Common.alert('Please enter SA Reference No.');
            checkResult = false;
            return checkResult;

        } else if(FormUtil.isEmpty($("#action").val())) {
            Common.alert('Please choose an Action to proceed.');
            checkResult = false;
            return checkResult;

        } else if(FormUtil.isEmpty($("#specialInstruction").val()) && SpecInstr == 1) {
            Common.alert('Please choose a Special Instruction.');
            checkResult = false;
            return checkResult;

        } else if($("#action").val() == '5') { //rejected and active with instruction action no need to check transaction ID
            if('${paymentInfo.payMode}' == '6507' || '${paymentInfo.payMode}' == '6508') {
                if(FormUtil.isEmpty($("#payment_transactionID").val())) {
                    Common.alert('Please enter Transaction ID.');
                    checkResult = false;
                    return checkResult;
                }

                // LaiKW - 20211201 - New tab validation for PO
                if('${paymentInfo.payMode}' == '6506') {
                    if(FormUtil.isEmpty($("#SARefNo").val())) {
                        Common.alert("Advance Billing - Reference Number is required.");
                        checkResult = false;
                        return checkResult;
                    }
                }
            } else if('${paymentInfo.payMode}' == '6528') { // card=MOTO/IPP checking only when approve action
                if((FormUtil.isEmpty($("#payment_cardMode").val()))) {
                    Common.alert('Please select Card Mode.');
                    checkResult = false;
                    return checkResult;

                } else if((FormUtil.isEmpty($("#payment_cardNo").val()))) {
                    Common.alert('Please enter Card No.');
                    checkResult = false;
                    return checkResult;

                } else if((FormUtil.isEmpty($("#payment_approvalNo").val()))) {
                    Common.alert('Please enter Approval No.');
                    checkResult = false;
                    return checkResult;

                } else if((FormUtil.isEmpty($("#payment_expDt").val()))) {
                    Common.alert('Please enter Expiry Date (CVV).');
                    checkResult = false;
                    return checkResult;

                } else if((FormUtil.isEmpty($("#payment_transactionDt").val()))) {
                    Common.alert('Please enter Transaction Date.');
                    checkResult = false;
                    return checkResult;

                } else if((FormUtil.isEmpty($("#payment_ccHolderName").val()))) {
                    Common.alert('Please enter Credit Card Holder Name.');
                    checkResult = false;
                    return checkResult;

                } else if((FormUtil.isEmpty($("#payment_issuedBank").val()))) {
                    Common.alert('Please select a Issued Bank.');
                    checkResult = false;
                    return checkResult;

                } else if((FormUtil.isEmpty($("#payment_cardType").val()))) {
                    Common.alert('Please select a Card Type.');
                    checkResult = false;
                    return checkResult;

                } else if((FormUtil.isEmpty($("#payment_merchantBank").val()))) {
                    Common.alert('Please select a Merchant Bank.');
                    checkResult = false;
                    return checkResult;
                }
            } else if ('${preSalesInfo.custTypeDesc}' == '965' || POFlg == 1) { //Company PO is mandatory or paymode = PO(6506)
                if(FormUtil.isEmpty($("#PONo").val())) {
	                Common.alert('Please enter Purchase Order.');
	                checkResult = false;
	                return checkResult;
                }
            }
        }
        return checkResult;
    }

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>eSVM Approval</h1>
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
    <li><a href="aTabPY" id="aTabPayment" onClick="javascript:chgTab('ord');">Payment</a></li>
    <li><a href="aTabFL" >Attachment</a></li>
    <li><a href="aTabBL" id="aTabBilling">Advance Billing Remark</a></li>
    <li><a href="aTabST" onClick="javascript:chgTab('pay');">Update Status</a></li>
</ul>

<!------------------------------------------------------------------------------
                Pre Sales Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/membership/eSvmPreSalesInfoPop.jsp" %>
<!------------------------------------------------------------------------------
                Payment Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/membership/eSvmPaymentPop.jsp" %>
<!------------------------------------------------------------------------------
                Attachment Area
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/membership/eSvmAttachment.jsp" %>
<!------------------------------------------------------------------------------
                Update Status Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/membership/eSvmPOAdvBilling.jsp" %>
<!------------------------------------------------------------------------------
                Update Status Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/membership/eSvmUpdateStatusPop.jsp" %>



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
