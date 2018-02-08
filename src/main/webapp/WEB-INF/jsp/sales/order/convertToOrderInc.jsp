<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">

    function fn_loadPreOrderInfo() {
        var _CUST_ID = '${preOrderInfo.custId}';

        Common.ajax("GET", "/sales/customer/selectCustomerJsonList", {custId : _CUST_ID}, function(result) {

            if(result != null && result.length == 1) {
                
                fn_tabOnOffSet('BIL_DTL', 'SHOW');

                var custInfo = result[0];

                console.log("성공.");
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

                if(custInfo.custAddId > 0) {

                    //----------------------------------------------------------
                    // [Billing Detail] : Billing Address SETTING
                    //----------------------------------------------------------
                    fn_loadMailAddr('${preOrderInfo.custBillAddId}');

                    //----------------------------------------------------------
                    // [Installation] : Installation Address SETTING
                    //----------------------------------------------------------
                    fn_loadInstallAddr('${preOrderInfo.instAddId}');
                }

                if(custInfo.custCntcId > 0) {
                    //----------------------------------------------------------
                    // [Master Contact] : Owner & Purchaser Contact
                    //                    Additional Service Contact
                    //----------------------------------------------------------

                    fn_loadCntcPerson('${preOrderInfo.custCntcId}');
                    fn_loadSrvCntcPerson(custInfo.custCareCntId);

                    //----------------------------------------------------------
                    // [Installation] : Installation Contact Person
                    //----------------------------------------------------------
                    fn_loadInstallationCntcPerson('${preOrderInfo.custCntcId}');
                    
                    // Salesman
                    fn_loadOrderSalesman(null, '${preOrderInfo.memCode}');
                    
                    $('#prefInstDt').val('${preOrderInfo.preDt}');
                    $('#prefInstTm').val('${preOrderInfo.preTm}');
                }
                
                //--------------------------------------------------------------
                // [Order Info]
                //--------------------------------------------------------------
                $('#appType').val('${preOrderInfo.appTypeId}');
                
                fn_getSvrPacComboConv('${preOrderInfo.appTypeId}', '${preOrderInfo.srvPacId}');
                
              //$('#srvPacId').val('${preOrderInfo.srvPacId}');
              
                $('#ordProudct').removeAttr("disabled");
              
                var stkType = $("#appType").val() == '66' ? '1' : '2';
                doGetComboAndGroup2('/sales/order/selectProductCodeList.do', {stkType:stkType, srvPacId:'${preOrderInfo.srvPacId}'}, '${preOrderInfo.itmStkId}', 'ordProudct', 'S', 'fn_setOptGrpClass');//product 생성
              
                $('#empChk').val('${preOrderInfo.empChk}');                
                $('#gstChk').val('${preOrderInfo.gstChk}');
                $('#exTrade').val('${preOrderInfo.exTrade}');
                $('#installDur').val('${preOrderInfo.instPriod}');
                $('#poNo').val('${preOrderInfo.custPoNo}');
                $('#refereNo').val('${preOrderInfo.sofNo}');

              //fn_loadProductPrice('${preOrderInfo.appTypeId}', '${preOrderInfo.itmStkId}');
              //fn_loadProductPromotion('${preOrderInfo.appTypeId}', '${preOrderInfo.itmStkId}', '${preOrderInfo.empChk}', $("#typeId").val(), '${preOrderInfo.exTrade}');
                
                $('#ordPromo').removeAttr("disabled");
                doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {appTypeId:'${preOrderInfo.appTypeId}'
                                                                                ,stkId:'${preOrderInfo.itmStkId}'
                                                                                ,empChk:'${preOrderInfo.empChk}'
                                                                                ,promoCustType:$("#typeId").val()
                                                                                ,exTrade:'${preOrderInfo.exTrade}'
                                                                                ,srvPacId:'${preOrderInfo.srvPacId}'}, '${preOrderInfo.promoId}', 'ordPromo', 'S', ''); //Common Code
                
              //$('#ordPromo').val('${preOrderInfo.promoId}');
              
		        $('#ordRentalFees').val('${preOrderInfo.mthRentAmt}');
		        $('#promoDiscPeriodTp').val('${preOrderInfo.promoDiscPeriodTp}');
		        $('#promoDiscPeriod').val('${preOrderInfo.promoDiscPeriod}');
		        $('#ordPrice').val('${preOrderInfo.totAmt}');
		        $('#orgOrdPrice').val('${preOrderInfo.norAmt}');
		        $('#orgOrdRentalFees').val('${preOrderInfo.norRntFee}');
		        $('#ordRentalFees').val('${preOrderInfo.discRntFee}');
		        $('#ordPv').val('${preOrderInfo.totPv}');
		        $('#ordPvGST').val('${preOrderInfo.totPvGst}');
		        $('#ordPriceId').val('${preOrderInfo.prcId}');

                $('[name="advPay"]').removeAttr("disabled");
                $("input:radio[name='advPay']:radio[value='${preOrderInfo.advBill}']").prop("checked", true);
                
                if('${preOrderInfo.is3rdParty}' == '1') {
                    $('#thrdParty').attr("checked", true);
                    $('#sctThrdParty').removeClass("blind");
                    fn_loadThirdParty('${preOrderInfo.rentPayCustId}', 2);
                }
                
                $('#rentPayMode').val('${preOrderInfo.rentPayModeId}');
                
                if($('#rentPayMode').val() == '131') {
                    $('#sctCrCard').removeClass("blind");
                    fn_loadCreditCard2('${preOrderInfo.custCrcId}');
                }
                else if($('#rentPayMode').val() == '132') {
                    $('#sctDirectDebit').removeClass("blind");
                    fn_loadBankAccount('${preOrderInfo.custAccId}');
                }
                
                if('${preOrderInfo.custBillId}' == '' || '${preOrderInfo.custBillId}' == '0') {

                    $('#grpOpt1').prop("checked", true);
        
                    $('#sctBillMthd').removeClass("blind");
                    $('#sctBillAddr').removeClass("blind");
        //          $('#sctBillPrefer').removeClass("blind");
        
                    $('#billMthdEmailTxt1').val($('#custCntcEmail').val().trim());
                  //$('#billMthdEmailTxt2').val($('#srvCntcEmail').val().trim());
        
                    if($('#typeId').val() == '965') { //Company
        
                        console.log("fn_setBillGrp 1 typeId : "+$('#typeId').val());
        
                        $('#sctBillPrefer').removeClass("blind");
                        
                        if('${preOrderInfo.custBillCustCareCntId}' != '' && '${preOrderInfo.custBillCustCareCntId}' != '0') {
                            fn_loadBillingPreference('${preOrderInfo.custBillCustCareCntId}');
                        }
        
                        $('#billMthdEstm').prop("checked", true);
                        $('#billMthdEmail1').prop("checked", true).removeAttr("disabled");
                        $('#billMthdEmail2').removeAttr("disabled");
                        $('#billMthdEmailTxt1').removeAttr("disabled").val('${preOrderInfo.custBillEmail}');
                        $('#billMthdEmailTxt2').removeAttr("disabled").val('${preOrderInfo.custBillEmailAdd}');
                        
                        if(FormUtil.isNotEmpty('${preOrderInfo.custBillEmailAdd}')) {
                            $('#billMthdEmail2').prop("checked", true);
                        }
                    }
                    else if($('#typeId').val() == '964') { //Individual
        
                        console.log("fn_setBillGrp 2 typeId : "+$('#typeId').val());
                        console.log("custCntcEmail : "+$('#custCntcEmail').val());
                        console.log(FormUtil.isNotEmpty($('#custCntcEmail').val().trim()));
        
                        if(FormUtil.isNotEmpty($('#custCntcEmail').val().trim())) {
                            $('#billMthdEstm').prop("checked", true);
                            $('#billMthdEmail1').prop("checked", true).removeAttr("disabled");
                            $('#billMthdEmail2').removeAttr("disabled");
                            $('#billMthdEmailTxt1').removeAttr("disabled").val('${preOrderInfo.custBillEmail}');
                            $('#billMthdEmailTxt2').removeAttr("disabled").val('${preOrderInfo.custBillEmailAdd}');
                            
                            if(FormUtil.isNotEmpty('${preOrderInfo.custBillEmailAdd}')) {
                                $('#billMthdEmail2').prop("checked", true);
                            }
                        }
        
                        $('#billMthdSms').prop("checked", true);
                        $('#billMthdSms1').prop("checked", true).removeAttr("disabled").val('${preOrderInfo.custBillIsSms}');
                        $('#billMthdSms2').removeAttr("disabled").val('${preOrderInfo.CustBillIsSms2}');
                        
                        if(FormUtil.isNotEmpty('${preOrderInfo.CustBillIsSms2}')) {
                            $('#billMthdSms2').prop("checked", true);
                        }
                    }
                }
                else {

                    $('#grpOpt2').prop("checked", true);
        
                    $('#sctBillSel').removeClass("blind");
        
                    $('#billRem').prop("readonly", true).addClass("readonly");
                    
                    fn_loadBillingGroupByIdConv('${preOrderInfo.custBillCustId}', '${preOrderInfo.custBillId}');
                }

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
                
                fn_checkDocList(false);

                if(custInfo.codeName == 'Government') {
                    Common.alert('<spring:message code="sal.alert.msg.gvmtCust" />');
                }
            }
            else {
//              Common.alert('<b>Customer not found.<br>Your input customer ID :'+$("#searchCustId").val()+'</b>');
                Common.alert('<spring:message code="sal.alert.msg.custNotFound" arguments="'+_CUST_ID+'"/>');
            }
        });
    }
	
    function fn_loadBillingGroupByIdConv(custId, custBillId){
        Common.ajax("GET", "/sales/customer/selectBillingGroupByKeywordCustIDList.do", {custId : custId, custBillId : custBillId}, function(result) {
            if(result != null && result.length > 0) {
                fn_loadBillingGroup(result[0].custBillId, result[0].custBillGrpNo, result[0].billType, result[0].billAddrFull, result[0].custBillRem, result[0].custBillAddId);
            }
        });
    }
    
	function fn_getSvrPacComboConv(selVal, srvPacId){
	    
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
