
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<style>

/* 커스텀 행 스타일 */
.my-row-style {
    background:#FFB2D9;
    font-weight:bold;
    color:#22741C;
}
</style>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/util.js"></script>

<script type="text/javaScript" language="javascript">

var oListGridID;
var bsHistoryGridID;

var resultBasicObject;
var resultSrvconfigObject;
var resultInstallationObject;
var defaultcTPackage = "9";

var SSTValue = "${sstValue}";

$(document).ready(function(){

    createAUIGridHList();
    createAUIGridOList();

    $("#cPromo").prop("disabled", true);
    $("#cPromo").attr("class", "disabled");

    $("#rbt").attr("style","display:none");
    $("#ORD_NO_RESULT").attr("style","display:none");


    $("#ORD_NO").keydown(function(key)  {
            if (key.keyCode == 13) {
                fn_doConfirm();
            }
     });

});





	function fn_doConfirm() {
		Common.ajax("GET", "/sales/membership/selectMembershipFreeConF", $("#sForm").serialize(), function(result) {
			console.log(result);

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

				Common.alert("Product have been discontinued. Therefore, create new quotation is not allowed");
				return;

			}
			else {

				if (fn_isActiveMembershipQuotationInfoByOrderNo()) {
					return;
				}

				$("#ORD_ID").val(result[0].ordId);
				$("#ORD_NO_RESULT").val(result[0].ordNo);

			    if (fn_svmSubscriptionEligibility()){
                    return;
                }

				fn_getDataInfo();

				fn_outspro();

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
		});
	}

	function fn_isActiveMembershipQuotationInfoByOrderNo() {
		var rtnVAL = false;
		Common.ajaxSync("GET", "/sales/membership/mActiveQuoOrder", {
			ORD_NO : $("#ORD_NO").val()
		}, function(result) {
			console.log(result);

			if (result.length > 0) {
				rtnVAL = true;
				Common.alert(" <b><spring:message code="sal.alert.msg.hasActQuotation" />[" + result[0].srvMemQuotNo + "]</b>");
				return true;
			}
		});

		return rtnVAL;
	}

	 function fn_svmSubscriptionEligibility() {
	        var rtnVAL = false;
	        Common.ajaxSync("GET", "/sales/membership/mSubscriptionEligbility", {
	            ORD_NO : $("#ORD_NO").val(),
	            ORD_ID : $("#ORD_ID").val()
	        }, function(data) {
	               if (data != null) {
	            	if(data.result == false){
	                    rtnVAL = true;

	                    var option = {
	                            title : data.title,
	                            content : data.message,
	                            isBig : false
	                          };

	                    Common.alertBase(option);
	                }
	            }
	        });

	        return rtnVAL;
	    }

	function fn_getDataInfo() {
		Common.ajax("GET", "/sales/membership/selectMembershipFreeDataInfo", $("#getDataForm").serialize(), function(result) {
			console.log(result);

			resultInstallationObject = result.installation;
			resultBasicObject = result.basic;

			var billMonth = getOrderCurrentBillMonth();

			if (fn_CheckRentalOrder(billMonth)) {
				$("#cbt").attr("style", "display:none");
				$("#ORD_NO").attr("style", "display:none");
				$("#sbt").attr("style", "display:none");

				$("#rbt").attr("style", "display:inline");
				$("#ORD_NO_RESULT").attr("style", "display:inline");
				$("#resultcontens").attr("style", "display:inline");

				setText(result);
				setPackgCombo();
			}
		});
	}

	function fn_outspro() {
		Common.ajax("GET", "/sales/membership/callOutOutsProcedure", $("#getDataForm").serialize(), function(result) {
			console.log(result);

			if (result.outSuts.length > 0) {
				$("#ordoutstanding").html(result.outSuts[0].ordOtstnd);
				$("#asoutstanding").html(result.outSuts[0].asOtstnd);
			}
		});
	}

	function setText(result) {
		resultBasicObject = result.basic;
		resultSrvconfigObject = result.srvconfig;

		$("#ordNo").html(result.basic.ordNo);
		$("#ordDt").html(result.basic.ordDt);
		$("#ORD_DATE").html(result.basic.orgOrdDt);
		$("#InstallmentPeriod").html(result.basic.InstallmentPeriod);
		$("#ordStusName").html(result.basic.ordStusName);
		$("#rentalStus").html(result.basic.rentalStus);
		$("#appTypeDesc").html(result.basic.appTypeDesc);
		$("#ordRefNo").html(result.basic.ordRefNo);
		$("#stockCode").html(result.basic.stockCode);
		$("#stockDesc").html(result.basic.stockDesc);
		$("#custId").html(result.basic.custId);
		$("#custName").html(result.basic.custName);
// 		$("#custNric").html(result.basic.custNric);
		$("#custType").html(result.basic.custType);

		$("#CUST_ID").val(result.basic.custId);
		$('#CUST_TYPE_ID').val(result.basic.custTypeId);
		$("#STOCK_ID").val(result.basic.stockId);

		$("#SAVE_SRV_CONFIG_ID").val(result.srvconfig.configId);
		$("#coolingOffPeriod").html(result.basic.coolOffPriod);

		if(result.srvExpiry){
			$('#hiddenMonthExpired').val(result.srvExpiry.monthExpired);
		}

		var address = result.installation.instAddrDtl + " " + result.installation.instStreet + " " + result.installation.instArea + " " + result.installation.instPostcode + " "
				+ result.installation.instCity + " " + result.installation.instState + " " + result.installation.instCountry;

		//$("#address").html();

		$("#installNo").html(result.installation.lastInstallNo);
		$("#installDate").html(result.installation.lastInstallDt);

		if (result.basic.appTypeCode == "INS") {
			$("#InstallmentPeriod").html(result.basic.InstallmentPeriod);
		}
		else {
			$("#InstallmentPeriod").html("-");
		}

		if (result.basic.appTypeCode == "REN") {
			$("#rentalStus").html(result.basic.rentalStus);
		}
		else {
			$("#rentalStus").html("-");
		}

		$("#TO_YYYYMM").val(result.srvconfig.add12todate);
		$("#EX_YYYYMM").val(result.srvconfig.add12expiredate);

		$("#expire").html(result.srvconfig.lastSrvMemExprDate);

		// $("#CVT_LAST_SRV_MEM_EXPR_DATE").val(result.srvconfig.cvtLastSrvMemExprDate);
		//  $("#CVT_NOW_DATE").val(result.srvconfig.cvtNowDate);

		//20190917 Vannie add to get min period for earlybird promo
		if (result.srvconfig.lastSrvMemExprDate != undefined){
			fn_newGetExpDate(result);
			fn_getMaxPeriodEarlyBirdPromo(result.srvconfig.lastSrvMemExprDate);
		}else{
			$("#HiddenIsCharge").val(0);
		}
		fn_setTerm();
		fn_getDataCPerson();
		fn_getDatabsHistory();
		fn_getDatabsOList();
	}

	function fn_goCustSearch() {
		Common.popupDiv('/sales/ccp/searchOrderNoPop.do', $('#_searchForm_').serializeJSON(), null, true, '_searchDiv');
	}

	function fn_callbackOrdSearchFunciton(item) {
		console.log(item);
		$("#ORD_NO").val(item.ordNo);
		fn_doConfirm();

	}

	function fn_doReset() {
		$("#_NewQuotDiv1").remove();
		fn_goNewQuotation();
	}

	function fn_setTerm() {
		$("#term").html();
		$("#isCharge").html();
	}

	function fn_goContactPersonPop() {
		Common.popupDiv("/sales/membership/memberFreeContactPop.do");
	}

	function fn_goNewContactPersonPop() {
		Common.popupDiv("/sales/membership/memberFreeNewContactPop.do");
	}

	function fn_addContactPersonInfo(objInfo) {
		console.log(objInfo);

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

	/*cPerson*/
	function fn_getDataCPerson() {
		Common.ajax("GET", "/sales/membership/selectMembershipFree_cPerson", $("#getDataForm").serialize(), function(result) {
			console.log(result);
			//custCntc_Id     custInitial    codeName     nameName    dob    gender     raceId     codename1     telM1     telM2     telO     telR     telf     nric     pos     email     dept     stusCodeId     updUserId     updDt     idOld     dcm     crtUserId     crtDt
			//set 1ros

			fn_doClearPersion();

			$("#name").html(result[0].name);
			$("#gender").html(result[0].gender);
			$("#nric").html(result[0].nric);
			$("#codename1").html(result[0].codename1);
			$("#telM1").html(result[0].telM1);
			$("#telO").html(result[0].telO);
			$("#telR").html(result[0].telR);
			$("#telf").html(result[0].telf);
			$("#email").html(result[0].email);
			$("#SAVE_CUST_CNTC_ID").val(result[0].custCntcId);

		});
	}

	/*bs_history*/
	function fn_getDatabsHistory() {
		Common.ajax("GET", "/sales/membership/selectMembershipFree_bs", $("#getDataForm").serialize(), function(result) {
			console.log(result);

			AUIGrid.setGridData(bsHistoryGridID, result);
			AUIGrid.resize(bsHistoryGridID, 1120, 250);

		});
	}

	/*newGetExpDate*/
	function fn_newGetExpDate(old_result) {
		Common.ajaxSync("GET", "/sales/membership/newGetExpDate", $("#getDataForm").serialize(), function(result) {
			console.log(result);

			if (result.expDate.expint <= 0) {
				$("#HiddenIsCharge").val(0);
				$("#isCharge").html("No");
				$("#term").html("<font color='green'> <spring:message code="sal.text.underMembership" /> </font>");

			}
			else if (result.expDate.expint > 0 && old_result.basic.coolOffPriod >= result.expDate.expint) {

				$("#HiddenIsCharge").val(0);
				$("#isCharge").html("No");
				$("#term").html("<font color='brown'> <spring:message code="sal.text.underCoolingOff" /> </font>");

			}
			else {
				$("#HiddenIsCharge").val(1);
				$("#isCharge").html("YES");
				$("#term").html("<font color='red'> <spring:message code="sal.text.passedCoolingOff" /> </font>");
			}

			if ($("#HiddenIsCharge").val() != "0") {
				$("#cPromo").prop("disabled", false);
				$("#cPromo").attr("class", "");
			}

		});

	}


	/*fn_getMaxPeriodEarlyBirdPromo*/
	function fn_getMaxPeriodEarlyBirdPromo(old_result) {

		$("#MBSH_EXP_DT").val(old_result.substring(6, 10) + old_result.substring(3, 5));

		var str1 = $("#MBSH_EXP_DT").val().substring(0, 4) + "-" + $("#MBSH_EXP_DT").val().substring(4);

		Common.ajax("GET", "/sales/membership/getMaxPeriodEarlyBirdPromo", $("#getDataForm").serialize(), function(result) {
			console.log(result);

			var dateOne = new Date(result.getMaxPeriodEarlyBirdPromo.strprmodt); //mbship_exp_dt - 4 months

			var dateTwo = new Date(str1); //mbship_exp_dt
			var lastDayofDt2 = new Date(dateTwo.getFullYear(), dateTwo.getMonth() + 1, 0);

			var dateNow = new Date();
			var lastDayofDtNow = new Date(dateNow.getFullYear(), dateNow.getMonth() + 1, 0);

			dateOne = formatDate(dateOne.toDateString());
			dateNow = formatDate(dateNow.toDateString());
			lastDayofDt2 = formatDate(lastDayofDt2.toDateString());
			lastDayofDtNow = formatDate(lastDayofDtNow.toDateString());

			console.log(dateOne + " " + dateNow + " " + lastDayofDt2 + " " + lastDayofDtNow);
			console.log(dateNow <= lastDayofDt2);
			console.log(dateNow <= lastDayofDtNow);
			if (dateNow <= lastDayofDt2 && dateNow <= lastDayofDtNow) { //eligible for earlybird promo
				$("#hiddenEarlyBirdPromo").val(1);
			}
			else {
				$("#hiddenEarlyBirdPromo").val(0);
			}

			console.log($("#hiddenEarlyBirdPromo").val());
		});
	}

	function formatDate(date) {
		var d = new Date(date), month = '' + (d.getMonth() + 1), day = '' + d.getDate(), year = d.getFullYear();

		if (month.length < 2)
			month = '0' + month;
		if (day.length < 2)
			day = '0' + day;

		return [ year, month, day ].join('-');
	}

	/*oList*/
	function fn_getDatabsOList() {
		Common.ajax("GET", "/sales/membership/newOListuotationList", $("#getDataForm").serialize(), function(result) {
			console.log(result);

			AUIGrid.setGridData(oListGridID, result);
			AUIGrid.resize(oListGridID, 1120, 250);

			if ($("#HiddenIsCharge").val() == "0") {
				return;
			}

			changeRowStyleFunction();

		});
	}

	function setPackgCombo() {
		doGetCombo('/sales/membership/getSrvMemCode?SALES_ORD_ID=' + $("#ORD_ID").val(), '', defaultcTPackage, 'cTPackage', 'S', '');
		fn_cTPackage_onchangeEvt();

	}

	function fn_cTPackage_onchangeEvt() {

		$("#cYear").removeAttr("disabled");
		$("#cYear").val("12");
		$("#txtPackagePrice").html("");
		$("#txtFilterCharge").html("");
		// $('#cPromotionpac option').remove();
		//  $('#cPromo option').remove();

		$("#packpro").attr("checked", false);
		$("#cPromoCombox").attr("checked", false);

		fn_cYear_onChageEvent();

	}

	function fn_cYear_onChageEvent() {

		//set clear
		fn_SubscriptionYear_initEvt();

		$("#SELPACKAGE_ID").val(defaultcTPackage);
		$("#DUR").val($("#cYear").val().trim());

		//set getMembershipPackageInfo
		fn_getMembershipPackageInfo($("#cYear").val().trim());

		fn_getMembershipPackageFilterInfo();

		fn_getFilterPromotionAmt();

	}

	function fn_getFilterPromotionAmt() {

		if ($("#HiddenIsCharge").val() != "0") {
			Common.ajax("GET", "/sales/membership/getFilterPromotionAmt.do", {
				SALES_ORD_NO : resultBasicObject.ordNo,
				SRV_PAC_ID : $('#SELPACKAGE_ID').val()
			}, function(result) {
				console.log(result);

				if (null != result) {
					$("#txtFilterCharge").html(result.normaAmt);
				}

			});
		}
	}

	function fn_onChange_cPromotionpac(o) {

		$('#txtPackagePrice').html($('#hiddenPacOriPrice').val());

		if ($("#cPromotionpac").val().trim() > 0) {

			var isProc = true;

			if ($("#cPromotionpac").val() == 542) {

				var CVT_LAST_SRV_MEM_EXPR_DATE = parseInt(resultSrvconfigObject.cvtLastSrvMemExprDate, 10);
				var CVT_NOW_DATE = parseInt(resultSrvconfigObject.cvtNowDate, 10);

				if (CVT_LAST_SRV_MEM_EXPR_DATE >= CVT_NOW_DATE) {

					isProc = true;

				}
				else {
					isProc = false;
				}
			}

			if ($("#cPromotionpac").val() == 31867 || $("#cPromotionpac").val() == 31871) {
				if ('${SESSION_INFO.userId}' == '102337' || '${SESSION_INFO.userId}' == '97507' || '${SESSION_INFO.userId}' == '80161') {
					isProc = true;
				}
				else {
					isProc = false;
				}
			}

			if (isProc) {

				var cPromotion = 0;
				if (null == $("#cPromotionpac").val().trim() || "" == $("#cPromotionpac").val().trim()) {
					cPromotion = 0;
				}
				else {
					cPromotion = $("#cPromotionpac").val().trim();
				}

				$("#PROMO_ID").val($("#cPromotionpac").val().trim());

				Common.ajax("GET", "/sales/membership/getPromoPricePercent", $("#getDataForm").serialize(), function(result) {
					console.log(result);

					if (result.length > 0) {

						// var oriprice                = Number($("#hiddenPacOriPrice").val()) ;
						//pacYear Added by Kit - 20180619
						var pacYear = parseInt($("#DUR").val(), 10) / 12;
// 						var oriprice = Number($("#hiddenNomalPrice").val()) / pacYear;
						var oriprice = Number($("#hiddenPacPriceB4Sst").val()) / pacYear;
						var promoPrcPrcnt = Number(result[0].promoPrcPrcnt);
						var promoAddDiscPrc = Number(result[0].promoAddDiscPrc);

						if (result[0].promoDiscType == "0") { //%

	                        if(Number(SSTValue) > 0){
								$("#txtPackagePrice").html("");
	                            // $("#txtPackagePrice").html(  (oriprice -  Math.floor(  ( oriprice * ( promoPrcPrcnt /100 )) - promoAddDiscPrc  )) );

// 	                            var t0 = Math.floor(oriprice - (oriprice * (promoPrcPrcnt / 100))) * pacYear;
	                            var t0 = Math.floor((oriprice * pacYear) * (100 - promoPrcPrcnt)/100);
                                var t1 = FormUtil.roundNumber((t0 * (100 + Number(SSTValue)) / 100), 2);


	                            var t2 = 0;
	                            if ($("#eurCertYn").val() == "N") {
	                                //t2 =    (t1 -  promoAddDiscPrc) * 100 /106; -- without GST 6% edited by TPY 23/05/2018
	                                t2 = (t1 - promoAddDiscPrc)
	                                $("#hiddenNomalPrice").val(Number(FormUtil.roundNumber(t1,2)));

	                            }
	                            else {
	                                t2 = t1 - promoAddDiscPrc;
	                            }

	                            var t3 = FormUtil.roundNumber(t2,2);
	                            $("#txtPackagePrice").html(Number(t3));

                            }else{ // else of fn_SstStart

                            	$("#txtPackagePrice").html("");
                                // $("#txtPackagePrice").html(  (oriprice -  Math.floor(  ( oriprice * ( promoPrcPrcnt /100 )) - promoAddDiscPrc  )) );

//                                 var t1 = Math.floor(oriprice - (oriprice * (promoPrcPrcnt / 100))) * pacYear;
                                var t1 = Math.floor((oriprice * pacYear) * (100 - promoPrcPrcnt)/100);

                                var t2 = 0;
                                if ($("#eurCertYn").val() == "N") {
                                    //t2 =    (t1 -  promoAddDiscPrc) * 100 /106; -- without GST 6% edited by TPY 23/05/2018
                                    t2 = (t1 - promoAddDiscPrc)
                                    $("#hiddenNomalPrice").val(Number(Math.floor(t1)));

                                }
                                else {
                                    t2 = t1 - promoAddDiscPrc;
                                }

                                var t3 = Math.floor(t2);
                                $("#txtPackagePrice").html(Number(t3));
                            }
						}
						else if (result[0].promoDiscType == "1") { //amt

	                        if(Number(SSTValue) > 0){
	                            //var t1 = (((oriprice - promoPrcPrcnt)* pacYear) - promoAddDiscPrc) * ((100 + SSTValue) / 100);
	                            var t2 = 0;

	                            var t1 = Math.floor((((oriprice - promoPrcPrcnt)* pacYear) - promoAddDiscPrc)) * ((100 + SSTValue) / 100);

	                            if ($("#eurCertYn").val() == "N") {
	                                //t2 = t1 *100 / 106; -- without GST 6% edited by TPY 23/05/2018
	                                t2 = t1;
	                                $("#hiddenNomalPrice").val(Number(FormUtil.roundNumber(t1,2)));

	                            }
	                            else {
	                                t2 = t1;
	                            }

	                            var t3 = FormUtil.roundNumber(t2,2);

	                            $("#txtPackagePrice").html(Number(t3));
	                            // $("#txtPackagePrice").html( Number(   Math.floor(   ( oriprice - promoPrcPrcnt) -promoAddDiscPrc  )));
                            }else{

                                var t1 = ((oriprice - promoPrcPrcnt)* pacYear) - promoAddDiscPrc;
                                var t2 = 0;

                                if ($("#eurCertYn").val() == "N") {
                                    //t2 = t1 *100 / 106; -- without GST 6% edited by TPY 23/05/2018
                                    t2 = t1;

                                    $("#hiddenNomalPrice").val(Number(Math.floor(t1)));
                                }
                                else {
                                    t2 = t1;
                                }

                                var t3 = Math.floor(t2);

                                $("#txtPackagePrice").html(Number(t3));
                                // $("#txtPackagePrice").html( Number(   Math.floor(   ( oriprice - promoPrcPrcnt) -promoAddDiscPrc  )));
                            }
						}
						else {
							Common.alert('<spring:message code="sal.alert.promDiscountTypeError" /> ');
							return;
						}
					}
				});

			}
			else {
				Common.alert("<spring:message code="sal.alert.title.promoNotEntitled" />" + DEFAULT_DELIMITER + " <spring:message code="sal.alert.msg.promoNotEntitled" />");
			}
		}

	}

	function f_multiCombo3() {

		$('#cPromo').change(function() {
			fn_LoadMembershipFilter($(this).val().trim());
		});

	}

	/*fn_getMembershipPackageInfo*/
	function fn_getMembershipPackageInfo(_id) {

		Common.ajax("GET", "/sales/membership/mPackageInfo", $("#getDataForm").serialize(), function(result) {
			console.log(result);

			if (result.packageInfo.srvMemPacId == null || result.packageInfo.srvMemPacId == "") {

				$("#HiddenHasPackage").val(0);
				$("#txtBSFreq").html("");
				$("#txtPackagePrice").html("");
				$("#hiddenPacOriPrice").val(0);
				$("#hiddenNomalPrice").val(0);

			}
			else {

				var pacYear = parseInt($("#DUR").val(), 10) / 12;

			    $("#hiddenPacPriceB4Sst").val(Math.round((result.packageInfo.srvMemItmPrc * pacYear)));

	            if(Number(SSTValue) > 0){
					var pacPrice = FormUtil.roundNumber(((result.packageInfo.srvMemItmPrc * (100 + Number(SSTValue)) /100) * pacYear) , 2);
				}else{
					var pacPrice = Math.round((result.packageInfo.srvMemItmPrc * pacYear));
				}

				$("#zeroRatYn").val(result.packageInfo.zeroRatYn);
				$("#eurCertYn").val(result.packageInfo.eurCertYn);

				$("#HiddenHasPackage").val(1);
				$("#txtBSFreq").html(result.packageInfo.srvMemItmPriod + " <spring:message code="sal.text.month" />");
				$("#hiddentxtBSFreq").val(result.packageInfo.srvMemItmPriod);

				$("#hiddenNomalPrice").val(pacPrice);

				$("#srvMemPacId").val(result.packageInfo.srvMemPacId);

				if ($("#eurCertYn").val() == "N") {
					//$("#txtPackagePrice").html(Math.floor(pacPrice *100/106)); -- without GST 6% edited by TPY 23/05/2018
					//$("#hiddenPacOriPrice").val(Math.floor(pacPrice *100/106)); -- without GST 6% edited by TPY 23/05/2018

	                if(Number(SSTValue) > 0){
                    	$("#txtPackagePrice").html(FormUtil.roundNumber(pacPrice, 2));
                        $("#hiddenPacOriPrice").val(FormUtil.roundNumber(pacPrice, 2));
                    }else{
	                     $("#txtPackagePrice").html(Math.floor(pacPrice));
	                     $("#hiddenPacOriPrice").val(Math.floor(pacPrice));
                    }
				}
				else {
					$("#txtPackagePrice").html(pacPrice);
					$("#hiddenPacOriPrice").val(pacPrice);
				}

				fn_getFilterChargeList();
			}

			if ($("#HiddenHasFilterCharge").val() == "1") {

				// fn_getFilterCharge(_id);
				fn_LoadMembershipPromotion();
				$("#btnViewFilterCharge").attr("style", "display:inline");

			}
			else {
				// $("#txtFilterCharge").html("0.00");
			}

			$("#packpro").removeAttr("disabled");

			//set packagePromotion combox
			fn_PacPromotionCode();

		});
	}

	function fn_getMembershipPackageFilterInfo() {

		$('#txtFilterCharge').html("");

		$("#cPromoCombox").attr("checked", false);

		$("#cPromoCombox").removeAttr("disabled");

		//$("#cPromo").val("");

		//doGetCombo('/sales/membership/getFilterPromotionCode?PROMO_SRV_MEM_PAC_ID=' + $("#SELPACKAGE_ID").val() + "&E_YN=" + $("#cEmplo").val(), '', '', 'cPromo', 'S', '');
		doGetComboCodeId('/sales/membership/getFilterPromotionCode?PROMO_SRV_MEM_PAC_ID=' + $("#SELPACKAGE_ID").val() + "&E_YN=" + $("#cEmplo").val(), '', '', 'cPromo', 'S', 'fn_setDefaultFilterPromo');

		/* if ($("#HiddenIsCharge").val() != "0") {
			$("#cPromo").prop("disabled", false);
			$("#cPromo").attr("class", "");
		} */
	}

	function fn_setDefaultFilterPromo() {

		if ($("#HiddenIsCharge").val() != "0") {
			console.log("set default filter promo");
			var paramdata = {
	                groupCode : '466',
	                codeName : 'FIL_MEM_DEFAULT_PROMO_N_EMP'
	        };

			if ($("#cEmplo").val() == 1){
	            paramdata = {
	                    groupCode : '466',
	                    codeName : 'FIL_MEM_DEFAULT_PROMO_EMP'
	            };
	        }

			Common.ajaxSync("GET", "/common/selectCodeList.do", paramdata, function(result) {
				console.log(result[0]);
				if (result != null && result.length > 0) {
	                $("#cPromo option[value='" + result[0].code + "']").attr("selected", true);
	            }
	            else {
	                $("#cPromo option[value='']").attr("selected", true);
	            }
			});

	        fn_getFilterChargeList();
		}
	}

	function fn_doPackagePro(v) {
		if (v.checked) {
			fn_PacPromotionCode();

			$("#cPromotionpac").removeAttr("disabled");
			$("#cPromotionpac").attr("class", "");
		}
		else {
			$("#cPromotionpac").attr("disabled", "disabled");
		}
	}

	function fn_doPromoCombox(v) {
		if (v.checked) {
			if ($("#HiddenIsCharge").val() != "0") {
				$("#cPromo").prop("disabled", false);
				$("#cPromo").attr("class", "");
			}
		}
		else {
			$("#cPromo").prop("disabled", true);
			$("#cPromo").attr("class", "disabled");
		}
	}

	function fn_PacPromotionCode() {

		$("#cPromotionpac").val("");

		var SALES_ORD_ID = $("#ORD_ID").val();
		var E_YN = $("#cEmplo").val();

		var pram = "?SALES_ORD_ID=" + SALES_ORD_ID + "&SRV_MEM_PAC_ID=" + $("#SELPACKAGE_ID").val() + "&E_YN=" + E_YN;

		doGetCombo('/sales/membership/getPromotionCode' + pram, '', '', 'cPromotionpac', 'S', '');

		$("#cPromotionpac").removeAttr("disabled");

		var _valid = true;
		var _sVale = $('#cYear').val();
		var _orderDate = $('#ORD_DATE').val();
		var _cutOffDate = "20160927";

		if (!_valid || _sVale != 12 || _orderDate < _cutOffDate) {
			$("#cPromotionpac option[value='31408']").remove();
		}

	}

	function fn_LoadMembershipPromotion() {

// 		$("#cPromo").val("");
		if ($("#HiddenIsCharge").val() != "0") {
			$("#cPromo").prop("disabled", false);
			$("#cPromo").attr("class", "");
		}

		//cbPromo.Enabled = true;

		/*

		private void LoadMembershipPromotion(int PackageID,int StkID)
		{
		ddlPromotion.Items.Clear();
		MembershipManager mm = new MembershipManager();
		List<MembershipPromotionInfo> ls = mm.GetMembershipPromotion(PackageID, StkID);
		if (ls.Count > 0)
		{
		    cbPromo.Enabled = true;
		    ddlPromotion.DataTextField = "PromoCodeName";
		    ddlPromotion.DataValueField = "PromoID";
		    ddlPromotion.DataSource = ls;
		    ddlPromotion.DataBind();
		    ddlPromotion.ClearSelection();
		    ddlPromotion.Text = string.Empty;
		}

		//Ben - 2016/09/30 - Validate eligibility for Early Bird Promotion
		MembershipManager oo = new MembershipManager();

		}

		 */
	}

	function fn_getFilterChargeList() {

		$("#txtFilterCharge").text("");

		if ($("#HiddenIsCharge").val() != "0") {

			if ($('#SELPACKAGE_ID').val() != "") {

				Common.ajax("GET", "/sales/membership/getFilterChargeListSum.do", {
					SALES_ORD_NO : $("#ORD_NO").val(),
					ORD_ID : $("#ORD_ID").val(),
					PROMO_ID : $('#cPromo').val(),
					SRV_PAC_ID : $('#SELPACKAGE_ID').val(),
					zeroRatYn : $("#zeroRatYn").val(),
					eurCertYn : $("#eurCertYn").val()
				}, function(result) {
					console.log(result);

					if (null != result) {
						/*  if(result[0] !=null){
							 if($("#zeroRatYn").val() == "N" || $("#eurCertYn").val() == "N"){

						         $("#txtFilterCharge").text( Math.floor(result[0].amt * 100 / 106));

							 }else{
						         $("#txtFilterCharge").text( result[0].amt);
							 }
						}  */
						$("#txtFilterCharge").text(result);
					}
				});
			}
		}
	}

	function fn_LoadMembershipFilter(_cPromotion) {

		var cPromotion = _cPromotion;

		if (null == cPromotion || "" == cPromotion) {
			cPromotion = 0;
		}

		$("#PROMO_ID").val(cPromotion);

		$("#_editDiv1").remove();
		$("#_popupDiv").remove();
		Common.popupDiv("/sales/membership/mFilterChargePop.do", $("#getDataForm").serializeJSON(), null, true, '_editDiv1');
	}

	function fn_back() {
		$("#_NewQuotDiv1").remove();
	}

	function fn_getFilterCharge(_cPromotion) {

		var cPromotion = _cPromotion;

		if (null == cPromotion || "" == cPromotion) {
			cPromotion = 0;
		}

		$("#PROMO_ID").val(cPromotion);

		if ($("#HiddenIsCharge").val() != "0") {
			Common.ajax("GET", "/sales/membership/getFilterChargeList.do", $("#getDataForm").serialize(), function(result) {
				console.log("======fn_getFilterCharge========>");
				console.log(result);

				if (result.outSuts.length > 0) {
					var prc = 0;
					for (i in result.outSuts) {
						prc += parseInt(result.outSuts[i].prc, 10);
					}

					console.log(prc);
					$("#txtFilterCharge").html(prc);

				}
				else {
					//$("#txtFilterCharge").html("0.00");
				}

				if ($("#cPromotionpac").val() > 0) {
					$("#FCPOPTITLE").val("<spring:message code="sal.page.title.filterChargeDetailsPromoApplied" />");
				}
				else {
					$("#FCPOPTITLE").val("Filter Charge Details - No Promotion");
				}

				/*
				if (ls.Count > 0)
				{
				    RadGrid_FilterCharge.DataSource = ls;
				    RadGrid_FilterCharge.DataBind();
				    GridFooterItem footer = (GridFooterItem)RadGrid_FilterCharge.MasterTableView.GetItems(GridItemType.Footer)[0];
				    string TotalPrice = footer["ChargePrice"].Text.Split(':')[1];
				    txtFilterCharge.Text = string.Format("{0:C}", TotalPrice.ToString()).Replace("$", "").Replace(",", "").Replace("RM", "");
				}
				else
				{
				    txtFilterCharge.Text = "0.00";
				}

				if (PromoID > 0)
				{


				    RadWindow_FilterCharge.Title = "Filter Charge Details - Promotion Applied";
				}
				else
				{
				    RadWindow_FilterCharge.Title = "Filter Charge Details - No Promotion";
				}

				 */
			});
		}
	}

	function changeRowStyleFunction() {

		// row Styling 함수를 다른 함수로 변경
		AUIGrid.setProp(oListGridID, "rowStyleFunction", function(rowIndex, item) {

			var lifePeriod = parseInt(item.srvFilterPriod, 10);
			var expInt = parseInt(item.expint, 10);

			if (lifePeriod > 0) {

				if (expInt > lifePeriod) {

					$("#HiddenHasFilterCharge").val(1);
					return "my-row-style";

				}
				else {
					return "";
				}

				/*
				 DateTime LastChangeDate = CommonFunction.ConvertDateDMYToMDY(item["FilterLastChange"].Text.Trim());
				 DateTime todayDate = CommonFunction.GetFirstDayOfMonth(DateTime.Now.Date);

				 int expireDateInt = (LastChangeDate.Year * 12) + LastChangeDate.Month;
				 int todayDateInt = (todayDate.Year * 12) + todayDate.Month;
				 int expInt = todayDateInt - expireDateInt;
				 if (expInt > lifePeriod)
				 {
				     e.Item.BackColor = System.Drawing.Color.Pink;
				     HiddenField hf = (HiddenField)item.FindControl("HiddenFilterCharge");
				     hf.Value = "1";
				     HiddenHasFilterCharge.Value = "1";
				 }
				 */

			}
		});

		// 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
		AUIGrid.update(oListGridID);
	};

	function fn_goSalesConfirm() {

		if ($("#SALES_PERSON").val() == "") {

			Common.alert("Please Key-In Sales Person Code. ");
			return;
		}

		Common.ajax("GET", "/sales/membership/paymentColleConfirm", {
			COLL_MEM_CODE : $("#SALES_PERSON").val()
		}, function(result) {
			console.log(result);
			if (result.length > 0) {

				$("#SALES_PERSON").val(result[0].memCode);
				$("#SALES_PERSON_DESC").html(result[0].name);
				$("#hiddenSalesPersonID").val(result[0].memId);

				$("#sale_confirmbt").attr("style", "display:none");
				$("#sale_searchbt").attr("style", "display:none");
				$("#SALES_PERSON").attr("class", "readonly");

				checkSalesPersonValidForCreation(result[0].memId,result[0].memCode);
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
	    $('#SALES_PERSON').val('');
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

			checkSalesPersonValidForCreation(item.memId,item.memCode);
		}
		else {
			$("#SALES_PERSON").val("");
			$("#SALES_PERSON_DESC").html("");
			$("#SALES_PERSON").attr("class", "");
		}
	}

	function fn_SubscriptionYear_initEvt() {

		console.log("-----fn_SubscriptionYear_initEvt ---- ");

		$("#cPromotionpac").val();
		$("#cPromoe").val();
		$("#cPromotionpac").attr("disabled", "disabled");
		$("#cPromoe").prop("disabled", true);
		$("#packpro").attr("checked", false);
		$("#cPromoCombox").attr("checked", false);
		$("#packpro").attr("disabled", "disabled");
		$("#cPromoCombox").attr("disabled", "disabled");
		$("#txtBSFreq").html("");
		$("#txtPackagePrice").html("-");
		$("#hiddenPacOriPrice").val("");
		$("#hiddenNomalPrice").val("");
		$("#txtFilterCharge").val("");
		$("#hiddenFilterCharge").val("");
		//$("#btnViewFilterCharge").attr("style" ,"display:none");

	}

	function getOrderCurrentBillMonth() {
		var billMonth = 0;

		Common.ajaxSync("GET", "/sales/membership/getOrderCurrentBillMonth", {
			ORD_ID : $("#ORD_ID").val()
		}, function(result) {
			console.log(result);

			if (result.length > 0) {
				if (parseInt(result[0].nowDate, 10) > parseInt(result[0].rentInstDt, 10)) {

					billMonth = 61;
					console.log("==========billMonth============" + billMonth);

					return billMonth;

				}
				else {
					Common.ajaxSync("GET", "/sales/membership/getOrderCurrentBillMonth", {
						ORD_ID : $("#ORD_ID").val(),
						RENT_INST_DT : 'SYSDATE'
					}, function(_result) {

						console.log("==========2============");
						console.log(_result);

						if (_result.length > 0) {
							billMonth = _result[0].rentInstNo;
						}

						console.log("==========2 end ============[" + billMonth + "]");

					});
				}
			}
		});

		return billMonth;
	}

	function fn_save() {
		    var rtnVAL = false;
            var billMonth = getOrderCurrentBillMonth();

            Common.ajaxSync("GET", "/sales/membership/mActiveQuoOrder", {
                ORD_NO : $("#ORD_NO").val()
            }, function(result) {
                console.log(result);

                if (result.length > 0) {
                    rtnVAL = true;
                    Common.alert(" <b><spring:message code="sal.alert.msg.hasActQuotation" />[" + result[0].srvMemQuotNo + "]</b>");
                    return true;
                }
            })

	        if (rtnVAL == false) {
	            if (fn_validRequiredField_Save() == false)
	                 return;
	             if (fn_CheckRentalOrder(billMonth)) {
	                 if (fn_CheckSalesPersonCode()) {
	                     fn_unconfirmSalesPerson();
	                 }
	             }
	        }

            return rtnVAL;
	}

	function fn_validRequiredField_Save() {

		var rtnMsg = "";
		var rtnValue = true;

		if (FormUtil.checkReqValue($("#srvMemPacId"))) {
			rtnMsg += "* Please select the type of package.<br />";
			rtnValue = false;
		}

		/*     if(FormUtil.checkReqValue($("#cPromotionpac"))){
		 rtnMsg  +="<spring:message code="sal.alert.msg.selectPackType" /> <br>" ;
		 rtnValue =false;
		 } */

		if (FormUtil.checkReqValue($("#cYear"))) {
			rtnMsg += "<spring:message code="sal.alert.msg.selectSubscriptionYear" /><br>";
			rtnValue = false;
		}
		else {
			if ($("#cYear").val() == "12" && $("#cPromotionpac").val() == "544") {

				rtnMsg += "<spring:message code="sal.alert.msg.notAllowPromotionDiscount" /> <br>";
				rtnValue = false;
			}
			if ($("#cYear").val() == "12" && $("#cPromotionpac").val() == "31741") {

				rtnMsg += "Subscription Year selected 1 year. "+"<spring:message code="sal.alert.msg.notAllowPromotion" /> <br>";
				rtnValue = false;
			}
			if ($("#cYear").val() == "12" && $("#cPromotionpac").val() == "32296") {
                rtnMsg += "Subscription Year selected 1 year. "+"<spring:message code="sal.alert.msg.notAllowPromotion" /> <br>";
                rtnValue = false;
            }
			if ($("#cYear").val() != "12" && $("#cPromotionpac").val() == "32302") {
                rtnMsg += "Subscription Year selected more than 1 year. "+"<spring:message code="sal.alert.msg.notAllowPromotionMore1y" /> <br>";
                rtnValue = false;
            }
		}

		if ($("#packpro").prop("checked")) {

			var expDate = resultSrvconfigObject.cvtLastSrvMemExprDate.substring(0, 6);
			var nowDate = resultSrvconfigObject.cvtNowDate.substring(0, 6);

			if ($("#cPromotionpac").val() == "649") {

				/*
				    DateTime ExpDate = DateTime.Parse(hiddenExpireDate.Value);
				    int expiryYear = ExpDate.Year;
				    int curYear = DateTime.Now.Year;
				    int expiryMonth = ExpDate.Month;
				    int curMonth = DateTime.Now.Month;

				    int month = ((curYear - expiryYear) * 12) + curMonth - expiryMonth;
				 */
				var month = parseInt(nowDate, 10) - parseInt(expDate, 10);

				if (month > 0) {
					rtnMsg += "<spring:message code="sal.alert.msg.membershipIsExpired" /><br>";
					rtnValue = false;
				}

			}
			else if ($("#cPromotionpac").val() == "650") {

				var month = parseInt(nowDate, 10) - parseInt(expDate, 10);

				var ful_exdate = resultSrvconfigObject.cvtLastSrvMemExprDate;
				var ful_nowdate = resultSrvconfigObject.cvtNowDate;

				if (parseInt(ful_exdate, 10) < parseInt(ful_nowdate, 10)) {

					if (resultBasicObject.stkCategoryId == 54) {
						if (month > 7) {
							rtnMsg += "<spring:message code="sal.alert.msg.membershipIsExpiredOver7" /><br>";
							rtnValue = false;
						}
					}
					else {
						if (month > 5) {
							rtnMsg += "<spring:message code="sal.alert.msg.membershipIsExpiredOver5" /><br>";
							rtnValue = false;
						}
					}

				}
				else {
					rtnMsg += "<spring:message code="sal.alert.msg.membershipIsHaventExpired" /><br>";
					rtnValue = false;
				}
			}
		}

		if (($("#cPromotionpac").val() == "31689" || $("#cPromotionpac").val() == "31742") && $("#hiddenEarlyBirdPromo").val() == "0") {

			rtnMsg += "<spring:message code="sal.alert.msg.NOearlyBirdPromo" /><br>";
			rtnValue = false;

		}

		//20190925 Vannie add checking on Cust Area ID
		if (FormUtil.isNotEmpty(resultInstallationObject.areaId)) {

			if ("DM" == resultInstallationObject.areaId.substring(0, 2)) {

				rtnMsg += "<spring:message code="sal.alert.msg.customerAddrChange" /><br>";
				rtnValue = false;

			}
		}

		if($("#cPromotionpac").val() == "32295" || $("#cPromotionpac").val() == "32296" || $("#cPromotionpac").val() == "32302"){
		        Common.ajaxSync("GET", "/sales/membership/mEligibleEVoucher", {
		            ORD_NO : $("#ORD_NO").val()
		        }, function(result) {
		            console.log(result);

		            if (result.length == 0) {
		            	rtnMsg += "The FMCO SVM RM50 discount promotion has been claimed.<br>";
		            	rtnValue = false;
		            }
		        });

		}
		//if ($("#cPromoCombox").prop("checked")){
		//  if(FormUtil.checkReqValue($("#packpro"))){
		// rtnMsg +="Please select the promotion <br>";
		// rtnValue =false;
		// }
		// }

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
						console.log("==========3===");
						console.log(result);

						if (result != null) {
							if (result.ordTotOtstnd > 0) {
								rtnMsg += "* This order has outstanding. Membership purchase is disallowed.<br />";
								rtnValue = false;
							} else{
								//webster lee 20072020:Added new validation
				                Common.ajaxSync("GET", "/sales/membership/getOutrightMemLedge", $("#getDataForm").serialize(), function(result1) {
				                	console.log("==========4===");
			                        console.log(result1);

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
                console.log("==========4===");
                console.log(result1);

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
			fn_DoSaveProcess();

			/* Common.popupDiv("/sales/membership/mNewQuotationSavePop.do" , $("#getDataForm").serializeJSON(), null , true , '_saveDiv1'); */
		}
	}

	function fn_SaveProcess_Click(_saveOption) {

		/*
		if(_saveOption == "1"){

		     //SAVE & PROCEED TO PAYMEMT
		    this.DisablePageControl_Page();
		    RadWindowManager1.RadAlert("<b>Quotation successfully saved.<br />Quotation number : " + retQuot.SrvMemQuotNo + "<br />System will auto redirect to payment process after 3 seconds.</b>", 450, 160, "Quotation Saved & Proceed To Payment", "callBackFn", null);
		    hiddenQuotID.Value = retQuot.SrvMemQuotID.ToString();
		    Timer1.Enabled = true;

		}else if(_saveOption == "2"){
		     //SAVE QUOTATION ONLY
		    this.DisablePageControl_Page();
		    RadWindowManager1.RadAlert("<b>Quotation successfully saved.<br />Quotation number : " + retQuot.SrvMemQuotNo + "</b>", 450, 160, "Quotation Saved", "callBackFn", null);

		}else {
		     RadWindowManager1.RadAlert("<b>Failed to save. Please try again later.</b>", 450, 160, "Failed To Save", "callBackFn", null);
		}*/
	}

	function fn_DoSaveProcess(_saveOption) {
		$("#srvMemQuotId").val(0);
		$("#srvSalesOrderId").val($("#ORD_ID").val());
		$("#srvMemQuotNo").val("");
		$("#srvMemPacId").val();

	    if(Number(SSTValue) > 0){
	    	var pacPriceB4Sst = FormUtil.roundNumber((Number($("#txtPackagePrice").text()) / (100 + Number(SSTValue)) * 100 ) , 2);

        	$("#srvMemPacNetAmt").val(pacPriceB4Sst);  // nomalAmt
        }else{
        	$("#srvMemPacNetAmt").val($("#txtPackagePrice").text()); //
        }

		//$("#srvMemPacNetAmt").val($("#hiddenNomalPrice").text());  // nomalAmt
		//$("#srvMemPacAmt").val($("#hiddenNomalPrice").val()); //srvMemPacNetAmt
		$("#srvMemPacAmt").val($("#txtPackagePrice").text()); //srvMemPacNetAmt

		$("#srvMemBSAmt").val($("#txtFilterCharge").text());
		$("#srvMemBSNetAmt").val($("#txtFilterCharge").text()); // srvMemBSNetAmt

		$("#srvMemPv").val(0);
		$("#srvDuration").val($("#cYear").val());
		$("#srvRemark").val($("#txtRemark").val());
		$("#srvQuotStatusId").val(1);
		$("#srvMemBS12Amt").val(0);

		if ($("#cPromotionpac").val() > 0)
			$("#srvPacPromoId").val($("#cPromotionpac").val());
		else
			$("#srvPacPromoId").val(0);

		if ($("#cPromo").val() > 0)
			$("#srvPromoId").val($("#cPromo").val());
		else
			$("#srvPromoId").val(0);

		$("#srvQuotCustCntId").val($("#SAVE_CUST_CNTC_ID").val());
		$("#srvMemQty").val(1);
		$("#srvSalesMemId").val($("#hiddenSalesPersonID").val());
		$("#srvMemId").val(0);
		$("#srvOrderStkId").val($("#STOCK_ID").val());
		$("#srvFreq").val($("#hiddentxtBSFreq").val());

		$("#empChk").val($("#cEmplo").val());

		if ($("#HiddenIsCharge").val() == "1") {
			$("#isFilterCharge").val("TRUE");
		}
		else {
			$("#isFilterCharge").val("FALSE");
		}

		/* // Added Reference No column by Hui Ding, 15-02-2021
		$("#refNo").val($("#REF_NO").val().trim());
 */
		Common.ajax("GET", "/sales/membership/mNewQuotationSave", $("#save_Form").serialize(), function(result) {
			console.log(result);

			if (result.code == "00") {

				/*   if(_saveOption == "1"){

				     Common.alert("<spring:message code="sal.alert.title.quotationSaveProceedToPayment" />"  +DEFAULT_DELIMITER
				   		               +" <b> <spring:message code="sal.alert.msg.quotationSaveProceedToPayment" /> "
				   		               + result.message + "<br/> <spring:message code="sal.alert.msg.quotationSaveProceedToPayment2" /> ");

				     setTimeout(function(){ fn_saveResultTrans(result.data) ;}, 3000);

				}else{ */
				Common.alert("<spring:message code="sal.alert.title.quotationSaved" />" + DEFAULT_DELIMITER + " <b> <spring:message code="sal.alert.msg.quotationSaved" />" + result.data + "<br /> ");

				$("#_NewQuotDiv1").remove();
				//fn_selectListAjax();
				/*  }              */
			}
			else {
				Common.alert("<spring:message code="sal.alert.title.saveFail" />" + DEFAULT_DELIMITER + " <b><spring:message code="sal.alert.msg.saveFail" /></b> ");
			}
		});
	}

	function fn_saveResultTrans(quot_id) {

		$("#_alertOk").click();
		$("#_NewQuotDiv1").remove();

		Common.popupDiv("/sales/membership/mAutoConvSale.do", {
			QUOT_ID : quot_id
		}, null, true, '_mConvSaleDiv1');
	}

	/*
	 private Boolean CheckRentalOrder()
	 {
	 Boolean valid = true;
	 string message = "";
	 int OrderID = int.Parse(hiddenOrderID.Value);

	 if (int.Parse(hiddenAppTypeID.Value) == 66)
	 {
	 if (txtRentStatus.Text.Trim() == "REG" || txtRentStatus.Text.Trim() == "INV")
	 {
	 Sales.Orders oo = new Sales.Orders();
	 int CurrentBillMth = oo.GetOrderCurrentBillMonth(OrderID);
	 if (CurrentBillMth > 60)
	 {
	 Data.spGetOrderOutstandingInfo_Result oi = new Data.spGetOrderOutstandingInfo_Result();
	 oi = oo.GetOrderOutstandingInfo(int.Parse(hiddenOrderID.Value));
	 if (oi.Order_TotalOutstanding > 0)
	 {
	 valid = false;
	 message += "* This order has outstanding. Membership purchase is disallowed.<br />";
	 }
	 }
	 }
	 else
	 {
	 valid = false;
	 message += "* Only [REG] or [INV] rental order is allowed to purchase membership.<br />";
	 }
	 }
	 if (!valid)
	 RadWindowManager1.RadAlert("<b>" + message + "</b>", 450, 160, "Rental Order Validation", "callBackFn", null);

	 return valid;

	 }
	 */

	function createAUIGridHList() {

		//AUIGrid 칼럼 설정
		var columnLayout = [ {
			dataField : "no",
			headerText : "<spring:message code="sal.title.bsNo" />",
			width : 90,
			editable : false
		}, {
			dataField : "month",
			headerText : "<spring:message code="sal.title.bsMonth" />",
			width : 80,
			editable : false
		}, {
			dataField : "code",
			headerText : "<spring:message code="sal.title.type" />",
			width : 70,
			editable : false
		}, {
			dataField : "code1",
			headerText : "<spring:message code="sal.title.status" />",
			width : 70,
			editable : false
		}, {
			dataField : "no1",
			headerText : "<spring:message code="sal.title.bsrNo" />",
			width : 100,
			editable : false
		}, {
			dataField : "c1",
			headerText : "<spring:message code="sal.title.settleDate" />",
			width : 170,
			editable : false
		}, {
			dataField : "memCode",
			headerText : "<spring:message code="sal.title.codyCode" />",
			width : 90,
			editable : false
		}, {
			dataField : "code3",
			headerText : "<spring:message code="sal.title.failReason" />",
			width : 105,
			editable : false
		}, {
			dataField : "code2",
			headerText : "<spring:message code="sal.title.collectionReason2" />",
			width : 100,
			editable : false
		}

		];

		//그리드 속성 설정
		var gridPros = {
			usePaging : true, //페이징 사용
			pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
			editable : false,
			fixedColumnCount : 1,
			headerHeight : 30,
			//selectionMode       : "singleRow",  //"multipleCells",
			showRowNumColumn : true
		//줄번호 칼럼 렌더러 출력

		};

		bsHistoryGridID = GridCommon.createAUIGrid("hList_grid_wrap", columnLayout, "", gridPros);
	}

	function createAUIGridOList() {

		//AUIGrid 칼럼 설정
		var columnLayout = [ {
			dataField : "stkCode",
			headerText : "Code",
			width : "12%",
			editable : false
		}, {
			dataField : "stkDesc",
			headerText : "Name",
			width : "50%",
			editable : false,
			style : 'left_style'
		}, {
			dataField : "code",
			headerText : "Type",
			width : "12%",
			editable : false
		}, {
			dataField : "srvFilterPriod",
			headerText : "Change Period",
			width : "12%",
			editable : false
		}, {
			dataField : "srvFilterPrvChgDt",
			headerText : "Last Change",
			width : "12%",
			editable : false
		}

		];

		//그리드 속성 설정
		var gridPros = {
			usePaging : true, //페이징 사용
			pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
			editable : false,
			fixedColumnCount : 1,
			showStateColumn : true,
			displayTreeOpen : false,
			// selectionMode       : "singleRow",  //"multipleCells",
			headerHeight : 30,
			useGroupingPanel : false, //그룹핑 패널 사용
			skipReadonlyColumns : true, //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
			wrapSelectionMove : true, //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
			showRowNumColumn : true,

			// row Styling 함수
			rowStyleFunction : function(rowIndex, item) {

				return "";
			}
		};

		oListGridID = GridCommon.createAUIGrid("oList_grid_wrap", columnLayout, "", gridPros);
	}

	function checkSalesPersonValidForCreation(memId,memCode){
		if(memCode == "100116" || memCode == "100224" || memCode == "ASPLKW"){
			return;
		}

		Common.ajax("GET", "/sales/membership/checkSalesPerson", {memId:memId,memCode:memCode}, function(memInfo) {
			if(memInfo == null){
				Common.alert("<b>Your input member code : " + memCode + " is not allowed for membership creation.</b>");
				fn_goSalesPersonReset();
			}
		});

 		//Only Cater for IND customer type
// 		var custTypeId= $('#CUST_TYPE_ID').val();
// 		var monthExpired =  $('#hiddenMonthExpired').val();
// 		var ordId = $("#ORD_ID").val();
// 		if(custTypeId == '964'){
// 			//ONLY ALLOW CONFIGURATION CD
// 			if(parseInt(monthExpired) < 2){
// 				Common.ajax("GET", "/sales/membership/checkConfigurationSalesPerson", {memId:memId,memCode:memCode,salesOrdId:ordId}, function(memInfo) {
// 					if(memInfo == null){
// 						Common.alert("<b>Your input member code : " + memCode + " is not allowed for membership creation.</b>");
// 						fn_goSalesPersonReset();
// 					}
// 				});
// 			}
// 			//ALLOW ALL CD
// 			else{
// 				Common.ajax("GET", "/sales/membership/checkSalesPerson", {memId:memId,memCode:memCode}, function(memInfo) {
// 					if(memInfo == null){
// 						Common.alert("<b>Your input member code : " + memCode + " is not allowed for membership creation.</b>");
// 						fn_goSalesPersonReset();
// 					}
// 				});
// 			}
// 		}
	}
</script>



<form id="getDataForm" method="post">
<div style="display:none">
    <input type="text" name="ORD_ID"     id="ORD_ID"/>
    <input type="text" name="CUST_ID"    id="CUST_ID"/>
    <input type="text" name="IS_EXPIRE"  id="IS_EXPIRE"/>
    <input type="text" name="STOCK_ID"  id="STOCK_ID"/>
    <input type="text" name="PAC_ID"  id="PAC_ID"/>
    <input type="text" name="TO_YYYYMM"  id="TO_YYYYMM" />
    <input type="text" name="EX_YYYYMM"  id="EX_YYYYMM"/>
    <input type="text" name="PROMO_ID"  id="PROMO_ID"/>
    <input type="text" name="ORD_DATE"  id="ORD_DATE"/>
    <input type="text" name="MBSH_EXP_DT"  id="MBSH_EXP_DT"/>
    <input type="text" name="CUST_TYPE_ID" id="CUST_TYPE_ID"/>
    <input type="text" name="SAVE_CUST_CNTC_ID"  id="SAVE_CUST_CNTC_ID"/>

    <!--Type of Package  -->
    <input type="text" name="SELPACKAGE_ID"  id="SELPACKAGE_ID"/>
    <!--Subscription Year  -->
    <input type="text" name="DUR"  id="DUR"/>

    <!--FilterChargePOPUP.Title -->
    <input type="text" name="FCPOPTITLE"  id="FCPOPTITLE"/>



</div>
</form>

<form id="oListDataHiddenForm" method="post">
<div style="display:none">
    <input type="text" name="HiddenHasFilterCharge"  id="HiddenHasFilterCharge"/>
    <input type="text" name="HiddenIsCharge"  id="HiddenIsCharge"/>
    <input type="text" name="HiddenHasPackage"  id="HiddenHasPackage"/>
    <input type="text" name="hiddenPacOriPrice"  id="hiddenPacOriPrice"/>
    <input type="text" name="hiddenNomalPrice"  id="hiddenNomalPrice"/>
    <input type="text" name="hiddenSalesPersonID"  id="hiddenSalesPersonID"/>
    <input type="text" name="hiddentxtBSFreq"  id="hiddentxtBSFreq"/>
    <input type="text" name="hiddenEarlyBirdPromo"  id="hiddenEarlyBirdPromo"/>
    <input type="text" name="hiddenMonthExpired" id="hiddenMonthExpired"/>
    <input type="text" name="hiddenPacPriceB4Sst" id="hiddenPacPriceB4Sst"/>
</div>
</form>


<form  id="save_Form" method="post">
    <div style="display:none">
            <input type="text" name="srvMemQuotId" id="srvMemQuotId" />
            <input type="text" name="srvSalesOrderId" id="srvSalesOrderId" />
            <input type="text" name="srvMemQuotNo" id="srvMemQuotNo" />
            <input type="text" name="srvMemPacId" id="srvMemPacId" />
            <input type="text" name="srvMemPacNetAmt" id="srvMemPacNetAmt" />
            <input type="text" name="srvMemPacTaxes" id="srvMemPacTaxes" />
            <input type="text" name="srvMemPacAmt" id="srvMemPacAmt" />
            <input type="text" name="srvMemBSNetAmt" id="srvMemBSNetAmt" />
            <input type="text" name="srvMemBSTaxes" id="srvMemBSTaxes" />
            <input type="text" name="srvMemBSAmt" id="srvMemBSAmt" />
            <input type="text" name="srvMemPv" id="srvMemPv" />
            <input type="text" name="srvDuration" id="srvDuration" />
            <input type="text" name="srvRemark" id="srvRemark" />
            <input type="text" name="srvQuotValid" id="srvQuotValid" />
            <input type="text" name="srvCreateAt" id="srvCreateAt" />
            <input type="text" name="srvCreateBy" id="srvCreateBy" />
            <input type="text" name="srvQuotStatusId" id="srvQuotStatusId" />
            <input type="text" name="srvUpdateBy" id="srvUpdateBy" />
            <input type="text" name="srvUpdateAt" id="srvUpdateAt" />
            <input type="text" name="srvMemBS12Amt" id="srvMemBS12Amt" />
            <input type="text" name="srvQuotCustCntId" id="srvQuotCustCntId" />
            <input type="text" name="srvMemQty" id="srvMemQty" />
            <input type="text" name="srvPromoId" id="srvPromoId" />
            <input type="text" name="srvSalesMemId" id="srvSalesMemId" />
            <input type="text" name="srvMemId" id="srvMemId" />
            <input type="text" name="srvOrderStkId" id="srvOrderStkId" />
            <input type="text" name="srvFreq" id="srvFreq" />
            <input type="text" name="srvPacPromoId" id="srvPacPromoId" />
            <input type="text" name="isFilterCharge" id="isFilterCharge" />
            <input type="text" name="empChk" id="empChk" />
            <input type="text" name="zeroRatYn" id="zeroRatYn" />
            <input type="text" name="eurCertYn" id="eurCertYn" />
            <!-- Added reference No column by Hui Ding, 15-02-2021
            <input type="text" name="refNo" id="refNo"/> -->
    </div>
</form>



<div id="popup_wrap" class="popup_wrap "><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.membershipMgmtNewQuotation" />  </h1>
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
<div  id="resultcontens"  style="display:none">

<form action="#"   id="sForm"  name="saveForm" method="post"   onsubmit="return false;">


        <section class="tap_wrap"><!-- tap_wrap start -->
        <ul class="tap_type1">
            <li><a href="#" class="on"  ><spring:message code="sal.tap.title.ordInfo" /></a></li>
            <!-- <li><a href="#"><spring:message code="sal.tap.title.contactPerson" /></a></li>-->
            <li><a href="#" onclick="javascript:AUIGrid.resize(bsHistoryGridID, 950,380);"><spring:message code="sal.tap.title.bsHis" /></a></li>
            <li><a href="#"  onclick="javascript:AUIGrid.resize(oListGridID, 950,380);"><spring:message code="sal.tap.title.orderProductFilter" /></a></li>
        </ul>

        <article class="tap_area"><!-- tap_area start -->

        <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:130px" />
            <col style="width:*" />
            <col style="width:130px" />
            <col style="width:*" />
            <col style="width:130px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row"><spring:message code="sal.text.ordNo" /></th>
            <td><span id='ordNo' ></span></td>
            <th scope="row"><spring:message code="sal.text.ordDate" /></th>
            <td><span id='ordDt'></span></td>
            <th scope="row"><spring:message code="sal.text.insPeriod" /></th>
            <td><span id='InstallmentPeriod'></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.orderStatus" /></th>
            <td><span id='ordStusName'></span></td>
            <th scope="row"><spring:message code="sal.text.rentalStatus" /></th>
            <td><span id='rentalStus'></span></td>
            <th scope="row"><spring:message code="sal.text.insNo" /></th>
            <td><span id='installNo'></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.appType" /></th>
            <td><span id='appTypeDesc'></span></td>
            <th scope="row"><spring:message code="sal.text.refNo" /></th>
            <td><span id='ordRefNo'></span></td>
            <th scope="row"><spring:message code="sal.text.insDate" /></th>
            <td><span id='installDate'></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.stockCode" /></th>
            <td><span id='stockCode'></span></td>
            <th scope="row"><spring:message code="sal.text.stokName" /></th>
            <td colspan="3" id='stockDesc'><span></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.coolingOffPeriod" /></th>
            <td><span id='coolingOffPeriod'></span></td>
            <th scope="row"><spring:message code="sal.text.term" /></th>
            <td><span id='term'></span></td>
            <th scope="row"><spring:message code="sal.text.isCharge" /></th>
            <td><span id='isCharge'></span></td>
        </tr>
        <tr>
            <th scope="row" rowspan="3"><spring:message code="sal.text.instAddr" /></th>
            <td rowspan="3" colspan="3" id='address'><span></span></td>
            <th scope="row"><spring:message code="sal.text.ordOutstanding" /></th>
            <td><span id='ordoutstanding'></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.asOutstanding" /></th>
            <td><span id='asoutstanding'></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.memExpire" /></th>
            <td><span id='expire'></span></td>
        </tr>

        <tr>
            <th scope="row"><spring:message code="sal.text.customerId" /></th>
            <td><span id='custId'></span></td>
            <th scope="row"><spring:message code="sal.text.custType" /></th>
            <td colspan="3" id='custType'><span></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.custName" /></th>
            <td colspan="5" id='custName'><span></span></td>
        </tr>
<!--         <tr> -->
<%--             <th scope="row"><spring:message code="sal.text.nric" />/<spring:message code="sal.text.companyNo" /></th> --%>
<!--             <td colspan="5" id='custNric' ><span></span></td> -->
<!--         </tr> -->
        </tbody>
        </table><!-- table end -->
        <p class="brown_text mt10">(<spring:message code="sal.text.isChargeFilter" />)</p>
        </article><!-- tap_area end -->


<!--      <article class="tap_area">tap_area start -->

<!--         <ul class="left_btns mb10"> -->
<%--             <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_goContactPersonPop()"><spring:message code="sal.btn.otherContactPerson" /></a></p></li> --%>
<%--            <li><p class="btn_blue2"><a href="#" onclick="fn_goNewContactPersonPop()"><spring:message code="sal.btn.newContactPerson" /></a></p></li> --%>
<!--         </ul> -->

<!--         <table class="type1">table start -->
<!--         <caption>table</caption> -->
<!--         <colgroup> -->
<!--             <col style="width:130px" /> -->
<!--             <col style="width:*" /> -->
<!--             <col style="width:130px" /> -->
<!--             <col style="width:*" /> -->
<!--             <col style="width:130px" /> -->
<!--             <col style="width:*" /> -->
<!--             <col style="width:130px" /> -->
<!--             <col style="width:*" /> -->
<!--         </colgroup> -->
<!--         <tbody> -->
<!--                  <tr> -->
<%--                     <th scope="row"><spring:message code="sal.text.name" /></th> --%>
<!--                     <td colspan="5" id="name"><span></span></td> -->
<!--                     <th scope="row"></th> -->
<!--                     <td><span id="gender"></span></td> -->
<!--                 </tr> -->
<!--                 <tr> -->
<%--                     <th scope="row"><spring:message code="sal.text.nric" /></th> --%>
<!--                     <td colspan="5" id="nric"><span></span></td> -->
<%--                     <th scope="row"><spring:message code="sal.text.race" /></th> --%>
<!--                     <td><span id="codename1"></span></td> -->
<!--                 </tr> -->
<!--                 <tr> -->
<%--                     <th scope="row"><spring:message code="sal.text.mobileNo" /></th> --%>
<!--                     <td><span id="telM1"></span></td> -->
<%--                     <th scope="row"><spring:message code="sal.text.officeNo" /></th> --%>
<!--                     <td><span id="telO"></span></td> -->
<%--                     <th scope="row"><spring:message code="sal.text.residenceNo" /></th> --%>
<!--                     <td><span id="telR" ></span></td> -->
<%--                     <th scope="row"><spring:message code="sal.text.faxNo" /></th> --%>
<!--                     <td><span id="telf"></span></td> -->
<!--                 </tr> -->
<!--                 <tr> -->
<%--                     <th scope="row"><spring:message code="sal.text.email" /></th> --%>
<!--                     <td colspan="7" id="email"><span></span></td> -->
<!--                 </tr> -->
<!--         </tbody> -->
<!--         </table>table end -->
<!--         </article>tap_area end -->



        <article class="tap_area"><!-- tap_area start -->
        <article class="grid_wrap"><!-- grid_wrap start -->
           <div id="hList_grid_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
        </article><!-- grid_wrap end -->
       </article><!-- tap_area end -->



        <article class="tap_area"><!-- tap_area start -->
        <article class="grid_wrap"><!-- grid_wrap start -->
           <div id="oList_grid_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
        </article><!-- grid_wrap end -->

        </article><!-- tap_area end -->

        </section><!-- tap_wrap end -->

        <aside class="title_line"><!-- title_line start -->
        <h3>Membership Information</h3>
        </aside><!-- title_line end -->

        <section class="search_table"><!-- search_table start -->
        <form action="#" method="post"  id='collForm' name ='collForm'>

        <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:130px" />
            <col style="width:*" />
            <col style="width:120px" />
            <col style="width:100px" />
            <col style="width:100px" />
            <col style="width:100px" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row"><spring:message code="sal.text.typeOfPack" /></th>
            <td>
            <select class="w100p" id='cTPackage' name='cTPackage'   onChange="fn_cTPackage_onchangeEvt()"></select>
            </td>
            <th scope="row"><spring:message code="sal.text.subscriptionYear" /></th>
            <td width='80px'>
            <select  id="cYear"   name= "cYear" style="width:80px"  disabled="disabled"  onChange="fn_cYear_onChageEvent()" >
                <option value="12" >1</option>
                <option value="24" >2</option>
<!--                 <option value="36" >3</option> -->
<!--                 <option value="48" >4</option> -->
            </select>
            </td>

              <th scope="row"><spring:message code="sal.text.employee" /> </th>
                <td>
                <select  style="width:80px"  id="cEmplo"   onChange="fn_cYear_onChageEvent()">
                    <option value="1">Y</option>
                    <option selected="selected" value="0">N</option>
                </select>
                </td>


        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.packPromotion" /></th>
            <td>

                     <div  style='display:none'>
                       <label>
                        <input type="checkbox" disabled="disabled"  id="packpro"   name="packpro" onclick="fn_doPackagePro(this)" /><span></span></label>
                     </div>
                    <select   id="cPromotionpac" name="cPromotionpac"  onChange="fn_onChange_cPromotionpac()"> </select>
            </td>
            <th scope="row"><spring:message code="sal.text.packPrice" /></th>
            <td  colspan="3">
                    <span id='txtPackagePrice'></span>
                    <span class='sstText' style="font-style: italic;color: red;"> <spring:message code='sys.common.sst.msg.incld' /></span>
            </td>

        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.filterPromo" /></th>
            <td>
          <div  style='display:none'>
            <label><input type="checkbox" disabled="disabled"  id="cPromoCombox"   name="cPromoCombox" onclick="fn_doPromoCombox(this)" /><span></span></label>
          </div>
            <select  id="cPromo" name='cPromo'  onchange="fn_getFilterChargeList()"></select>
            </td>
            <th scope="row"><spring:message code="sal.text.filterPrice" /></th>
            <td colspan="2">
                  <span id="txtFilterCharge"></span>
             </td>
            <td>
                  <div  id="btnViewFilterCharge" class="right_btns"  style="display:none" >
                        <p class="btn_sky"><a href="#" onclick="javascript:fn_LoadMembershipFilter()"><spring:message code="sal.text.detail" /></a></p>
                   </div>
        </tr>

        <tr>
            <th scope="row"><spring:message code="sal.text.salPersonCode" /></th>
            <td><input type="text" title="" placeholder="" class=""  style="width:100px" id="SALES_PERSON" name="SALES_PERSON"  />
                <p class="btn_sky"  id="sale_confirmbt" ><a href="#" onclick="javascript:fn_goSalesConfirm()"><spring:message code="sal.btn.confirm" /></a></p>
                <p class="btn_sky"  id="sale_searchbt"><a href="#" onclick="javascript:fn_goSalesPerson()" ><spring:message code="sal.btn.search" /></a></p>
                <p class="btn_sky"  id="sale_resetbt" style="display:none"><a href="#" onclick="javascript:fn_goSalesPersonReset()" ><spring:message code="sal.btn.reset" /></a></p>
            </td>
            <th scope="row"><spring:message code="sal.text.salPersonCode" /></th>
            <td colspan="3"><span id="SALES_PERSON_DESC"  name="SALES_PERSON_DESC"></span></td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.remark" /></th>
            <td><textarea cols="20" rows="5" id='txtRemark' name=''></textarea></td>
            <th scope="row"><spring:message code="sal.text.bsFrequency" /></th>
            <td colspan="3" ><span id='txtBSFreq'></span></td>
        </tr>
       <%--  <tr>
            <th scope="row"><spring:message code="sal.text.refNo" /></th>
            <td><input type="text" title="" placeholder="" class=""  id="REF_NO" name="REF_NO"  />
            <th></th>
            <td colspan="3"></td>
        </tr> --%>
        </tbody>
        </table><!-- table end -->
        </form>
        </section><!-- search_table end -->


        <ul class="center_btns">
            <li><p class="btn_blue2"><a href="#"  onclick="javascript:fn_save()"><spring:message code="sal.btn.save" /></a></p></li>

         <!--  <li><p class="btn_blue2"><a href="#"  onclick="javascript:fn_saveResultTrans()">test</a></p></li> -->
        </ul>
</form>

</div>
</section>

</section><!-- content end -->


</section>

</div>
