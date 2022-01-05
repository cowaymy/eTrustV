<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
	var TODAY_DD = "${toDay}";
	var ORD_ID = "${orderDetail.basicInfo.ordId}";
	var ORD_NO = "${orderDetail.basicInfo.ordNo}";
	var ORD_DT = "${orderDetail.basicInfo.ordDt}";
	var ORD_STUS_ID = "${orderDetail.basicInfo.ordStusId}";
	var ORD_STUS_CODE = "${orderDetail.basicInfo.ordStusCode}";
	var CUST_ID = "${orderDetail.basicInfo.custId}";
	var CUST_TYPE_ID = "${orderDetail.basicInfo.custTypeId}";
	var APP_TYPE_ID = "${orderDetail.basicInfo.appTypeId}";
	var APP_TYPE_DESC = "${orderDetail.basicInfo.appTypeDesc}";
	var CUST_NRIC = "${orderDetail.basicInfo.custNric}";
	var PROMO_ID = "${orderDetail.basicInfo.ordPromoId}";
	var PROMO_CODE = "${orderDetail.basicInfo.ordPromoCode}";
	var PROMO_DESC = "${orderDetail.basicInfo.ordPromoDesc}";
	var STOCK_ID = "${orderDetail.basicInfo.stockId}";
	var STOCK_CDE = "${orderDetail.basicInfo.stockCode}";
	var STOCK_DESC = "${orderDetail.basicInfo.stockDesc}";
	var CNVR_SCHEME_ID = "${orderDetail.basicInfo.cnvrSchemeId}";
	var RENTAL_STUS = "${orderDetail.basicInfo.rentalStus}";
	var EMP_CHK = "${orderDetail.basicInfo.empChk}";
	var EX_TRADE = "${orderDetail.basicInfo.exTrade}";
	var TODAY_DD = "${toDay}";
	var SRV_PAC_ID = "${orderDetail.basicInfo.srvPacId}";
	var GST_CHK = "${orderDetail.basicInfo.gstChk}";
	var IS_NEW_VER = "${orderDetail.isNewVer}";
	var txtPrice_uc_Value = "${orderDetail.basicInfo.ordAmt}";
	var txtPV_uc_Value = "${orderDetail.basicInfo.ordPv}";

	var myFileCaches = {};
	var atchFileGrpId = 0;

	var filterGridID;
	var globalCmbFlg = 0; // VARIABLE FOR COMBO PACKAGE PROMOTION FLAG. 0 > NOT COMBO PROMO. 1 > IS COMBO PROMO.

	$(document).ready(function() {
		console.log("rootRequestPop");

		// Taken out from fn_changeTab("OTRN")
		var vTit = '<spring:message code="sal.page.title.ordReq" />';

		if ($("#ordReqType option:selected").index() > 0) {
			vTit += ' - ' + $('#ordReqType option:selected').text();
		}

		$('#hTitle').text(vTit);

		$('#aTabBI').click();
		fn_loadListOwnt();
		fn_loadOrderInfoOwnt();

		// j_date
		var dateToday = new Date();
		var pickerOpts = {
			changeMonth : true,
			changeYear : true,
			dateFormat : "dd/mm/yy",
			minDate : dateToday
		};

		$("#dpCallLogDate").datepicker(pickerOpts);
	});

	$(function() {
		// General - Start
		// $("#btnCloseReq").click(fn_back("reqC"));

		$("#fileSelector1").change(function(e) {
			var file = e.target.files[0];

			if (file == null && myFileCaches[1] != null) {
				delete myFileCaches[1];
			} else if (file != null) {
				myFileCaches[1] = {
					file : file
				};
			}
			console.log(myFileCaches);
		});

		$("#fileSelector2").change(function(e) {
			var file = e.target.files[0];

			if (file == null && myFileCaches[2] != null) {
				delete myFileCaches[2];
			} else if (file != null) {
				myFileCaches[2] = {
					file : file
				};
			}
			console.log(myFileCaches);
		});

		$("#fileSelector3").change(function(e) {
			var file = e.target.files[0];

			if (file == null && myFileCaches[3] != null) {
				delete myFileCaches[3];
			} else if (file != null) {
				myFileCaches[3] = {
					file : file
				};
			}
			console.log(myFileCaches);
		});

		$("#fileSelector4").change(function(e) {
			var file = e.target.files[0];

			if (file == null && myFileCaches[4] != null) {
				delete myFileCaches[4];
			} else if (file != null) {
				myFileCaches[4] = {
					file : file
				};
			}
			console.log(myFileCaches);
		});

		$("#fileSelector5").change(function(e) {
			var file = e.target.files[0];

			if (file == null && myFileCaches[5] != null) {
				delete myFileCaches[5];
			} else if (file != null) {
				myFileCaches[5] = {
					file : file
				};
			}
			console.log(myFileCaches);
		});

		$("#fileSelector6").change(function(e) {
			var file = e.target.files[0];
			if (file == null && myFileCaches[6] != null) {
				delete myFileCaches[6];
			} else if (file != null) {
				myFileCaches[6] = {
					file : file
				};
			}
			console.log(myFileCaches);
		});

		$("#fileSelector7").change(function(e) {
			var file = e.target.files[0];

			if (file == null && myFileCaches[7] != null) {
				delete myFileCaches[7];
			} else if (file != null) {
				myFileCaches[7] = {
					file : file
				};
			}
			console.log(myFileCaches);
		});

		$("#fileSelector8").change(function(e) {
			var file = e.target.files[0];

			if (file == null && myFileCaches[8] != null) {
				delete myFileCaches[8];
			} else if (file != null) {
				myFileCaches[8] = {
					file : file
				};
			}
			console.log(myFileCaches);
		});

		$("#fileSelector9").change(function(e) {
			var file = e.target.files[0];

			if (file == null && myFileCaches[9] != null) {
				delete myFileCaches[9];
			} else if (file != null) {
				myFileCaches[9] = {
					file : file
				};
			}
			console.log(myFileCaches);
		});

		$("#fileSelector10").change(function(e) {
			var file = e.target.files[0];

			if (file == null && myFileCaches[10] != null) {
				delete myFileCaches[10];
			} else if (file != null) {
				myFileCaches[10] = {
					file : file
				};
			}
			console.log(myFileCaches);
		});
		// General - End

		$('#btnReqOwnTrans').click(function() {
			// fn_isLockOrder is not needed here as data saving will insert into ROT staging
			console.log("btnReqOwnTrans :: click");
			if (fn_validReqOwnt()) {
				fn_attachmentUpload();
				//fn_doSaveReqOwnt();
			}
		});

		$('#custIdOwnt').change(function(event) {
			fn_selectCustInfo();
		});

		$('#custIdOwnt').keydown(function(event) {
			if (event.which === 13) { //enter
				fn_selectCustInfo();
				return false;
			}
		});

		$('#addCustBtn').click(
				function() {
					Common.popupWin("searchFormOwnt",
							"/sales/customer/customerRegistPop.do", {
								width : "1200px",
								height : "580x"
							});
				});

		$('#custBtnOwnt').click(function() {
			Common.popupDiv("/common/customerPop.do", {
				callPrgm : "ORD_REGISTER_CUST_CUST"
			}, null, true);
		});


		$('#btnAddAddress').click(function() {
			Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {
				custId : $('#txtHiddenCustIDOwnt').val(),
				callParam : "ORD_REQUEST_MAIL"
			}, null, true);
		});

		$('#btnSelectAddress').click(function() {
			Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {
				custId : $('#txtHiddenCustIDOwnt').val(),
				callPrgm : "fn_loadMailAddress"
			}, null, true);
		});

		$('#btnAddContact').click(function() {
			Common.popupDiv('/sales/customer/updateCustomerNewContactPop.do', {
				"custId" : $('#txtHiddenCustIDOwnt').val(),
				callParam : "ORD_REQUEST_MAIL"
			}, null, true, '_editDiv3New');
		});

		$('#btnSelectContact').click(function() {
			Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {
				custId : $('#txtHiddenCustIDOwnt').val(),
				callPrgm : "fn_loadCntcPerson"
			}, null, true);
		});

		$('#btnAddInstAddress').click(function() {
			Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {
				custId : $('#txtHiddenCustIDOwnt').val(),
				callParam : "ORD_REQUEST_MAIL"
			}, null, true);
		});

		$('#btnSelectInstAddress').click(function() {
			Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {
				custId : $('#txtHiddenCustIDOwnt').val(),
				callPrgm : "fn_loadInstAddress"
			}, null, true);
		});

		$('#btnAddInstContact').click(function() {
			Common.popupDiv('/sales/customer/updateCustomerNewContactPop.do', {
				"custId" : $('#txtHiddenCustIDOwnt').val(),
				callParam : "ORD_REQUEST_MAIL"
			}, null, true, '_editDiv3New');
		});

		$('#btnSelectInstContact').click(function() {
			Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {
				custId : $('#txtHiddenCustIDOwnt').val(),
				callPrgm : "fn_loadInstallationCntcPerson"
			}, null, true);
		});

		$('#btnThirdPartyOwnt').click(function(event) {
			fn_clearRentPayMode();
			fn_clearRentPay3thParty();
			fn_clearRentPaySetCRC();
			fn_clearRentPaySetDD();

			if ($('#btnThirdPartyOwnt').is(":checked")) {
				$('#sctThrdParty').removeClass("blind");
			} else {
				$('#sctThrdParty').addClass("blind");
			}
		});

		$('#cmbRentPaymodeOwnt')
				.change(
						function() {
							fn_clearRentPaySetCRC();
							fn_clearRentPaySetDD();

							var rentPayModeIdx = $(
									"#cmbRentPaymodeOwnt option:selected")
									.index();
							var rentPayModeVal = $("#cmbRentPaymodeOwnt").val();

							if (rentPayModeIdx > 0) {
								if (rentPayModeVal == '133'
										|| rentPayModeVal == '134') {
									var rentPayModeTxt = $(
											"#cmbRentPaymodeOwnt option:selected")
											.text();

									Common
											.alert('<spring:message code="sal.alert.msg.rentPayRestriction" />'
													+ DEFAULT_DELIMITER
													+ '<spring:message code="sal.alert.msg.notProvideSvc" arguments="'+rentPayModeTxt+'"/>');
									fn_clearRentPayMode();
								} else {
									if (rentPayModeVal == '131') {
										if ($('#btnThirdPartyOwnt').is(
												":checked")
												&& FormUtil
														.isEmpty($(
																'#txtHiddenThirdPartyIDOwnt')
																.val())) {
											Common
													.alert('<spring:message code="sal.alert.title.thirdPartyRequired" />'
															+ DEFAULT_DELIMITER
															+ '<spring:message code="sal.alert.msg.plzSelThirdPartyFirst" />');
										} else {
											$('#sctCrCard')
													.removeClass("blind");
										}
									} else if (rentPayModeVal == '132') {
										if ($('#btnThirdPartyOwnt').is(
												":checked")
												&& FormUtil
														.isEmpty($(
																'#txtHiddenThirdPartyIDOwnt')
																.val())) {
											Common
													.alert('<spring:message code="sal.alert.title.thirdPartyRequired" />'
															+ DEFAULT_DELIMITER
															+ '<spring:message code="sal.alert.msg.plzSelThirdPartyFirst" />');
										} else {
											$('#sctDirectDebit').removeClass(
													"blind");
										}
									}
								}
							}
						});

		$('#txtThirdPartyIDOwnt').change(function(event) {
			fn_loadThirdParty($('#txtThirdPartyIDOwnt').val().trim(), 2);
		});

		$('#txtThirdPartyIDOwnt').keydown(function(event) {
			if (event.which === 13) { //enter
				fn_loadThirdParty($('#txtThirdPartyIDOwnt').val().trim(), 2);
			}
		});

		$('#thrdPartyBtn').click(function() {
			Common.popupDiv("/common/customerPop.do", {
				callPrgm : "ORD_REQUEST_PAY"
			}, null, true);
		});

		$('#btnAddCRC').click(
				function() {
					var vCustId = $('#btnThirdPartyOwnt').is(":checked") ? $(
							'#txtHiddenThirdPartyIDOwnt').val() : $(
							'#txtHiddenCustIDOwnt').val();

					if (FormUtil.isEmpty($("#nricOwnt").val())) {
						Common.alert("NRIC required to add new Credit Card!");
						return false;
					}

					Common.popupDiv(
							"/sales/customer/customerCreditCardAddPop.do", {
								custId : vCustId,
								nric : $("#nricOwnt").val()
							}, null, true);
				});

		$('#btnSelectCRC').click(
				function() {
					var vCustId = $('#btnThirdPartyOwnt').is(":checked") ? $(
							'#txtHiddenThirdPartyIDOwnt').val() : $(
							'#txtHiddenCustIDOwnt').val();

					Common.popupDiv(
							"/sales/customer/customerCreditCardSearchPop.do", {
								custId : vCustId,
								callPrgm : "ORD_REQUEST_PAY"
							}, null, true);
				});

		$('#btnAddBankAccount').click(
				function() {
					var vCustId = $('#thrdParty').is(":checked") ? $(
							'#txtHiddenThirdPartyIDOwnt').val() : $(
							'#txtHiddenCustIDOwnt').val();

					Common.popupDiv(
							"/sales/customer/customerBankAccountAddPop.do", {
								custId : vCustId
							}, null, true);
				});

		$('#btnSelectBankAccount').click(
				function() {
					var vCustId = $('#thrdParty').is(":checked") ? $(
							'#txtHiddenThirdPartyIDOwnt').val() : $(
							'#txtHiddenCustIDOwnt').val();

					Common.popupDiv(
							"/sales/customer/customerBankAccountSearchPop.do",
							{
								custId : vCustId,
								callPrgm : "ORD_REQUEST_PAY"
							});
				});

		$('#btnAddThirdParty').click(
				function() {
					Common.popupWin("searchFormOwnt",
							"/sales/customer/customerRegistPop.do", {
								width : "1200px",
								height : "580x"
							});
				});

		$('[name="grpOpt"]').click(function() {
			fn_setBillGrp($('input:radio[name="grpOpt"]:checked').val());
		});

		$('#billGrpBtn').click(function() {
			Common.popupDiv("/sales/customer/customerBillGrpSearchPop.do", {
				custId : $('#txtHiddenCustIDOwnt').val(),
				callPrgm : "ORD_REQUEST_BILLGRP"
			}, null, true);
		});

		// Rental Billing Group Address Buttons
		$('#liBillNewAddr').click(function() {
			Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {
				custId : $('#txtHiddenCustIDOwnt').val(),
				callParam : "ORD_REGISTER_BILL_MTH"
			}, null, true);
		});

		$('#liBillSelAddr').click(function() {
			//Common.popupWin("searchForm", "/sales/customer/customerAddressSearchPop.do", {width : "1200px", height : "630x"});
			Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {
				custId : $('#txtHiddenCustIDOwnt').val(),
				callPrgm : "ORD_REGISTER_BILL_MTH"
			}, null, true);
		});

		$('#billPreferAddAddrBtn')
				.click(
						function() {
							//Common.popupWin("searchForm", "/sales/customer/customerConctactSearchPop.do", {width : "1200px", height : "630x"});
							Common
									.popupDiv(
											'/sales/customer/updateCustomerNewAddContactPop.do',
											{
												"custId" : $(
														'#txtHiddenCustIDOwnt')
														.val(),
												"callParam" : ""
											}, null, true, '_editDiv3New');
						});

		$('#billPreferSelAddrBtn').click(function() {
			//Common.popupWin("searchForm", "/sales/customer/customerConctactSearchPop.do", {width : "1200px", height : "630x"});
			Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {
				custId : $('#txtHiddenCustIDOwnt').val(),
				callPrgm : "ORD_REGISTER_BILL_PRF"
			}, null, true);
		});


		$('#billMthdPost').change(function() {
			$('#hiddenBillMthdPost').val("0");
			if ($("#billMthdPost").is(":checked")) {
				$('#billMthdEstm').change();
				$('#billMthdSms').change();
				$('#hiddenBillMthdPost').val("1");
			}
		});
		$('#billMthdSms').change(
				function() {
					$('#billMthdSms1').prop("checked", false).prop("disabled",
							true);
					$('#billMthdSms2').prop("checked", false).prop("disabled",
							true);

					$('#hiddenBillMthdSms1').val("0");
					$('#hiddenBillMthdSms2').val("0");
					if ($("#billMthdSms").is(":checked")) {
						$('#billMthdEstm').change();
						$('#billMthdSms1').removeAttr("disabled").prop(
								"checked", true);
						$('#billMthdSms2').removeAttr("disabled");
						$('#hiddenBillMthdSms1').val("1");
					}
				});
		$('#billMthdSms2').change(function() {
			$('#hiddenBillMthdSms2').val("0");
			if ($("#billMthdSms").is(":checked")) {
				$('#hiddenBillMthdSms2').val("1");
			}
		});
		$('#billMthdEstm').change(
				function() {

					$('#spEmail1').text("");
					$('#spEmail2').text("");
					$('#billMthdEmail1').prop("checked", false).prop(
							"disabled", true);
					$('#billMthdEmail2').prop("checked", false).prop(
							"disabled", true);
					$('#billMthdEmailTxt1').val("").prop("disabled", true);
					$('#billMthdEmailTxt2').val("").prop("disabled", true);

					$('#hiddenBillMthdEstm').val("0");

					if ($("#billMthdEstm").is(":checked")) {
						$('#billMthdSms').change();
						$('#spEmail1').text("*");
						$('#spEmail2').text("*");
						$('#billMthdEmail1').removeAttr("disabled").prop(
								"checked", true);
						$('#billMthdEmail2').removeAttr("disabled");
						$('#billMthdEmailTxt1').removeAttr("disabled").val(
								$('#txtContactEmailOwnt').val().trim());
						$('#billMthdEmailTxt2').removeAttr("disabled");
						//$('#billMthdEmailTxt2').removeAttr("disabled").val($('#srvCntcEmail').val().trim());
						$('#hiddenBillMthdEstm').val("1");
					}
				});
		$('#billGrpWeb').change(function() {
			$('#hiddenBillGrpWeb').val("0");
			if ($("#billGrpWeb").is(":checked")) {
				$('#hiddenBillGrpWeb').val("1");
			}
		});
	});

	function fn_loadBillingGroup(billGrpId, custBillGrpNo, billType,
			billAddrFull, custBillRem, custBillAddId) {
		$('#txtHiddenBillGroupIDOwnt').removeClass("readonly").val(billGrpId);
		$('#txtBillGroupOwnt').removeClass("readonly").val(custBillGrpNo);
		$('#txtBillTypeOwnt').removeClass("readonly").val(billType);
		$('#txtBillAddressOwnt').removeClass("readonly").val(billAddrFull);
		$('#txtBillGroupRemarkOwnt').removeClass("readonly").val(custBillRem);

		fn_loadMailAddress(custBillAddId);
	}

	function fn_setBillGrp(grpOpt) {
		if (grpOpt == 'new') {
			$('#btnAddAddress').removeClass("blind");
			$('#btnSelectAddress').removeClass("blind");

			fn_clearBillGroup();

			$('#grpOpt1').prop("checked", true);

			$('#sctBillMthd').removeClass("blind");
			$('#sctBillAddr').removeClass("blind");
			//          $('#sctBillPrefer').removeClass("blind");

			$('#liBillNewAddr').removeClass("blind");
			$('#liBillSelAddr').removeClass("blind");
			$('#liBillPreferNewAddr').removeClass("blind");
			$('#liBillPreferSelAddr').removeClass("blind");

			$('#billMthdEmailTxt1').val($('#txtContactEmailOwnt').val().trim());
			// $('#billMthdEmailTxt2').val($('#srvCntcEmail').val().trim());

			if ($('#typeIdOwnt').val() == '965') {
				//Company
				console.log("fn_setBillGrp 1 typeId : "
						+ $('#typeIdOwnt').val());

				$('#sctBillPrefer').removeClass("blind");

				console.log("setBillGrp :: " + $('#newCustCntcId').val());
				fn_loadBillingPreference($('#newCustCntcId').val());

				$('#billMthdEstm').prop("checked", true);
				$('#billMthdEmail1').prop("checked", true).removeAttr(
						"disabled");
				$('#billMthdEmail2').removeAttr("disabled");
				$('#billMthdEmailTxt1').removeAttr("disabled");
				$('#billMthdEmailTxt2').removeAttr("disabled");

				$('#hiddenBillMthdEstm').val("1");

				if ($("#corpTypeId").val() == 1151
						|| $("#corpTypeId").val() == 1154
						|| $("#corpTypeId").val() == 1333) {
					$('#billMthdPost').removeAttr("disabled");
				} else {
					$('#billMthdPost').prop("disabled", true);
				}
			} else if ($('#typeIdOwnt').val() == '964') {
				//Individual

				console.log("fn_setBillGrp 2 typeId : "
						+ $('#typeIdOwnt').val());
				console.log("custCntcEmail : "
						+ $('#txtContactEmailOwnt').val());
				console.log(FormUtil.isNotEmpty($('#txtContactEmailOwnt').val()
						.trim()));

				if (FormUtil.isNotEmpty($('#txtContactEmailOwnt').val().trim())) {
					$('#billMthdEstm').prop("checked", true);
					$('#billMthdEmail1').prop("checked", true).removeAttr(
							"disabled");
					$('#billMthdEmail2').removeAttr("disabled");
					$('#billMthdEmailTxt1').removeAttr("disabled");
					$('#billMthdEmailTxt2').removeAttr("disabled");
					$('#billMthdPost').removeAttr("disabled");

					$('#hiddenBillMthdEstm').val("1");
				}

				$('#billMthdSms').prop("checked", true);
				$('#billMthdSms1').prop("checked", true).removeAttr("disabled");
				$('#billMthdSms2').removeAttr("disabled");

				$('#hiddenBillMthdSms1').val("1");
			}

		} else if (grpOpt == 'exist') {
			$('#btnAddAddress').removeClass("blind");
			$('#btnSelectAddress').removeClass("blind");

			fn_clearBillGroup();

			$('#sctBillSel').removeClass("blind");
			$('#liBillNewAddr').removeClass("blind");
			$('#liBillSelAddr').removeClass("blind");
			$('#liBillPreferNewAddr').removeClass("blind");
			$('#liBillPreferSelAddr').removeClass("blind");

			$('#grpOpt2').prop("checked", true);
			$('#sctBillSel').removeClass("blind");
			$('#txtBillGroupRemarkOwnt').prop("readonly", true);
		}
	}

	function fn_loadBillingPreference(custCareCntId) {

		Common.ajax("GET", "/sales/order/selectSrvCntcJsonInfo.do", {
			custCareCntId : custCareCntId
		}, function(srvCntcInfo) {

			if (srvCntcInfo != null) {
				$("#hiddenBPCareId").val(srvCntcInfo.custCareCntId);
				$("#billPreferInitial").val(srvCntcInfo.custInitial);
				$("#billPreferName").val(srvCntcInfo.name);
				$("#billPreferTelO").val(srvCntcInfo.telO);
				$("#billPreferExt").val(srvCntcInfo.ext);
			}
		});
	}

	function fn_loadBankAccountPop(bankAccId) {
		fn_clearRentPaySetDD();
		fn_loadBankAccount(bankAccId);

		$('#sctDirectDebit').removeClass("blind");

		if (!FormUtil.IsValidBankAccount($('#txtHiddenRentPayBankAccIDOwnt')
				.val(), $('#txtRentPayBankAccNoOwnt').val())) {
			fn_clearRentPaySetDD();
			$('#sctDirectDebit').removeClass("blind");
			Common
					.alert('<spring:message code="sal.alert.title.invalidBankAcc" />'
							+ DEFAULT_DELIMITER
							+ '<spring:message code="sal.alert.msg.invalidAccForAutoDebit" />');
		}
	}

	function fn_loadBankAccount(bankAccId) {
		Common.ajax("GET", "/sales/order/selectCustomerBankDetailView.do", {
			getparam : bankAccId
		}, function(rsltInfo) {

			if (rsltInfo != null) {
				$("#txtHiddenRentPayBankAccIDOwnt").val(rsltInfo.custAccId);
				$("#txtRentPayBankAccNoOwnt").val(rsltInfo.custAccNo);
				$("#hiddenRentPayEncryptBankAccNoOwnt").val(
						rsltInfo.custEncryptAccNo);
				$("#txtRentPayBankAccTypeOwnt").val(rsltInfo.codeName);
				$("#txtRentPayBankAccNameOwnt").val(rsltInfo.custAccOwner);
				$("#txtRentPayBankAccBankBranchOwnt").val(
						rsltInfo.custAccBankBrnch);
				$("#txtRentPayBankAccBankOwnt").val(
						rsltInfo.bankCode + ' - ' + rsltInfo.bankName);
				$("#hiddenRentPayBankAccBankIDOwnt")
						.val(rsltInfo.custAccBankId);
			}
		});
	}

	function fn_loadCreditCard(crcId, custOriCrcNo, custCrcNo, custCrcType,
			custCrcName, custCrcExpr, custCRCBank, custCrcBankId, crcCardType) {
		$('#txtHiddenRentPayCRCIDOwnt').val(crcId);
		$('#txtRentPayCRCNoOwnt').val(custOriCrcNo);
		$('#hiddenRentPayEncryptCRCNoOwnt').val(custCrcNo);
		$('#txtRentPayCRCTypeOwnt').val(custCrcType);
		$('#txtRentPayCRCNameOwnt').val(custCrcName);
		$('#txtRentPayCRCExpiryOwnt').val(custCrcExpr);
		$('#txtRentPayCRCBankOwnt').val(custCRCBank);
		$('#hiddenRentPayCRCBankIDOwnt').val(custCrcBankId);
		$('#rentPayCRCCardTypeOwnt').val(crcCardType);
	}

	function fn_loadThirdParty(custId, sMethd) {

		fn_clearRentPayMode();
		fn_clearRentPay3thParty();
		fn_clearRentPaySetCRC();
		fn_clearRentPaySetDD();

		if (custId != $('#txtHiddenCustIDOwnt').val()) {
			Common
					.ajax(
							"GET",
							"/sales/customer/selectCustomerJsonList",
							{
								custId : custId
							},
							function(result) {
								if (result != null && result.length == 1) {
									var custInfo = result[0];

									$('#txtHiddenThirdPartyIDOwnt').val(
											custInfo.custId)
									$('#txtThirdPartyIDOwnt').val(
											custInfo.custId)
									$('#txtThirdPartyTypeOwnt').val(
											custInfo.codeName1)
									$('#txtThirdPartyNameOwnt').val(
											custInfo.name)
									$('#txtThirdPartyNRICOwnt').val(
											custInfo.nric)

								} else {
									if (sMethd == 2) {
										Common
												.alert('<spring:message code="sal.alert.msg.input3rdPartyId" arguments="'+custId+'"/>');
									}
								}
							});
		} else {
			Common
					.alert('<spring:message code="sal.alert.msg.samePerson3rdPartyId" arguments="'+custId+'"/>');
		}

		$('#sctThrdParty').removeClass("blind");
	}

	//ClearControl_RentPaySet_ThirdParty
	function fn_clearRentPayMode() {
		$('#cmbRentPaymodeOwnt').val('');
		$('#txtRentPayICOwnt').val('');
	}

	//ClearControl_RentPaySet_ThirdParty
	function fn_clearRentPay3thParty() {
		//PanelThirdParty.Visible = false;
		$('#txtThirdPartyIDOwnt').val('');
		$('#txtHiddenThirdPartyIDOwnt').val('');
		$('#txtThirdPartyTypeOwnt').val('');
		$('#txtThirdPartyNameOwnt').val('');
		$('#txtThirdPartyNRICOwnt').val('');
	}

	//ClearControl_RentPaySet_CRC
	function fn_clearRentPaySetCRC() {
		$('#sctCrCard').addClass("blind");
		$('#txtRentPayCRCNoOwnt').val('');
		$('#txtHiddenRentPayCRCIDOwnt').val('');
		$('#hiddenRentPayEncryptCRCNoOwnt').val('');
		$('#txtRentPayCRCTypeOwnt').val('');
		$('#txtRentPayCRCNameOwnt').val('');
		$('#txtRentPayCRCExpiryOwnt').val('');
		$('#txtRentPayCRCBankOwnt').val('');
		$('#hiddenRentPayCRCBankIDOwnt').val('');
	}

	//ClearControl_RentPaySet_DD
	function fn_clearRentPaySetDD() {
		$('#sctDirectDebit').addClass("blind");
		$('#txtRentPayBankAccNoOwnt').val('');
		$('#txtHiddenRentPayBankAccIDOwnt').val('');
		$('#hiddenRentPayEncryptBankAccNoOwnt').val('');
		$('#txtRentPayBankAccTypeOwnt').val('');
		$('#txtRentPayBankAccNameOwnt').val('');
		$('#txtRentPayBankAccBankBranchOwnt').val('');
		$('#txtRentPayBankAccBankOwnt').val('');
		$('#hiddenRentPayBankAccBankIDOwnt').val('');
	}

	function fn_selectCustInfo() {
		var strCustId = $('#custIdOwnt').val();

		//CLEAR CUSTOMER
		fn_clearCustomer();
		fn_clearMailAddress();
		fn_clearContactPerson();

		//CLEAR RENTAL PAY SETTING
		$('#btnThirdPartyOwnt').prop("checked", false);

		fn_clearRentPayMode();
		fn_clearRentPay3thParty();
		fn_clearRentPaySetCRC();
		fn_clearRentPaySetDD();

		//CLEAR BILLING GROUP
		fn_clearBillGroup();

		//CLEAR INSTALLATION
		fn_clearInstAddress();
		fn_clearInstallationCntcPerson();

		if (FormUtil.isNotEmpty(strCustId) && strCustId > 0) {
			if (CUST_ID == strCustId) {
				$('#custIdOwnt').val('');
				Common.alert('<spring:message code="sal.msg.invalidCustId" />'
						+ DEFAULT_DELIMITER
						+ '<spring:message code="sal.msg.ownerOfOrder" />');
			} else {
				fn_loadCustomer(strCustId);
			}
		} else {
			Common
					.alert('<b><spring:message code="sal.msg.invalidCustId" /></b>');
		}
	}

	//ClearControl_BillGroup
	function fn_clearBillGroup() {

		$('#grpOpt1').removeAttr("checked");
		$('#grpOpt2').removeAttr("checked");

		$('#sctBillSel').addClass("blind");
		$('#sctBillMthd').addClass("blind");
		$('#sctBillAddr').addClass("blind");
		$('#sctBillPrefer').addClass("blind");

		$('#txtBillGroupOwnt').val('');
		$('#txtHiddenBillGroupIDOwnt').val('');
		$('#txtBillTypeOwnt').val('');
		$('#txtBillAddressOwnt').val('');
		$('#txtBillGroupRemarkOwnt').val('');
		$('#installDur').removeAttr("readonly");

		$("#billMthdPost").val("");
		$("#billMthdSms").val("");
		$("#billMthdSms1").val("");
		$("#billMthdSms2").val("");
		$("#billMthdEstm").val("");
		$("#billMthdEmail1").val("");
		$("#billMthdEmail2").val("");
		$("#billMthdEmailTxt1").val("");
		$("#billMthdEmailTxt2").val("");
		$("#billGrpWeb").val("");
		$("#billGrpWebUrl").val("");

		$("#billAddrDtl").val("");
		$("#billStreet").val("");
		$("#billArea").val("");
		$("#billCity").val("");
		$("#billPostCode").val("");
		$("#billState").val("");
		$("#billCountry").val("");

		$("#billPreferInitial").val("");
		$("#billPreferName").val("");
		$("#billPreferTelO").val("");
		$("#billPreferExt").val("");

	}

	//ClearControl_Installation_Address
	function fn_clearInstAddress() {
		$('#btnAddInstAddress').addClass("blind");
		$('#btnSelectInstAddress').addClass("blind");

		$('#txtHiddenInstAddressIDOwnt').val('');
		$('#txtInstAddrDtlOwnt').val('');
		$('#txtInstStreetOwnt').val('');
		$('#txtInstAreaOwnt').val('');
		$('#txtInstCityOwnt').val('');
		$('#txtInstPostcodeOwnt').val('');
		$('#txtInstStateOwnt').val('');
		$('#txtInstCountryOwnt').val('');
	}

	function fn_clearMailAddress() {

		$('#btnAddAddress').addClass("blind");
		$('#btnSelectAddress').addClass("blind");

		$('#txtHiddenAddressIDOwnt').val('');
		$('#txtMailAddrDtlOwnt').val('');
		$('#txtMailStreetOwnt').val('');
		$('#txtMailAreaOwnt').val('');
		$('#txtMailCityOwnt').val('');
		$('#txtMailPostcodeOwnt').val('');
		$('#txtMailStateOwnt').val('');
		$('#txtMailCountryOwnt').val('');
	}

	//ClearControl_Customer(Customer)
	function fn_clearCustomer() {
		//      $('#custFormOwnt').clearForm();

		$('#custIdOwnt').clearForm();
		$('#custTypeNmOwnt').clearForm();
		$('#typeIdOwnt').clearForm();
		$('#nameOwnt').clearForm();
		$('#nricOwnt').clearForm();
		$('#nationNmOwnt').clearForm();
		$('#raceOwnt').clearForm();
		$('#raceIdOwnt').clearForm();
		$('#dobOwnt').clearForm();
		$('#genderOwnt').clearForm();
		$('#pasSportExprOwnt').clearForm();
		$('#visaExprOwnt').clearForm();
		$('#emailOwnt').clearForm();
		$('#custRemOwnt').clearForm();
		$('#empChkOwnt').clearForm();
	}

	function fn_loadCustomer(custId) {

		$("#searchCustIdOwnt").val(custId);

		Common
				.ajax(
						"GET",
						"/sales/customer/selectCustomerJsonList",
						{
							custId : custId
						},
						function(result) {

							if (result != null && result.length == 1) {
								var custInfo = result[0];
								//
								$("#txtHiddenCustIDOwnt").val(custInfo.custId); //Customer ID(Hidden)
								$("#custIdOwnt").val(custInfo.custId); //Customer ID
								$("#custTypeNmOwnt").val(custInfo.codeName1); //Customer Name
								$("#typeIdOwnt").val(custInfo.typeId); //Type
								$("#nameOwnt").val(custInfo.name); //Name
								$("#nricOwnt").val(custInfo.nric); //NRIC/Company No
								$("#nationNmOwnt").val(custInfo.name2); //Nationality
								$("#raceIdOwnt").val(custInfo.raceId); //Nationality
								$("#raceOwnt").val(custInfo.codeName2); //
								$("#dobOwnt").val(
										custInfo.dob == '01/01/1900' ? ''
												: custInfo.dob); //DOB
								$("#genderOwnt").val(custInfo.gender); //Gender
								$("#pasSportExprOwnt")
										.val(
												custInfo.pasSportExpr == '01/01/1900' ? ''
														: custInfo.pasSportExpr); //Passport Expiry
								$("#visaExprOwnt").val(
										custInfo.visaExpr == '01/01/1900' ? ''
												: custInfo.visaExpr); //Visa Expiry
								$("#emailOwnt").val(custInfo.email); //Email
								$("#custRemOwnt").val(custInfo.rem); //Remark
								$("#empChkOwnt").val(
										"${orderDetail.basicInfo.empChk}"); //Employee
								$("#newCustCntcId").val(custInfo.custCntcId); // Contact ID

								if (custInfo.corpTypeId > 0) {
									$("#corpTypeNmOwnt").val(custInfo.codeName); //Industry Code
								} else {
									$("#corpTypeNmOwnt").val(""); //Industry Code
								}

								if (custInfo.custAddId > 0) {
									//----------------------------------------------------------
									// Mail Address SETTING
									//----------------------------------------------------------
									fn_clearMailAddress();
									fn_loadMailAddress(custInfo.custAddId);

									//----------------------------------------------------------
									// Installation Address SETTING
									//----------------------------------------------------------
									fn_clearInstAddress();
									fn_loadInstAddress(custInfo.custAddId);
								}

								if (custInfo.custCntcId > 0) {
									//----------------------------------------------------------
									// Contact Person
									//----------------------------------------------------------
									fn_clearContactPerson();
									fn_loadCntcPerson(custInfo.custCntcId);

									//----------------------------------------------------------
									// Installation Contact Person
									//----------------------------------------------------------
									fn_clearInstallationCntcPerson();
									fn_loadInstallationCntcPerson(custInfo.custCntcId);
								}

								$('#btnSelectAddress').removeClass("blind");
								$('#btnAddAddress').removeClass("blind");
								$('#btnSelectContact').removeClass("blind");
								$('#btnAddContact').removeClass("blind");
								$('#btnSelectInstAddress').removeClass("blind");
								$('#btnAddInstAddress').removeClass("blind");
								$('#btnSelectInstContact').removeClass("blind");
								$('#btnAddInstContact').removeClass("blind");

							} else {
								Common
										.alert('<spring:message code="sal.alert.msg.custNotFound" arguments="'+custId+'"/>');
							}
						});
	}

	function fn_clearInstallationCntcPerson() {

		$('#btnSelectInstContact').removeClass("blind");
		$('#btnAddInstContact').removeClass("blind");

		$('#txtHiddenInstContactIDOwnt').val('');
		$('#txtInstContactNameOwnt').val('');
		$('#txtInstContactInitialOwnt').val('');
		$('#txtInstContactGenderOwnt').val('');
		$('#txtInstContactICOwnt').val('');
		$('#txtInstContactDOBOwnt').val('');
		$('#txtInstContactRaceOwnt').val('');
		$('#txtInstContactEmailOwnt').val('');
		$('#txtInstContactDeptOwnt').val('');
		$('#txtInstContactPostOwnt').val('');
		$('#txtInstContactTelMobOwnt').val('');
		$('#txtInstContactTelResOwnt').val('');
		$('#txtInstContactTelOffOwnt').val('');
		$('#txtInstContactTelFaxOwnt').val('');
	}

	function fn_loadInstallationCntcPerson(custCntcId) {
		$("#searchCustCntcId").val(custCntcId);

		Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {
			custCntcId : custCntcId
		}, function(rslt) {
			if (rslt != null) {
				$("#txtHiddenInstContactIDOwnt").val(rslt.custCntcId);
				$("#txtInstContactNameOwnt").val(rslt.name1);
				$("#txtInstContactInitialOwnt").val(rslt.code);
				$("#txtInstContactGenderOwnt").val(rslt.gender);
				$("#txtInstContactICOwnt").val(rslt.nric);
				$("#txtInstContactDOBOwnt").val(rslt.dob);
				$("#txtInstContactRaceOwnt").val(rslt.codeName);
				$("#txtInstContactEmailOwnt").val(rslt.email);
				$("#txtInstContactDeptOwnt").val(rslt.dept);
				$("#txtInstContactPostOwnt").val(rslt.pos);
				$("#txtInstContactTelMobOwnt").val(rslt.telM1);
				$("#txtInstContactTelResOwnt").val(rslt.telR);
				$("#txtInstContactTelOffOwnt").val(rslt.telO);
				$("#txtInstContactTelFaxOwnt").val(rslt.telf);
			}
		});
	}

	function fn_loadCntcPerson(custCntcId) {
		Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {
			custCntcId : custCntcId
		}, function(rslt) {

			if (rslt != null) {
				$("#txtHiddenContactIDOwnt").val(rslt.custCntcId);
				$("#txtContactNameOwnt").val(rslt.name1);
				$("#txtContactInitialOwnt").val(rslt.code);
				$("#txtContactGenderOwnt").val(rslt.gender);
				$("#txtContactICOwnt").val(rslt.nric);
				$("#txtContactDOBOwnt").val(rslt.dob);
				$("#txtContactRaceOwnt").val(rslt.codeName);
				$("#txtContactEmailOwnt").val(rslt.email);
				$("#txtContactDeptOwnt").val(rslt.dept);
				$("#txtContactPostOwnt").val(rslt.pos);
				$("#txtContactTelMobOwnt").val(rslt.telM1);
				$("#txtContactTelResOwnt").val(rslt.telR);
				$("#txtContactTelOffOwnt").val(rslt.telO);
				$("#txtContactTelFaxOwnt").val(rslt.telf);
			}
		});
	}

	function fn_clearContactPerson() {
		$('#btnAddContact').addClass("blind");
		$('#btnSelectContact').addClass("blind");

		$('#txtHiddenContactIDOwnt').val('');
		$('#txtContactNameOwnt').val('');
		$('#txtContactInitialOwnt').val('');
		$('#txtContactGenderOwnt').val('');
		$('#txtContactICOwnt').val('');
		$('#txtContactDOBOwnt').val('');
		$('#txtContactRaceOwnt').val('');
		$('#txtContactEmailOwnt').val('');
		$('#txtContactDeptOwnt').val('');
		$('#txtContactPostOwnt').val('');
		$('#txtContactTelMobOwnt').val('');
		$('#txtContactTelResOwnt').val('');
		$('#txtContactTelOffOwnt').val('');
		$('#txtContactTelFaxOwnt').val('');
	}

	function fn_loadMailAddress(custAddId) {
		Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {
			custAddId : custAddId
		}, function(rslt) {
			if (rslt != null) {
				$("#txtHiddenAddressIDOwnt").val(rslt.custAddId); //Customer Address ID(Hidden)
				$("#txtMailAddrDtlOwnt").val(rslt.addrDtl); //Address
				$("#txtMailStreetOwnt").val(rslt.street); //Street
				$("#txtMailAreaOwnt").val(rslt.area); //Area
				$("#txtMailCityOwnt").val(rslt.city); //City
				$("#txtMailPostcodeOwnt").val(rslt.postcode); //Post Code
				$("#txtMailStateOwnt").val(rslt.state); //State
				$("#txtMailCountryOwnt").val(rslt.country); //Country
			}
		});
	}

	function fn_loadInstAddress(custAddId) {
		Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {
			custAddId : custAddId
		}, function(rslt) {
			if (rslt != null) {
				$("#txtHiddenInstAddressIDOwnt").val(rslt.custAddId); //Customer Address ID(Hidden)
				$("#txtInstAddrDtlOwnt").val(rslt.addrDtl); //Address
				$("#txtInstStreetOwnt").val(rslt.street); //Street
				$("#txtInstAreaOwnt").val(rslt.area); //Area
				$("#txtInstCityOwnt").val(rslt.city); //City
				$("#txtInstPostcodeOwnt").val(rslt.postcode); //Post Code
				$("#txtInstStateOwnt").val(rslt.state); //State
				$("#txtInstCountryOwnt").val(rslt.country); //Country
			}
		});
	}

	// 리스트 조회.
	function fn_selectOrderActiveFilterList() {
		Common.ajax("GET", "/sales/membership/selectMembershipFree_oList", {
			ORD_ID : ORD_ID
		}, function(result) {
			AUIGrid.setGridData(filterGridID, result);
		});
	}

	function fn_getLoginInfo() {
		var userId = 0;

		Common.ajaxSync("GET", "/sales/order/loginUserId.do", '', function(
				rsltInfo) {
			if (rsltInfo != null) {
				userId = rsltInfo.userId;
			}
		});

		return userId;
	}

	function fn_getCheckAccessRight(userId, moduleUnitId) {
		var result = false;
		/*
		 Common.ajaxSync("GET", "/sales/order/selectCheckAccessRight.do", {userId : userId, moduleUnitId : moduleUnitId}, function(rsltInfo) {
		 if(rsltInfo != null) {
		 result = true;
		 }
		 console.log('fn_getLoginInfo result:'+result);
		 });
		 */
		return true;
	}

	function fn_loadOrderInfoOwnt() {
		if (APP_TYPE_ID == '66') {
			fn_tabOnOffSetOwnt('REN_PAY', 'SHOW');
		}

		fn_tabOnOffSetOwnt('BIL_GRP', 'SHOW');

		$('#dpPreferInstDateOwnt').val(
				"${orderDetail.installationInfo.preferInstDt}");
		$('#tpPreferInstTimeOwnt').val(
				"${orderDetail.installationInfo.preferInstTm}");
		$('#hiddenAppTypeIDOwnt').val(APP_TYPE_ID);

		Common.ajax("GET", "/sales/order/selectInstallInfo.do", {
			salesOrderId : ORD_ID
		}, function(instInfo) {
			if (instInfo != null) {
				$("#txtInstSpecialInstructionOwnt").val(instInfo.instct);
			}
		});
	}

	function fn_attachmentUpload() {
		//var formData = Common.getFormData("frmReqOwnt");
		var formData = new FormData();
		$.each(myFileCaches, function(n, v) {
			console.log("n : " + n + " v.file : " + v.file);
			formData.append(n, v.file);
		});

		Common.ajaxFile("/sales/ownershipTransfer/attachmentUpload.do",
				formData, function(result) {
					console.log(result);
					// 신규 add return atchFileGrpId의 key = fileGroupKey
					$("#atchFileGrpId").val(result.data.fileGroupKey);
					fn_doSaveReqOwnt();
				});
	}

	function fn_doSaveReqOwnt() {
		console.log("===== fn_doSaveReqOwnt =====");
		console.log($('#frmReqOwnt').serializeJSON());

		Common.ajax("POST", "/sales/ownershipTransfer/saveRequest.do", $(
				'#frmReqOwnt').serializeJSON(), function(result) {
			var msg = "Order Number : " + $("#salesOrdNo").val()
					+ "<br/>Ownership successfully transferred."
			Common.alert('<spring:message code="sal.alert.msg.ownTransSum" />'
					+ DEFAULT_DELIMITER + "<b>" + msg + "</b>",
					fn_selfClose("req"));
		}, function(jqXHR, textStatus, errorThrown) {
			try {
				Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER
						+ "<b>Saving data prepration failed.</b>");
			} catch (e) {
			}
		});
	}

	function fn_validReqOwnt() {
		var msg = "";

		var todayDD = Number(TODAY_DD.substr(0, 2));
		var todayYY = Number(TODAY_DD.substr(6, 4));

		if (todayYY >= 2018 && (todayDD >= 26 || todayDD == 1)) {
			msg = '<spring:message code="sal.msg.underOwnTrans2" />';
			Common.alert(
					'<spring:message code="sal.alert.msg.actionRestriction" />'
							+ DEFAULT_DELIMITER + "<b>" + msg + "</b>",
					fn_selfClose);
			return false;
		} else {
			if (!fn_validReqOwntCustmer()) {
				return false;
			}
			if (!fn_validReqOwntMailAddress()) {
				return false;
			}
			if (!fn_validReqOwntContact()) {
				return false;
			}
			if (!fn_validReqOwntRentPaySet()) {
				return false;
			}
			if (!fn_validReqOwntBillGroup()) {
				return false;
			}
			if (!fn_validReqOwntInstallation()) {
				return false;
			}
		}
		return true;
	}

	function fn_validReqOwntInstallation() {
		var isValid = true, msg = "";

		if (FormUtil.checkReqValue($('#txtHiddenInstAddressIDOwnt'))) {
			isValid = false;
			msg += '<spring:message code="sal.alert.msg.plzSelInstallAddr" />';
		}
		if (FormUtil.checkReqValue($('#txtHiddenInstContactIDOwnt'))) {
			isValid = false;
			msg += '<spring:message code="sal.alert.msg.plzSelInstallContact" />';
		}
		if ($("#cmbDSCBranchOwnt option:selected").index() <= 0) {
			isValid = false;
			msg += '<spring:message code="sal.alert.msg.plzSelDscBrnch" />';
		}
		if (FormUtil.checkReqValue($('#dpPreferInstDateOwnt'))) {
			isValid = false;
			msg += '<spring:message code="sal.alert.msg.plzSelPreferInstDate" />';
		}
		if (FormUtil.checkReqValue($('#tpPreferInstTimeOwnt'))) {
			isValid = false;
			msg += '<spring:message code="sal.alert.msg.plzSelPreferInstTime" />';
		}

		if (!isValid) {
			$('#tabIN').click();
			Common.alert('<spring:message code="sal.alert.msg.ownTransSum" />'
					+ DEFAULT_DELIMITER + "<b>" + msg + "</b>");
		}
		return isValid;
	}

	function fn_validReqOwntBillGroup() {
		/* var isValid = true, msg = "";

		//if(APP_TYPE_ID == '66' || IS_NEW_VER == 'Y') {
		if (!$('#grpOpt1').is(":checked") && !$('#grpOpt2').is(":checked")) {
		    isValid = false;
		    msg += '<spring:message code="sal.alert.msg.plzSelGrpOpt2" />';
		} else {
		    if ($('#grpOpt2').is(":checked")) {
		        if (FormUtil.checkReqValue($('#txtHiddenBillGroupIDOwnt'))) {
		            isValid = false;
		            msg += '* <spring:message code="sal.alert.msg.plzSelBillGrp" /><br>';
		        }
		    }
		}

		if (!isValid) {
		    $('#tabBG').click();
		    Common.alert('<spring:message code="sal.alert.msg.ownTransSum" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
		}
		return isValid;
		 */

		var isValid = true, msg = "";

		var grpOptSelYN = (!$('#grpOpt1').is(":checked") && !$('#grpOpt2').is(
				":checked")) ? false : true;
		var grpOptVal = $(':radio[name="grpOpt"]:checked').val(); //new, exist

		if (!grpOptSelYN) {
			isValid = false;
			msg += '* <spring:message code="sal.alert.msg.plzSelGrpOpt" /><br>';
		} else {
			if (grpOptVal == 'exist') {

				if (FormUtil.checkReqValue($('#hiddenBillGrpId'))) {
					isValid = false;
					msg += '* <spring:message code="sal.alert.msg.plzSelBillGrp" /><br>';
				}
			} else {
				console.log('billMthdSms  checked:'
						+ $("#billMthdSms").is(":checked"));
				console.log('billMthdPost checked:'
						+ $("#billMthdPost").is(":checked"));
				console.log('billMthdEstm checked:'
						+ $("#billMthdEstm").is(":checked"));

				if (!$("#billMthdSms").is(":checked")
						&& !$("#billMthdPost").is(":checked")
						&& !$("#billMthdEstm").is(":checked")) {
					isValid = false;
					msg += '* <spring:message code="sal.alert.msg.pleaseSelectBillingMethod" /><br>';
				} else {
					if ($("#typeIdOwnt").val() == '965'
							&& $("#billMthdSms").is(":checked")) {
						isValid = false;
						msg += '* <spring:message code="sal.alert.msg.smsBillingMethod" /><br>';
					}

					if ($("#billMthdEstm").is(":checked")) {
						if (FormUtil.checkReqValue($('#billMthdEmailTxt1'))) {
							isValid = false;
							msg += '* <spring:message code="sal.alert.msg.plzKeyInEmailAddr" /><br>';
						} else {
							if (FormUtil.checkEmail($('#billMthdEmailTxt1')
									.val())) {
								isValid = false;
								msg += '* <spring:message code="sal.msg.invalidEmail" /><br>';
							}
						}
						if (!FormUtil.checkReqValue($('#billMthdEmailTxt2'))
								&& FormUtil.checkEmail($('#billMthdEmailTxt2')
										.val())) {
							isValid = false;
							msg += '* <spring:message code="sal.msg.invalidEmail" /><br>';
						}
					} else {
						if (!FormUtil.checkReqValue($('#billMthdEmailTxt1'))
								&& FormUtil.checkEmail($('#billMthdEmailTxt1')
										.val())) {
							isValid = false;
							msg += '* <spring:message code="sal.msg.invalidEmail" /><br>';
						}
						if (!FormUtil.checkReqValue($('#billMthdEmailTxt2'))
								&& FormUtil.checkEmail($('#billMthdEmailTxt2')
										.val())) {
							isValid = false;
							msg += '* <spring:message code="sal.msg.invalidEmail" /><br>';
						}
					}
				}
			}
		}

		if (!isValid)
			Common
					.alert('<spring:message code="sal.alert.msg.saveSalOrdSum" />'
							+ DEFAULT_DELIMITER + "<b>" + msg + "</b>");

		return isValid;
	}

	function fn_validReqOwntRentPaySet() {
		var isValid = true, msg = "";
		if (APP_TYPE_ID == '66') {
			if ($('#btnThirdPartyOwnt').is(":checked")) {
				if (FormUtil.checkReqValue($('#txtHiddenThirdPartyIDOwnt'))) {
					isValid = false;
					msg += '<spring:message code="sal.alert.msg.plzSelThirdParty" />';
				}
			}

			if ($("#cmbRentPaymodeOwnt option:selected").index() <= 0) {
				Common
						.ajaxSync(
								"GET",
								"/sales/order/selectOderOutsInfo.do",
								{
									ordId : ORD_ID
								},
								function(result) {
									if (result != null && result.length > 0) {
										if (result[0].lastBillMth != 60
												|| result[0].ordTotOtstnd != 0) {
											isValid = false;
											msg += '<spring:message code="sal.alert.msg.plzSelRentPayMode" />';
										}
									}
								});
			} else {
				if ($("#cmbRentPaymodeOwnt").val() == '131') { //CRC
					if (FormUtil.checkReqValue($('#txtHiddenRentPayCRCIDOwnt'))) {
						isValid = false;
						msg += '<spring:message code="sal.alert.msg.plzSelCrdCard" />';
					} else {
						if (FormUtil
								.checkReqValue($('#hiddenRentPayCRCBankIDOwnt'))
								|| $('#hiddenRentPayCRCBankIDOwnt').val() == '0') {
							isValid = false;
							msg += '<spring:message code="sal.alert.msg.invalidCrdCardIssuebank" />';
						}
					}
				} else if ($("#cmbRentPaymodeOwnt").val() == '132') { //DD
					if (FormUtil
							.checkReqValue($('#txtHiddenRentPayBankAccIDOwnt'))) {
						isValid = false;
						msg += '<spring:message code="sal.alert.msg.plzSelBankAccount" />';
					} else {
						if (FormUtil
								.checkReqValue($('#hiddenRentPayBankAccBankIDOwnt'))
								|| $('#hiddenRentPayBankAccBankIDOwnt').val() == '0') {
							isValid = false;
							msg += '<spring:message code="sal.alert.msg.invalidBankAccIssueBank" />';
						}
					}
				}
			}
		}

		if (!isValid) {
			$('#tabRP').click();
			Common.alert('<spring:message code="sal.alert.msg.ownTransSum" />'
					+ DEFAULT_DELIMITER + "<b>" + msg + "</b>");
		}
		return isValid;
	}

	function fn_validReqOwntContact() {
		var isValid = true, msg = "";

		if (FormUtil.checkReqValue($('#txtHiddenContactIDOwnt'))) {
			isValid = false;
			msg += '* <spring:message code="sal.alert.msg.plzSelCntcPer" /><br>';
		}

		if (!isValid) {
			$('#tabCP').click();
			Common.alert('<spring:message code="sal.alert.msg.ownTransSum" />'
					+ DEFAULT_DELIMITER + "<b>" + msg + "</b>");
		}
		return isValid;
	}

	function fn_validReqOwntMailAddress() {
		var isValid = true, msg = "";

		if (FormUtil.checkReqValue($('#txtHiddenAddressIDOwnt'))) {
			isValid = false;
			msg += '<spring:message code="sal.msg.plzSelAddr" />'
		}

		if (!isValid) {
			$('#tabMA').click();
			Common.alert('<spring:message code="sal.alert.msg.ownTransSum" />'
					+ DEFAULT_DELIMITER + "<b>" + msg + "</b>");
		}
		return isValid;
	}

	function fn_validReqOwntCustmer() {
		var isValid = true, msg = "";

		if (FormUtil.checkReqValue($('#txtHiddenCustIDOwnt'))) {
			isValid = false;
			msg += '* <spring:message code="sal.alert.msg.plzSelCust2" /><br>';
		}

		if (!isValid) {
			$('#tabCT').click();
			Common.alert('<spring:message code="sal.alert.msg.ownTransSum" />'
					+ DEFAULT_DELIMITER + "<b>" + msg + "</b>");
		}
		return isValid;
	}

	function fn_loadListOwnt() {
		doGetComboData('/common/selectCodeList.do', {
			groupCode : '324'
		}, '', 'empChkOwnt', 'S'); //EMP_CHK
		doGetComboOrder('/common/selectCodeList.do', '19', 'CODE_NAME', '',
				'cmbRentPaymodeOwnt', 'S', ''); //Common Code
		doGetComboSepa('/common/selectBranchCodeList.do', '5', ' - ',
				"${orderDetail.installationInfo.dscId}", 'cmbDSCBranchOwnt',
				'S', ''); //Branch Code
	}

	function fn_tabOnOffSetOwnt(tabNm, opt) {
		switch (tabNm) {
		case 'REN_PAY':
			if (opt == 'SHOW') {
				if ($('#tabRP').hasClass("blind"))
					$('#tabRP').removeClass("blind");
				if ($('#atcRP').hasClass("blind"))
					$('#atcRP').removeClass("blind");

			} else if (opt == 'HIDE') {
				if (!$('#tabRP').hasClass("blind"))
					$('#tabRP').addClass("blind");
				if (!$('#atcRP').hasClass("blind"))
					$('#atcRP').addClass("blind");

			}
			break;
		case 'BIL_GRP':
			if (opt == 'SHOW') {
				if ($('#tabBG').hasClass("blind"))
					$('#tabBG').removeClass("blind");
				if ($('#atcBG').hasClass("blind"))
					$('#atcBG').removeClass("blind");
			} else if (opt == 'HIDE') {
				if (!$('#tabBG').hasClass("blind"))
					$('#tabBG').addClass("blind");
				if (!$('#atcBG').hasClass("blind"))
					$('#atcBG').addClass("blind");
			}
			break;
		default:
			break;
		}
	}

	// Billing Rental Group Search address callback
	function fn_loadMailAddr(custAddId) {
		console.log("fn_loadMailAddr START");

		Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {
			custAddId : custAddId
		}, function(billCustInfo) {

			if (billCustInfo != null) {

				console.log("성공.");
				console.log("hiddenBillAddId : " + billCustInfo.custAddId);

				$("#hiddenBillAddId").val(billCustInfo.custAddId); //Customer Address ID(Hidden)
				$("#billAddrDtl").val(billCustInfo.addrDtl); //Address
				$("#billStreet").val(billCustInfo.street); //Street
				$("#billArea").val(billCustInfo.area); //Area
				$("#billCity").val(billCustInfo.city); //City
				$("#billPostCode").val(billCustInfo.postcode); //Post Code
				$("#billState").val(billCustInfo.state); //State
				$("#billCountry").val(billCustInfo.country); //Country

				$("#hiddenBillStreetId").val(billCustInfo.custAddId); //Magic Address STREET_ID(Hidden)

				console
						.log("hiddenBillAddId2 : "
								+ $("#hiddenBillAddId").val());
			}
		});
	}

	function fn_selfClose() {
		$('#btnCloseReq').click();
	}

	/*
	function fn_reloadPage() {
	    Common.popupDiv("/sales/order/requestROT.do", {salesOrderId : ORD_ID, ordReqType : $('#ordReqType').val()}, null, true);
	    $('#btnCloseReq').click();
	}
	 */
</script>

<!-- popup_wrap start -->
<div id="reqPopup" class="popup_wrap">
	<!-- pop_header start -->
	<header class="pop_header">
		<h1 id="hTitle">
			<spring:message code="sal.page.title.ordReq" />
		</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a id="btnCloseReq" href="#"><spring:message
							code="sal.btn.close" /></a>
				</p></li>
		</ul>
	</header>
	<!-- pop_header end -->

	<!-- pop_body start -->
	<section class="pop_body">
		<!--
      ****************************************************************************
                                         Order Detail Page Include START
      *****************************************************************************
    -->
		<%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
		<!--
      ****************************************************************************
                                         Order Detail Page Include END
      *****************************************************************************
    -->
		<!--
      ****************************************************************************
                                         Ownership Transfer Request START
      *****************************************************************************
    -->
		<section id="scOT">
			<form id="searchFormOwnt" name="searchForm" action="#" method="post">
				<input id="searchCustIdOwnt" name="custId" type="hidden" />
			</form>
			<form id="frmReqOwnt" name="frmReqOwnt" action="#" method="post">
				<input name="salesOrdId" type="hidden"
					value="${orderDetail.basicInfo.ordId}" /> <input name="salesOrdNo"
					type="hidden" value="${orderDetail.basicInfo.ordNo}" /> <input
					name="hiddenCurrentCustID" type="hidden"
					value="${orderDetail.basicInfo.custId}" /> <input
					id="txtHiddenCustIDOwnt" name="txtHiddenCustID" type="hidden" /> <input
					id="hiddenCustTypeIDOwnt" name="hiddenCustTypeID" type="hidden" />
				<input id="txtHiddenContactIDOwnt" name="txtHiddenContactID"
					type="hidden" /> <input id="txtHiddenAddressIDOwnt"
					name="txtHiddenAddressID" type="hidden" /> <input
					id="hiddenAppTypeIDOwnt" name="hiddenAppTypeID" type="hidden" /> <input
					id="txtHiddenInstAddressIDOwnt" name="txtHiddenInstAddressID"
					type="hidden" /> <input id="txtHiddenInstContactIDOwnt"
					name="txtHiddenInstContactID" type="hidden" /> <input
					id="isNewVer" name="isNewVer" type="hidden"
					value="${orderDetail.isNewVer}" /> <input id="newCustCntcId"
					name="newCustCntcId" type="hidden" /> <input
					id="hiddenBillMthdPost" name="hiddenBillMthdPost" type="hidden"
					value="0" /> <input id="hiddenBillMthdSms1"
					name="hiddenBillMthdSms1" type="hidden" value="0" /> <input
					id="hiddenBillMthdSms2" name="hiddenBillMthdSms2" type="hidden"
					value="0" /> <input id="hiddenBillMthdEstm"
					name="hiddenBillMthdEstm" type="hidden" value="0" /> <input
					id="hiddenBillGrpWeb" name="hiddenBillGrpWeb" type="hidden"
					value="0" /> <input id="atchFileGrpId" name="atchFileGrpId"
					type="hidden" />

				<aside class="title_line">
					<!-- title_line start -->
					<!--<h3>
                    <spring:message code="sal.page.subTitle.ownTransInfo" />
                    </h3>  -->
				</aside>

				<article class="tap_area">
					<header>
						<h1>Ownership Transfer Information</h1>
					</header>
					<section class="search_table">
						<table class="type1">
							<colgroup>
								<col style="width: 140px" />
								<col style="width: 100px" />
								<col style="width: 140px" />
								<col style="width: 100px" />
								<col style="width: 140px" />
								<col style="width: 100px" />
							</colgroup>

							<tbody>
								<tr>
									<th scope="row">ROT Reason</th>
									<td colspan="5"><select id="rotReason" name="rotReason"
										class="w100p">
											<c:forEach var="list" items="${requestReasonList}"
												varStatus="status">
												<option value="${list.codeId}">${list.codeName}</option>
											</c:forEach>
									</select></td>
								</tr>
								<tr>
									<th scope="row">Require A/S</th>
									<td><select id="rotReqAS" name="rotReqAS" class="w100p">
											<option value="1">YES</option>
											<option value="0">NO</option>
									</select></td>
									<th scope="row">Require Rebill</th>
									<td><select id="rotReqRebill" name="rotReqRebill"
										class="w100p">
											<option value="1">YES</option>
											<option value="0">NO</option>
									</select></td>
									<th scope="row">Require Invoice Grouping</th>
									<td><select id="rotReqInvoiceGrp" name="rotReqInvoiceGrp"
										class="w100p">
											<option value="1">YES</option>
											<option value="0">NO</option>
									</select></td>
								</tr>
								<!-- auto_file start -->
								<tr>
									<th scope="row">Attachment 1</th>
									<td colspan="5">
										<div class="auto_file3 w100p">
											<input type="file" id="fileSelector1" name="fileSelector1"
												title="file add" readonly='readonly' />
											<!--
                                            <label>
                                                <input type='text' class='input_text' readonly='readonly' />
                                                <span class='label_text'><a href='#'>File</a></span>
                                            </label>
                                             -->
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row">Attachment 2</th>
									<td colspan="5">
										<div class="auto_file3 w100p">
											<input type="file" id="fileSelector2" name="fileSelector2"
												title="file add" />
											<!--
                                            <label>
                                                <input type='text' class='input_text' readonly='readonly' />
                                                <span class='label_text'><a href='#'>File</a></span>
                                            </label>
                                             -->
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row">Attachment 3</th>
									<td colspan="5">
										<div class="auto_file3 w100p">
											<input type="file" id="fileSelector3" name="fileSelector3"
												title="file add" />
											<!--
                                            <label>
                                                <input type='text' class='input_text' readonly='readonly' />
                                                <span class='label_text'><a href='#'>File</a></span>
                                            </label>
                                             -->
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row">Attachment 4</th>
									<td colspan="5">
										<div class="auto_file3 w100p">
											<input type="file" id="fileSelector4" name="fileSelector4"
												title="file add" />
											<!--
                                            <label>
                                                <input type='text' class='input_text' readonly='readonly' />
                                                <span class='label_text'><a href='#'>File</a></span>
                                            </label>
                                             -->
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row">Attachment 5</th>
									<td colspan="5">
										<div class="auto_file3 w100p">
											<input type="file" id="fileSelector5" name="fileSelector5"
												title="file add" />
											<!--
                                            <label>
                                                <input type='text' class='input_text' readonly='readonly' />
                                                <span class='label_text'><a href='#'>File</a></span>
                                            </label>
                                             -->
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row">Attachment 6</th>
									<td colspan="5">
										<div class="auto_file3 w100p">
											<input type="file" id="fileSelector6" name="fileSelector6"
												title="file add" />
											<!--
                                            <label>
                                                <input type='text' class='input_text' readonly='readonly' />
                                                <span class='label_text'><a href='#'>File</a></span>
                                            </label>
                                             -->
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row">Attachment 7</th>
									<td colspan="5">
										<div class="auto_file3 w100p">
											<input type="file" id="fileSelector7" name="fileSelector7"
												title="file add" />
											<!--
                                            <label>
                                                <input type='text' class='input_text' readonly='readonly' />
                                                <span class='label_text'><a href='#'>File</a></span>
                                            </label>
                                             -->
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row">Attachment 8</th>
									<td colspan="5">
										<div class="auto_file3 w100p">
											<input type="file" id="fileSelector8" name="fileSelector8"
												title="file add" />
											<!--
                                            <label>
                                                <input type='text' class='input_text' readonly='readonly' />
                                                <span class='label_text'><a href='#'>File</a></span>
                                            </label>
                                             -->
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row">Attachment 9</th>
									<td colspan="5">
										<div class="auto_file3 w100p">
											<input type="file" id="fileSelector9" name="fileSelector9"
												title="file add" />
											<!--
                                            <label>
                                                <input type='text' class='input_text' readonly='readonly' />
                                                <span class='label_text'><a href='#'>File</a></span>
                                            </label>
                                             -->
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row">Attachment 10</th>
									<td colspan="5">
										<div class="auto_file3 w100p">
											<input type="file" id="fileSelector10" name="fileSelector10"
												title="file add" />
											<!--
                                            <label>
                                                <input type='text' class='input_text' readonly='readonly' />
                                                <span class='label_text'><a href='#'>File</a></span>
                                            </label>
                                             -->
										</div>
									</td>
								</tr>
								<!-- auto_file end -->
							</tbody>
						</table>
					</section>
					<!-- title_line end -->

					<!-- tap_wrap start -->
					<section class="tap_wrap">
						<ul class="tap_type1 num4">
							<li id="tabCT"><a href="#" class="on"><spring:message
										code="sal.title.text.customer" /></a></li>
<%--                             <li id="tabRQ"><a href="#" ><spring:message --%>
<%--                                         code="sal.text.requestor" /></a></li> --%>
							<li id="tabMA"><a href="#"><spring:message
										code="sal.title.text.mailingAddr" /></a></li>
							<li id="tabCP"><a href="#"><spring:message
										code="sal.tap.title.contactPerson" /></a></li>
							<li id="tabRP" class="blind"><a href="#"><spring:message
										code="sal.title.text.rentalPaySetting" /></a></li>
							<li id="tabBG" class="blind"><a href="#"><spring:message
										code="sal.page.subtitle.rentalBillingGroup" /></a></li>
							<li id="tabIN"><a href="#"><spring:message
										code="sal.text.inst" /></a></li>
						</ul>

						<!-- tap_area start -->
						<article class="tap_area">
							<ul class="right_btns mb10">
								<li><p class="btn_grid">
										<a id="addCustBtn" href="#"><spring:message
												code="sal.btn.addNewCust" /></a>
									</p></li>
							</ul>

							<section class="search_table">
								<!-- search_table start -->
								<table class="type1">
									<!-- table start -->
									<caption>table</caption>
									<colgroup>
										<col style="width: 140px" />
										<col style="width: *" />
										<col style="width: 170px" />
										<col style="width: *" />
									</colgroup>

									<tbody>
										<tr>
											<th scope="row"><spring:message
													code="sal.text.customerId" /><span class="must">*</span></th>
											<td><input id="custIdOwnt" name="txtCustID" type="text"
												title="" placeholder="Customer ID" class="" /> <a
												class="search_btn" id="custBtnOwnt"><img
													src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
													alt="search" /></a></td>
											<th scope="row"><spring:message code="sal.text.type" /></th>
											<td><input id="custTypeNmOwnt" name="txtCustType"
												type="text" title="" placeholder="Customer Type"
												class="w100p" readonly /> <input id="typeIdOwnt"
												name="hiddenCustTypeID" type="hidden" /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.name" /></th>
											<td><input id="nameOwnt" name="txtCustName" type="text"
												title="" placeholder="Customer Name" class="w100p" readonly />
											</td>
											<th scope="row"><spring:message
													code="sal.text.nricCompanyNo" /></th>
											<td><input id="nricOwnt" name="txtCustIC" type="text"
												title="" placeholder="NRIC/Company No" class="w100p"
												readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message
													code="sal.text.nationality" /></th>
											<td><input id="nationNmOwnt" name="txtCustNationality"
												type="text" title="" placeholder="Nationality" class="w100p"
												readonly /></td>
											<th scope="row"><spring:message code="sal.text.race" /></th>
											<td><input id="raceOwnt" name="txtCustRace" type="text"
												title="" placeholder="Race" class="w100p" readonly /> <input
												id="raceIdOwnt" name="hiddenCustRaceID" type="hidden" /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.dob" /></th>
											<td><input id="dobOwnt" name="txtCustDOB" type="text"
												title="" placeholder="DOB" class="w100p" readonly /></td>
											<th scope="row"><spring:message code="sal.text.gender" /></th>
											<td><input id="genderOwnt" name="txtCustGender"
												type="text" title="" placeholder="Gender" class="w100p"
												readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message
													code="sal.text.passportExpire" /></th>
											<td><input id="pasSportExprOwnt"
												name="txtCustPassportExpiry" type="text" title=""
												placeholder="Passport Expiry" class="w100p" readonly /></td>
											<th scope="row"><spring:message
													code="sal.text.visaExpire" /></th>
											<td><input id="visaExprOwnt" name="txtCustVisaExpiry"
												type="text" title="" placeholder="Visa Expiry" class="w100p"
												readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.email" /></th>
											<td><input id="emailOwnt" name="txtCustEmail"
												type="text" title="" placeholder="Email Address"
												class="w100p" readonly /></td>
											<th scope="row"><spring:message
													code="sal.text.indutryCd" /></th>
											<td><input id="corpTypeNmOwnt" name="corpTypeNm"
												type="text" title="" placeholder="Industry Code"
												class="w100p" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.employee" /><span
												class="must">*</span></th>
											<td colspan="3"><select id="empChkOwnt" name="empChk"
												class="w100p"></select></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.remark" /></th>
											<td colspan="3"><textarea id="custRemOwnt"
													name="txtCustRemark" cols="20" rows="5"
													placeholder="Remark" readonly></textarea></td>
										</tr>
									</tbody>
								</table>
								<!-- table end -->
							</section>
							<!-- search_table end -->
						</article>

						<!-- tap_area end -->





						<article class="tap_area">
							<!-- tap_area start -->
							<section class="search_table">
								<!-- search_table start -->
								<ul class="right_btns mb10">
									<li id="btnAddAddress" class="blind"><p class="btn_grid">
											<a id="billNewAddrBtn" href="#">Add New Address</a>
										</p></li>
									<li id="btnSelectAddress" class="blind"><p
											class="btn_grid">
											<a id="billSelAddrBtn" href="#">Select Another Address</a>
										</p></li>
								</ul>
								<table class="type1">
									<!-- table start -->
									<caption>table</caption>
									<colgroup>
										<col style="width: 140px" />
										<col style="width: *" />
										<col style="width: 170px" />
										<col style="width: *" />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row"><spring:message
													code="sal.text.addressDetail" /><span class="must">*</span></th>
											<td colspan="3"><input id="txtMailAddrDtlOwnt"
												name="txtMailAddrDtl" type="text" title=""
												placeholder="Address Detail" class="w100p readonly" readonly />
											</td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.street" /></th>
											<td colspan="3"><input id="txtMailStreetOwnt"
												name="txtMailStreet" type="text" title=""
												placeholder="Street" class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.area" /><span
												class="must">*</span></th>
											<td colspan="3"><input id="txtMailAreaOwnt"
												name="txtMailArea" type="text" title="" placeholder="Area"
												class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.city" /><span
												class="must">*</span></th>
											<td><input id="txtMailCityOwnt" name="txtMailCity"
												type="text" title="" placeholder="City"
												class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.postCode" /><span
												class="must">*</span></th>
											<td><input id="txtMailPostcodeOwnt"
												name="txtMailPostcode" type="text" title=""
												placeholder="Postcode" class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.state" /><span
												class="must">*</span></th>
											<td><input id="txtMailStateOwnt" name="txtMailState"
												type="text" title="" placeholder="State"
												class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.country" /><span
												class="must">*</span></th>
											<td><input id="txtMailCountryOwnt" name="txtMailCountry"
												type="text" title="" placeholder="Country"
												class="w100p readonly" readonly /></td>
										</tr>
									</tbody>
								</table>
								<!-- table end -->
							</section>
							<!-- search_table end -->
						</article>
						<!-- tap_area end -->
						<article class="tap_area">
							<!-- tap_area start -->
							<section class="search_table">
								<!-- search_table start -->
								<ul class="right_btns mb10">
									<li id="btnAddContact" class="blind"><p class="btn_grid">
											<a id="mstCntcNewAddBtn" href="#"><spring:message
													code="sal.title.text.addNewCntc" /></a>
										</p></li>
									<li id="btnSelectContact" class="blind"><p
											class="btn_grid">
											<a id="mstCntcSelAddBtn" href="#"><spring:message
													code="sal.btn.selNewContact" /></a>
										</p></li>
								</ul>
								<table class="type1">
									<!-- table start -->
									<caption>table</caption>
									<colgroup>
										<col style="width: 140px" />
										<col style="width: *" />
										<col style="width: 170px" />
										<col style="width: *" />
										<col style="width: 170px" />
										<col style="width: *" />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row"><spring:message code="sal.text.name" /><span
												class="must">*</span></th>
											<td><input id="txtContactNameOwnt" name="txtContactName"
												type="text" title="" placeholder="Name"
												class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.initial" /></th>
											<td><input id="txtContactInitialOwnt"
												name="txtContactInitial" type="text" title=""
												placeholder="Initial" class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.gender" /></th>
											<td><input id="txtContactGenderOwnt"
												name="txtContactGender" type="text" title=""
												placeholder="Gender" class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.nric" /></th>
											<td><input id="txtContactICOwnt" name="txtContactIC"
												type="text" title="" placeholder="NRIC"
												class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.dob" /></th>
											<td><input id="txtContactDOBOwnt" name="txtContactDOB"
												type="text" title="" placeholder="DOB"
												class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.race" /></th>
											<td><input id="txtContactRaceOwnt" name="txtContactRace"
												type="text" title="" placeholder="Race"
												class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.email" /></th>
											<td><input id="txtContactEmailOwnt"
												name="txtContactEmail" type="text" title=""
												placeholder="Email" class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.dept" /></th>
											<td><input id="txtContactDeptOwnt" name="txtContactDept"
												type="text" title="" placeholder="Department"
												class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.post" /></th>
											<td><input id="txtContactPostOwnt" name="txtContactPost"
												type="text" title="" placeholder="Post"
												class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.telM" /></th>
											<td><input id="txtContactTelMobOwnt"
												name="txtContactTelMob" type="text" title=""
												placeholder="Telephone Number (Mobile)"
												class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.telR" /></th>
											<td><input id="txtContactTelResOwnt"
												name="txtContactTelRes" type="text" title=""
												placeholder="Telephone Number (Residence)"
												class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.telO" /></th>
											<td><input id="txtContactTelOffOwnt"
												name="txtContactTelOff" type="text" title=""
												placeholder="Telephone Number (Office)"
												class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.telF" /></th>
											<td><input id="txtContactTelFaxOwnt"
												name="txtContactTelFax" type="text" title=""
												placeholder="Telephone Number (Fax)" class="w100p readonly"
												readonly /></td>
											<th scope="row"></th>
											<td></td>
											<th scope="row"></th>
											<td></td>
										</tr>
									</tbody>
								</table>
								<!-- table end -->
							</section>
							<!-- search_table end -->
						</article>
						<!-- tap_area end -->
						<!--
            ****************************************************************************
                                                                   Rental Pay Set
            *****************************************************************************
                -->
						<article id="atcRP" class="tap_area blind">
							<!-- tap_area start -->
							<section class="search_table">
								<!-- search_table start -->
								<table class="type1 mb1m">
									<!-- table start -->
									<caption>table</caption>
									<colgroup>
										<col style="width: 170px" />
										<col style="width: *" />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row"><spring:message
													code="sal.text.payByThirdParty" /></th>
											<td colspan="3"><label><input
													id="btnThirdPartyOwnt" name="btnThirdParty" type="checkbox"
													value="1" /><span></span></label></td>
										</tr>
									</tbody>
								</table>
								<!-- table end -->
								<section id="sctThrdParty" class="blind">
									<aside class="title_line">
										<!-- title_line start -->
										<h3>
											<spring:message code="sal.text.thirdParty" />
										</h3>
									</aside>
									<!-- title_line end -->
									<ul class="right_btns mb10">
										<li><p class="btn_grid">
												<a id="btnAddThirdParty" href="#"><spring:message
														code="sal.btn.addNewThirdParty" /></a>
											</p></li>
									</ul>
									<!--
            ****************************************************************************
                                                 Third Party - Form ID(thrdPartyForm)
            *****************************************************************************
                       -->
									<table class="type1">
										<!-- table start -->
										<caption>table</caption>
										<colgroup>
											<col style="width: 170px" />
											<col style="width: *" />
											<col style="width: 190px" />
											<col style="width: *" />
										</colgroup>
										<tbody>
											<tr>
												<th scope="row"><spring:message
														code="sal.text.customerId" /><span class="must">*</span></th>
												<td><input id="txtThirdPartyIDOwnt"
													name="txtThirdPartyID" type="text" title=""
													placeholder="Third Party ID" class="" /> <a href="#"
													class="search_btn" id="thrdPartyBtn"><img
														src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
														alt="search" /></a> <input id="txtHiddenThirdPartyIDOwnt"
													name="txtHiddenThirdPartyID" type="hidden" /></td>
												<th scope="row"><spring:message code="sal.text.type" /></th>
												<td><input id="txtThirdPartyTypeOwnt"
													name="txtThirdPartyType" type="text" title=""
													placeholder="Costomer Type" class="w100p readonly" readonly />
												</td>
											</tr>
											<tr>
												<th scope="row"><spring:message code="sal.text.name" /></th>
												<td><input id="txtThirdPartyNameOwnt"
													name="txtThirdPartyName" type="text" title=""
													placeholder="Customer Name" class="w100p readonly" readonly />
												</td>
												<th scope="row"><spring:message
														code="sal.text.nricCompanyNo" /></th>
												<td><input id="txtThirdPartyNRICOwnt"
													name="txtThirdPartyNRIC" type="text" title=""
													placeholder="NRIC/Company Number" class="w100p readonly"
													readonly /></td>
											</tr>
										</tbody>
									</table>
									<!-- table end -->
								</section>
								<!--
            ****************************************************************************
                                              Rental Paymode - Form ID(rentPayModeForm)
            *****************************************************************************
                          -->
								<section id="sctRentPayMode">
									<table class="type1">
										<!-- table start -->
										<caption>table</caption>
										<colgroup>
											<col style="width: 170px" />
											<col style="width: *" />
											<col style="width: 190px" />
											<col style="width: *" />
										</colgroup>
										<tbody>
											<tr>
												<th scope="row"><spring:message
														code="sal.text.rentalPaymode" /><span class="must">*</span></th>
												<td><select id="cmbRentPaymodeOwnt"
													name="cmbRentPaymode" class="w100p"></select></td>
												<th scope="row"><spring:message
														code="sal.text.nricPassbook" /></th>
												<td><input id="txtRentPayICOwnt" name="txtRentPayIC"
													type="text" title=""
													placeholder="NRIC appear on DD/Passbook" class="w100p" />
												</td>
											</tr>
										</tbody>
									</table>
									<!-- table end -->
								</section>
								<section id="sctCrCard" class="blind">
									<aside class="title_line">
										<!-- title_line start -->
										<h3>
											<spring:message code="sal.page.subtitle.creditCard" />
										</h3>
									</aside>
									<!-- title_line end -->
									<ul class="right_btns mb10">
										<li><p class="btn_grid">
												<a id="btnAddCRC" href="#"><spring:message
														code="sal.btn.addNewCreditCard" /></a>
											</p></li>
										<li><p class="btn_grid">
												<a id="btnSelectCRC" href="#"><spring:message
														code="sal.btn.selectAnotherCreditCard" /></a>
											</p></li>
									</ul>
									<!--
            ****************************************************************************
                                              Credit Card - Form ID(crcForm)
            *****************************************************************************
                     -->
									<table class="type1 mb1m">
										<!-- table start -->
										<caption>table</caption>
										<colgroup>
											<col style="width: 170px" />
											<col style="width: *" />
											<col style="width: 190px" />
											<col style="width: *" />
										</colgroup>
										<tbody>
											<tr>
												<th scope="row"><spring:message
														code="sal.text.creditCardNumber" /><span class="must">*</span></th>
												<td><input id="txtRentPayCRCNoOwnt"
													name="txtRentPayCRCNo" type="text" title=""
													placeholder="Credit Card Number" class="w100p readonly"
													readonly /> <input id="txtHiddenRentPayCRCIDOwnt"
													name="txtHiddenRentPayCRCID" type="hidden" /> <input
													id="hiddenRentPayEncryptCRCNoOwnt"
													name="hiddenRentPayEncryptCRCNo" type="hidden" /></td>
												<th scope="row"><spring:message
														code="sal.text.creditCardType" /></th>
												<td><input id="txtRentPayCRCTypeOwnt"
													name="txtRentPayCRCType" type="text" title=""
													placeholder="Credit Card Type" class="w100p readonly"
													readonly /></td>
											</tr>
											<tr>
												<th scope="row"><spring:message
														code="sal.text.nameOnCard" /></th>
												<td><input id="txtRentPayCRCNameOwnt"
													name="txtRentPayCRCName" type="text" title=""
													placeholder="Name On Card" class="w100p readonly" readonly />
												</td>
												<th scope="row"><spring:message code="sal.text.expiry" /></th>
												<td><input id="txtRentPayCRCExpiryOwnt"
													name="txtRentPayCRCExpiry" type="text" title=""
													placeholder="Credit Card Expiry" class="w100p readonly"
													readonly /></td>
											</tr>
											<tr>
												<th scope="row"><spring:message
														code="sal.text.issueBank" /></th>
												<td><input id="txtRentPayCRCBankOwnt"
													name="txtRentPayCRCBank" type="text" title=""
													placeholder="Issue Bank" class="w100p readonly" readonly />
													<input id="hiddenRentPayCRCBankIDOwnt"
													name="hiddenRentPayCRCBankID" type="hidden" title=""
													class="w100p" /></td>
												<th scope="row"><spring:message
														code="sal.text.cardType" /></th>
												<td><input id="rentPayCRCCardTypeOwnt"
													name="rentPayCRCCardType" type="text" title=""
													placeholder="Card Type" class="w100p readonly" readonly />
												</td>
											</tr>
										</tbody>
									</table>
									<!-- table end -->
									<ul class="center_btns">
										<li><p class="btn_blue">
												<a id="ordSaveBtn" href="#"><spring:message
														code="sal.btn.ok" /></a>
											</p></li>
									</ul>
								</section>
								<section id="sctDirectDebit" class="blind">
									<aside class="title_line">
										<!-- title_line start -->
										<h3>
											<spring:message code="sal.page.subtitle.directDebit" />
										</h3>
									</aside>
									<!-- title_line end -->
									<ul class="right_btns mb10">
										<li><p class="btn_grid">
												<a id="btnAddBankAccount" href="#"><spring:message
														code="sal.btn.addNewBankAccount" /></a>
											</p></li>
										<li><p class="btn_grid">
												<a id="btnSelectBankAccount" href="#"><spring:message
														code="sal.btn.selectAnotherBankAccount" /></a>
											</p></li>
									</ul>
									<!--
            ****************************************************************************
                                              Direct Debit - Form ID(ddForm)
            *****************************************************************************
                     -->
									<table class="type1">
										<!-- table start -->
										<caption>table</caption>
										<colgroup>
											<col style="width: 170px" />
											<col style="width: *" />
											<col style="width: 190px" />
											<col style="width: *" />
										</colgroup>
										<tbody>
											<tr>
												<th scope="row"><spring:message
														code="sal.text.accountNumber" /><span class="must">*</span></th>
												<td><input id="txtRentPayBankAccNoOwnt"
													name="txtRentPayBankAccNo" type="text" title=""
													placeholder="Account Number readonly"
													class="w100p readonly" readonly /> <input
													id="txtHiddenRentPayBankAccIDOwnt"
													name="txtHiddenRentPayBankAccID" type="hidden" /> <input
													id="hiddenRentPayEncryptBankAccNoOwnt"
													name="hiddenRentPayEncryptBankAccNo" type="hidden" /></td>
												<th scope="row"><spring:message
														code="sal.text.accountType" /></th>
												<td><input id="txtRentPayBankAccTypeOwnt"
													name="txtRentPayBankAccType" type="text" title=""
													placeholder="Account Type readonly" class="w100p readonly"
													readonly /></td>
											</tr>
											<tr>
												<th scope="row"><spring:message
														code="sal.text.accountHolder" /></th>
												<td><input id="txtRentPayBankAccNameOwnt"
													name="txtRentPayBankAccName" type="text" title=""
													placeholder="Account Holder" class="w100p readonly"
													readonly /></td>
												<th scope="row"><spring:message
														code="sal.text.issueBankBranch" /></th>
												<td><input id="txtRentPayBankAccBankBranchOwnt"
													name="txtRentPayBankAccBankBranch" type="text" title=""
													placeholder="Issue Bank Branch" class="w100p readonly"
													readonly /></td>
											</tr>
											<tr>
												<th scope="row"><spring:message
														code="sal.text.issueBank" /></th>
												<td colspan=3><input id="txtRentPayBankAccBankOwnt"
													name="txtRentPayBankAccBank" type="text" title=""
													placeholder="Issue Bank" class="w100p readonly" readonly />
													<input id="hiddenRentPayBankAccBankIDOwnt"
													name="hiddenRentPayBankAccBankID" type="hidden" /></td>
											</tr>
										</tbody>
									</table>
									<!-- table end -->
								</section>
							</section>
							<!-- search_table end -->
						</article>
						<!-- tap_area end -->
						<!--
            ****************************************************************************
                                                                  Billing Group
            *****************************************************************************
                 -->
						<article id="atcBG" class="tap_area blind">
							<!-- tap_area start -->
							<!-- New Billing Group Type start -->
							<table class="type1">
								<!-- table start -->
								<caption>table</caption>
								<colgroup>
									<col style="width: 150px" />
									<col style="width: *" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row"><spring:message
												code="sal.text.groupOption" /><span class="must">*</span></th>
										<td><label><input type="radio" id="grpOpt1"
												name="grpOpt" value="new" /><span><spring:message
														code="sal.btn.newBillingGroup" /></span></label> <label><input
												type="radio" id="grpOpt2" name="grpOpt" value="exist" /><span><spring:message
														code="sal.btn.existBillGrp" /></span></label></td>
									</tr>
								</tbody>
							</table>
							<!-- table end -->
							<!-- New Billing Group - Copy from OrderRegister -->
							<!------------------------------------------------------------------------------
          Billing Method - Form ID(billMthdForm)
      ------------------------------------------------------------------------------->
							<section id="sctBillMthd" class="blind">
								<table class="type1 mb1m">
									<!-- table start -->
									<caption>table</caption>
									<colgroup>
										<col style="width: 150px" />
										<col style="width: *" />
										<col style="width: 170px" />
										<col style="width: *" />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" rowspan="5"><spring:message
													code="sal.text.billingMethod" /><span class="must">*</span></th>
											<td colspan="3"><label><input id="billMthdPost"
													name="billMthd" type="radio" disabled /><span><spring:message
															code="sal.text.post" /></span></label></td>
										</tr>
										<tr>
											<td colspan="3"><label><input id="billMthdSms"
													name="billMthd" type="radio" /><span><spring:message
															code="sal.text.sms" /></span></label> <label><input
													id="billMthdSms1" name="billMthdSms1" type="checkbox"
													disabled /><span><spring:message
															code="sal.text.mobile" /> 1</span></label> <label><input
													id="billMthdSms2" name="billMthdSms2" type="checkbox"
													disabled /><span><spring:message
															code="sal.text.mobile" /> 2</span></label></td>
										</tr>
										<tr>
											<td><label><input id="billMthdEstm"
													name="billMthd" type="radio" /><span><spring:message
															code="sal.text.eBilling" /></span></label> <label><input
													id="billMthdEmail1" name="billMthdEmail1" type="checkbox"
													disabled /><span><spring:message
															code="sal.text.email" /> 1</span></label> <label><input
													id="billMthdEmail2" name="billMthdEmail2" type="checkbox"
													disabled /><span><spring:message
															code="sal.text.email" /> 2</span></label></td>
											<th scope="row"><spring:message
													code="sal.title.text.eamilOne" /><span id="spEmail1"
												class="must">*</span></th>
											<td><input id="billMthdEmailTxt1"
												name="billMthdEmailTxt1" type="text" title=""
												placeholder="Email Address" class="w100p" disabled /></td>
										</tr>
										<tr>
											<td></td>
											<th scope="row"><spring:message
													code="sal.title.text.emailTwo" /></th>
											<td><input id="billMthdEmailTxt2"
												name="billMthdEmailTxt2" type="text" title=""
												placeholder="Email Address" class="w100p" disabled /></td>
										</tr>
										<tr>
											<td><label><input id="billGrpWeb"
													name="billGrpWeb" type="checkbox" /><span><spring:message
															code="sal.text.webPortal" /></span></label></td>
											<th scope="row"><spring:message
													code="sal.text.webAddrUrl" /></th>
											<td><input id="billGrpWebUrl" name="billGrpWebUrl"
												type="text" title="" placeholder="Web Address" class="w100p" /></td>
										</tr>
									</tbody>
								</table>
								<!-- table end -->
							</section>

							<!------------------------------------------------------------------------------
          Billing Address - Form ID(billAddrForm)
      ------------------------------------------------------------------------------->
							<section id="sctBillAddr" class="blind">
								<input id="hiddenBillAddId" name="custAddId" type="hidden" /> <input
									id="hiddenBillStreetId" name="hiddenBillStreetId" type="hidden" />

								<aside class="title_line">
									<!-- title_line start -->
									<h3>
										<spring:message code="sal.title.billingAddress" />
									</h3>
								</aside>
								<!-- title_line end -->

								<ul class="right_btns mb10">
									<li id="liBillNewAddr" class="blind"><p class="btn_grid">
											<a id="billNewAddrBtn" href="#"><spring:message
													code="sal.btn.addNewAddr" /></a>
										</p></li>
									<li id="liBillSelAddr" class="blind"><p class="btn_grid">
											<a id="billSelAddrBtn" href="#"><spring:message
													code="sal.title.text.selectAnotherAddress" /></a>
										</p></li>
								</ul>

								<table class="type1">
									<!-- table start -->
									<caption>table</caption>
									<colgroup>
										<col style="width: 150px" />
										<col style="width: *" />
										<col style="width: 170px" />
										<col style="width: *" />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row"><spring:message
													code="sal.text.addressDetail" /><span class="must">*</span></th>
											<td colspan="3"><input id="billAddrDtl"
												name="billAddrDtl" type="text" title=""
												placeholder="Address Detail" class="w100p readonly" readonly />
											</td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.street" /></th>
											<td colspan="3"><input id="billStreet" name="billStreet"
												type="text" title="" placeholder="Street"
												class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.area" /><span
												class="must">*</span></th>
											<td colspan="3"><input id="billArea" name="billArea"
												type="text" title="" placeholder="Area"
												class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.city" /><span
												class="must">*</span></th>
											<td><input id="billCity" name="billCity" type="text"
												title="" placeholder="City" class="w100p readonly" readonly />
											</td>
											<th scope="row"><spring:message code="sal.text.postCode" /><span
												class="must">*</span></th>
											<td><input id="billPostCode" name="billPostCode"
												type="text" title="" placeholder="Postcode"
												class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.state" /><span
												class="must">*</span></th>
											<td><input id="billState" name="billState" type="text"
												title="" placeholder="State" class="w100p readonly" readonly />
											</td>
											<th scope="row"><spring:message code="sal.text.country" /><span
												class="must">*</span></th>
											<td><input id="billCountry" name="billCountry"
												type="text" title="" placeholder="Country"
												class="w100p readonly" readonly /></td>
										</tr>

									</tbody>
								</table>
								<!-- table end -->
								<!-- Existing Type end -->
							</section>
							<br>

							<section id="sctBillPrefer" class="blind">
								<aside class="title_line">
									<!-- title_line start -->
									<h3>
										<spring:message code="sal.title.text.billPrefer" />
									</h3>
								</aside>
								<!-- title_line end -->

								<ul class="right_btns mb10">
									<li id="liBillPreferNewAddr" class="blind"><p
											class="btn_grid">
											<a id="billPreferAddAddrBtn" href="#"><spring:message
													code="sal.btn.addNewContact" /></a>
										</p></li>
									<li id="liBillPreferSelAddr" class="blind"><p
											class="btn_grid">
											<a id="billPreferSelAddrBtn" href="#"><spring:message
													code="sal.btn.selNewContact" /></a>
										</p></li>
								</ul>

								<!------------------------------------------------------------------------------
          Billing Preference - Form ID(billPreferForm)
      ------------------------------------------------------------------------------->
								<section class="search_table">
									<!-- search_table start -->
									<input id="hiddenBPCareId" name="hiddenBPCareId" type="hidden" />
									<table class="type1">
										<!-- table start -->
										<caption>table</caption>
										<colgroup>
											<col style="width: 150px" />
											<col style="width: *" />
											<col style="width: 170px" />
											<col style="width: *" />
										</colgroup>
										<tbody>
											<tr>
												<th scope="row"><spring:message code="sal.text.initial" /><span
													class="must">*</span></th>
												<td colspan="3"><select id="billPreferInitial"
													name="billPreferInitial" class="w100p"></select></td>
											</tr>
											<tr>
												<th scope="row"><spring:message code="sal.text.name" /><span
													class="must">*</span></th>
												<td colspan="3"><input id="billPreferName"
													name="billPreferName" type="text" title=""
													placeholder="Name" class="w100p" readonly /></td>
											</tr>
											<tr>
												<th scope="row"><spring:message
														code="sal.title.text.telO" /><span class="must">*</span></th>
												<td><input id="billPreferTelO" name="billPreferTelO"
													type="text" title="" placeholder="Tel(Office)"
													class="w100p" readonly /></td>
												<th scope="row"><spring:message code="sal.text.extNo" /><span
													class="must">*</span></th>
												<td><input id="billPreferExt" name="billPreferExt"
													type="text" title="" placeholder="Ext No." class="w100p"
													readonly /></td>
											</tr>
										</tbody>
									</table>
									<!-- table end -->
								</section>
								<!-- search_table end -->
							</section>

							<!-- Existing Billing Group -->
							<!--
            ****************************************************************************
                                            Billing Group Selection - Form ID(billPreferForm)
            *****************************************************************************
                  -->
							<section id="sctBillSel" class="blind">
								<aside class="title_line">
									<!-- title_line start -->
									<h3>
										<spring:message code="sal.page.subtitle.billingGroupSelection" />
									</h3>
								</aside>
								<!-- title_line end -->
								<table class="type1">
									<!-- table start -->
									<caption>table</caption>
									<colgroup>
										<col style="width: 150px" />
										<col style="width: *" />
										<col style="width: 170px" />
										<col style="width: *" />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row"><spring:message
													code="sal.text.billingGroup" /><span class="must">*</span></th>
											<td><input id="txtBillGroupOwnt" name="txtBillGroup"
												type="text" title="" placeholder="Billing Group"
												class="readonly" readonly /><a id="billGrpBtn" href="#"
												class="search_btn"><img
													src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
													alt="search" /></a> <input id="txtHiddenBillGroupIDOwnt"
												name="txtHiddenBillGroupID" type="hidden" /></td>
											<th scope="row"><spring:message
													code="sal.text.billingType" /><span class="must">*</span></th>
											<td><input id="txtBillTypeOwnt" name="txtBillType"
												type="text" title="" placeholder="Billing Type"
												class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message
													code="sal.text.billingAddress" /></th>
											<td colspan="3"><textarea id="txtBillAddressOwnt"
													name="txtBillAddress" cols="20" rows="5" readonly></textarea>
											</td>
										</tr>
									</tbody>
								</table>
								<!-- table end -->
							</section>
							<table class="type1">
								<!-- table start -->
								<caption>table</caption>
								<colgroup>
									<col style="width: 150px" />
									<col style="width: *" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row"><spring:message code="sal.text.remark" /></th>
										<td><textarea id="txtBillGroupRemarkOwnt"
												name="txtBillGroupRemark" cols="20" rows="5" readonly></textarea>
										</td>
									</tr>
								</tbody>
							</table>
							<!-- table end -->
							<!-- Existing Type end -->
						</article>
						<!-- tap_area end -->
						<!--
            ****************************************************************************
                                                                      Installation
            *****************************************************************************
                  -->
						<article class="tap_area">
							<!-- tap_area start -->
							<aside class="title_line">
								<!-- title_line start -->
								<h3>
									<spring:message code="sal.text.instAddr" />
								</h3>
							</aside>
							<!-- title_line end -->
							<section class="search_table">
								<!-- search_table start -->
								<ul class="right_btns mb10">
									<li id="btnAddInstAddress" class="blind"><p
											class="btn_grid">
											<a id="billNewAddrBtn" href="#"><spring:message
													code="sal.text.instAddr" /></a>
										</p></li>
									<li id="btnSelectInstAddress" class="blind"><p
											class="btn_grid">
											<a id="billSelAddrBtn" href="#"><spring:message
													code="sal.title.text.selectAnotherAddress" /></a>
										</p></li>
								</ul>
								<table class="type1">
									<!-- table start -->
									<caption>table</caption>
									<colgroup>
										<col style="width: 140px" />
										<col style="width: *" />
										<col style="width: 170px" />
										<col style="width: *" />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row"><spring:message
													code="sal.text.addressDetail" /><span class="must">*</span></th>
											<td colspan="3"><input id="txtInstAddrDtlOwnt"
												name="txtInstAddrDtl" type="text" title=""
												placeholder="Address Detail" class="w100p readonly" readonly />
											</td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.street" /></th>
											<td colspan="3"><input id="txtInstStreetOwnt"
												name="txtInstStreet" type="text" title=""
												placeholder="Street" class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.area" /><span
												class="must">*</span></th>
											<td colspan="3"><input id="txtInstAreaOwnt"
												name="txtInstArea" type="text" title="" placeholder="Area"
												class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.city" /><span
												class="must">*</span></th>
											<td><input id="txtInstCityOwnt" name="txtMailCity"
												type="text" title="" placeholder="City"
												class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.postCode" /><span
												class="must">*</span></th>
											<td><input id="txtInstPostcodeOwnt"
												name="txtMailPostcode" type="text" title=""
												placeholder="Postcode" class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.state" /><span
												class="must">*</span></th>
											<td><input id="txtInstStateOwnt" name="txtInstState"
												type="text" title="" placeholder="State"
												class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.country" /><span
												class="must">*</span></th>
											<td><input id="txtInstCountryOwnt" name="txtInstCountry"
												type="text" title="" placeholder="Country"
												class="w100p readonly" readonly /></td>
										</tr>
									</tbody>
								</table>
								<!-- table end -->
								<aside class="title_line">
									<!-- title_line start -->
									<h3>
										<spring:message code="sal.title.text.installCntcPerson" />
									</h3>
								</aside>
								<!-- title_line end -->
								<ul class="right_btns mb10">
									<li id="btnAddInstContact" class="blind"><p
											class="btn_grid">
											<a id="mstCntcNewAddBtn" href="#"><spring:message
													code="sal.title.text.addNewCntc" /></a>
										</p></li>
									<li id="btnSelectInstContact" class="blind"><p
											class="btn_grid">
											<a id="mstCntcSelAddBtn" href="#"><spring:message
													code="sal.btn.selNewContact" /></a>
										</p></li>
								</ul>
								<table class="type1">
									<!-- table start -->
									<caption>table</caption>
									<colgroup>
										<col style="width: 140px" />
										<col style="width: *" />
										<col style="width: 170px" />
										<col style="width: *" />
										<col style="width: 170px" />
										<col style="width: *" />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row"><spring:message code="sal.text.name" /><span
												class="must">*</span></th>
											<td><input id="txtInstContactNameOwnt"
												name="txtInstContactName" type="text" title=""
												placeholder="Name" class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.initial" /></th>
											<td><input id="txtInstContactInitialOwnt"
												name="txtInstContactInitial" type="text" title=""
												placeholder="Initial" class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.gender" /></th>
											<td><input id="txtInstContactGenderOwnt"
												name="txtInstContactGender" type="text" title=""
												placeholder="Gender" class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.nric" /></th>
											<td><input id="txtInstContactICOwnt"
												name="txtInstContactIC" type="text" title=""
												placeholder="NRIC" class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.dob" /></th>
											<td><input id="txtInstContactDOBOwnt"
												name="txtInstContactDOB" type="text" title=""
												placeholder="DOB" class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.race" /></th>
											<td><input id="txtInstContactRaceOwnt"
												name="txtInstContactRaceOwnt" type="text" title=""
												placeholder="Race" class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.email" /></th>
											<td><input id="txtInstContactEmailOwnt"
												name="txtInstContactEmail" type="text" title=""
												placeholder="Email" class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.dept" /></th>
											<td><input id="txtInstContactDeptOwnt"
												name="txtInstContactDept" type="text" title=""
												placeholder="Department" class="w100p readonly" readonly />
											</td>
											<th scope="row"><spring:message code="sal.text.post" /></th>
											<td><input id="txtInstContactPostOwnt"
												name="txtInstContactPost" type="text" title=""
												placeholder="Post" class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.telM" /></th>
											<td><input id="txtInstContactTelMobOwnt"
												name="txtInstContactTelMob" type="text" title=""
												placeholder="Telephone Number (Mobile)"
												class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.telR" /></th>
											<td><input id="txtInstContactTelResOwnt"
												name="txtInstContactTelRes" type="text" title=""
												placeholder="Telephone Number (Residence)"
												class="w100p readonly" readonly /></td>
											<th scope="row"><spring:message code="sal.text.telO" /></th>
											<td><input id="txtInstContactTelOffOwnt"
												name="txtInstContactTelOff" type="text" title=""
												placeholder="Telephone Number (Office)"
												class="w100p readonly" readonly /></td>
										</tr>
										<tr>
											<th scope="row"><spring:message code="sal.text.telF" /></th>
											<td><input id="txtInstContactTelFaxOwnt"
												name="txtInstContactTelFax" type="text" title=""
												placeholder="Telephone Number (Fax)" class="w100p" /></td>
											<th scope="row"></th>
											<td></td>
											<th scope="row"></th>
											<td></td>
										</tr>
									</tbody>
								</table>
								<!-- table end -->
								<aside class="title_line">
									<!-- title_line start -->
									<h3>
										<spring:message code="sal.title.text.installInfomation" />
									</h3>
								</aside>
								<!-- title_line end -->
								<table class="type1">
									<!-- table start -->
									<caption>table</caption>
									<colgroup>
										<col style="width: 140px" />
										<col style="width: *" />
										<col style="width: 170px" />
										<col style="width: *" />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row"><spring:message
													code="sal.title.text.dscBrnch" /><span class="must">*</span></th>
											<td colspan="3"><select id="cmbDSCBranchOwnt"
												name="cmbDSCBranch" class="w100p"></select></td>
										</tr>
										<tr>
											<th scope="row"><spring:message
													code="sal.title.text.perferInstDate" /><span class="must">*</span></th>
											<td><input id="dpPreferInstDateOwnt"
												name="dpPreferInstDate" type="text"
												title="Create start Date" placeholder="DD/MM/YYYY"
												class="j_date w100p" /></td>
											<th scope="row"><spring:message
													code="sal.title.text.perferInstTime" /><span class="must">*</span></th>
											<td>
												<div class="time_picker w100p">
													<!-- time_picker start -->
													<input id="tpPreferInstTimeOwnt" name="tpPreferInstTime"
														type="text" title="" placeholder=""
														class="time_date w100p" />
													<ul>
														<li>Time Picker</li>
														<li><a href="#">12:00 AM</a></li>
														<li><a href="#">01:00 AM</a></li>
														<li><a href="#">02:00 AM</a></li>
														<li><a href="#">03:00 AM</a></li>
														<li><a href="#">04:00 AM</a></li>
														<li><a href="#">05:00 AM</a></li>
														<li><a href="#">06:00 AM</a></li>
														<li><a href="#">07:00 AM</a></li>
														<li><a href="#">08:00 AM</a></li>
														<li><a href="#">09:00 AM</a></li>
														<li><a href="#">10:00 AM</a></li>
														<li><a href="#">11:00 AM</a></li>
														<li><a href="#">12:00 PM</a></li>
														<li><a href="#">01:00 PM</a></li>
														<li><a href="#">02:00 PM</a></li>
														<li><a href="#">03:00 PM</a></li>
														<li><a href="#">04:00 PM</a></li>
														<li><a href="#">05:00 PM</a></li>
														<li><a href="#">06:00 PM</a></li>
														<li><a href="#">07:00 PM</a></li>
														<li><a href="#">08:00 PM</a></li>
														<li><a href="#">09:00 PM</a></li>
														<li><a href="#">10:00 PM</a></li>
														<li><a href="#">11:00 PM</a></li>
													</ul>
												</div> <!-- time_picker end -->
											</td>
										</tr>
										<tr>
											<th scope="row"><spring:message
													code="sal.title.text.specialInstruction" /><span
												class="must">*</span></th>
											<td colspan=3><textarea
													id="txtInstSpecialInstructionOwnt"
													name="txtInstSpecialInstruction" cols="20" rows="5"></textarea>
											</td>
										</tr>
									</tbody>
								</table>
								<!-- table end -->
							</section>
							<!-- search_table end -->
						</article>
						<!-- tap_area end -->
					</section>
					<!-- tap_wrap end -->
					<section class="search_table mt20">
						<!-- search_table start -->
						<table class="type1">
							<!-- table start -->
							<caption>table</caption>
							<colgroup>
								<col style="width: 140px" />
								<col style="width: *" />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row"><spring:message code="sal.text.refNo" /></th>
									<td><input id="txtReferenceNoOwnt" name="txtReferenceNo"
										type="text" title="" placeholder="" class="w100p" /></td>
								</tr>
							</tbody>
						</table>
						<!-- table end -->
					</section>
				</article>
				<!-- search_table end -->
				<ul class="center_btns">
					<li><p class="btn_blue2">
							<a id="btnReqOwnTrans" href="#"><spring:message
									code="sal.btn.tranfOwn" /></a>
						</p></li>
				</ul>
			</form>
		</section>
		<!--
      ****************************************************************************
                                         Ownership Transfer Request END
      *****************************************************************************
    -->
	</section>
	<!-- pop_body end -->
</div>
<!-- popup_wrap end -->