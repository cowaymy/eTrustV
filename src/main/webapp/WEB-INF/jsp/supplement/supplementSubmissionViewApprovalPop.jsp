<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style type="text/css">

/* 커스텀 스타일 정의 */
.auto_file2 {
  width: 100% !important;
}

.auto_file2>label {
  width: 100% !important;
}

.auto_file2 label input[type=text] {
  width: 40% !important;
  float: left
}

</style>
<script type="text/javaScript">

	var purchaseGridID;
	var myFileCaches = {};
	var atchFileGrpId = 0;
	var custId = '${supplement.custId}';
	var sofNo = '${supplement.sofNo}';
	var supSubmId = '${supplement.supSubmId}';
	var nric = '${supplement.nric}';
	var memId = '${supplement.memId}';
	var atchFileGrpId = '${supplement.atchFileGrpId}';
	var subRemark = '${supplement.supSubmRmk}';
	var modValue = '${modValue}';

	var sofFileId = 0;
    var nricFileId = 0;
    var otherFileId = 0;
    var otherFileId2 = 0;
    var otherFileId3 = 0;
    var otherFileId4 = 0;
    var otherFileId5 = 0;

    var sofFileName = "";
    var nricFileName = "";
    var otherFileName = "";
    var otherFileName2 = "";
    var otherFileName3 = "";
    var otherFileName4 = "";
    var otherFileName5 = "";


	$(document).ready(
			function() {
				createPurchaseGridID();
				fn_loadSupplementSubmission();
				fn_loadSupplementSubmissionItem(supSubmId);

				 doGetComboData('/status/selectStatusCategoryCdList.do', {selCategoryId : 34, parmDisab : 0}, '', 'subApprovalStatus', 'S', '');
				 //console.log("modValue : " + modValue);
				 if(modValue == "approval"){
					 $('#scSubmissionApproval').show();
					 $('#btnSaveApproval').show();
					 $('#btnSaveCancel').hide();
					 $('#supSubmHeader').text('<spring:message code="supplement.text.submissionApproval" />');
				 }else if(modValue == "cancel"){
					 $('#scSubmissionApproval').hide();
					 $('#btnSaveApproval').hide();
					 $('#btnSaveCancel').show();
					 $('#supSubmHeader').text('<spring:message code="supplement.text.submissionCancel" />');
				 }else{
					 $('#scSubmissionApproval').hide();
					 $('#btnSaveApproval').hide();
					 $('#btnSaveCancel').hide();
					 $('#supSubmHeader').text('<spring:message code="supplement.text.submissionView" />');
				 }


			});


	$(function() {
		$('#btnSaveApproval').click(function() {
			if (FormUtil.checkReqValue($("#subApprovalStatus"))) {
		        Common.alert("* <spring:message code='sys.msg.necessary' arguments='Submission Status' htmlEscape='false'/> </br>");
		        return false;
		    }

		    if ($("#subApprovalStatus").val() == "RJT" || $("#subApprovalStatus").val() == "CAN") {
		        if (FormUtil.checkReqValue($("#subApprovalRemark"))) {
		            Common.alert("* <spring:message code='sys.msg.necessary' arguments='Submission Remark' htmlEscape='false'/> </br>");
		            return false;
		        }
		    }

		    var saveSubmissionApproval = function() {
		        var data = {
		            supSubmId: supSubmId,
		            stus: $("#subApprovalStatus").val(),
		            remark: $("#subApprovalRemark").val()
		        };

		        Common.ajax("POST", "/supplement/updateSubmissionApprovalStatus.do", data, function(result) {
		            Common.alert(result.message, fn_closeSupplementSubmissionViewApprovalPop);
		            $("#popup_wrap").remove();
		        }, function(error) {
		            Common.alert("An error occurred while saving submission approval: " + error.message);
		        });
		    };

		    saveSubmissionApproval();
	    });


		$('#btnSaveCancel').click(function() {

		    var saveSubmissionApproval = function() {
		        var data = {
		            supSubmId: supSubmId,
		            stus: "CAN",
		            remark: "Confirm to Cancel"
		        };

		        Common.ajax("POST", "/supplement/updateSubmissionApprovalStatus.do", data, function(result) {
		            Common.alert(result.message, fn_closeSupplementSubmissionViewApprovalPop);
		            $("#popup_wrap").remove();
		        }, function(error) {
		            Common.alert("An error occurred while saving submission cancel: " + error.message);
		        });
		    };

		    saveSubmissionApproval();
	    });


	});

	function fn_loadSupplementSubmission(){

		$('#nric').prop("readonly", true).addClass("readonly").hide();
		$('#sofNo').prop("readonly", true).addClass("readonly").hide();

		$('#remark').val(subRemark);
		fn_maskingData('_NRIC', $('#nric').val(nric));
		fn_maskingData('_SOFNO', $('#sofNo').val(sofNo));

		$('#pNric').show();
		$('#pSofNo').show();

		fn_loadCustomer(custId,null);
		fn_loadOrderSalesman(memId,null);

		if(atchFileGrpId != 0){
            fn_loadAtchment(atchFileGrpId);
        }

	}

	function fn_loadCustomer(custId, nric) {
		Common
				.ajax(
						"GET",
						"/sales/customer/selectCustomerJsonList",
						{
							custId : custId,
							nric : nric
						},
						function(result) {
							Common.removeLoader();

							if (result.length > 0) {

								var custInfo = result[0];
								$('#scSupplementSubmissionView').removeClass("blind");
													$("#hiddenCustId").val(
															custInfo.custId); //Customer ID(Hidden)
													$("#custTypeNm").text(
															custInfo.codeName1);
													$("#hiddenCustTypeNm").val(
															custInfo.codeName1); //Customer Type Nm(Hidden)
													$("#hiddenTypeId").val(
															custInfo.typeId); //Type
													$("#name").text(
															custInfo.name); //Name
													$("#nric").val(
															custInfo.nric); //NRIC/Company No
													$("#nationNm").text(
															custInfo.name2); //Nationality
													$("#race").text(
															custInfo.codeName2); //
													$("#dob")
															.text(
																	custInfo.dob == '01/01/1900' ? ''
																			: custInfo.dob); //DOB
													$("#gender").text(
															custInfo.gender); //Gender
													$("#pasSportExpr")
															.text(
																	custInfo.pasSportExpr == '01/01/1900' ? ''
																			: custInfo.pasSportExpr); //Passport Expiry
													$("#visaExpr")
															.text(
																	custInfo.visaExpr == '01/01/1900' ? ''
																			: custInfo.visaExpr); //Visa Expiry
													$("#custEmail").val(
															custInfo.email); //Email
													$("#pCustEmail").show();
													fn_maskingData(
															"_CUSTEMAIL",
															$("#custEmail"));
													$("#custEmail").text(
															custInfo.email); //Email
													$("#hiddenCustStatusId")
															.val(
																	custInfo.custStatusId); //Customer Status
													$("#custStatus")
															.text(
																	custInfo.custStatus); //Customer Status
													if (custInfo.receivingMarketingMsgStatus == 1) {
														$("#marketMessageYes")
																.prop(
																		"checked",
																		true);
													} else {
														$("#marketMessageNo")
																.prop(
																		"checked",
																		true);
													}

													if (custInfo.corpTypeId > 0) {
														$("#corpTypeNm")
																.val(
																		custInfo.codeName); //Industry Code
													} else {
														$("#corpTypeNm")
																.val(""); //Industry Code
													}

													if (custInfo.custAddId > 0) {

														fn_loadBillAddr(custInfo.custAddId);
														fn_loadInstallAddr(custInfo.custAddId);
													}

													if (custInfo.custCntcId > 0) {

														fn_loadMainCntcPerson(custInfo.custCntcId);
														fn_loadCntcPerson(custInfo.custCntcId);

													}


							}
						});
	}

	function fn_createCustomerPop() {
		if (Common.checkPlatformType() == "mobile") {
			var strDocumentWidth = $(document).outerWidth();
			var strDocumentHeight = $(document).outerHeight();
			Common.popupWin("frmCustSearch",
					"/sales/customer/customerRegistPopESales.do", {
						width : strDocumentWidth + "px",
						height : strDocumentHeight + "px",
						resizable : "no",
						scrollbars : "yes"
					});
		} else {
			Common.popupWin("frmCustSearch",
					"/sales/customer/customerRegistPopESales.do", {
						width : "1220px",
						height : "690",
						resizable : "no",
						scrollbars : "no"
					});
		}
	}

	function fn_loadMainCntcPerson(custCntcId) {
		Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {
			custCntcId : custCntcId
		}, function(custCntcInfo) {
			if (custCntcInfo != null) {
				$("#hiddenCustCntcId").val(custCntcInfo.custCntcId);
				$("#custInitial").text(custCntcInfo.code);
				$("#custEmail").val(custCntcInfo.email);
			}
		});
	}

	function fn_loadCntcPerson(custCntcId) {
		Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {
			custCntcId : custCntcId
		}, function(custCntcInfo) {
			if (custCntcInfo != null) {
				$("#hiddenCustCntcId").val(custCntcInfo.custCntcId);
				$("#custCntcInitial").val(custCntcInfo.code);
				$("#custCntcName").text(custCntcInfo.name1);
				$("#custCntcEmail").val(custCntcInfo.email);
				$("#pCntcEmail").show();
				fn_maskingData("_CNTCEMAIL", $("#custCntcEmail"));
				$("#custCntcTelM").val(custCntcInfo.telM1);
				$("#pCustCntcTelM").show();
				fn_maskingData("_CUSTCNTCTELM", $("#custCntcTelM"));
				$("#custCntcTelR").val(custCntcInfo.telR);
				$("#pCustCntcTelR").show();
				fn_maskingData("_CUSTCNTCTELR", $("#custCntcTelR"));
				$("#custCntcTelO").val(custCntcInfo.telO);
				$("#pCustCntcTelO").show();
				fn_maskingData("_CUSTCNTCTELO", $("#custCntcTelO"));
				$("#custCntcTelF").val(custCntcInfo.telf);
				$("#pCustCntcTelF").show();
				fn_maskingData("_CUSTCNTCTELF", $("#custCntcTelF"));
				$("#custCntcExt").text(custCntcInfo.ext);
			}
		});
	}

	function fn_loadBillAddr(custAddId) {
		Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {
			custAddId : custAddId
		}, function(billCustInfo) {
			if (billCustInfo != null) {
				$("#hiddenBillAddId").val(billCustInfo.custAddId); //Customer Address ID(Hidden)
				$("#billAddrDtl").val(billCustInfo.addrDtl); //Address
				$("#pBillAddrDtl").show();
				fn_maskingDataAddr("_BILLADDRDTL", $("#billAddrDtl"));
				$("#billStreet").text(billCustInfo.street); //Street
				$("#billArea").text(billCustInfo.area); //Area
				$("#billCity").text(billCustInfo.city); //City
				$("#billPostCode").text(billCustInfo.postcode); //Post Code
				$("#billState").text(billCustInfo.state); //State
				$("#billCountry").text(billCustInfo.country); //Country
				$("#hiddenBillStreetId").val(billCustInfo.custAddId); //Magic Address STREET_ID(Hidden)
			}
		});
	}

	function fn_loadInstallAddr(custAddId) {
		Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {
			custAddId : custAddId
		}, function(custInfo) {
			if (custInfo != null) {
				$("#hiddenCustAddId").val(custInfo.custAddId); //Customer Address ID(Hidden)
				$("#instAddrDtl").val(custInfo.addrDtl); //Address
				$("#pInstAddrDtl").show();
				fn_maskingDataAddr("_INSTADDRDTL", $("#instAddrDtl"));
				$("#instStreet").text(custInfo.street); //Street
				$("#instArea").text(custInfo.area); //Area
				$("#instCity").text(custInfo.city); //City
				$("#instPostCode").text(custInfo.postcode); //Post Code
				$("#instState").text(custInfo.state); //State
				$("#instCountry").text(custInfo.country); //Country
				$("#dscBrnchId").val(custInfo.brnchId); //DSC Branch
				if (MEM_TYPE == 2)
					$("#keyinBrnchId").val(custInfo.cdBrnchId); //Posting Branch
				else if (MEM_TYPE == 7)
					$("#keyinBrnchId").val(284); //Posting Branch
				else
					$("#keyinBrnchId").val(custInfo.soBrnchId); //Posting Branch
				if (custInfo.gstChk == '1') {
					$("#gstChk").val('1').prop("disabled", true);
				} else {
					$("#gstChk").val('0').removeAttr("disabled");
				}
			}
		});
	}

	function fn_loadOrderSalesman(memId, memCode) {
		Common
				.ajax(
						"GET",
						"/supplement/selectMemberByMemberIDCode.do",
						{
							memId : memId,
							memCode : memCode
						},
						function(memInfo) {

							if (memInfo == null) {
								Common
										.alert('<b>Member not found.</br>Your input member code : '
												+ memCode + '</b>');
							} else {
								$('#salesmanCd').val(memInfo.memCode);
								$('#salesmanNm').val(memInfo.name);
								$('#hidSalesmanId').val(memInfo.memId);
								$('#isSuppl').val(memInfo.isSuppl);

								if(memInfo.isSuppl == 'N' || memInfo.isSuppl == null){
									Common
									.alert('<spring:message code="supplement.alert.memCodeNotEligible" />' + ' - '
											+ memCode + '</b>');
									$('#salesmanCd').val('');
									$('#salesmanNm').val('');
								}else{
									Common.ajax("GET", "/supplement/selectMemBrnchByMemberCode.do", {
										memCode : memInfo.memCode
									}, function(result) {
										if(result != null){
											$('#salesmanBrnch').text(result.brnch);
											$('#hidSalesmanBrnchId').val(result.brnchId);
										}else{
											$('#salesmanBrnch').val('');
											$('#hidSalesmanBrnchId').val('');
										}
									});
								}
							}
						});
	}


	function fn_loadSupplementSubmissionItem(supSubmId){

		var detailParam = {supSubmId : supSubmId};
        //Ajax
        Common.ajax("GET", "/supplement/selectSupplementSubmissionItmView", detailParam, function(result){
            AUIGrid.setGridData(purchaseGridID, result);
        });

	}

	// Define a common function to handle file input changes
	function handleFileChange(evt, cacheIndex) {
		var file = evt.target.files[0];
		if (file == null && myFileCaches[cacheIndex] != null) {
			delete myFileCaches[cacheIndex];
		} else if (file != null) {
			myFileCaches[cacheIndex] = {
				file : file
			};
		}

		var msg = '';
		if (file && file.name.length > 30) {
			msg += "*File name wording should be not more than 30 alphabet.<br>";
		}

		var fileType = file ? file.type.split('/') : [];
		if (fileType[1] != 'jpg' && fileType[1] != 'jpeg'
				&& fileType[1] != 'png' && fileType[1] != 'pdf') {
			msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
		}

		if (file && file.size > 2000000) {
			msg += "*Only allow picture with less than 2MB.<br>";
		}

		if (msg) {
			myFileCaches[cacheIndex].file['checkFileValid'] = false;
			Common.alert(msg);
		} else {
			myFileCaches[cacheIndex].file['checkFileValid'] = true;
		}

		//console.log(myFileCaches);
	}

	function fn_removeFile(name) {
		if (name == "OTH") {
			$("#otherFile").val("");
			$('#otherFile').change();
		} else if (name == "OTH2") {
			$("#otherFile2").val("");
			$('#otherFile2').change();
		} else if (name == "OTH3") {
			$("#otherFile3").val("");
			$('#otherFile3').change();
		} else if (name == "OTH4") {
			$("#otherFile4").val("");
			$('#otherFile4').change();
		} else if (name == "OTH5") {
			$("#otherFile5").val("");
			$('#otherFile5').change();
		}
	}

	function fn_maskingData(ind, obj) {
		var maskedVal = (obj.val()).substr(-4)
				.padStart((obj.val()).length, '*');
		$("#span" + ind).html(maskedVal);
	}

	function fn_maskingDataAddr(ind, obj) {
		var maskedVal = (obj.val()).substr(-20).padStart((obj.val()).length,
				'*');
		$("#span" + ind).html(maskedVal);
	}

	function createPurchaseGridID() {

		var posColumnLayout = [ {
			dataField : "stkCode",
			headerText : '<spring:message code="sal.title.itemCode" />',
			width : '10%'
		}, {
			dataField : "stkDesc",
			headerText : '<spring:message code="sal.title.itemDesc" />',
			width : '30%'
		}, {
			dataField : "inputQty",
			headerText : '<spring:message code="sal.title.qty" />',
			width : '10%'
		}, {
			dataField : "amt",
			headerText : '<spring:message code="sal.title.unitPrice" />',
			width : '10%',
			dataType : "numeric",
			formatString : "#,##0.00"
		}, {
			dataField : "subTotal",
			headerText : '<spring:message code="sal.title.subTotalExclGST" />',
			width : '15%',
			dataType : "numeric",
			formatString : "#,##0.00",
			expFunction : function(rowIndex, columnIndex, item, dataField) {
				var calObj = fn_calculateAmt(item.amt, item.inputQty);
				return Number(calObj.subChanges);
			}
		}, {
			dataField : "subChng",
			headerText : 'GST(0%)',
			width : '10%',
			dataType : "numeric",
			formatString : "#,##0.00",
			expFunction : function(rowIndex, columnIndex, item, dataField) {
				var calObj = fn_calculateAmt(item.amt, item.inputQty);
				return Number(calObj.taxes);
			}
		}, {
			dataField : "totalAmt",
			headerText : '<spring:message code="sal.text.totAmt" />',
			width : '15%',
			dataType : "numeric",
			formatString : "#,##0.00",
			expFunction : function(rowIndex, columnIndex, item, dataField) {
				var calObj = fn_calculateAmt(item.amt, item.inputQty);
				return Number(calObj.subTotal);
			}
		}, {
			dataField : "stkTypeId",
			visible : false
		}, {
			dataField : "stkId",
			visible : false
		} //STK_ID
		];

		//그리드 속성 설정
		var gridPros = {
			showFooter : true,
			usePaging : true, //페이징 사용
			pageRowCount : 10, //한 화면에 출력되는 행 개수 20(기본값:20)
			editable : false,
			fixedColumnCount : 1,
			showStateColumn : true,
			displayTreeOpen : false,
			//         selectionMode       : "singleRow",  //"multipleCells",
			headerHeight : 30,
			useGroupingPanel : false, //그룹핑 패널 사용
			skipReadonlyColumns : true, //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
			wrapSelectionMove : true, //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
			showRowNumColumn : true, //줄번호 칼럼 렌더러 출력
			showRowCheckColumn : true, //checkBox
			softRemoveRowMode : false
		};

		purchaseGridID = GridCommon.createAUIGrid("#item_grid_wrap",
				posColumnLayout, '', gridPros); // address list
		AUIGrid.resize(purchaseGridID, 960, 300);

		//
		var footerLayout = [ {
			labelText : "Total(RM)",
			positionField : "#base"
		}, {
			dataField : "subTotal",
			positionField : "subTotal",
			operation : "SUM",
			formatString : "#,##0.00",
			style : "aui-grid-my-footer-sum-total2"
		}, {
			dataField : "subChng",
			positionField : "subChng",
			operation : "SUM",
			formatString : "#,##0.00",
			style : "aui-grid-my-footer-sum-total2"
		}, {
			dataField : "totalAmt",
			positionField : "totalAmt",
			operation : "SUM",
			formatString : "#,##0.00",
			style : "aui-grid-my-footer-sum-total2"
		} ];
		//
		// 푸터 레이아웃 그리드에 설정
		AUIGrid.setFooter(purchaseGridID, footerLayout);
	}

	//posItmSrchPop -> posSystemPop
	function getItemListFromSrchPop(itmList) {
		AUIGrid.setGridData(purchaseGridID, itmList);

	}

	//Purchase Charge Amount
	function fn_calcuPurchaseAmt() {

		var totArr = [];
		totArr = AUIGrid.getColumnValues(purchaseGridID, 'totalAmt');

		var totalAmount = 0;
		if (totArr != null && totArr.length > 0) {
			for (var idx = 0; idx < totArr.length; idx++) {
				totalAmount += totArr[idx];
			}
		}
		totalAmount = parseFloat(totalAmount).toFixed(2);

		return totalAmount;
	}

	function fn_calculateAmt(amt, qty) {

		var subTotal = 0;
		var subChanges = 0;
		var taxes = 0;

		subTotal = amt * qty;
		subChanges = (subTotal * 100) / 100;
		subChanges = subChanges.toFixed(2); //소수점2반올림
		taxes = subTotal - subChanges;
		taxes = taxes.toFixed(2);

		var retObj = {
			subTotal : subTotal,
			subChanges : subChanges,
			taxes : taxes
		};

		return retObj;

	}

	var prev = "";
	var regexp = /^\d*(\.\d{0,2})?$/;

	function fn_inputAmt(obj) {

		if (obj.value.search(regexp) == -1) {
			obj.value = prev;
		} else {
			prev = obj.value;
		}

	}

	function fn_closeSupplementSubmissionViewApprovalPop() {
	    myFileCaches = {};
	    $('#btnSubmissionViewApprovalClose').click();

	    fn_getSupplementSubmissionList();
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
        Common.ajax("Get", "/supplement/selectAttachList.do", {atchFileGrpId :atchFileGrpId} , function(result) {
            //console.log(result);
           if(result) {
                if(result.length > 0) {
                    $("#attachTd").html("");
                    for ( var i = 0 ; i < result.length ; i++ ) {
                        switch (result[i].fileKeySeq){
                        case '1':
                            sofFileId = result[i].atchFileId;
                            sofFileName = result[i].atchFileName;
                            $(".input_text[id='sofFileTxt']").val(sofFileName);
                            break;
                        case '2':
                            nricFileId = result[i].atchFileId;
                            nricFileName = result[i].atchFileName;
                            $(".input_text[id='nricFileTxt']").val(nricFileName);
                            break;
                        case '3':
                            otherFileId = result[i].atchFileId;
                            otherFileName = result[i].atchFileName;
                            $(".input_text[id='otherFileTxt']").val(otherFileName);
                            break;
                        case '4':
                            otherFileId2 = result[i].atchFileId;
                            otherFileName2 = result[i].atchFileName;
                            $(".input_text[id='otherFileTxt2']").val(otherFileName2);
                            break;
                        case '5':
                            otherFileId3 = result[i].atchFileId;
                            otherFileName3 = result[i].atchFileName;
                            $(".input_text[id='otherFileTxt3']").val(otherFileName3);
                            break;
                        case '6':
                            otherFileId4 = result[i].atchFileId;
                            otherFileName4 = result[i].atchFileName;
                            $(".input_text[id='otherFileTxt4']").val(otherFileName4);
                            break;
                        case '7':
                            otherFileId5 = result[i].atchFileId;
                            otherFileName5 = result[i].atchFileName;
                            $(".input_text[id='otherFileTxt5']").val(otherFileName5);
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
</script>

  <div id="popup_wrap" class="popup_wrap">
  <input type="hidden" id="_memBrnch" value="${userBrnchId}">
  <input type="hidden" name="hidSalesmanBrnchId" id="hidSalesmanBrnchId" value="">
  <input type="hidden" name="isSuppl" id="isSuppl" value="">
  <input type="hidden" name="hidTotAmt" id="hidTotAmt" value="">
  <input type="hidden" name="hidSalesmanId" id="hidSalesmanId" value="">
    <!-- popup_wrap start -->
  <header class="pop_header">
    <!-- pop_header start -->
    <h1 id="supSubmHeader"></h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a id="btnSubmissionViewApprovalClose" href="#"><spring:message code="sal.btn.close" /></a>
        </p>
      </li>
    </ul>
  </header>
  <!-- pop_header end -->

  <section class="pop_body">
    <!-- pop_body start -->
    <aside class="title_line">
      <!-- title_line start -->
   <%--    <ul class="right_btns">
        <li>
          <p class="btn_blue">
            <a id="btnConfirm" href="#"><spring:message code="sal.btn.confirm" /></a>
          </p>
        </li>
        <li>
          <p class="btn_blue">
            <a id="btnClear" href="#"><spring:message code="sal.btn.clear" /></a>
          </p>
        </li>
      </ul> --%>
    </aside>
    <!-- title_line end -->

    <form id="frmCustSearch" name="frmCustSearch" action="#" method="post">
      <input id="selType" name="selType" type="hidden" value="1" />
      <input id="callPrgm" name="callPrgm" type="hidden" value="PRE_ORD" />
      <table class="type1">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width: 150px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code="sal.text.nricCompanyNo"/></th>
            <td colspan="3">
              <input id="nric" name="nric" type="text" title="" placeholder="" class="w100p" style="min-width: 150px" value="" readonly/>
               <table id="pNric" style="display:none">
                 <tr>
                   <td><span id="span_NRIC"></span></td>
                 </tr>
               </table>
             </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="supplement.text.eSOFno" /></th>
            <td colspan="3">
              <input id="sofNo" name="sofNo" type="text" title="" placeholder="" class="w100p" style="min-width: 150px" value="" readonly/>
              <table id="pSofNo" style="display:none">
                 <tr>
                   <td><span id="span_SOFNO"></span></td>
                 </tr>
               </table>
            </td>
          </tr>
          <tr>
            <th scope="row" colspan="4"><span class="must"><spring:message code='sales.msg.ordlist.icvalid' /></span></th>
          </tr>
        </tbody>
      </table>
      <!-- table end -->
    </form>

    <!------------------------------------------------------------------------------
      Supplement Submission Content START
    ------------------------------------------------------------------------------->

    <section id="scSupplementSubmissionView" class="blind">
      <section class="tap_wrap">
        <!-- tap_wrap start -->
        <ul class="tap_type1 num4">
          <li><a id="aTabCS" class="on"><spring:message code="sal.page.title.custInformation" /></a></li>
          <li><a id="aTabBD"><spring:message code="supplement.text.paymentInfo" /></a></li>
          <li><a id="aTabOI"><spring:message code="supplement.text.supplementInfo" /></a></li>
          <li><a id="aTabFL"><spring:message code="sal.text.attachment" /></a></li>
        </ul>

        <article class="tap_area">
          <!-- tap_area start -->
          <section class="search_table">
            <!-- search_table start -->
            <section class="tap_wrap">
            <ul class="tap_type1 num4">
          	<li><a id="aTabGI" class="on"><spring:message code="supplement.text.generalInfo" /></a></li>
          	<li><a id="aTabCI"><spring:message code="sal.tap.title.contactInfo" /></a></li>
          	<li><a id="aTabDI"><spring:message code="supplement.text.deliveryAddressInfo" /></a></li>
        	</ul>
        	<article class="tap_area">
            <form id="frmNewSubmission" name="frmNewSubmission" action="#" method="post">
              <input id="hiddenCustId" name="custId" type="hidden" />
              <input id="hiddenCustTypeNm" name="custTypeNm" type="hidden" />
              <input id="hiddenTypeId" name="typeId" type="hidden" />
              <input id="hiddenCustCntcId" name="custCntcId" type="hidden" />
              <input id="hiddenCustAddId" name="custAddId" type="hidden" />
              <input id="hiddenCallPrgm" name="callPrgm" type="hidden" />
              <input id="hiddenCustStatusId" name="hiddenCustStatusId" type="hidden" />


              <!-- title_line start -->
              <aside class="title_line">
                <h3><spring:message code="supplement.text.generalInfo" /></h3>
              </aside>
              <!-- title_line end -->

              <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                  <col style="width: 40%" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.custType" /><span class="must">**</span></th>
                    <td><span id="custTypeNm" name="custTypeNm"></span></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.title.text.companyType" /><span class="must">**</span></th>
                    <td><span id="corpTypeNm" name="corpTypeNm"></span></td>
                  </tr>
                  <tr>
                  	<th scope="row"><spring:message code="sal.text.initial" /><span class="must">**</span></th>
                    <td><span id="custInitial" name="custInitial"></span></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.custName" /><span class="must">**</span></th>
                    <td><span id="name" name="name"></span></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.nationality" /></th>
                    <td><span id="nationNm" name="nationNm"></span></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="supplement.text.passportExpiryDate" /></th>
                    <td><span id="pasSportExpr" name="pasSportExpr"></span></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="supplement.text.passportVisaExpiryDate" /></th>
                    <td><span id="visaExpr" name="visaExpr"></span></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.dob" /></th>
                    <td><span id="dob" name="dob"></span></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.race" /></th>
                    <td><span id="race" name="race"></span></td>
                  </tr>
                   <tr>
                    <th scope="row"><spring:message code="sal.text.gender" /></th>
                    <td><span id="gender" name="gender"></span></td>
                  </tr>
                   <tr>
                    <th scope="row"><spring:message code="sal.text.email" /></th>
                    <td>
                      <input id="custEmail" name="custCntcEmail" type="text" title="" placeholder="" class="w100p readonly" readonly style="display:none"/>
                      <table id="pCustEmail" style="display:none">
                        <tr>
                         <td><span id="span_CUSTEMAIL"></span></td>
                          </tr>
                      </table>
                    </td>
                  </tr>
                   <tr>
                    <th scope="row"><spring:message code="sal.text.custStus" /><span class="must">**</span></th>
                    <td><span id="custStatus" name="custStatus"></span></td>
                  </tr>
                </tbody>
              </table>
              <!-- table end -->
            </form>
            </article>
            <article class="tap_area">
            <section class="search_table">
            <!-- search_table start -->
            <aside class="title_line">
              <!-- title_line start -->
              <h3><spring:message code="sal.tap.title.contactInfo" /></h3>
            </aside>
            <!-- title_line end -->
                <ul class="right_btns mb10">
<%--                   <li>
                    <p class="btn_grid">
                      <a id="btnSelCntc" href="#"><spring:message code="sal.btn.selNewContact" /></a>
                    </p>
                  </li>
                  <li>
                    <p class="btn_grid">
                      <a id="btnNewCntc" href="#"><spring:message code="pay.btn.addNewContact" /></a>
                    </p>
                  </li> --%>
                </ul>

                <table class="type1">
                  <!-- table start -->
                  <caption>table</caption>
                  <colgroup>
                    <col style="width: 40%" />
                    <col style="width: *" />
                  </colgroup>
                  <tbody>
                    <tr>
                      <th scope="row"><spring:message code="sal.title.text.contactPersonName" /><span class="must">**</span></th>
                      <td>
                        <span id="custCntcName" name="custCntcName"></span>
                       </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code="sal.text.mobileNo" /><span class="must">**</span></th>
                      <td>
                        <input id="custCntcTelM" name="custCntcTelM" type="text" title="" placeholder="" class="w100p readonly" readonly style="display:none"/>
                        <table id="pCustCntcTelM" style="display:none">
                        <tr>
                         <td><span id="span_CUSTCNTCTELM"></span></td>
                       </tr>
                      </table>
                      </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code="supplement.text.residenceContactNo" /><span class="must">**</span></th>
                      <td>
                        <input id="custCntcTelR" name="custCntcTelR" type="text" title="" placeholder="" class="w100p readonly" readonly style="display:none"/>
                        <table id="pCustCntcTelR" style="display:none">
                        <tr>
                         <td><span id="span_CUSTCNTCTELR"></span></td>
                       </tr>
                      </table>
                      </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code="supplement.text.officeContactNo" /></th>
                      <td>
                        <input id="custCntcTelO" name="custCntcTelO" type="text" title="" placeholder="" class="w100p readonly" readonly style="display:none"/>
                        <table id="pCustCntcTelO" style="display:none">
                        <tr>
                         <td><span id="span_CUSTCNTCTELO"></span></td>
                       </tr>
                      </table>
                      </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code="sal.text.faxNo" /></th>
                      <td>
                        <input id="custCntcTelF" name="custCntcTelF" type="text" title="" placeholder="" class="w100p readonly" readonly style="display:none"/>
                        <table id="pCustCntcTelF" style="display:none">
                          <tr>
                             <td><span id="span_CUSTCNTCTELF"></span></td>
                           </tr>
                         </table>
                      </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code="sal.text.extNo" /></th>
                      <td>
                        <span id="custCntcExt" name="custCntcExt"></span>
                      </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code="sal.text.email" /><span class="must">**</span></th>
                      <td>
                        <input id="custCntcEmail" name="custCntcEmail" type="text" title="" placeholder="" class="w100p readonly" readonly style="display:none"/>
                        <table id="pCntcEmail" style="display:none">
                          <tr>
                             <td><span id="span_CNTCEMAIL"></span></td>
                           </tr>
                         </table>
                      </td>
                    </tr>
                  </tbody>
                </table>
                <!-- table end -->
              </section>
            </article>
            <article class="tap_area">
            <section class="search_table">
            <!-- search_table start -->
            <aside class="title_line">
              <!-- title_line start -->
              <h3><spring:message code="supplement.text.deliveryAddressInfo" /></h3>
            </aside>
                          <ul class="right_btns mb10">
             <%--    <li><p class="btn_grid">
                    <a id="btnSelInstAddr" href="#"><spring:message code="supplement.btn.selectExistingAddress" /></a>
                  </p></li>
                <li><p class="btn_grid">
                    <a id="btnNewInstAddr" href="#"><spring:message code="supplement.btn.addNewAddress" /></a>
                  </p></li> --%>
              </ul>

              <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                  <col style="width: 40%" />
                  <col style="width: *" />
                  <col style="width: 40%" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.addressDetail" /><span class="must">**</span></th>
                    <td colspan="3">
                      <input id="instAddrDtl" name="instAddrDtl" type="text" title="" placeholder="eg. NO 10/UNIT 13-02-05/LOT 33945" class="w100p readonly" readonly style="display:none"/>
                      <table id="pInstAddrDtl" style="display:none">
                          <tr>
                             <td><span id="span_INSTADDRDTL"></span></td>
                           </tr>
                         </table>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.street" /></th>
                    <td colspan="3">
                      <span id="instStreet" name="instStreet"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.area" /><span class="must">**</span></th>
                    <td colspan="3">
                      <span id="instArea" name="instArea"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.city" /><span class="must">**</span></th>
                    <td colspan="3">
                      <span id="instCity" name="instCity"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.postCode" /><span class="must">**</span></th>
                    <td colspan="3">
                      <span id="instPostCode" name="instPostCode"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.state" /><span class="must">**</span></th>
                    <td colspan="3">
                      <span id="instState" name="instState"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.country" /><span class="must">**</span></th>
                    <td colspan="3">
                      <span id="instCountry" name="instCountry"></span>
                    </td>
                  </tr>
                </tbody>
              </table>
              </section>
            </article>
          </section>
          </section>
          <!-- search_table end -->
        </article>
        <!-- tap_area end -->
		<article class="tap_area">
		<section class="search_table">
            <!-- search_table start -->
            <!------------------------------------------------------------------------------
              Billing Address - Form ID(billAddrForm)
            ------------------------------------------------------------------------------->
            <section id="sctBillAddr">
              <input id="hiddenBillAddId" name="custAddId" type="hidden" />
              <input id="hiddenBillStreetId" name="hiddenBillStreetId" type="hidden" />

              <aside class="title_line">
                <!-- title_line start -->
                <h3><spring:message code="sal.title.billingAddress" /></h3>
              </aside>
              <!-- title_line end -->

              <ul class="right_btns mb10">
                <%-- <li>
                  <p class="btn_grid">
                    <a id="billSelAddrBtn" href="#"><spring:message code="supplement.btn.selectAnotherAddress" /></a>
                  </p>
                </li>
                <li>
                  <p class="btn_grid">
                    <a id="billNewAddrBtn" href="#"><spring:message code="supplement.btn.addNewAddress" /></a>
                  </p>
                </li> --%>
              </ul>

              <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                  <col style="width: 40%" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.addressDetail" /><span class="must">**</span></th>
                    <td>
                      <input id="billAddrDtl" name="billAddrDtl" type="text" title="" placeholder="eg. NO 10/UNIT 13-02-05/LOT 33945" class="w100p readonly" readonly  style="display:none"/>
                      <table id="pBillAddrDtl" style="display:none">
                          <tr>
                             <td><span id="span_BILLADDRDTL"></span></td>
                           </tr>
                         </table>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.street" /></th>
                    <td>
                      <span id="billStreet" name="billStreet"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.area" /><span class="must">**</span></th>
                    <td>
                      <span id="billArea" name="billArea"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.city" /><span class="must">**</span></th>
                    <td>
                      <span id="billCity" name="billCity"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.postCode" /><span class="must">**</span></th>
                    <td>
                      <span id="billPostCode" name="billPostCode"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.state" /><span class="must">**</span></th>
                    <td>
                      <span id="billState" name="billState"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.country" /><span class="must">**</span></th>
                    <td>
                      <span id="billCountry" name="billCountry"></span>
                    </td>
                  </tr>
                </tbody>
              </table>
              <!-- table end -->
              <!-- Existing Type end -->
            </section>
              </section>
		</article>
		<article class="tap_area">
		<section class="search_table">
            <!-- search_table start -->
            <aside class="title_line">
              <!-- title_line start -->
              <h3><spring:message code="supplement.text.supplementInfo" /></h3>
            </aside>
            <!-- title_line end -->
            <table class="type1">
              <!-- table start -->
              <caption>table</caption>
              <colgroup>
                <col style="width: 40%" />
                <col style="width: *" />
              </colgroup>
              <tr>
                  <th scope="row"><spring:message code="sal.text.salManCode" /><span class="must">*</span></th>
                  <td>
                    <input id="salesmanCd" name="salesmanCd" type="text" style="width: 230px;" title="" placeholder="" class="" disabled="disabled"/>
                    <a id="memBtn" href="#" class="search_btn">
                      <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                    </a>
                    </td>
                   <td>
                    <p>
                      <input id="salesmanNm" name="salesmanNm" type="text" style="width: 250px;" class="" title="" placeholder="Salesman Name" disabled="disabled">
                    </p>
                  </td>
                </tr>
				<tr>
				<th scope="row"><spring:message code="supplement.text.submissionBranch"/></th>
				<td colspan="2">
                      <span id="salesmanBrnch" name="salesmanBrnch"></span>
                    </td>
				</tr>
				<tr>
    				<th scope="row"><spring:message code="sal.title.remark" /></th>
    				<td colspan="2">
        			<!-- <input type="text" title="" placeholder="" class="w100p" id="_remark" name="_remark" maxlength = "50" /> -->
        			<textarea id="remark" name="remark" cols="20" rows="5" disabled="disabled"></textarea>
    				</td>
				</tr>
              </table>
              <aside class="title_line"><!-- title_line start -->
				<h2><spring:message code="sal.title.text.purchItems" /></h2>
			  </aside><!-- title_line end -->

			<ul class="right_btns">
<%--     		<li><p class="btn_grid"><a id="_addBtn"><spring:message code="supplement.btn.addItemSelection" /></a></p></li>
    		<li><p class="btn_grid"><a id="_delBtn"><spring:message code="sal.btn.del" /></a></p></li> --%>
			</ul>

			<article class="grid_wrap"><!-- grid_wrap start -->
				<div id="item_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
			</article><!-- grid_wrap end -->


              </section>
		</article>
		<article class="tap_area">
		<section class="search_table">
            <!-- search_table start -->
            <aside class="title_line">
              <!-- title_line start -->
              <h3><spring:message code="sal.text.attachment" /></h3>
            </aside>
            <!-- title_line end -->
                     <table class="type1">
            <!-- table start -->
            <caption>table</caption>
            <colgroup>
              <col style="width: 30%" />
              <col style="width: *" />
            </colgroup>
            <tbody>
              <tr>
                <th scope="row"><spring:message code="supplement.text.eSofForm" /><span class="must">**</span></th>
                <td>
                  <div class="auto_file2">
                    <input type="file" title="file add" id="sofFile" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                    <label>
                      <input type='text' class='input_text' readonly='readonly' id='sofFileTxt'/>
                      <!-- <span class='label_text'><a href='#'>Upload</a></span> -->
                    </label>
                  </div>
                </td>
              </tr>

              <tr>
                <th scope="row"><spring:message code="supplement.text.photocopyOfNric" /><span class="must">**</span></th>
                <td>
                  <div class="auto_file2">
                    <input type="file" title="file add" id="nricFile" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                    <label>
                      <input type='text' class='input_text' readonly='readonly' id='nricFileTxt'/>
                        <!-- <span class='label_text'>
                          <a href='#'>Upload</a></span> <span class='label_text'></span> -->
                    </label>
                  </div>
                </td>
              </tr>

              <tr>
                <th scope="row"><spring:message code="supplement.text.other" />1</th>
                <td>
                  <div class="auto_file2">
                    <input type="file" title="file add" id="otherFile" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                    <label>
                      <input type='text' class='input_text' readonly='readonly' id='otherFileTxt'/>
                      <!-- <span class='label_text'>
                      <a href='#'>Upload</a></span>
                      <span class='label_text'>
                        <a href='#' onclick='fn_removeFile("OTH")'>Remove</a>
                      </span> -->
                    </label>
                  </div>
                </td>
              </tr>

              <tr>
                <th scope="row"><spring:message code="supplement.text.other" />2</th>
                <td>
                  <div class="auto_file2">
                    <input type="file" title="file add" id="otherFile2" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                    <label>
                      <input type='text' class='input_text' readonly='readonly' id='otherFileTxt2'/>
                      <!-- <span class='label_text'>
                        <a href='#'>Upload</a>
                      </span>
                      <span class='label_text'>
                        <a href='#' onclick='fn_removeFile("OTH2")'>Remove</a>
                      </span> -->
                    </label>
                  </div>
                </td>
              </tr>

               <tr>
                <th scope="row"><spring:message code="supplement.text.other" />3</th>
                <td>
                  <div class="auto_file2">
                    <input type="file" title="file add" id="otherFile3" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                    <label>
                      <input type='text' class='input_text' readonly='readonly' id='otherFileTxt3'/>
                      <!-- <span class='label_text'>
                        <a href='#'>Upload</a>
                      </span>
                      <span class='label_text'>
                        <a href='#' onclick='fn_removeFile("OTH3")'>Remove</a>
                      </span> -->
                    </label>
                  </div>
                </td>
              </tr>

              <tr>
                <th scope="row"><spring:message code="supplement.text.other" />4</th>
                <td>
                  <div class="auto_file2">
                    <input type="file" title="file add" id="otherFile4" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                    <label>
                      <input type='text' class='input_text' readonly='readonly' id='otherFileTxt4'/>
                      <!-- <span class='label_text'>
                        <a href='#'>Upload</a>
                      </span>
                      <span class='label_text'>
                        <a href='#' onclick='fn_removeFile("OTH4")'>Remove</a>
                      </span> -->
                    </label>
                  </div>
                </td>
              </tr>

              <tr>
                <th scope="row"><spring:message code="supplement.text.other" />5</th>
                <td>
                  <div class="auto_file2">
                    <input type="file" title="file add" id="otherFile5" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                    <label>
                      <input type='text' class='input_text' readonly='readonly' id='otherFileTxt5'/>
                      <!-- <span class='label_text'>
                        <a href='#'>Upload</a>
                      </span>
                      <span class='label_text'>
                        <a href='#' onclick='fn_removeFile("OTH5")'>Remove</a>
                      </span> -->
                    </label>
                  </div>
                </td>
              </tr>
              <tr>
                <td colspan=2>
                  <span class="red_text"><spring:message code="supplement.text.picFormatNotice" />
                </span></td>
              </tr>
            </tbody>
          </table>
              </section>
		</article>
        <!-- tap_area end -->
      </section>
      <!-- tap_wrap end -->
    </section>
    <!------------------------------------------------------------------------------
      Supplement Submission Content END
    ------------------------------------------------------------------------------->
      <section id="scSubmissionApproval">
              <aside class="title_line">
                <!-- title_line start -->
                <h3><spring:message code="supplement.text.submissionApproval" /></h3>
              </aside>
              <!-- title_line end -->

              <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                  <col style="width: 40%" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
				<tr>
				<th scope="row"><spring:message code="supplement.text.submissionStatus"/><span class="must">**</span></th>
				<td>
                   <select id="subApprovalStatus" name="subApprovalStatus" class="w100p"></select>
                </td>
				</tr>
				<tr>
    				<th scope="row"><spring:message code="sal.title.remark" /></th>
    				<td colspan="2">
        			<!-- <input type="text" title="" placeholder="" class="w100p" id="_remark" name="_remark" maxlength = "50" /> -->
        			<textarea id="subApprovalRemark" name="subApprovalRemark" cols="20" rows="5"></textarea>
    				</td>
				</tr>
                </tbody>
              </table>
              <!-- table end -->
              <ul class="center_btns mt20">
        <li>
          <p class="btn_blue2 big">
            <a id="btnSaveApproval" href="#"><spring:message code="sys.btn.save" /></a>
          </p>
        </li>
      </ul>
  </section>
		<ul class="center_btns mt20">
        	<li>
          <p class="btn_blue2 big">
            <a id="btnSaveCancel" href="#"><spring:message code="sales.btn.CtoC" /></a>
          </p>
			</li>
      	</ul>
  </section>
  <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
