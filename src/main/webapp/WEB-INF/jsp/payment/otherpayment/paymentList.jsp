<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up div{
    color:#FF0000;
}
</style>
<script type="text/javaScript">
	//AUIGrid 그리드 객체
	var myGridID;
	var gridDataLength = 0;

	//Grid에서 선택된 RowID
	var selectedGridValue;

	//Grid Properties 설정
	var gridPros = {
	        // 편집 가능 여부 (기본값 : false)
	        editable : false,
	        // 상태 칼럼 사용
	        showStateColumn : false,
	        // 기본 헤더 높이 지정
	        headerHeight : 35,

	        softRemoveRowMode:false,

	        showRowCheckColumn : true

	};

	// AUIGrid 칼럼 설정
	var columnLayout = [
        {dataField : "groupSeq",headerText : "<spring:message code='pay.head.paymentGrpNo'/>",width : 100 , editable : false},
        {dataField : "appType",headerText : "<spring:message code='pay.head.appType'/>",width : 130 , editable : false},
        {dataField : "payItmModeId",headerText : "<spring:message code='pay.head.payTypeId'/>",width : 240 , editable : false, visible : false},
		{dataField : "payItmModeNm",headerText : "<spring:message code='pay.head.mode'/>",width : 120 , editable : false},
        {dataField : "custId",headerText : "<spring:message code='pay.head.customerId'/>",width : 100 , editable : false},
		{dataField : "salesOrdNo",headerText : "<spring:message code='pay.head.salesOrder'/>", editable : false},
		{dataField : "totAmt",headerText : "<spring:message code='pay.head.amount'/>", editable : false, dataType:"numeric", formatString : "#,##0.00" },
		{dataField : "payItmRefDt",headerText : "<spring:message code='pay.head.transDate'/>",width : 120 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
		{dataField : "orNo",headerText : "<spring:message code='pay.head.worNo'/>",width : 120,editable : false},
		{dataField : "brnchId",headerText : "<spring:message code='pay.head.keyInBranch'/>",width : 100,editable : false},
		{dataField : "crcStateMappingId",headerText : "<spring:message code='pay.head.crcStateId'/>",width : 110,editable : false},
		{dataField : "crcStateMappingDt",headerText : "<spring:message code='pay.head.crcMappingDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
		{dataField : "bankStateMappingId",headerText : "<spring:message code='pay.head.bankStateId'/>",width : 110,editable : false},
		{dataField : "bankStateMappingDt",headerText : "<spring:message code='pay.head.bankMappingDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
		{dataField : "revStusId",headerText : "<spring:message code='pay.head.reverseStatusId'/>",width : 110,editable : false, visible : false},
		{dataField : "ftStusId",headerText : "<spring:message code='pay.head.reverseStatusId'/>",width : 110,editable : false, visible : false},
		{dataField : "revStusNm",headerText : "<spring:message code='pay.head.reverseStatus'/>",width : 110,editable : false},
		{dataField : "revDt",headerText : "<spring:message code='pay.head.reverseDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
		{dataField : "payId",headerText : "<spring:message code='pay.head.PID'/>",width : 110,editable : false, visible : false},
		{dataField : "payData",headerText : "Pay Data",width : 110,editable : false, visible : false},
		{dataField : "orType",headerText : "OR Type",width : 110,editable : false, visible : false},
		{dataField : "bankAcc",headerText : "Bank Acc Code",width : 110,editable : false, visible : false}
	];


	$(document).ready(function(){
		//그리드 생성

        if("${SESSION_INFO.userTypeId}" == "2" ){

            if("${SESSION_INFO.memberLevel}" =="2" || "${SESSION_INFO.memberLevel}" =="3"){
                $("#btnrequestFT").hide();
            }
        }

	    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

	    AUIGrid.bind(myGridID, "cellClick", function( event ){
		    selectedGridValue = event.rowIndex;
            var item = event.item, rowIdField, rowId, rowOrNo;

            rowIdField = AUIGrid.getProp(event.pid, "rowIdField");
            rowId = item[rowIdField];

            // check if already checked
            if(AUIGrid.isCheckedRowById(event.pid, rowId)) {
                // Add extra checkbox unchecked
                AUIGrid.addUncheckedRowsByIds(event.pid, rowId);

            } else {
                // add extra checkbox check
                AUIGrid.addCheckedRowsByIds(event.pid, rowId);
            }
        });

        AUIGrid.bind(myGridID, "rowCheckClick", function(event) {
           var item = event.item, rowIdField, rowId, rowOrNo;

           // check if already checked
            if(AUIGrid.isCheckedRowById(event.pid, rowId)) {
                // Add extra checkbox unchecked
                AUIGrid.addUncheckedRowsByIds(event.pid, rowId);
            } else {
                // add extra checkbox check
                AUIGrid.addCheckedRowsByIds(event.pid, rowId);
            }
         });

         AUIGrid.bind(myGridID, "rowAllChkClick", function(event) {
               var item = event.item, rowIdField, rowId, rowOrNo;

                // check if already checked
                 if(AUIGrid.isCheckedRowById(event.pid, rowId)) {
                     // Add extra checkbox unchecked
                     AUIGrid.addUncheckedRowsByIds(event.pid, rowId);
                 } else {
                     // add extra checkbox check
                     AUIGrid.addCheckedRowsByIds(event.pid, rowId);
                 }
          });

	});

    // ajax list 조회.
    function searchList(){

    	if(FormUtil.checkReqValue($("#ordNo")) && FormUtil.checkReqValue($("#orNo"))  && FormUtil.checkReqValue($("#trxId"))){
    		Common.alert("Please key in the order number OR OR No OR transaction ID.");
    		return;
    	}

        //if(FormUtil.checkReqValue($("#tranDateFr")) ||
		//	FormUtil.checkReqValue($("#tranDateTo"))){
        //   Common.alert("<spring:message code='pay.alert.inputTransDate'/>");
        //    return;
        //}

    	Common.ajax("POST","/payment/selectGroupPaymentList.do",$("#searchForm").serializeJSON(), function(result){
    		AUIGrid.setGridData(myGridID, result);
    	});
    }

    // 화면 초기화
    function clear(){
    	//화면내 모든 form 객체 초기화
    	$("#searchForm")[0].reset();

    	//그리드 초기화
    	//AUIGrid.clearGridData(myGridID);
    }

    //Search Order 팝업
    function fn_orderSearchPop(){
    	Common.popupDiv("/sales/order/orderSearchPop.do", {callPrgm : "RENTAL_PAYMENT", indicator : "SearchOrder"});
    }

    //Search Order 팝업에서 결과값 받기
    function fn_callBackRentalOrderInfo(ordNo, ordId){
    	$("#ordId").val(ordId);
        $("#ordNo").val(ordNo);
   }




	//Request DCF 팝업
	function fn_requestDCFPop(){
	    var selectedItem = AUIGrid.getCheckedRowItemsAll(myGridID);

	    if(selectedItem.length > 0){
            var groupSeqList = [];
//             var revStusList = [];
//             var ftStusList = [];
//             var trxList= [];

            for(var i = 0 ; i < selectedItem.length ; i++){
            	groupSeqList.push(selectedItem[i].groupSeq);
//             	revStusList.push(selectedItem[i].revStusId);
//             	ftStusList.push(selectedItem[i].ftStusId);
//             	trxList.push(selectedItem[i].bankStateMappingId == null ? 0 : selectedItem[i].bankStateMappingId);
            }

//             var selectedOrder = {
//             	"groupSeqList" : JSON.stringify(groupSeqList.join()),
//             	"revStusList" : JSON.stringify(revStusList.join()),
//             	"ftStusList" : JSON.stringify(ftStusList.join()),
//             	"trxList" : JSON.stringify(trxList.join())
//             };

//            Common.ajax("GET","/payment/validDCF2", selectedOrder, function(result){
           Common.ajax("POST","/payment/validDCF2", {selectedOrder : JSON.stringify(selectedItem)}, function(result){
                if(result.error){
                	Common.alert(result.error);
                }else if(result.success){
                	 Common.popupDiv('/payment/initRequestDCFPop.do', {"groupSeqList" : JSON.stringify(groupSeqList.join())}, null , true ,'_requestDCFPop');
                }
            });

	    }else{
	    	Common.alert('No Payment List selected.');
	    }
     }

	function fn_requestDCFPopOld(){
        var selectedItem = AUIGrid.getSelectedIndex(myGridID);
        console.log(selectedItem);

        if (selectedItem[0] > -1){
            var groupSeq = AUIGrid.getCellValue(myGridID, selectedGridValue, "groupSeq");
            console.log("groupSeq");
            console.log(groupSeq);
            var revStusId = AUIGrid.getCellValue(myGridID, selectedGridValue, "revStusId");
            console.log("revStusId");
            console.log(revStusId);
            const revStusNm = AUIGrid.getCellValue(myGridID, selectedGridValue, "revStusNm");
            console.log("revStusNm");
            console.log(revStusNm);
            let data = AUIGrid.getOrgGridData(myGridID).filter(r => r.groupSeq == groupSeq);
            console.log("data");
            console.log(data);
            let ftStus = data.map(d => d.ftStusId);
            console.log("ftStus");
            console.log(ftStus);
            fetch("/payment/validDCF?groupSeq=" + groupSeq)
            .then(resp => resp.json()).then(d => {
                if (d.error) {
                    Common.alert(d.error)
                } else if (d.success) {
                    if (revStusNm == "Refund") {
                        Common.alert("<b>This has already been refunded. </b>");
                    } else if (revStusId == 1) {
                        Common.alert("<spring:message code='pay.alert.groupNumberRequested' arguments='"+groupSeq+"' htmlEscape='false'/>");
                    } else if (revStusId == 5) {
                        Common.alert("<spring:message code='pay.alert.groupNumberApproved' arguments='"+groupSeq+"' htmlEscape='false'/>");
                    } else {
                        if (!(ftStus.filter(s => s == 1).length)) {
                            Common.popupDiv('/payment/initRequestDCFPopOld.do', {"groupSeq" : groupSeq}, null , true ,'_requestDCFPopOld');
                        }else{
                            Common.alert("<b>This has already been Fund Transfer processing Requested/Approved. </b>");
                        }
                    }
                }
            })
        }else{
             Common.alert('No Payment List selected.');
        }
    }



	//Request Fund Transfer 팝업
	function fn_requestFTPop(){
		var selectedItem = AUIGrid.getCheckedRowItems(myGridID);

        if(selectedItem.length > 1){
	            Common.alert("<b>Only 1 payment record is available for request Fund Transfer.</b>");
	            return;
        }else if (selectedItem.length = 1){
			var groupSeq = selectedItem[0].item.groupSeq;
			var payId = selectedItem[0].item.payId;
			var appType = selectedItem[0].item.appType;

			var appTypeId;
			if(appType == 'RENTAL'){
				appTypeId = 1;
			}else if(appType == 'OUT') {
				appTypeId = 2;
			}else if(appType == 'MEMBERSHIP') {
				appTypeId = 3;
			}else if(appType == 'AS' || appType == 'HP') {
				appTypeId = 4;
			}else if(appType == 'OUT_MEM') {
				appTypeId = 5;
			}

			if(appTypeId == ''){
	             Common.alert('This Payment App Type is not valid.');
				 return;
			}

			fetch("/payment/validFT?payId=" + payId)
			.then(resp => resp.json()).then(d => {
				if (d.error) {
					Common.alert(d.error)
				} else if (d.success) {
					var revStusId = selectedItem[0].item.revStusId;
					var ftStusId = selectedItem[0].item.ftStusId;
					const revStusNm = selectedItem[0].item.revStusNm;

					if (revStusNm == "Refund") {
						Common.alert("<b>This has already been refunded. </b>");
					} else if (revStusId == 0 || revStusId == 6) {
						if(ftStusId == 0 || ftStusId == 6) {
							Common.popupDiv('/payment/initRequestFTPop.do', {"groupSeq" : groupSeq , "payId" : payId , "appTypeId" : appTypeId}, null , true ,'_requestFTPop');
						}else{
							Common.alert("<b>This has already been Fund Transfer processing Requested/Approved. </b>");
						}
					} else {
						Common.alert("<b>Payment Group Number [" + groupSeq + "] has already been REVERSE processing Requested. </b>");
					}
				}
			})


		}else{
             Common.alert('No Payment List selected.');
        }
// 		var selectedItem = AUIGrid.getSelectedIndex(myGridID);

// 		if (selectedItem[0] > -1){
// 			var groupSeq = AUIGrid.getCellValue(myGridID, selectedGridValue, "groupSeq");
// 			var payId = AUIGrid.getCellValue(myGridID, selectedGridValue, "payId");
// 			var appType = AUIGrid.getCellValue(myGridID, selectedGridValue, "appType");

// 			var appTypeId;
// 			if(appType == 'RENTAL'){
// 				appTypeId = 1;
// 			}else if(appType == 'OUT') {
// 				appTypeId = 2;
// 			}else if(appType == 'MEMBERSHIP') {
// 				appTypeId = 3;
// 			}else if(appType == 'AS' || appType == 'HP') {
// 				appTypeId = 4;
// 			}else if(appType == 'OUT_MEM') {
// 				appTypeId = 5;
// 			}

// 			if(appTypeId == ''){
// 	             Common.alert('This Payment App Type is not valid.');
// 				 return;
// 			}

// 			fetch("/payment/validFT?payId=" + payId)
// 			.then(resp => resp.json()).then(d => {
// 				if (d.error) {
// 					Common.alert(d.error)
// 				} else if (d.success) {
// 					var revStusId = AUIGrid.getCellValue(myGridID, selectedGridValue, "revStusId");
// 					var ftStusId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ftStusId");
// 					const revStusNm = AUIGrid.getCellValue(myGridID, selectedGridValue, "revStusNm");

// 					if (revStusNm == "Refund") {
// 						Common.alert("<b>This has already been refunded. </b>");
// 					} else if (revStusId == 0 || revStusId == 6) {
// 						if(ftStusId == 0 || ftStusId == 6) {
// 							Common.popupDiv('/payment/initRequestFTPop.do', {"groupSeq" : groupSeq , "payId" : payId , "appTypeId" : appTypeId}, null , true ,'_requestFTPop');
// 						}else{
// 							Common.alert("<b>This has already been Fund Transfer processing Requested/Approved. </b>");
// 						}
// 					} else {
// 						Common.alert("<b>Payment Group Number [" + groupSeq + "] has already been REVERSE processing Requested. </b>");
// 					}
// 				}
// 			})


// 		}else{
//              Common.alert('No Payment List selected.');
//         }
	}

    function fn_requestRefundPop(){

    	var data = {};
        var selectedItem = AUIGrid.getCheckedRowItemsAll(myGridID);
        var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

         if (selectedItem.length > 0){
        	 data = selectedItem;
        	 /*var refGroupSeqList = [];
            var refPayIdList = [];
            var refRevStusList = [];
            var refFtStusList = [];
            var refBankStateIdList = [];
            var refBankStateMappingDtList = [];
            var refCrcStateIdList = [];
            var refCrcStateMappingDtList = [];
            var refAppType = [];
            var refPayDataList = [];
            var refOrTypeList = [];
            var refPayItmModeIdList = [];
            var refPayItmBankAccIdList = [];

            for(var i = 0; i< selectedItem.length; i++){
            	refGroupSeqList.push(selectedItem[i].groupSeq);
            	refPayIdList.push(selectedItem[i].payId);
            	refRevStusList.push(selectedItem[i].revStusId);
            	refFtStusList.push(selectedItem[i].ftStusId);
            	refBankStateIdList.push(selectedItem[i].bankStateMappingId == null ? 0 : selectedItem[i].bankStateMappingId);
            	refBankStateMappingDtList.push(selectedItem[i].bankStateMappingDt == null ? 0 : selectedItem[i].bankStateMappingDt);
            	refCrcStateIdList.push(selectedItem[i].crcStateMappingId == null ? 0 : selectedItem[i].crcStateMappingId);
                refCrcStateMappingDtList.push(selectedItem[i].crcStateMappingDt == null ? 0 : selectedItem[i].crcStateMapping);
                refPayDataList.push(selectedItem[i].payData == null ? 0 : selectedItem[i].payData);
                refOrTypeList.push(selectedItem[i].orType == null ? 0 : selectedItem[i].orType);
                refPayItmModeIdList.push(selectedItem[i].payItmModeId == null ? 0 : selectedItem[i].payItmModeId);
                refPayItmBankAccIdList.push(selectedItem[i].payItmBankAccId == null ? 0 : selectedItem[i].payItmBankAccId);
            	//refAppType.push(selectedItem[i].appType);

            	var appTypeId;
                if(selectedItem[i].appType == 'RENTAL'){
                    appTypeId = 1;
                }else if(selectedItem[i].appType == 'OUT') {
                    appTypeId = 2;
                }else if(selectedItem[i].appType == 'MEMBERSHIP') {
                    appTypeId = 3;
                }else if(selectedItem[i].appType == 'AS' || selectedItem[i].appType == 'HP') {
                    appTypeId = 4;
                }else if(selectedItem[i].appType == 'OUT_MEM') {
                    appTypeId = 5;
                }

                refAppType.push(appTypeId);

            }
 */
            /* var selectedOrder = {
            		"groupSeqList" : JSON.stringify(refGroupSeqList.join()),
            		"payIdList" : JSON.stringify(refPayIdList.join()),
            		"revStusList" : JSON.stringify(refRevStusList.join()),
            		"rfStusList" : JSON.stringify(refFtStusList.join()),
            		"bankStateIdList" : JSON.stringify(refBankStateIdList.join()),
            		"bankStateMappingDt" : JSON.stringify(refBankStateMappingDtList.join()),
            		"appTypeIdList" : JSON.stringify(refAppType.join()),
            		"crcStateIdList" : JSON.stringify(refCrcStateIdList.join()),
                    "crcStateMappingDt" : JSON.stringify(refCrcStateMappingDtList.join()),
                    "payDataList" : JSON.stringify(refPayDataList.join()),
                    "orTypeList" : JSON.stringify(refOrTypeList.join()),
                    "payItmModeIdList" : JSON.stringify(refPayItmModeIdList.join()),
                    "payItmBankAccIdList" : JSON.stringify(refPayItmBankAccIdList.join())
            };

            */

            var refGroupSeqList = [];
            var refPayIdList = [];
            var refAppType = [];

            for(var i = 0; i< selectedItem.length; i++){
                refGroupSeqList.push(selectedItem[i].groupSeq);
                refPayIdList.push(selectedItem[i].payId);

                var appTypeId;
                if(selectedItem[i].appType == 'RENTAL'){
                    appTypeId = 1;
                }else if(selectedItem[i].appType == 'OUT') {
                    appTypeId = 2;
                }else if(selectedItem[i].appType == 'MEMBERSHIP') {
                    appTypeId = 3;
                }else if(selectedItem[i].appType == 'AS' || selectedItem[i].appType == 'HP') {
                    appTypeId = 4;
                }else if(selectedItem[i].appType == 'OUT_MEM') {
                    appTypeId = 5;
                }

                refAppType.push(appTypeId);
            }


            var selectedOrder = {
                    "groupSeqList" : JSON.stringify(refGroupSeqList.join()),
                    "payIdList" : JSON.stringify(refPayIdList.join()),
                    "appTypeIdList" : JSON.stringify(refAppType.join())
            };

            Common.ajax("POST","/payment/validRefund", {selectedOrder : JSON.stringify(AUIGrid.getCheckedRowItemsAll(myGridID))}, function(result){
            	if(result.error) {
            		Common.alert(result.error);
            	}
            	else if (result.success) {
            		Common.popupDiv('/payment/initRequestRefundPop.do', selectedOrder, null , true ,'_requestRefundPop');
            	}
            });
        }
        else{
        	Common.alert('No Payment List selected.');
        }
    }
</script>
<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Payment List</h2>
        <ul class="right_btns">
           <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a href="javascript:searchList();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>

            <li><p class="btn_blue"><a href="javascript:clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
           </c:if>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <!-- search_table start -->
        <form id="searchForm" action="#" method="post">
         <input type="hidden" name="data" id="data" />
            <input type="hidden" name="ordId" id="ordId" />
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Sales Order No</th>
                        <td>
                            <input type="text" id="ordNo" name="ordNo" class="" />
                             <p class="btn_sky">
                                 <a href="javascript:fn_orderSearchPop();" id="search"><spring:message code='sys.btn.search'/></a>
                             </p>
                        </td>
                        <%-- <!-- Celeste DCF SCR [s] -->
                        <th scope="row">Bank  State ID</th>
                        <td>
                            <input type="text" id="bankStateId" name="bankStateId" class="" />
                             <p class="btn_sky">
                                 <a href="javascript:fn_orderSearchPop();" id="search"><spring:message code='sys.btn.search'/></a>
                             </p>
                        </td>
                        <!-- Celeste DCF SCR [s] --> --%>
                        <th scope="row">OR No</th>
                        <td>
                            <input type="text" id="orNo" name="orNo" class="w100p" />
                        </td>
                    </tr>
					<tr>
						<th scope="row">Transaction Date</th>
                        <td>
                            <!-- date_set start -->
                            <div class="date_set w100p">
                            <p><input type="text" id="tranDateFr" name="tranDateFr" title="Transaction Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text" id="tranDateTo" name="tranDateTo" title="Transaction End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                        <th scope="row">Key-in Date</th>
                        <td>
                            <!-- date_set start -->
                            <div class="date_set w100p">
                            <p><input type="text" id="payDtFr" name="payDtFr" title="Key In Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text" id="payDtTo" name="payDtTo" title="Key In End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div>
                            <!-- date_set end -->
                        </td>

                    </tr>

                    <tr>
                        <th scope="row">Transaction ID </th>
                        <td colspan="3">
                            <input type="text" id="trxId" name="trxId" class="" />
                         </td>
                    </tr>

                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->

	<!-- link_btns_wrap start -->
	<aside class="link_btns_wrap">
		<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
		<dl class="link_list">
			<dt>Link</dt>
			<dd>
				<ul class="btns">
					 <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
						<li><p class="link_btn"><a href="javascript:fn_requestDCFPop();" id="btnrequestDCF"><spring:message code='pay.btn.requestDcf'/></a></p></li>
	                        <!-- Previos version of REQUEST DCF -->
	<!-- 					<li><p class="link_btn"><a href="javascript:fn_requestDCFPopOld();" id="btnrequestDCF">Request DCF OLD</a></p></li> -->
					</c:if>
				    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
					       <li><p class="link_btn"><a href="javascript:fn_requestFTPop();" id="btnrequestFT"><spring:message code='pay.btn.requestFT'/></a></p></li>
					</c:if>
					<c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
					   <li><p class="link_btn"><a href="javascript:fn_requestRefundPop();" id="btnrequestRefund"><spring:message code='pay.btn.requestRefund'/></a></p></li>
					</c:if>
				</ul>
				<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
			</dd>
		</dl>
	</aside>
	<!-- link_btns_wrap end -->

    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->

</section>
<!-- content end -->


