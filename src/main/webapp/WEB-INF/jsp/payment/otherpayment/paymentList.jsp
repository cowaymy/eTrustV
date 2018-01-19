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
	        
	        softRemoveRowMode:false
	
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
		{dataField : "payId",headerText : "<spring:message code='pay.head.PID'/>",width : 110,editable : false, visible : false}
	];
	
    
	$(document).ready(function(){
		//그리드 생성
	    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
		
		// Master Grid 셀 클릭시 이벤트
	    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
		    selectedGridValue = event.rowIndex;
	    });
	    
	});

    // ajax list 조회.
    function searchList(){
    	
    	if(FormUtil.checkReqValue($("#ordNo"))){
            Common.alert("<spring:message code='pay.alert.orderNumberFirst'/>");
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
		var selectedItem = AUIGrid.getSelectedIndex(myGridID);
		
		if (selectedItem[0] > -1){
			var groupSeq = AUIGrid.getCellValue(myGridID, selectedGridValue, "groupSeq");
			var revStusId = AUIGrid.getCellValue(myGridID, selectedGridValue, "revStusId");

			if (revStusId == 1) {
				Common.alert("<spring:message code='pay.alert.groupNumberRequested' arguments='"+groupSeq+"' htmlEscape='false'/>");
			} else if (revStusId == 5) {
				Common.alert("<spring:message code='pay.alert.groupNumberApproved' arguments='"+groupSeq+"' htmlEscape='false'/>");
			} else {
				Common.popupDiv('/payment/initRequestDCFPop.do', {"groupSeq" : groupSeq}, null , true ,'_requestDCFPop');
			}
		}else{
             Common.alert('No Payment List selected.');
        }	
	}


	//Request Fund Transfer 팝업
	function fn_requestFTPop(){
		var selectedItem = AUIGrid.getSelectedIndex(myGridID);
		
		if (selectedItem[0] > -1){
			var groupSeq = AUIGrid.getCellValue(myGridID, selectedGridValue, "groupSeq");
			var payId = AUIGrid.getCellValue(myGridID, selectedGridValue, "payId");
			var appType = AUIGrid.getCellValue(myGridID, selectedGridValue, "appType");

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


			var revStusId = AUIGrid.getCellValue(myGridID, selectedGridValue, "revStusId");
			var ftStusId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ftStusId");

			if (revStusId == 0 || revStusId == 6) {
				if(ftStusId == 0 || ftStusId == 6) {
					Common.popupDiv('/payment/initRequestFTPop.do', {"groupSeq" : groupSeq , "payId" : payId , "appTypeId" : appTypeId}, null , true ,'_requestFTPop');
				}else{
					Common.alert("<b>This has already been Fund Transfer processing Requested. </b>");   
				}
			} else {
				Common.alert("<b>Payment Group Number [" + groupSeq + "] has already been REVERSE processing Requested. </b>");   
			} 

		}else{
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
           </c:if>
            <li><p class="btn_blue"><a href="javascript:clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <!-- search_table start -->
        <form id="searchForm" action="#" method="post">
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
					<li><p class="link_btn"><a href="javascript:fn_requestDCFPop();"><spring:message code='pay.btn.requestDcf'/></a></p></li>
				</c:if>
					<li><p class="link_btn"><a href="javascript:fn_requestFTPop();"><spring:message code='pay.btn.requestFT'/></a></p></li>
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


