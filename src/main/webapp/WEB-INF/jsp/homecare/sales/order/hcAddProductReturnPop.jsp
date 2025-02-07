<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style>
#sirimNo {background:#f2f2f2 ; cursor:no-drop;}
#serialNo {background:#f2f2f2; cursor:no-drop;}
#serialNo2 {background:#f2f2f2; cursor:no-drop;}

</style>

<script type="text/javaScript">
    var _vTagNum = '';

	$(document).ready(function() {
	    var myGridID_view;

        doGetCombo('/homecare/sales/order/getPartnerMemInfo.do?ORDER_NO='+ '${installResult.salesOrdNo}', 0, '', 'partnerCode', 'S', ''); //DDL PARTNER CODE

	    createInstallationViewAUIGrid();
	    fn_viewInstallResultSearch();

	    var callType = "${callType.typeId}";
	    if(callType == 0) {
	        $(".red_text").text( "<spring:message code='service.msg.InstallationInformation'/>");
	    } else {
	        if("${orderInfo.c9}" == 21) {
	            $(".red_text").text( "<spring:message code='service.msg.InstallationStatus'/>");
	        } else if("${orderInfo.c9}" == 4) {
	        	$(".red_text").text( "<spring:message code='service.msg.InstallationCompleted'/>");
	        }
	    }

	    if("${stock}"  != null) {
	    	$("#hidActualCTMemCode").val("${stock.memCode}");
	    	$("#hidActualCTId").val("${stock.movToLocId}");

	    } else {
	    	$("#hidActualCTMemCode").val("0");
	        $("#hidActualCTId").val("0");
	    }

	    if("${orderInfo.installEntryId}" != null) {
	    	$("#hidCategoryId").val("${orderInfo.stkCtgryId}");

	    	if(callType == 258) {
	    		$("#hidPromotionId").val("${orderInfo.c8}");
	    		$("#hidPriceId").val("${orderInfo.c11}");
	    		$("#hiddenOriPriceId").val("${orderInfo.c11}");
	    		$("#hiddenOriPrice").val("${orderInfo.c12}");
	    		$("#hiddenOriPV").val("${orderInfo.c13}");
	    		$("#hiddenProductItem").val("${orderInfo.c7}");
	    		$("#hidPERentAmt").val("${orderInfo.c17}");
	    		$("#hidPEDefRentAmt").val("${orderInfo.c18}");
	    		$("#hidInstallStatusCodeId").val("${orderInfo.c19}");
	    		$("#hidPEPreviousStatus").val("${orderInfo.c20}");
	    		$("#hidDocId").val("${orderInfo.docId}");
	    		$("#hidOldPrice").val("${orderInfo.c15}");
	    		$("#hidExchangeAppTypeId").val("${orderInfo.c21}");

	    	} else {
	    		$("#hidPromotionId").val("${orderInfo.c2 }");
	    		$("#hidPriceId").val("${orderInfo.itmPrcId}");
	    		$("#hiddenOriPriceId").val("${orderInfo.itmPrcId}");
	    		$("#hiddenOriPrice").val("${orderInfo.c5}");
	    		$("#hiddenOriPV").val("${orderInfo.c6}");
	    		$("#hiddenCatogory").val("${orderInfo.codename1}");
	    		$("#hiddenProductItem").val("${orderInfo.stkDesc}");
	    		$("#hidPERentAmt").val("${orderInfo.c7}");
	    		$("#hidPEDefRentAmt").val("${orderInfo.c8}");
	    		$("#hidInstallStatusCodeId").val("${orderInfo.c9}");
	    	}

	    }
	    $("#hiddenCustomerType").val("${customerContractInfo.typeId}");
	    $("#checkCommission").prop("checked",true);
	    $("#addInstallForm #partnerCode").prop("readonly" , false);
	    $("#addInstallForm #partnerCode").attr("disabled", false);

	    $("#addInstallForm #installStatus").change(function () {
	        if($("#addInstallForm #installStatus").val() == 4) {
	                $("#checkCommission").prop("checked",true);
	                $("#addInstallForm #installDate").prop("readonly" , false);
	                $("#addInstallForm #installDate").attr("class" , "j_date w100p hasDatepicker");
	                $("#addInstallForm #installDate").attr("placeholder" , "DD/MM/YYYY");
	                $("#addInstallForm #partnerCode").prop("readonly" , false);
	                $("#addInstallForm #partnerCode").attr("disabled", false);
	        } else {
	            $("#checkCommission").prop("checked",false);
	            $("#addInstallForm #installDate").val("");
	            $("#addInstallForm #installDate").prop("readonly" , true);
	            $("#addInstallForm #installDate").attr("readonly" , true);
	            $("#addInstallForm #installDate").attr("class" , "disabled");
	            $("#addInstallForm #installDate").attr("placeholder" , "only complete case");
	            $("#addInstallForm #partnerCode").prop("readonly" , true);
	            $("#addInstallForm #partnerCode").attr("disabled", true);
	        }
	    });

	    $("#installDate").change(function(){
	        var checkMon =   $("#installDate").val();

	        Common.ajax("GET", "/services/checkMonth.do?intallDate=" + checkMon, ' ', function(result) {
	             if(result.code == "99") { // fail
	                 Common.alert(result.message);
	                 $("#installDate").val('');
	             }
	        });
	    });
	});

	// Save Product Return Result - Button Click
	function fn_saveInstall() {
	    if($("#addInstallForm #installStatus").val() == 4) {   // Completed
	        if($("#failReason").val() != 0 || $("#nextCallDate").val() != '') {
				Common.alert("Not allowed to choose a reason for fail or recall date in complete status");
				return;
			}
			if ($("#addInstallForm #installDate").val() == '' ||  $("#addInstallForm #custRelationship").val() == '' || $("#addInstallForm #custName").val() == '' || $("#addInstallForm #partnerCode").val() == 0) {
				Common.alert("Please insert 'Actual Product Return Date', 'Acctance Name',  'Acctance Relationship', 'Pairing Code' <br/>in complete status");
	            return;
	        }
		 }

		if($("#addInstallForm #installStatus").val() == 21) {  // Failed
            if( $("#failReason").val() == 0 || $("#nextCallDate").val() == '' ){
		        Common.alert("Please insert 'Failed Reason', 'Next Call Date'<br/>in fail status");
		        return;
		    }
		    if ( $("#addInstallForm #installDate").val() != ''  || $("#addInstallForm #custName").val() != '' ) {
		        Common.alert("Not allowed to choose 'Actual Product Return Date', 'Acctance Name' <br/>in fail status");
		        return;
		    }
		}
			if( $("#serialRequireChkYn").val() == "N" ){

			    /* Common.ajax("POST", "/sales/order/addProductReturn.do", $("#addInstallForm").serializeJSON(), function(result) {
			        Common.alert(result.message,fn_saveclose);
			    }); */
				Common.alert("Can't return the product. Check the serial RequireYN.");
	            return;
			} else {
			    var pRetnNo = AUIGrid.getCellValue(myGridID_view, 0, "retnNo");
			    $("#addInstallForm #hidRefDocNo").val(pRetnNo); // Retn No

		    	Common.ajax("POST", "/homecare/sales/order/hcAddProductReturnSerial.do", $("#addInstallForm").serializeJSON(), function(result) {
		            Common.alert(result.message, fn_saveclose);
		        });
			}
		}


	function fn_saveclose(){
		addInstallationPopupId.remove();
		fn_orderCancelListAjax();
	}

	function fn_viewInstallResultSearch(){
	    var jsonObj = {
	        salesOrdNo : $("#hidTaxInvDSalesOrderNo").val()
        };
	    Common.ajax("GET", "/sales/order/viewProductReturnSearch.do", jsonObj, function(result) {
	        AUIGrid.setGridData(myGridID_view, result);

	        if(result != null) {
	    	   if(result.length > 0) {
	    		   $("#serialRequireChkYn").val(result[0].serialRequireChkYn);

	    		   if($("#serialRequireChkYn").val() == "Y") {
	    			   $("#btnSerialEdit").attr("style", "");
	    			   $("#btnSerialEdit2").attr("style", "");
	    		   }
	    	   }
	       }
	   });
	}

    // 시리얼 수정 팝업 호출
    function fn_serialChangePop(_tagNum) {
    	_vTagNum = _tagNum;

    	if(_tagNum == '1') {   // Mattress
    		$("#serialNoChangeForm #pSerialNo").val($("#serialNo").val()); // Serial No
            $("#serialNoChangeForm #pSalesOrdId").val($("#hidSalesOrderId").val()); // 주문 ID
            $("#serialNoChangeForm #pSalesOrdNo").val($("#salesOrdNo").val()); // 주문 번호
            $("#serialNoChangeForm #pRefDocNo").val(AUIGrid.getCellValue(myGridID_view, 0, "retnNo")); // Retn No
            $("#serialNoChangeForm #pItmCode").val($("#stkCode").val()); // 제품 ID

    	} else {  // Frame
    		$("#serialNoChangeForm #pSerialNo").val($("#serialNo2").val()); // Serial No
            $("#serialNoChangeForm #pSalesOrdId").val($("#hidSalesOrderId2").val()); // 주문 ID
            $("#serialNoChangeForm #pSalesOrdNo").val($("#salesOrdNo2").val()); // 주문 번호
            $("#serialNoChangeForm #pRefDocNo").val($("#retnNo2").val()); // Retn No
            $("#serialNoChangeForm #pItmCode").val($("#stkCode2").val()); // 제품 ID
    	}

	    $("#serialNoChangeForm #pCallGbn").val("RETURN");
	    $("#serialNoChangeForm #pMobileYn").val("N");

	    if(Common.checkPlatformType() == "mobile") {
	        popupObj = Common.popupWin("inBoundInForm", "/logistics/serialChange/serialNoChangePop.do", {width : "1000px", height : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
	    } else {
	        Common.popupDiv("/logistics/serialChange/serialNoChangePop.do", $("#serialNoChangeForm").serializeJSON(), null, true, '_serialNoChangePop');
	    }
	}

	// 모바일에서 호출시 닫기 이벤트
	function fn_PopSerialChangeClose(){
	    if(popupObj!=null) popupObj.close();

	    if(_vTagNum == '1') {
	    	$("#addInstallForm #asIsSerialNo").val( obj.asIsSerialNo );
	        $("#addInstallForm #beforeSerialNo").val( obj.beforeSerialNo );
	        $("#addInstallForm #serialNo").val( obj.asIsSerialNo );

	    } else {
	    	$("#addInstallForm #asIsSerialNo2").val( obj.asIsSerialNo );
	        $("#addInstallForm #beforeSerialNo2").val( obj.beforeSerialNo );
	        $("#addInstallForm #serialNo2").val( obj.asIsSerialNo );
	    }

	    fn_viewInstallResultSearch(); //조회
	}

	// 팝업에서 호출하는 조회 함수
	function SearchListAjax(obj){
		if(_vTagNum == '1') {
            $("#addInstallForm #asIsSerialNo").val( obj.asIsSerialNo );
            $("#addInstallForm #beforeSerialNo").val( obj.beforeSerialNo );
            $("#addInstallForm #serialNo").val( obj.asIsSerialNo );

        } else {
            $("#addInstallForm #asIsSerialNo2").val( obj.asIsSerialNo );
            $("#addInstallForm #beforeSerialNo2").val( obj.beforeSerialNo );
            $("#addInstallForm #serialNo2").val( obj.asIsSerialNo );
        }

		fn_viewInstallResultSearch(); //조회
	}

	function createInstallationViewAUIGrid() {
	    //AUIGrid 칼럼 설정
	    var columnLayout = [
            {dataField : "retnNo",                  headerText : 'ReturnNum',                                                         width : 130},
            {dataField : "code",                    headerText : '<spring:message code="service.grid.Status" />',        width : 180},
            {dataField : "reqstDt",                 headerText : 'Return Date',                                                        width : 180},
            {dataField : "memCode",                 headerText : 'DT Code',      width : 250},
            {dataField : "name",                    headerText : 'DT Name',     width : 180},
            {dataField : "partnerCode",             headerText : 'Partner Code',      width : 250},
            {dataField : "partnerCodeName",         headerText : 'Partner Name',     width : 180},
            {dataField : "serialRequireChkYn",      headerText : 'SERIAL_REQUIRE_CHK_YN', width : 0}
        ];

	    // 그리드 속성 설정
        var gridPros = {
	        // 페이징 사용
	        usePaging : true,
	        // 한 화면에 출력되는 행 개수 20(기본값:20)
	        pageRowCount : 20,
	        editable : false,
	        showStateColumn : true,
	        displayTreeOpen : true,
	        headerHeight : 30,
	        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	        skipReadonlyColumns : true,
	        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	        wrapSelectionMove : true,
	        // 줄번호 칼럼 렌더러 출력
	        showRowNumColumn : false
	    };

	    myGridID_view = AUIGrid.create("#grid_wrap_view", columnLayout, gridPros);
	}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
	<h1>Product Return Result</h1>
	<ul class="right_opt">
	    <li><p class="btn_blue2"><a href="#"><spring:message code='expense.CLOSE'/></a></p></li>
	</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
	<section class="tap_wrap"><!-- tap_wrap start -->
		<ul class="tap_type1">
		    <li><a href="#" class="on"><spring:message code='sales.tap.order'/></a></li>
		    <li><a href="#"><spring:message code='sales.tap.customerInfo'/></a></li>
		    <li><a href="#"><spring:message code='sales.tap.installationInfo'/></a></li>
		    <li><a href="#"><spring:message code='sales.tap.HPInfo'/></a></li>
		</ul>
		<article class="tap_area"><!-- tap_area start -->
			<aside class="title_line"><!-- title_line start -->
			<h2>Order Information</h2>
			</aside><!-- title_line end -->

			<input type="hidden" value="<c:out value="${installResult.installEntryId}"/>" id="installEntryId" name="installEntryId"/>
			<input type="hidden"  id="serialRequireChkYn" name="serialRequireChkYn"/>
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:150px" />
				    <col style="width:*" />
				    <col style="width:120px" />
				    <col style="width:*" />
				    <col style="width:150px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row"><spring:message code='service.title.Type'/></th>
					    <td><span>Product Return Result Add</span></td>
					    <th scope="row"><spring:message code='service.title.InstallNo'/></th>
					    <td><span><c:out value="${installResult.installEntryNo}"/></span></td>
					    <th scope="row"><spring:message code='service.title.OrderNo'/></th>
					    <td>
					        <input type="hidden" id="salesOrdNo" name="salesOrdNo" value="${installResult.salesOrdNo}" />
                            <span><c:out value="${installResult.salesOrdNo}"/></span>
					    </td>
					</tr>
					<tr>
					    <th scope="row"><spring:message code='service.title.RefNo'/></th>
					    <td><span><c:out value="${installResult.refNo}"/></span></td>
					    <th scope="row"><spring:message code='service.title.OrderDate'/></th>
					    <td><span><c:out value="${installResult.salesDt}"/></span></td>
					    <th scope="row"><spring:message code='service.title.ApplicationType'/></th>
					    <c:if test="${installResult.codeid1  == '257' }">
					        <td><span><c:out value="${orderInfo.codeName}"/></span></td>
					    </c:if>
					    <c:if test="${installResult.codeid1  == '258' }">
					        <td><span><c:out value="${orderInfo.c5}"/></span></td>
					    </c:if>
					</tr>
					<tr>
					    <th scope="row"><spring:message code='service.title.Remark'/></th>
					    <td colspan="5"><span><c:out value="${orderInfo.rem}"/></span></td>
					</tr>
					<tr>
					    <th scope="row"><spring:message code='service.title.LastUpdatedBy'/></th>
					    <td><span><c:out value="${installResult.userName}"/></span></td>
					    <th scope="row">Product</th>
					    <c:if test="${installResult.codeid1  == '257' }">
					        <td>
					            <input type="hidden" id="stkCode" name="stkCode" value="${orderInfo.stkCode}" />
					            <span><c:out value="${orderInfo.stkCode} - ${orderInfo.stkDesc} " /></span>
					        </td>
					    </c:if>
					    <c:if test="${installResult.codeid1  == '258' }">
					        <td>
					            <input type="hidden" id="stkCode" name="stkCode" value="${orderInfo.c6}" />
					            <span><c:out value="${orderInfo.c6} - ${orderInfo.c7} " /></span>
					        </td>
					    </c:if>
					    <th scope="row"><spring:message code='service.title.Promotion'/></th>
					    <c:if test="${installResult.codeid1  == '257' }">
					        <td><span><c:out value="${orderInfo.c3} - ${orderInfo.c4} " /></span></td>
					    </c:if>
					    <c:if test="${installResult.codeid1  == '258' }">
					         <td><span><c:out value="${orderInfo.c9} - ${orderInfo.c10} " /></span></td>
					    </c:if>
					</tr>
					<tr>
					    <th scope="row"><spring:message code='service.title.Price'/></th>
					    <c:if test="${installResult.codeid1  == '257' }">
					        <td><span><c:out value="${orderInfo.c5}"/></span></td>
					    </c:if>
					    <c:if test="${installResult.codeid1  == '258' }">
					        <td><span><c:out value="${orderInfo.c12}"/></span></td>
					    </c:if>
					    <th scope="row"><spring:message code='service.title.PV'/></th>
					    <c:if test="${installResult.codeid1  == '257' }">
					        <td><span><c:out value="${orderInfo.c6}"/></span></td>
					    </c:if>
					    <c:if test="${installResult.codeid1  == '258' }">
					        <td><span><c:out value="${orderInfo.c13}"/></span></td>
					    </c:if>
					    <th scope="row"></th>
					    <td></td>
					</tr>
				</tbody>
			</table><!-- table end -->
		</article><!-- tap_area end -->

		<article class="tap_area"><!-- tap_area start -->
			<aside class="title_line"><!-- title_line start -->
			<h2><spring:message code='service.title.CustomerInformation'/></h2>
			</aside><!-- title_line end -->
            <!-- table start -->
			<table class="type1">
				<caption>table</caption>
				<colgroup>
				    <col style="width:150px" />
				    <col style="width:*" />
				    <col style="width:140px" />
				    <col style="width:*" />
				    <col style="width:130px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row"><spring:message code='service.title.CustomerName'/></th>
					    <td><span><c:out value="${customerInfo.name}"/></span></td>
					    <th scope="row"><spring:message code='service.title.CustomerNRIC'/></th>
					    <td><span><c:out value="${customerInfo.nric}"/></span></td>
					    <th scope="row"><spring:message code='service.title.Gender'/></th>
					    <td><span><c:out value="${customerInfo.gender}"/></span></td>
					</tr>
					<tr>
					    <th scope="row" rowspan="4"><spring:message code='service.title.MailingAddress'/></th>
					    <td colspan="5"><span></span></td>
					</tr>
					<tr>
					    <td colspan="5"><span></span></td>
					</tr>
					<tr>
					    <td colspan="5"><span></span></td>
					</tr>
					<tr>
					    <td colspan="5"><span></span></td>
					</tr>
					<tr>
					    <th scope="row"><spring:message code='service.title.ContactPerson'/></th>
					    <td><span><c:out value="${customerContractInfo.name}"/></span></td>
					    <th scope="row"><spring:message code='service.title.Gender'/></th>
					    <td><span><c:out value="${customerContractInfo.gender}"/></span></td>
					    <th scope="row"><spring:message code='service.title.ResidenceNo'/></th>
					    <td><span><c:out value="${customerContractInfo.telR}"/></span></td>
					</tr>
					<tr>
					    <th scope="row"><spring:message code='service.title.MobileNo'/></th>
					    <td><span><c:out value="${customerContractInfo.telM1}"/></span></td>
					    <th scope="row"><spring:message code='service.title.OfficeNo'/></th>
					    <td><span><c:out value="${customerContractInfo.telO}"/></span></td>
					    <th scope="row"><spring:message code='service.title.OfficeNo'/></th>
					    <td><span><c:out value="${customerContractInfo.telF}"/></span></td>
					</tr>
				</tbody>
			</table><!-- table end -->
		</article><!-- tap_area end -->
        <!-- tap_area start -->
		<article class="tap_area">
			<aside class="title_line"><!-- title_line start -->
			<h2><spring:message code='service.title.InstallationInformation'/></h2>
			</aside><!-- title_line end -->
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:150px" />
				    <col style="width:*" />
				    <col style="width:130px" />
				    <col style="width:*" />
				    <col style="width:130px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row"><spring:message code='service.title.RequestInstallDate'/></th>
					    <td><span><c:out value="${installResult.c1}"/></span></td>
					    <th scope="row"><spring:message code='service.title.AssignedCT'/></th>
					    <td colspan="3"><span><c:out value="(${stock.memCode}) ${stock.name}"/></span></td>
					</tr>
					    <th scope="row" rowspan="4"><spring:message code='service.title.InstallationAddress'/></th>
					    <td colspan="5"><span><c:out value="${installation.Address}"/></span></td>
					</tr>
					<tr>
					    <td colspan="5"><span></span></td>
					</tr>
					<tr>
					    <td colspan="5"><span></span></td>
					</tr>
					<tr>
					    <td colspan="5"><span></span></td>
					</tr>
					<tr>
					    <th scope="row"><spring:message code='service.title.SpecialInstruction'/></th>
					    <td><span><c:out value="${installation.instct}"/> </span></td>
					    <th scope="row"><spring:message code='service.title.PreferredDate'/></th>
					    <td></td>
					    <th scope="row"><spring:message code='service.title.PreferredTime'/></th>
					    <td></td>
					</tr>
				</tbody>
			</table><!-- table end -->

			<aside class="title_line"><!-- title_line start -->
			<h2><spring:message code='service.title.InstallationContactPerson'/></h2>
			</aside><!-- title_line end -->
            <!-- table start -->
			<table class="type1">
				<caption>table</caption>
				<colgroup>
				    <col style="width:150px" />
				    <col style="width:*" />
				    <col style="width:130px" />
				    <col style="width:*" />
				    <col style="width:130px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row"><spring:message code='service.title.Name'/></th>
					    <td><span><c:out value="${installationContract.name}"/></span></td>
					    <th scope="row"><spring:message code='service.title.Gender'/></th>
					    <td></td>
					    <th scope="row"><spring:message code='service.title.ResidenceNo'/></th>
					    <td><span><c:out value="${installationContract.telR}"/></span></td>
					</tr>
					<tr>
					    <th scope="row"><spring:message code='service.title.MobileNo'/></th>
					    <td><span><c:out value="${installationContract.telM1}"/></span></td>
					    <th scope="row"><spring:message code='service.title.OfficeNo'/></th>
					    <td><span><c:out value="${installationContract.telO}"/></span></td>
					    <th scope="row"><spring:message code='service.title.FaxNo'/></th>
					    <td><span><c:out value="${installationContract.telF}"/></span></td>
					</tr>
				</tbody>
			</table><!-- table end -->
		</article>
        <!-- tap_area end -->

        <!-- tap_area start -->
		<article class="tap_area">
	        <!-- title_line start -->
			<aside class="title_line">
			<h2><spring:message code='service.title.HPInformation'/></h2>
			</aside><!-- title_line end -->
            <!-- table start -->
			<table class="type1">
				<caption>table</caption>
				<colgroup>
				    <col style="width:150px" />
				    <col style="width:*" />
				    <col style="width:135px" />
				    <col style="width:*" />
				    <col style="width:130px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row"><spring:message code='service.title.HP_CodyCode'/></th>
					    <td><span><c:out value="${hpMember.memCode}"/></span></td>
					    <th scope="row"><spring:message code='service.title.HP_CodyName'/></th>
					    <td><span><c:out value="${hpMember.name1}"/></span></td>
					    <th scope="row"><spring:message code='service.title.HP_CodyNRIC'/></th>
					    <td><span><c:out value="${hpMember.nric}"/></span></td>
					</tr>
					<tr>
					    <th scope="row"><spring:message code='service.title.MobileNo'/></th>
					    <td><span><c:out value="${hpMember.telMobile}"/></span></td>
					    <th scope="row"><spring:message code='sales.HouseNo'/></th>
					    <td><span><c:out value="${hpMember.telHuse}"/></span></td>
					    <th scope="row"><spring:message code='service.title.OfficeNo'/></th>
					    <td><span><c:out value="${hpMember.telOffice}"/></span></td>
					</tr>
					<tr>
					    <th scope="row"><spring:message code='service.title.DepartmentCode'/></th>
					    <td><span><c:out value="${salseOrder.deptCode}"/></span></td>
					    <th scope="row"><spring:message code='service.title.GroupCode'/></th>
					    <td><span><c:out value="${salseOrder.grpCode}"/></span></td>
					    <th scope="row"><spring:message code='service.title.OrganizationCode'/></th>
					    <td><span><c:out value="${salseOrder.orgCode}"/></span></td>
					</tr>
				</tbody>
			</table><!-- table end -->
		</article><!-- tap_area end -->
    </section><!-- tap_wrap end -->

<aside class="title_line mt30"><!-- title_line start -->
<h2>View Product Return Result</h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_view" style="width: 100%; height:200px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Add Product Return Result</h2>
</aside><!-- title_line end -->

<form id="serialNoChangeForm" name="serialNoChangeForm" method="POST">
    <input type="hidden" name="pSerialNo" id="pSerialNo"/>
    <input type="hidden" name="pSalesOrdId"  id="pSalesOrdId"/>
    <input type="hidden" name="pSalesOrdNo"  id="pSalesOrdNo"/>
    <input type="hidden" name="pRefDocNo" id="pRefDocNo"/>
    <input type="hidden" name="pItmCode" id="pItmCode"/>
    <input type="hidden" name="pCallGbn" id="pCallGbn"/>
    <input type="hidden" name="pMobileYn" id="pMobileYn"/>
</form>

<form action="#" id="addInstallForm" method="post">
	<input type="hidden" value="<c:out value="${installResult.installEntryId}"/>" id="installEntryId" name="installEntryId"/>
	<input type="hidden" value="${callType.typeId}" id="hidCallType" name="hidCallType"/>
	<input type="hidden" value="${installResult.installEntryId}" id="hidEntryId" name="hidEntryId"/>
	<input type="hidden" value="${installResult.custId}" id="hidCustomerId" name="hidCustomerId" />
	<input type="hidden" value="${installResult.salesOrdId}" id="hidSalesOrderId" name="hidSalesOrderId" />
	<input type="hidden" value="${installResult.sirimNo}" id="hidSirimNo" name="hidSirimNo" />
	<input type="hidden" value="${installResult.serialNo}" id="hidSerialNo" name="hidSerialNo" />
	<input type="hidden" value="${installResult.isSirim}" id="hidStockIsSirim" name="hidStockIsSirim" />
	<input type="hidden" value="${installResult.stkGrad}" id="hidStockGrade" name="hidStockGrade" />
	<input type="hidden" value="${installResult.stkCtgryId}" id="hidSirimTypeId" name="hidSirimTypeId" />
	<input type="hidden" value="${installResult.codeId}" id="hidAppTypeId" name="hidAppTypeId" />
	<input type="hidden" value="${installResult.installStkId}" id="hidProductId" name="hidProductId" />
	<input type="hidden" value="${installResult.custAddId}" id="hidCustAddressId" name="hidCustAddressId" />
	<input type="hidden" value="${installResult.custCntId}" id="hidCustContactId" name="hidCustContactId" />
	<input type="hidden" value="${installResult.custBillId}" id="hiddenBillId" name="hiddenBillId" />
	<input type="hidden" value="${installResult.codeName}" id="hiddenCustomerPayMode" name="hiddenCustomerPayMode" />
	<input type="hidden" value="${installResult.installEntryNo}" id="hiddeninstallEntryNo" name="hiddeninstallEntryNo" />
	<input type="hidden" value="" id="hidActualCTMemCode" name="hidActualCTMemCode" />
	<input type="hidden" value="" id="hidActualCTId" name="hidActualCTId" />
	<input type="hidden" value="${sirimLoc.whLocCode}" id="hidSirimLoc" name="hidSirimLoc" />
	<input type="hidden" value="" id="hidCategoryId" name="hidCategoryId" />
	<input type="hidden" value="" id="hidPromotionId" name="hidPromotionId" />
	<input type="hidden" value="" id="hidPriceId" name="hidPriceId" />
	<input type="hidden" value="" id="hiddenOriPriceId" name="hiddenOriPriceId" />
	<input type="hidden" value="${orderInfo.c5}" id="hiddenOriPrice" name="hiddenOriPrice" />
	<input type="hidden" value="" id="hiddenOriPV" name="hiddenOriPV" />
	<input type="hidden" value="" id="hiddenCatogory" name="hiddenCatogory" />
	<input type="hidden" value="" id="hiddenProductItem" name="hiddenProductItem" />
	<input type="hidden" value="" id="hidPERentAmt" name="hidPERentAmt" />
	<input type="hidden" value="" id="hidPEDefRentAmt" name="hidPEDefRentAmt" />
	<input type="hidden" value="" id="hidInstallStatusCodeId" name="hidInstallStatusCodeId" />
	<input type="hidden" value="" id="hidPEPreviousStatus" name="hidPEPreviousStatus" />
	<input type="hidden" value="" id="hidDocId" name="hidDocId" />
	<input type="hidden" value="" id="hidOldPrice" name="hidOldPrice" />
	<input type="hidden" value="" id="hidExchangeAppTypeId" name="hidExchangeAppTypeId" />
	<input type="hidden" value="" id="hiddenCustomerType" name="hiddenCustomerType" />
	<input type="hidden" value="" id="hiddenPostCode" name="hiddenPostCode" />
	<input type="hidden" value="" id="hiddenCountryName" name="hiddenCountryName" />
	<input type="hidden" value="" id="hiddenStateName" name="hiddenStateName" />
	<input type="hidden" value="${promotionView.promoId}" id="hidPromoId" name="hidPromoId" />
	<input type="hidden" value="${promotionView.promoPrice}" id="hidPromoPrice" name="hidPromoPrice" />
	<input type="hidden" value="${promotionView.promoPV}" id="hidPromoPV" name="hidPromoPV" />
	<input type="hidden" value="${promotionView.swapPromoId}" id="hidSwapPromoId" name="hidSwapPromoId" />
	<input type="hidden" value="${promotionView.swapPormoPrice}" id="hidSwapPromoPrice" name="hidSwapPromoPrice" />
	<input type="hidden" value="${promotionView.swapPromoPV}" id="hidSwapPromoPV" name="hidSwapPromoPV" />
	<input type="hidden" value="" id="hiddenInstallPostcode" name="hiddenInstallPostcode" />
	<input type="hidden" value="" id="hiddenInstallStateName" name="hiddenInstallStateName" />

	<input type="hidden" value="${customerInfo.name}" id="hidCustomerName" name="hidCustomerName"  />
	<input type="hidden" value="${customerContractInfo.telM1}" id="hidCustomerContact" name="hidCustomerContact"  />
	<input type="hidden" value="${installResult.salesOrdNo}" id="hidTaxInvDSalesOrderNo" name="hidTaxInvDSalesOrderNo"  />
	<input type="hidden" value="${installResult.installEntryNo}" id="hidTradeLedger_InstallNo" name="hidTradeLedger_InstallNo"  />
	 <c:if test="${installResult.codeid1  == '257' }">
	      <input type="hidden" value="${orderInfo.c5}" id = "hidOutright_Price" name = "hidOutright_Price" />
	 </c:if>
	 <c:if test="${installResult.codeid1  == '258' }">
	<input type="hidden" value=" ${orderInfo.c12}" id = "hidOutright_Price" name = "hidOutright_Price" />
	 </c:if>
	 <input type="hidden" value="${installation.Address}" id="hidInstallation_AddDtl" name = "hidInstallation_AddDtl" />
	<input type="hidden" value="${installation.areaId}" id = "hidInstallation_AreaID" name = "hidInstallation_AreaID"/>
	<input type="hidden" value="${customerContractInfo.name}" id = "hidInatallation_ContactPerson" name = "hidInatallation_ContactPerson"/>
	<input type="hidden" value="${callEntryId}" id = "hicallEntryId" name = "callEntryId"/>

	<input type="hidden" value="" id="asIsSerialNo" name="asIsSerialNo"/>
	<input type="hidden" value="" id="beforeSerialNo" name="beforeSerialNo"/>
	<input type="hidden" value="" id="hidRefDocNo" name="hidRefDocNo"/>
	<input type="hidden" value="${homecareYn}" id="homecareYn" name="homecareYn"/>
	<input type="hidden" value="${orderHcInfo.anoOrdId}" id="hidSalesOrderId2" name="hidSalesOrderId2"/>
	<input type="hidden" value="${orderHcInfo.anoOrdNo}" id="salesOrdNo2" name="salesOrdNo2"/>
	<input type="hidden" value="${orderHcInfo.anoStkCode}" id="stkCode2" name="stkCode2"/>
	<input type="hidden" value="${orderHcInfo.anoRetnNo}" id="retnNo2" name="retnNo2"/>
	<input type="hidden" value="" id="asIsSerialNo2" name="asIsSerialNo2"/>
    <input type="hidden" value="" id="beforeSerialNo2" name="beforeSerialNo2"/>

	<!-- table start -->
	<table class="type1 mb1m">
		<caption>table</caption>
		<colgroup>
		    <col style="width:130px" />
		    <col style="width:350px" />
		    <col style="width:170px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
			<tr>
			    <th scope="row">PR Result</th>
			    <td>
				    <select class="w100p" id="installStatus" name="returnStatus">
				        <option value="4">Completed</option>
				        <option value="21">Failed</option>
				    </select>
			    </td>
			    <th scope="row">Actual PR Date</th>
			    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  id="installDate" name="returnDate"/></td>
			</tr>
			<tr>
			    <th scope="row">DT Code</th>
			    <td><input type="text" title="" value="<c:out value="(${pRCtInfo.memCode}) ${pRCtInfo.name}"/>" placeholder="" class="readonly" style="width:100%;" id="ctCode"  readonly="readonly" name="ctCode" />
			    <input type="hidden" title="" value="${pRCtInfo.memId}" placeholder="" class="" id="CTID" name="CTID" />
			    <th scope="row">Pairing Code<span id='m7' name='m7' class="must">*</span></th>
		        <td>
                    <select id='partnerCode' name='partnerCode' class="w100p"></select>
		        </td>
			</tr>
		</tbody>
	</table><!-- table end -->

	<table class="type1" id="completedHide"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:130px" />
		    <col style="width:130px" />
		    <col style="width:110px" />
		    <col style="width:110px" />
		    <col style="width:110px" />
		    <col style="width:*" />
		    <col style="width:110px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
		<tr>
		    <th scope="row"><spring:message code='service.title.SIRIMNo'/></th>
		    <td colspan="3"><input type="text" title="" placeholder="" class="w100p"    readonly = "readonly" id="sirimNo" name="sirimNo"   value="${installResult.sirimNo}"/></td>
		    <th scope="row">
		      <spring:message code='service.title.SerialNo'/>(MAT)</br>
		      <spring:message code='service.title.SerialNo'/>(FRA)
		    </th>
		    <td colspan="3">
		        <input type="text" title="" placeholder="" style="position:relative; width:70%;" readonly = "readonly" id="serialNo" name="serialNo"  value="${orderSerial}"/>
		        <p id="btnSerialEdit" class="btn_grid" style="display:none">
		            <a href="#" onClick="fn_serialChangePop('1')">EDIT<!-- Modify --></a>
		        </p>
		        <input type="text" title="" placeholder="" style="position:relative; width:70%;" readonly = "readonly" id="serialNo2" name="serialNo2"  value="${orderHcInfo.anoOrderSerial}"/>
                <p id="btnSerialEdit2" class="btn_grid" style="display:none">
                    <a href="#" onClick="fn_serialChangePop('2')">EDIT<!-- Modify --></a>
                </p>
		    </td>
		</tr>
		<tr>
            <th scope="row">Acceptance Cust Name</th>
		    <td  colspan="3"><input type="text" title="" placeholder="" class="w100p" id="custName" name="custName"/></td>
		    <th scope="row">Acceptance Cust Relationship</th>
		    <td  colspan="3">
                <select class="w100p" id="custRelationship" name="custRelationship">
		           <option value="2688">Owner</option>
		           <option value="2689">Mother</option>
		           <option value="2690">Father</option>
		           <option value="2691">Brother</option>
		           <option value="2692">Sister</option>
		           <option value="2693">Spouse</option>
		           <option value="2694">Staff</option>
		           <option value="2695">Maid</option>
		           <option value="2696">Other</option>
		        </select>
            </td>
		</tr>
		<tr>
            <td colspan="8">
                <label><input type="checkbox" id="checkCommission" name="checkCommission"/><span><spring:message code='service.btn.AllowCommission'/> ?</span></label>
		    </td>
		</tr>
		</tbody>
	</table><!-- table end -->

	<aside class="title_line" id="completedHide1"><!-- title_line start -->
	<%-- <h2><spring:message code='service.title.SMSInfo'/></h2> --%>
	</aside><!-- title_line end -->

	<table class="type1" id="completedHide2"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:110px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
		</tbody>
	</table><!-- table end -->
	<table class="type1" id="failHide3"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:110px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
		<tr>
            <th scope="row"><spring:message code='service.title.FailedReason'/></th>
		    <td>
		        <select class="w100p" id="failReason" name="failReason">
			        <option value="0">Failed Reason</option>
			        <c:forEach var="list" items="${failReason }" varStatus="status">
			           <option value="${list.resnId}">${list.c1}</option>
			        </c:forEach>
                </select>
		    </td>
		    <th scope="row"><spring:message code='service.title.NextCallDate'/></th>
		    <td>
		        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  id="nextCallDate" name="nextCallDate"/>
		    </td>
		</tr>
		</tbody>
	</table><!-- table end -->
	<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:110px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
		<tr>
		    <th scope="row"><spring:message code='service.title.Remark'/></th>
		    <td><input type="text" title="" placeholder="" class="w100p" id="remark" name="remark" /></td>
		</tr>
		</tbody>
	</table><!-- table end -->
</form>

<div  id='sav_div'>
	<ul class="center_btns" >
	    <li><p class="btn_blue2">
	        <a href="#" onclick="fn_saveInstall()">Save Product Return Result</a></p>
	    </li>
	</ul>
</div>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
