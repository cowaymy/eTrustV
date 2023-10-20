<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">

    function fn_loadCopyChange() {
        var _CUST_ID = '${orderInfo.basicInfo.custId}';

        Common.ajax("GET", "/sales/customer/selectCustomerJsonList", {custId : _CUST_ID}, function(result) {

            if(result != null && result.length == 1) {

                fn_tabOnOffSet('BIL_DTL', 'SHOW');

                var custInfo = result[0];

                console.log("����.");
                console.log("custId : " + result[0].custId);
                console.log("userName1 : " + result[0].name);

                //
                $("#hiddenCustId").val(custInfo.custId); //Customer ID(Hidden)
                $("#custId").val(custInfo.custId); //Customer ID
                $("#custTypeNm").val(custInfo.codeName1); //Customer Name
                $("#typeId").val(custInfo.typeId); //Type
                $("#name").val(custInfo.name); //Name
                $("#nric").val(custInfo.nric); //NRIC/Company No
                $("#nationNm").val(custInfo.name2); //Nationality
                $("#raceId").val(custInfo.raceId); //Nationality
                $("#race").val(custInfo.codeName2); //
                $("#dob").val(custInfo.dob == '01/01/1900' ? '' : custInfo.dob); //DOB
                $("#gender").val(custInfo.gender); //Gender
                $("#pasSportExpr").val(custInfo.pasSportExpr == '01/01/1900' ? '' : custInfo.pasSportExpr); //Passport Expiry
                $("#visaExpr").val(custInfo.visaExpr == '01/01/1900' ? '' : custInfo.visaExpr); //Visa Expiry
                $("#email").val(custInfo.email); //Email
                $("#custRem").val(custInfo.rem); //Remark

                if(custInfo.receivingMarketingMsgStatus == 1){
                	$("#marketMessageYes").prop("checked", true);
                }
                else{
                	$("#marketMessageNo").prop("checked", true);
                }

                if(custInfo.corpTypeId > 0) {
                    $("#corpTypeNm").val(custInfo.codeName); //Industry Code
                }
                else {
                    $("#corpTypeNm").val(""); //Industry Code
                }

                if($('#typeId').val() == '965') { //Company
                    $('#sctBillPrefer').removeClass("blind");
                } else {
                    $('#sctBillPrefer').addClass("blind");
                }

                //----------------------------------------------------------
                // [Billing Detail] : Billing Address SETTING
                //----------------------------------------------------------
                fn_loadMailAddr('${orderInfo.mailingInfo.mailAddrId}');

                //----------------------------------------------------------
                // [Installation] : Installation Address SETTING
                //----------------------------------------------------------
                fn_loadInstallAddr('${orderInfo.installationInfo.installAddrId}');

                $('#prefInstDt').val('${orderInfo.installationInfo.preferInstDt}');
                $('#prefInstTm').val('${orderInfo.installationInfo.preferInstTm}');
                $("#dscBrnchId").val('${orderInfo.installationInfo.dscId}'); //DSC Branch
                $("#speclInstct").val("${orderInfo.installationInfo.instct}");

                //----------------------------------------------------------
                // [Master Contact] : Owner & Purchaser Contact
                //                    Additional Service Contact
                //----------------------------------------------------------

                fn_loadCntcPerson('${orderInfo.basicInfo.ordCntcId}');
                fn_loadSrvCntcPerson('${orderInfo.basicInfo.custCareCntId}');

                //----------------------------------------------------------
                // [Installation] : Installation Contact Person
                //----------------------------------------------------------
                fn_loadInstallationCntcPerson('${orderInfo.installationInfo.installCntcId}');

                // Salesman
                fn_loadOrderSalesman(null, '${orderInfo.basicInfo.ordMemCode}');

                //--------------------------------------------------------------
                // [Order Info]
                //--------------------------------------------------------------
                $('#appType').val('${orderInfo.basicInfo.appTypeId}');

                fn_getSvrPacCombo('${orderInfo.basicInfo.appTypeId}', '${orderInfo.basicInfo.srvPacId}');

              //$('#srvPacId').val('${orderInfo.srvPacId}');

                $('#ordProudct').removeAttr("disabled");

                var stkType = $("#appType").val() == '66' ? '1' : '2';
                doGetComboAndGroup2('/sales/order/selectProductCodeList.do', {stkType:stkType, srvPacId:'${orderInfo.basicInfo.srvPacId}'}, '${orderInfo.basicInfo.stockId}', 'ordProudct', 'S', 'fn_setOptGrpClass');//product ����

                $('#empChk').val('${orderInfo.basicInfo.empChk}');
                //$('#gstChk').val('${orderInfo.basicInfo.gstChk}');
                doGetComboData('/common/selectCodeList.do', {groupCode :'326'}, '${orderInfo.basicInfo.gstChk}', 'gstChk',  'S'); //GST_CHK

                if('${orderInfo.basicInfo.gstChk}' == '1') {
                    fn_tabOnOffSet('REL_CER', 'SHOW');
                }
                else {
                    fn_tabOnOffSet('REL_CER', 'HIDE');
                }

                $('#exTrade').val('${orderInfo.basicInfo.exTrade}');
                $('#installDur').val('${orderInfo.basicInfo.instPriod}');
                $('#poNo').val('${orderInfo.basicInfo.ordPoNo}');
                $('#refereNo').val('${orderInfo.basicInfo.ordRefNo}');

              //fn_loadProductPrice('${orderInfo.appTypeId}', '${orderInfo.itmStkId}');
              //fn_loadProductPromotion('${orderInfo.appTypeId}', '${orderInfo.itmStkId}', '${orderInfo.empChk}', $("#typeId").val(), '${orderInfo.exTrade}');

                $('#ordPromo').removeAttr("disabled");
                var month = '${orderInfo.basicInfo.month}';
                var year = '${orderInfo.basicInfo.year}';
                var date = year + month;
                var ekeyCrtUser = '${orderInfo.basicInfo.ekeyCrtUser}';
                console.log("aaa:"+month);
                console.log("aaa:"+year);
                console.log("aaa:"+ekeyCrtUser);

                voucherAppliedStatus = 0;
                if('${orderInfo.basicInfo.voucherInfo}' != null && '${orderInfo.basicInfo.voucherInfo}' != ""){
				  	voucherAppliedStatus = 1;
					voucherAppliedCode =  '${preOrderInfo.voucherInfo.voucherCode}';
			    }

                if(date >= 201907 && ekeyCrtUser != null) {
                //if(month >= '7' && year == '2019' ) {
                	doGetComboData('/sales/order/selectPromotionByAppTypeStockESales.do', {appTypeId:'${orderInfo.basicInfo.appTypeId}'
                        ,stkId:'${orderInfo.basicInfo.stockId}'
                        ,empChk:'${orderInfo.basicInfo.empChk}'
                        ,promoCustType:$("#typeId").val()
                        ,exTrade:'${orderInfo.basicInfo.exTrade}'
                        ,srvPacId:'${orderInfo.basicInfo.srvPacId}'
                	    ,promoId:'${orderInfo.basicInfo.ordPromoId}'
                        , voucherPromotion: voucherAppliedStatus}
                	    ,'${orderInfo.basicInfo.ordPromoId}', 'ordPromo', 'S', ''); //Common Code
                }
                else
                {
                	 if($("#appType").val() == '66') {
                		  doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {appTypeId:'${orderInfo.basicInfo.appTypeId}'
                              ,stkId:'${orderInfo.basicInfo.stockId}'
                              ,empChk:'${orderInfo.basicInfo.empChk}'
                              ,promoCustType:$("#typeId").val()
                              ,exTrade:'${orderInfo.basicInfo.exTrade}'
                              ,srvPacId:'${orderInfo.basicInfo.srvPacId}'
                              , voucherPromotion: voucherAppliedStatus}, '${orderInfo.basicInfo.ordPromoId}', 'ordPromo', 'S', ''); //Common Code

                	 }
                	 else{
                		  doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {appTypeId:'${orderInfo.basicInfo.appTypeId}'
                              ,stkId:'${orderInfo.basicInfo.stockId}'
                              ,empChk:'${orderInfo.basicInfo.empChk}'
                              ,promoCustType:$("#typeId").val()
                              , isSrvPac:'Y'
                              ,exTrade:'${orderInfo.basicInfo.exTrade}'
                              ,srvPacId:'${orderInfo.basicInfo.srvPacId}'
                              , voucherPromotion: voucherAppliedStatus}, '${orderInfo.basicInfo.ordPromoId}', 'ordPromo', 'S', ''); //Common Code
                	 }


                }


              //$('#ordPromo').val('${orderInfo.promoId}');

		        $('#ordRentalFees').val('${orderInfo.basicInfo.mthRentAmt}');
		        $('#promoDiscPeriodTp').val('${orderInfo.basicInfo.promoDiscPeriodTp}');
		        $('#promoDiscPeriod').val('${orderInfo.basicInfo.promoDiscPeriod}');
		        $('#ordPrice').val('${orderInfo.basicInfo.ordAmt}');
		        $('#orgOrdPrice').val('${orderInfo.basicInfo.norAmt}');
		        $('#orgOrdRentalFees').val('${orderInfo.basicInfo.norRntFee}');
		        $('#ordRentalFees').val('${orderInfo.basicInfo.discRntFee}');
		        $('#ordPv').val('${orderInfo.basicInfo.ordPv}');
		      //$('#ordPvGST').val('${orderInfo.basicInfo.totPvGst}');
		        $('#ordPriceId').val('${orderInfo.basicInfo.itmPrcId}');

                $('[name="advPay"]').removeAttr("disabled");
                $("input:radio[name='advPay']:radio[value='${orderInfo.basicInfo.advBill}']").prop("checked", true);

                if('${orderInfo.rentPaySetInf.is3party}' == 'Yes') {
                    $('#thrdParty').attr("checked", true);
                    $('#sctThrdParty').removeClass("blind");
                    fn_loadThirdParty('${orderInfo.rentPaySetInf.payerCustId}', 2);
                }

                $('#rentPayMode').val('${orderInfo.rentPaySetInf.payModeId}');

                if($('#rentPayMode').val() == '131') {
                    $('#sctCrCard').removeClass("blind");
                    fn_loadCreditCard2('${orderInfo.rentPaySetInf.crcId}');
                }
                else if($('#rentPayMode').val() == '132') {
                    $('#sctDirectDebit').removeClass("blind");
                    fn_loadBankAccount('${orderInfo.rentPaySetInf.custAccId}');
                }

                $('#grpOpt2').prop("checked", true);

                $('#sctBillSel').removeClass("blind");

                $('#billRem').prop("readonly", true).addClass("readonly");

                fn_loadBillingGroupById('${orderInfo.basicInfo.custId}', '${orderInfo.basicInfo.custBillId}');

                $('#liMstCntcNewAddr').removeClass("blind");
                $('#liMstCntcSelAddr').removeClass("blind");
                $('#liMstCntcNewAddr2').removeClass("blind");
                $('#liMstCntcSelAddr2').removeClass("blind");
                $('#liBillNewAddr').removeClass("blind");
                $('#liBillSelAddr').removeClass("blind");
                $('#liBillNewAddr2').removeClass("blind");
                $('#liBillSelAddr2').removeClass("blind");
                $('#liInstNewAddr').removeClass("blind");
                $('#liInstSelAddr').removeClass("blind");
                $('#liInstNewAddr2').removeClass("blind");
                $('#liInstSelAddr2').removeClass("blind");

              //fn_checkDocList(false);

                Common.ajaxSync("GET", "/sales/order/selectDocumentJsonList.do", {salesOrderId : '${orderInfo.basicInfo.ordId}'}, function(result) {
                    if(result != null && result.length > 0) {
                        fn_checkSavedDocList(result);
                    }
                });

                $('#certRefNo').val('${orderInfo.gstCertInfo.eurcRefNo}');
                $('#certRefDt').val('${orderInfo.gstCertInfo.eurcRefDt}');
                $('#txtCertCustRgsNo').val('${orderInfo.gstCertInfo.eurcCustRgsNo}');
                $('#txtCertCustRgsNo').val('${orderInfo.gstCertInfo.eurcCustRgsNo}');
                $('#txtCertRemark').val('${orderInfo.gstCertInfo.eurcRem}');
/*
                if(custInfo.codeName == 'Government') {
                    Common.alert('<b>Goverment Customer</b>');
                }
*/
            }
            else {
//              Common.alert('<b>Customer not found.<br>Your input customer ID :'+$("#searchCustId").val()+'</b>');
                Common.alert('<spring:message code="sal.alert.msg.custNotFound" arguments="'+_CUST_ID+'"/>');
            }
        });
    }

    function fn_checkSavedDocList(list) {
        for(var i = 0; i < AUIGrid.getRowCount(docGridID) ; i++) {

            AUIGrid.setCellValue(docGridID, i, "chkfield", 0);

            var vCodeId = AUIGrid.getCellValue(docGridID, i, "codeId");
            console.log('vCodeId:'+vCodeId);
            for(var j = 0; j < list.length; j++) {

                console.log('list[j].docTypeId:'+list[j].docTypeId);

                if(vCodeId == list[j].docTypeId) {
                    AUIGrid.setCellValue(docGridID, i, "chkfield", 1);
                    if(docDefaultChk == false) docDefaultChk = true;
                    break;
                }
            }
        }
    }

    function fn_loadBillingGroupById(custId, custBillId){
        Common.ajax("GET", "/sales/customer/selectBillingGroupByKeywordCustIDList.do", {custId : custId, custBillId : custBillId}, function(result) {
            if(result != null && result.length > 0) {
                fn_loadBillingGroup(result[0].custBillId, result[0].custBillGrpNo, result[0].billType, result[0].billAddrFull, result[0].custBillRem, result[0].custBillAddId);
            }
        });
    }

	function fn_getSvrPacCombo(selVal, srvPacId){

	    var appSubType = '';

        switch(selVal) {
            case '66' : //RENTAL
                fn_tabOnOffSet('PAY_CHA', 'SHOW');
                $('[name="advPay"]').removeAttr("disabled");

                appSubType = '367';
                break;
            case '67' : //OUTRIGHT
                appSubType = '368';
                break;
            case '68' : //INSTALLMENT
                appSubType = '369';
                break;
            case '1412' : //Outright Plus
                fn_tabOnOffSet('PAY_CHA', 'SHOW');
                $('[name="advPay"]').removeAttr("disabled");

                appSubType = '370';
                break;
            case '142' : //Sponsor
                appSubType = '371';
                break;
            case '143' : //Service
                appSubType = '372';
                break;
            case '144' : //Education
                appSubType = '373';
                break;
            case '145' : //Free Trial
                appSubType = '374';
                break;
            default :
                break;
        }

        var pType = $("#appType").val() == '66' ? '1' : '2';
        //doGetComboData('/common/selectCodeList.do', {pType : pType}, '',  'srvPacId',  'S', 'fn_setDefaultSrvPacId'); //APPLICATION SUBTYPE
        doGetComboData('/sales/order/selectServicePackageList.do', {appSubType : appSubType, pType : pType}, srvPacId, 'srvPacId', 'S', ''); //APPLICATION SUBTYPE
    }
</script>
