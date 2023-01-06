<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

var resultBasicObject;
var resultSrvconfigObject;
var resultInstallationObject;
var defaultcTPackage = "9";
var myGridIDBillGroup;
var myGridIDProForma;
var defaultOrd = "0";
var sortingInfo = [];
sortingInfo[0] = { dataField : "salesOrdNo", sortType : 1 }; // 오름차순 1

var columnLayoutBill =[
                       {dataField:"salesOrdNo", headerText:"<spring:message code='pay.head.orderNo'/>"},
                       {dataField:"salesOrdId", headerText:"Sales Ord Id", visible:false},
                       {dataField:"refNo", headerText:"Ref No."},
                       {dataField:"orderDate", headerText:"Order Date", dataType : "date", formatString : "yyyy-mm-dd hh:MM:ss"},
                       {dataField:"status", headerText:"Status"},
                       {dataField:"appType", headerText:"App Type"},
                       {dataField:"product", headerText:"Product"},
                       {dataField:"custName", headerText:"Customer"},
                       {dataField:"custBillId", headerText:"Bill ID"},
                       {dataField:"proformaStus", headerText:"proformaStus", visible:false},
                       {dataField:"advStartDt", headerText:"advStartDt", visible:false},
                       {dataField:"advEndDt", headerText:"advEndDt", visible:false},
                       {dataField:"stkId", headerText:"stkId", visible:false},
                       {
	                       dataField : "undefined",
	                       headerText : " ",
	                       width : '10%',
	                       renderer : {
	                                type : "ButtonRenderer",
	                                labelText : "Select",
	                                onclick : function(rowIndex, columnIndex, value, item) {
	                                    $("#orderId").val(item.salesOrdId);
	                                    if (fn_chkProForma(item.salesOrdId)) {
	                                        return;
	                                    }
	                                    fn_SelectPO(item.salesOrdId);
	                                    $("#grid_wrap_ProForma").show();
	                                    $("#divBtnProForma").show();
	                                    $("#divTotalProForma").show();
	                                    $("#btnAddToProForma").show();
	                              }
	                       }
	                   }
                   ];

var columnLayoutProForma =[
						{dataField :"salesOrdId",  headerText : "SalesOrdId",      width: 150 ,editable : false, visible : false},
						{dataField :"salesOrdNo", headerText : "<spring:message code="pay.head.orderNO" />",   width: 150, editable : false },
						{dataField :"packType", headerText : "Month of Package", width: 150, editable : false },
						{dataField :"advPeriod", headerText : "Advance Period", width: 150, editable : false },
						{dataField :"disc", headerText : "Discount (%)", width: 150, editable : false },
						{dataField :"packPrice", headerText : "Package Price", width: 150, editable : false },
						{dataField :"salesmanCode", headerText : "Salesman Code", width: 150, editable : false },
						{dataField :"finalRentalFee", headerText : "Final Rental Fee", width: 150, editable : false },
						{dataField :"orderDt", headerText : "Order Date", width: 150, editable : false },
						{dataField :"orderStus", headerText : "Order Status", width: 150, editable : false },
						{dataField :"custName",  headerText : "<spring:message code="pay.head.customerName" />",      width: 140 ,editable : false },
						{dataField :"adStartDt",  headerText : "adStartDt",      width: 140 ,visible : false },
						{dataField :"adEndDt",  headerText : "adEndDt",      width: 140 ,visible : false },
						{dataField :"packOriPrice",  headerText : "packOriPrice",      width: 140 , visible : false}, //after discount
						{dataField :"remark",  headerText : "remark",      width: 140, visible : false }
                   ];

var gridProsBill = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 5,

};

var gridProsProForma = {
        editable: false,
        showRowCheckColumn : true,
        showStateColumn: false,
        pageRowCount : 5,
        showRowAllCheckBox : true,
        independentAllCheckBox : false,
        softRemoveRowMode:false
};

$(document).ready(function(){

    myGridIDBillGroup = AUIGrid.create("#grid_wrap_billGroup", columnLayoutBill, gridProsBill);
    myGridIDProForma = AUIGrid.create("#grid_wrap_ProForma", columnLayoutProForma, gridProsProForma);

    $("#grid_wrap_billGroup").hide();
    $("#grid_wrap_ProForma").hide();
    $("#btnAddToProForma").hide();
    $("#divBtnProForma").hide();
    $("#divTotalProForma").hide();
    AUIGrid.setSelectionMode(myGridIDBillGroup, "singleRow");

    $("#rbt").attr("style","display:none");
    $("#ORD_NO_RESULT").attr("style","display:none");

    $("#hidActBill").val("Y");
    $("#hidInsCheck").val("Y");

    $("#ORD_NO").keydown(function(key)  {
           if (key.keyCode == 13) {
               fn_doConfirm();
           }
    });
});

function fn_doConfirm() {

     Common.ajax("GET", "/sales/membership/selectMembershipFreeConF", $("#sForm").serialize(), function(result) {

        if (result == 0) {

            $("#cbt").attr("style", "display:inline");
            $("#ORD_NO").attr("style", "display:inline");
            $("#sbt").attr("style", "display:inline");
            $("#rbt").attr("style", "display:none");
            $("#ORD_NO_RESULT").attr("style", "display:none");

            $("#resultcontens").attr("style", "display:none");

            Common.alert("No order found or this order is not under complete status or activation status.");
            return;

        }
        else if (result[0].stkId == '1' || result[0].stkId == '651' || result[0].stkId == '218' || result[0].stkId == '689' || result[0].stkId == '216' || result[0].stkId == '687'
                || result[0].stkId == '3' || result[0].stkId == '653') {

            Common.alert("Product have been discontinued. Therefore, create new Pro-Forma invoice is not allowed");
            return;
        }
        else {

            if (fn_isActiveMembershipQuotationInfoByOrderNo()) {
                return;
            }

            if (fn_chkCustType()) {
                return;
            }

            $("#ORD_ID").val(result[0].ordId);
            $("#ORD_NO_RESULT").val(result[0].ordNo);

            fn_loadOrderPO($("#ORD_ID").val());

        }
    });
}

function fn_loadOrderPO(orderId){

    Common.ajax("GET","/payment/selectInvoiceBillGroupListProForma.do", {"orderId" : orderId} , function(result){
        if(result != null){
            $("#billGroupNo").val(result[0].custBillGrpNo);
            AUIGrid.setGridData(myGridIDBillGroup, result);
        }
     });
    $("#grid_wrap_billGroup").show();
}

    function fn_isActiveMembershipQuotationInfoByOrderNo() {
        var rtnVAL = false;
        Common.ajaxSync("GET", "/sales/membership/mActiveQuoOrder", {
            ORD_NO : $("#ORD_NO").val()
        }, function(result) {

            if (result.length > 0) {
                rtnVAL = true;
                Common.alert(" <b><spring:message code="sal.alert.msg.hasActQuotation" />[" + result[0].srvMemQuotNo + "]</b>");
                return true;
            }
        });

        return rtnVAL;
    }

    function fn_chkCustType() {
        var rtnVAL = false;

        Common.ajaxSync("GET", "/payment/chkCustType", {
            ordNo : $("#ORD_NO").val()
        }, function(result) {

            if (result.length > 0) {
            	if(result[0].typeId != "965"){ //965 = company
            		rtnVAL = true;
                    Common.alert("This order belongs to individual customer <br> (Only for corporate customer only)");
                    return true;
            	}

            	 if(result[0].appTypeId != "66"){ //66 = Rental
                     rtnVAL = true;
                     Common.alert("This order is " + result[0].appType + " order <br> (Only for Rental orders only)");
                     return true;
                 }

                 if(result[0].stusId != "4"){ //66 = Rental
                     rtnVAL = true;
                     Common.alert("This order is currently under " + result[0].stus + " status <br> (Only for Completed orders only)");
                     return true;
                 }
            }
        });

        return rtnVAL;
    }

    function fn_getDataInfo(orderId) {
        Common.ajax("GET", "/sales/membership/selectMembershipFreeDataInfo", {"ORD_ID" : orderId} , function(result) {

            resultInstallationObject = result.installation;
            resultBasicObject = result.basic;

            var billMonth = getOrderCurrentBillMonth();

            if (fn_CheckRentalOrder(billMonth)) {

            	 $("#packType").attr("disabled",false);
                 $("#SALES_PERSON").attr("disabled",false);
                 $("#txtRemark").attr("disabled",false);
                 $("#sale_confirmbt").attr("style", "display:block");
                 $("#sale_searchbt").attr("style", "display:block");

                 setText(result);
                 setPackgCombo();
            }
        });
    }

    function fn_outspro() {
        Common.ajax("GET", "/sales/membership/callOutOutsProcedure", $("#getDataForm").serialize(), function(result) {

            if (result.outSuts.length > 0) {
                $("#ordoutstanding").html(result.outSuts[0].ordOtstnd);
                $("#asoutstanding").html(result.outSuts[0].asOtstnd);
            }
        });
    }

    function setText(result) {

        resultBasicObject = result.basic;
        resultSrvconfigObject = result.srvconfig;

        $("#ORD_ID").val(result.basic.ordId);
        $("#orderNo").html(result.basic.ordNo);
        $("#finalRentalFee").html(result.basic.ordMthRental);

        $("#custId").html(result.basic.custId);
        $("#customerName").html(result.basic.custName);
        $("#STOCK_ID").val(result.basic.stockId);
        $("#hiddenOrderDt").val(result.basic.ordDt);
        $("#hiddenOrderStus").val(result.basic.ordStusName);
    }

    function fn_goCustSearch() {
        Common.popupDiv('/sales/ccp/searchOrderNoPop.do', $('#_searchForm_').serializeJSON(), null, true, '_searchDiv');
    }

    function fn_callbackOrdSearchFunciton(item) {
        $("#ORD_NO").val(item.ordNo);
        fn_doConfirm();

    }

    function fn_doReset() {
        $("#newProFormaPopupId").remove();
        fn_goNew();
    }

    function fn_goContactPersonPop() {
        Common.popupDiv("/sales/membership/memberFreeContactPop.do");
    }

    function fn_goNewContactPersonPop() {
        Common.popupDiv("/sales/membership/memberFreeNewContactPop.do");
    }

    function fn_addContactPersonInfo(objInfo) {

        fn_doClearPersion();

        $("#name").html(objInfo.name);
        $("#gender").html(objInfo.gender);
        $("#nric").html(objInfo.nric);
        $("#codename1").html(objInfo.codename1);
        $("#telM1").html(objInfo.telM1);
        $("#telO").html(objInfo.telO);
        $("#telR").html(objInfo.telR);
        $("#telf").html(objInfo.telf);
        $("#email").html(objInfo.email);
        $("#SAVE_CUST_CNTC_ID").val(objInfo.custCntcId);

    }

    function fn_doClearPersion() {

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

    function formatDate(date) {
        var d = new Date(date), month = '' + (d.getMonth() + 1), day = '' + d.getDate(), year = d.getFullYear();

        if (month.length < 2)
            month = '0' + month;
        if (day.length < 2)
            day = '0' + day;

        return [ year, month, day ].join('-');
    }

    function setPackgCombo() {
    	$("#txtPackagePrice").html("");

        $("#packpro").attr("checked", false);
        $("#cPromoCombox").attr("checked", false);


        if(fn_chkEligible()){
        	$("#hiddenEligible").val("Y");
        }else{
        	$("#hiddenEligible").val("N");
        }
        fn_packType_onChageEvent();
    }

    function fn_chkEligible(){

    	var rtnVAL = false;
        Common.ajaxSync("GET", "/payment/chkEligible", {ordNo : $("#ORD_NO").val()}, function(result) {
        	console.log("eligi" + result.promoEligible.advDisc);
            if (result.promoEligible.advDisc == 1 ){
                rtnVAL = true;
            }else{
            	rtnVAL = false;
            }
        });

        return rtnVAL;
    }

    function fn_packType_onChageEvent(){

        $("#SELPACKAGE_ID").val(defaultcTPackage);
        var packType = $("#packType").val();

        $("#DUR").val(packType);

        $("#hidInsCheck").val("Y");

        var adPeriod = packType == "12" ? "1" : "2";
        if($("#hiddenEligible").val() == "Y"){
        	var discountVal = adPeriod == "1" ? "5" : "10";
            $("#discount").val(discountVal);
        }else{
        	 $("#discount").val("0");
        }

        fn_getDiscPeriod($("#ORD_NO").val());
        fn_getMembershipPackageInfo(packType);

    }

    function fn_getDiscPeriod(ordNo){
        Common.ajax("GET", "/payment/getDiscPeriod.do", { ordNo : $("#ORD_NO").val()}, function(result) { //ahhh salesordid multiple

            if(result[0] != "" && result[0] != null){
                var discount = $("#discount").val();
                var insDiff = 60 - Math.abs(result[0].installment);

               if(discount == '5'){
                	if( insDiff < '12' ){
                		Common.alert("This billing group has less than 12 months installment");
                		$("#hidInsCheck").val("N");
                	}
                }else{
                	if( insDiff < '24' ){
                        Common.alert("This billing group has less than 24 months installment");
                        $("#hidInsCheck").val("N");
                    }
                }

                console.log("schlDT");
                console.log(result[0].schdulDt);
                $("#adStartDt").val(result[0].schdulDt);

                var endMonth = Math.abs($("#adStartDt").val().substring(0,2)) + 11;
                var endYear = $("#adStartDt").val().substring(3,7);

                console.log("111");
                console.log(endMonth);
                console.log(endYear);

                if(endMonth > 12){
                      endYear = Math.abs(endYear) + 1;
                      endMonth = Math.abs(endMonth) - 12;
                }

                if(endMonth < 10 & endMonth  >= 1){
                    endMonth = "0" + endMonth;
                }

                console.log("222");
                console.log(endMonth);
                console.log(endYear);

                $("#adEndDt").val(endMonth + "/" + endYear);

                var year = $("#adStartDt").val().substring(3,7);
                var month = $("#adStartDt").val().substring(0,2);

                if(month < 10 & month  >= 1){
                    month = "0" + month;
                }
                if(month < 1){
                    year = year - 1;
                    month = 12 - Math.abs(month);
                }
            }
            else{
                Common.alert("This billing group does not have Active bill");
                $("#hidActBill").val("N");
            }
        });

    }

    function fn_getMembershipPackageInfo(_id) {

        console.log("discount");
        console.log($("#hiddenEligible").val());
        console.log($("#discount").val());

        Common.ajax("GET", "/sales/membership/mPackageInfo", $("#getDataForm").serialize(), function(result) {

            if (result.packageInfo.srvMemPacId == null || result.packageInfo.srvMemPacId == "") {

                $("#HiddenHasPackage").val(0);
                $("#txtBSFreq").html("");
                $("#txtPackagePrice").html("");
                $("#hiddenPacOriPrice").val(0);

            }
            else {

                var pacYear = parseInt($("#DUR").val(), 10) / 12;
                var pacPrice = 0 ;
                //var pacPrice = Math.round((result.packageInfo.srvMemItmPrc * pacYear));
                if(pacYear == "1"){
                	pacPrice = parseInt($("#finalRentalFee").html(), 10) * 12;
                }else{
                	pacPrice = parseInt($("#finalRentalFee").html(), 10) * 24;
                }

                $("#zeroRatYn").val(result.packageInfo.zeroRatYn);
                $("#eurCertYn").val(result.packageInfo.eurCertYn);

                $("#HiddenHasPackage").val(1);
                $("#txtBSFreq").html(result.packageInfo.srvMemItmPriod + " <spring:message code="sal.text.month" />");
                $("#hiddentxtBSFreq").val(result.packageInfo.srvMemItmPriod);

                $("#srvMemPacId").val(result.packageInfo.srvMemPacId);

                if ($("#eurCertYn").val() == "N") {
                    $("#txtPackagePrice").html(Math.floor(pacPrice));
                    $("#hiddenPacOriPrice").val(Math.floor(pacPrice));
                }
                else {
                    $("#txtPackagePrice").html(pacPrice);
                    $("#hiddenPacOriPrice").val(pacPrice);
                }
            }

            $("#packpro").removeAttr("disabled");

            if($("#discount").val() != "0"){
            	var discount = $("#discount").val();
            	var discountPercnt = (100 - parseInt(discount)) / 100;
                var packPrice = $("#hiddenPacOriPrice").val();

                var discountPrice  = parseInt(packPrice) * discountPercnt

                $("#txtPackagePrice").html(discountPrice.toFixed(2));
            }
        });
    }

    function fn_discount_onChageEvent(){

        var discount = $("#discount").val();
        if(discount != "0") {
            var discountPercnt = (100 - parseInt(discount)) / 100;
            var packPrice = $("#hiddenPacOriPrice").val();

            var discountPrice  = parseInt(packPrice) * discountPercnt
            $("#txtPackagePrice").html(discountPrice.toFixed(2));
        }
        else{
        	fn_packType_onChageEvent();
        }
    }

    function fn_back() {
        $("#newProFormaPopupId").remove();
    }

    function fn_goSalesConfirm() {

        if ($("#SALES_PERSON").val() == "") {

            Common.alert("Please Key-In Sales Person Code. ");
            return;
        }

        Common.ajax("GET", "/sales/membership/paymentColleConfirm", {
            COLL_MEM_CODE : $("#SALES_PERSON").val()
        }, function(result) {

            if (result.length > 0) {

                $("#SALES_PERSON").val(result[0].memCode);
                $("#SALES_PERSON_DESC").html(result[0].name);
                $("#hiddenSalesPersonID").val(result[0].memId);

                $("#sale_confirmbt").attr("style", "display:none");
                $("#sale_searchbt").attr("style", "display:none");
                //$("#sale_resetbt").attr("style" ,"display:inline");
                $("#SALES_PERSON").attr("class", "readonly");

            }
            else {

                $("#SALES_PERSON_DESC").html("");
                Common.alert(" <spring:message code="sal.alert.msg.unableToFind" /> [" + $("#SALES_PERSON").val() + "] <spring:message code="sal.alert.msg.unableToFind2" />   ");
                return;
            }

        });
    }

    function fn_goSalesPerson() {

        Common.popupDiv("/sales/membership/paymentCollecter.do?resultFun=S");
    }

    function fn_goSalesPersonReset() {

        $("#sale_confirmbt").attr("style", "display:inline");
        $("#sale_searchbt").attr("style", "display:inline");
        $("#sale_resetbt").attr("style", "display:none");
        $("#SALES_PERSON").attr("class", "");
        $("#SALES_PERSON_DESC").html("");
        $("#hiddenSalesPersonID").val("");

    }

    function fn_doSalesResult(item) {

        if (typeof (item) != "undefined") {

            $("#SALES_PERSON").val(item.memCode);
            $("#SALES_PERSON_DESC").html(item.name);
            $("#hiddenSalesPersonID").val(item.memId);
            $("#sale_confirmbt").attr("style", "display:none");
            $("#sale_searchbt").attr("style", "display:none");
            $("#sale_resetbt").attr("style", "display:inline");
            $("#SALES_PERSON").attr("class", "readonly");

        }
        else {
            $("#SALES_PERSON").val("");
            $("#SALES_PERSON_DESC").html("");
            $("#SALES_PERSON").attr("class", "");
        }
    }

    function getOrderCurrentBillMonth() {
        var billMonth = 0;

        Common.ajaxSync("GET", "/sales/membership/getOrderCurrentBillMonth", {
            ORD_ID : $("#ORD_ID").val()
        }, function(result) {

            if (result.length > 0) {
                if (parseInt(result[0].nowDate, 10) > parseInt(result[0].rentInstDt, 10)) {

                    billMonth = 61;

                    return billMonth;

                }
                else {
                    Common.ajaxSync("GET", "/sales/membership/getOrderCurrentBillMonth", {
                        ORD_ID : $("#ORD_ID").val(),
                        RENT_INST_DT : 'SYSDATE'
                    }, function(_result) {

                        if (_result.length > 0) {
                            billMonth = _result[0].rentInstNo;
                        }

                    });
                }
            }
        });

        return billMonth;
    }

    function fn_save() {
    	fn_DoSaveProcess();
    }

    function fn_validRequiredField_Save() {

        var rtnMsg = "";
        var rtnValue = true;

        if (FormUtil.checkReqValue($("#adStartDt"))) {
            rtnMsg += "* Please select Advance Period start date<br />";
            rtnValue = false;
        }

        if (FormUtil.checkReqValue($("#adEndDt"))) {
            rtnMsg += "* Please select Advance Period start date<br />";
            rtnValue = false;
        }

        if (rtnValue == false) {
            Common.alert("<spring:message code="sal.alert.title.saveQuotationSummary" />" + DEFAULT_DELIMITER + rtnMsg);
        }

        return rtnValue;
    }

    function fn_CheckRentalOrder(billMonth) {
        var rtnMsg = "";
        var rtnValue = true;

        if (resultBasicObject.appTypeId == 66) {

            /*  if( $("#rentalStus").text() == "REG" ||$("#rentalStus").text() == "INV" ){ */
            if (resultBasicObject.rentalStus == "REG" || resultBasicObject.rentalStus == "INV") {

                if (billMonth > 60) {
                    Common.ajaxSync("GET", "/sales/membership/getOderOutsInfo", $("#getDataForm").serialize(), function(result) {

                        if (result != null) {
                            if (result.ordTotOtstnd > 0) {
                                rtnMsg += "* This order has outstanding. Membership purchase is disallowed.<br />";
                                rtnValue = false;
                            } else{
                                //webster lee 20072020:Added new validation
                                Common.ajaxSync("GET", "/sales/membership/getOutrightMemLedge", $("#getDataForm").serialize(), function(result1) {

                                    if(result1 != null) {
                                        if (result1.amt > 0) {
                                            rtnMsg +=  "This order has outstanding.<br />";
                                            rtnValue = false;
                                        }
                                    }

                                }, function(jqXHR, textStatus, errorThrown) {
                                    try {
                                        console.log("status : " + jqXHR.status);
                                        console.log("code : " + jqXHR.responseJSON.code);
                                        console.log("message : " + jqXHR.responseJSON.message);
                                        console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
                                    }
                                    catch (e) {
                                        console.log(e);
                                    }
                                    rtnMsg += jqXHR.responseJSON.message;
                                    rtnValue = false;
                                });
                            }

                        }

                    }, function(jqXHR, textStatus, errorThrown) {
                        try {
                            console.log("status : " + jqXHR.status);
                            console.log("code : " + jqXHR.responseJSON.code);
                            console.log("message : " + jqXHR.responseJSON.message);
                            console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
                        }
                        catch (e) {
                            console.log(e);
                        }

                        rtnMsg += jqXHR.responseJSON.message;
                        rtnValue = false;
                    });
                }

            }
            else {
                rtnMsg += "<spring:message code="sal.alert.msg.onlyRegOrINV" /><br>";
                rtnValue = false;
            }
        } else {
            Common.ajaxSync("GET", "/sales/membership/getOutrightMemLedge", $("#getDataForm").serialize(), function(result1) {

                if(result1 != null) {
                    if (result1.amt > 0) {
                        rtnMsg +=  "This order has outstanding.<br />";
                        rtnValue = false;
                    }
                }

            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    console.log("status : " + jqXHR.status);
                    console.log("code : " + jqXHR.responseJSON.code);
                    console.log("message : " + jqXHR.responseJSON.message);
                    console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
                }
                catch (e) {
                    console.log(e);
                }
                rtnMsg += jqXHR.responseJSON.message;
                rtnValue = false;
            });
        }


        if (rtnValue == false) {
        	$("#packType").attr("disabled",true);
            $("#SALES_PERSON").attr("disabled",true);
            $("#txtRemark").attr("disabled",true);
            $("#sale_confirmbt").attr("style", "display:none");
            $("#sale_searchbt").attr("style", "display:none");

            Common.alert("<spring:message code="sal.alert.title.rentalOrderValidation" />" + DEFAULT_DELIMITER + rtnMsg);

        }

        return rtnValue;
    }

    function fn_CheckSalesPersonCode() {

        if ($("#SALES_PERSON").val() == "") {

            Common.alert("<spring:message code="sal.alert.msg.keyInSalesPersonCode" /> ");
            return false;
        }
        return true;
    }

    function fn_unconfirmSalesPerson() {

        if ($("#hiddenSalesPersonID").val() == "") {
            Common.alert("<spring:message code="sal.alert.title.salesPersonConfirmation" />" + DEFAULT_DELIMITER + "<spring:message code="sal.alert.msg.salesPersonConfirmation" />");
            return false;

        }
        else {
        	//ahhh

        	 var pfItem = new Object();
        	 var packTypeInd = true;

       	     pfItem.salesOrdId = $("#ORD_ID").val();
       	     pfItem.salesOrdNo = $("#orderNo").html();
       	     pfItem.packType = $("#packType").val();
       	     pfItem.advPeriod = $("#adStartDt").val() + " - " + $("#adEndDt").val();
       	     pfItem.adStartDt = $("#adStartDt").val();
       	     pfItem.adEndDt = $("#adEndDt").val();
       	     pfItem.disc = $("#discount").val();
       	     pfItem.packPrice = $("#txtPackagePrice").html();
       	     pfItem.packOriPrice = $("#hiddenPacOriPrice").val();
       	     pfItem.salesmanCode = $("#SALES_PERSON").val();
       	     pfItem.finalRentalFee = $("#finalRentalFee").html();
       	     pfItem.orderDt = $("#hiddenOrderDt").val();
       	     pfItem.orderStus = $("#hiddenOrderStus").val();
       	     pfItem.custName = $("#customerName").html();
       	     pfItem.remark = $("#txtRemark").val();

       	     var allItems = AUIGrid.getGridData(myGridIDProForma);

            if (AUIGrid.isUniqueValue(myGridIDProForma, "salesOrdId", pfItem.salesOrdId)) {

            	for (var i = 0 ; i < allItems.length ; i++){
            		if(pfItem.packType != allItems[i].packType){
            			packTypeInd = false;
            		}
                }

                if(packTypeInd == false){
                	Common.alert("Kindly choose same Package Type");
                }else{
                	fn_addRow(pfItem);
                    fn_calTotalPackPrice();
                }
		    } else {
		      Common.alert("<spring:message code='service.msg.rcdExist'/>");
		      return;
		    }

        }
    }

    function fn_addRow(gItem) {
        AUIGrid.addRow(myGridIDProForma, gItem, "first");
      }

    function fn_calTotalPackPrice(){
    	//ahh
    	var totalPackPrice = 0;
        var totalPriceAllItems = AUIGrid.getGridData(myGridIDProForma);

       var ordCount = totalPriceAllItems.length;
       if(totalPriceAllItems.length > 0){
           for (var i = 0 ; i < totalPriceAllItems.length ; i++){
        	   totalPackPrice += parseFloat(totalPriceAllItems[i].packPrice);
           }
       }

       $("#txtTotalAmt").html(totalPackPrice.toFixed(2) + '(' + totalPriceAllItems.length + ')');
    }


    function fn_DoSaveProcess(_saveOption) {

    	var allItems = AUIGrid.getGridData(myGridIDProForma);
    	var data = {};
    	var orderIdArr = [];

        if(allItems.length > 0){

            var item = new Object();
            var rowList = [];

            for (var i = 0 ; i < allItems.length ; i++){
	            rowList[i] = {
	                    salesOrdNo : allItems[i].salesOrdNo,
	                    salesOrdId : allItems[i].salesOrdId,
	                    packType : allItems[i].packType,
	                    memCode :  allItems[i].salesmanCode,
	                    adStartDt : allItems[i].adStartDt,
	                    adEndDt : allItems[i].adEndDt,
	                    totalAmt: allItems[i].packPrice, //afterDiscount
	                    packPrice: allItems[i].packOriPrice, //Bfore discount  xx
	                    remark:  allItems[i].remark, //xx
	                    discount: allItems[i].disc,
	            }
	            orderIdArr[i] = {salesOrdId: allItems[i].salesOrdId};
            }

            data.all = rowList;

        }
        else {
        	Common.alert("Choose at least 1 order no for Pro Forma Invoice");
            return;
        }

    	 if(allItems != undefined){
    		  Common.ajax("POST", "/payment/saveNewProForma.do", data, function(result) {
	              Common.alert(result.message, fn_saveclose);
	              $("#popup_wrap").remove();
	              //fn_genPFInvoice(result.data);
	              fn_selectListAjax();

	        });
    	}
    }

    function fn_saveclose() {
        newProFormaPopupId.remove();
    }

    function fn_SelectPO(orderId)
    {
         $("#resultcontens").show();
         fn_getDataInfo(orderId);

         if("${SESSION_INFO.userTypeId}" == "1"  || "${SESSION_INFO.userTypeId}" == "2" ){
             $("#cEmplo option[value='0']").attr('selected', 'selected');
             $('#cEmplo').attr("disabled",true);
         }

         if ('${SESSION_INFO.userTypeId}' == 1 || '${SESSION_INFO.userTypeId}' == 2 || '${SESSION_INFO.userTypeId}' == 3 || '${SESSION_INFO.userTypeId}' == 7) {
             $("#SALES_PERSON").val("${SESSION_INFO.userName}");
             $("#sale_confirmbt").hide();
             $("#sale_searchbt").hide();
             fn_goSalesConfirm();
         }
    }

     function fn_chkProForma(){
    	 var rtnVAL = false;
    	 var selectedItems = AUIGrid.getSelectedItems(myGridIDBillGroup);

         Common.ajaxSync("GET", "/payment/chkProForma", {
             ordNo :  selectedItems[0].item.salesOrdNo
         }, function(result) {

            if(result.length > 0){

        	 var today = new Date();
             var startDt = result[0].advStartDt;
             var endDt = result[0].advEndDt;

             today = Date.parse(today);
             var parseStart = Date.parse(startDt);
             var parseEnd = Date.parse(endDt);


        		 if((today <= parseEnd && today >= parseStart)) {
                     rtnVAL = true;
                     Common.alert("This order is still within the date of invoice period <br /> Invoice Period: " + result[0].advStartDt + " - " + result[0].advEndDt);
                     return true;
        		 }else{
        			 rtnVAL = true;
                     Common.alert("This order is already created Pro-Forma Invoice and under " + result[0].stusName + " status");
                     return true;
        		 }
        	 }
         });
         return rtnVAL;
    }

	$("#btnAddToProForma").click(function(){
	    var billMonth = getOrderCurrentBillMonth();

	    if (fn_validRequiredField_Save() == false)
	        return;

	    if( $("#hidActBill").val() == "N"){
            Common.alert("This billing group does not have Active bill");
            return;
        }

        if( $("#hidInsCheck").val() == "N"){
            Common.alert("This billing group has less than 12 or 24 months installment");
            return;
        }

	    if (fn_CheckRentalOrder(billMonth)) {
	        if (fn_CheckSalesPersonCode()) {
	            fn_unconfirmSalesPerson();
	        }
	    }
	});

	$("#btnRemoveProForma").click(function(){

	var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridIDProForma);
	var allItems = AUIGrid.getGridData(myGridIDProForma);
	var billGroupItems = AUIGrid.getGridData(myGridIDBillGroup);

	if (checkedItems.length > 0){
	    var item = new Object();
	    var rowList = [];
	    var index = 0;
	    for (var i = checkedItems.length-1 ; i >= 0; i--){

	        rowList[index] = {
		                      salesOrdNo : checkedItems[i].salesOrdNo,
		                      salesOrdId : checkedItems[i].salesOrdId,
		                      refNo : checkedItems[i].refNo,
		                      orderDate : checkedItems[i].orderDate,
		                      status : checkedItems[i].status,
		                      appType : checkedItems[i].appType,
		                      product : checkedItems[i].product,
		                      custName : checkedItems[i].custName,
		                      custBillId : checkedItems[i].custBillId,
		                      proformaStus : checkedItems[i].proformaStus,
		                      advStartDt : checkedItems[i].advStartDt,
		                      advEndDt : checkedItems[i].advEndDt,
		                      stkId : checkedItems[i].stkId,
	                      }
	        index++;
	   }

	   if(rowList.length > 0){
		    var chkRow = true;
	        for (var i = 0 ; i  < rowList.length ; i++){
	            var salesOrdNo = rowList[i].salesOrdNo;

	            for (var j = 0 ; j  < billGroupItems.length ; j++){
	                if(salesOrdNo ==  billGroupItems[j].salesOrdNo){
	                    chkRow = false;
	                }
	            }

	            if(chkRow){
	                AUIGrid.addRow(myGridIDBillGroup, rowList[i], "first");
	            }

	       }
	       AUIGrid.setSorting(myGridIDBillGroup, sortingInfo);
	    }

	    AUIGrid.removeCheckedRows(myGridIDProForma);
	    fn_calTotalPackPrice();

	    }else{
	        Common.alert("<spring:message code='pay.alert.removeLatestOne'/>");
	    }
	 });

    function fn_genPFInvoice(refNo) {

    	$("#reportPDFForm #reportFileName").val('/payment/ProformaInvoice_PDF.rpt');
    	$("#reportPDFForm #v_adv1Boolean").val(0);
        $("#reportPDFForm #v_adv2Boolean").val(0);
        $("#reportPDFForm #v_noadv1Boolean").val(0);
        $("#reportPDFForm #v_noadv2Boolean").val(0);
        $("#reportPDFForm #v_refNo").val(refNo);
        //$("#reportPDFForm #v_orderId").val(refNo); //get order id arr
        $("#reportPDFForm #viewType").val("PDF");
        $("#reportPDFForm #reportDownFileName").val('PUBLIC_TaxInvoice_Proforma');
        //packtype
        if ($("#advance1").is(":checked")) $("#reportPDFForm #v_adv1Boolean").val(1);
        if ($("#advance2").is(":checked")) $("#reportPDFForm #v_adv2Boolean").val(1);
        if ($("#no_advance1").is(":checked")) $("#reportPDFForm #v_noadv1Boolean").val(1);
        if ($("#no_advance2").is(":checked")) $("#reportPDFForm #v_noadv2Boolean").val(1);
        Common.report("reportPDFForm");
    }

</script>



<form id="getDataForm" method="post">
<div style="display:none">
    <input type="text" name="ORD_ID"     id="ORD_ID"/>
    <input type="text" name="STOCK_ID"  id="STOCK_ID"/>
    <input type="text" name="SELPACKAGE_ID"  id="SELPACKAGE_ID"/>
    <input type="text" name="DUR"  id="DUR"/>
    <input type="text" name="hiddenPacOriPrice"  id="hiddenPacOriPrice"/>
    <input type="text" name="hiddenOrderDt"  id="hiddenOrderDt"/>
    <input type="text" name="hiddenOrderStus"  id="hiddenOrderStus"/>
    <input type="text" name="hiddenEligible"  id="hiddenEligible"/>
</div>
</form>

<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="" />
    <input type="hidden" id="v_refNo" name="v_refNo" />
    <input type="hidden" id="v_orderId" name="v_orderId" />
    <input type="hidden" id="v_adv1Boolean" name="v_adv1Boolean" />
    <input type="hidden" id="v_adv2Boolean" name="v_adv2Boolean" />
    <input type="hidden" id="v_noadv1Boolean" name="v_noadv1Boolean" />
    <input type="hidden" id="v_noadv2Boolean" name="v_noadv2Boolean" />
    <input type="hidden" id="emailSubject" name="emailSubject" value="" />
    <input type="hidden" id="emailText" name="emailText" value="" />
    <input type="hidden" id="emailTo" name="emailTo" value="" />
    <input type="hidden" id ="reportDownFileName" name="reportDownFileName" value=""/>
</form>

<div id="popup_wrap" class="popup_wrap "><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Pro-Forma Invoice</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="nc_close"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="height:450px"><!-- pop_body start -->

<section id="content"><!-- content start -->

<section class="search_table"><!-- search_table start -->
<form action="#"   id="sForm"  name="sForm" method="post" >
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td>
           <input type="text" title="" id="ORD_NO" name="ORD_NO" placeholder="" class="" />
           <p class="btn_sky"  id='cbt'> <a href="#" onclick="javascript: fn_doConfirm()"> <spring:message code="sal.btn.confirm" /></a></p>
           <p class="btn_sky" id='sbt'><a href="#" onclick="javascript: fn_goCustSearch()"><spring:message code="sal.btn.search" /></a></p>
           <input type="text" title="" id="ORD_NO_RESULT" name="ORD_NO_RESULT"   placeholder="" class="readonly " readonly="readonly" />
           <p class="btn_sky" id="rbt"> <a href="#" onclick="javascript :fn_doReset()"><spring:message code="sal.btn.reselect" /></a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<section>
  <!-- grid_wrap start -->
  <article id="grid_wrap_billGroup" class="grid_wrap"></article>
  <!-- grid_wrap end -->
</section>

<section>
<div  id="resultcontens"  style="display:none">

<form action="#"   id="sForm"  name="saveForm" method="post"   onsubmit="return false;">

        <aside class="title_line"><!-- title_line start -->
        <h3>Pro Forma Information</h3>
        </aside><!-- title_line end -->

        <section class="search_table"><!-- search_table start -->
        <form action="#" method="post"  id='collForm' name ='collForm'>
        <div style="display: none">
            <input type="text" name="hidActBill" id="hidActBill"/>
            <input type="text" name="hidInsCheck" id="hidInsCheck"/>
         </div>


        <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
             <col style="width: 130px" />
		     <col style="width: 350px" />
		     <col style="width: 170px" />
		     <col style="width: *" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row"><spring:message code="sal.text.ordNo" /></th>
            <td><span id='orderNo' ></span></td>
            <th scope="row"><spring:message code="sal.text.custName" /></th>
            <td><span id='customerName'></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.typeOfPack" /></th>
            <td>
            <select  id="packType"   name= "packType" onChange="fn_packType_onChageEvent()" >
                <option value="12" >1 Year</option>
                <option value="24" >2 Year</option>
            </select>
            </td>
            <th scope="row"><spring:message code="sal.title.text.finalRentalFees" /></th>
            <td><span id="finalRentalFee"></span></td>
        </tr>
        <tr>
			<th scope="row">Advance Period</th>
			<td>
		        <div class="date_set w100p"><!-- date_set start -->
		        <p><input type="text"  placeholder="MM/YYYY" class="j_date2 w100p"  id="adStartDt" name="adStartDt" disabled="disabled" class="readonly "/></p>
		        <span><spring:message code="sal.text.to" /></span>
		        <p><input type="text"  placeholder="MM/YYYY" class="j_date2 w100p"  id="adEndDt" name="adEndDt" disabled="disabled" class="readonly "/></p>
		        </div><!-- date_set end -->
	        </td>
	        <th scope="row"><spring:message code="sal.text.packPrice" /></th>
            <td><span id='txtPackagePrice'></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.title.text.discount" /></th>
            <td>
            <select  id="discount"   name= "discount" onChange="fn_discount_onChageEvent()" disabled="disabled" >
                <option value="0" >Not Eligible</option>
                <option value="5" >5%</option>
                <option value="10" >10%</option>
            </select>
            </td>
            <th scope="row"></th><td></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.salPersonCode" /></th>
            <td><input type="text" title="" placeholder="" class=""  style="width:100px" id="SALES_PERSON" name="SALES_PERSON"  />
                <p class="btn_sky"  id="sale_confirmbt" ><a href="#" onclick="javascript:fn_goSalesConfirm()"><spring:message code="sal.btn.confirm" /></a></p>
                <p class="btn_sky"  id="sale_searchbt"><a href="#" onclick="javascript:fn_goSalesPerson()" ><spring:message code="sal.btn.search" /></a></p>
                <p class="btn_sky"  id="sale_resetbt" style="display:none"><a href="#" onclick="javascript:fn_goSalesPersonReset()" ><spring:message code="sal.btn.reset" /></a></p>
            </td>
            <th scope="row"><spring:message code="sal.text.salPersonCode" /></th>
            <td><span id="SALES_PERSON_DESC"  name="SALES_PERSON_DESC"></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.remark" /></th>
            <td><textarea rows="5" id='txtRemark' name=''></textarea></td>
            <th scope="row"></th>
            <td></td>
        </tr>
        </tbody>
        </table><!-- table end -->
        </form>
        </section><!-- search_table end -->

        <ul class="center_btns">
            <li><p class="btn_blue2"><a href="#" id="btnAddToProForma">Add to Pro Forma</a></p></li>
        </ul><br />
</form>

</div>
</section>

<section>
  <!-- grid_wrap start -->
  <article id="grid_wrap_ProForma" class="grid_wrap"></article>
  <div id='divTotalProForma'>
    <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
             <col style="width: 130px" />
             <col style="width: 350px" />
             <col style="width: 170px" />
             <col style="width: *" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row">Total Amount<br />(Total Orders)</th>
            <td><span id='txtTotalAmt' ></span></td>
            <th scope="row"></th><td></td>
        </tr>
        </tbody>
    </table><!-- table end -->
  </div>
  <div id='divBtnProForma'>
   <ul class="center_btns mt20">
    <li><p class="btn_blue2"><a href="#" id="btnRemoveProForma">Remove from Pro Forma</a></p></li>
    <li><p class="btn_blue2"><a href="#"  onclick="javascript:fn_save()">Save</a></p></li>
   </ul>
   </div>


  <!-- grid_wrap end -->
</section>

</section><!-- content end -->


</section>

</div>
