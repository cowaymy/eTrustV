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
	var confirmFTGridID;

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

	//Default Combo Data
	var statusData = [{"codeId": "1","codeName": "Active"},
					{"codeId": "5","codeName": "Approved"},
					{"codeId": "6","codeName": "Rejected"}];

	// AUIGrid 칼럼 설정
	var columnLayout = [
        {dataField : "ftReqId",headerText : "<spring:message code='pay.head.ftRequestNo'/>",width : 150 , editable : false},
        {dataField : "ftResnNm",headerText : "<spring:message code='pay.head.reason'/>",width : 240 , editable : false},
        {dataField : "ftCrtUserNm",headerText : "<spring:message code='pay.head.requestor'/>",width : 180 , editable : false},
        {dataField : "ftCrtDt",headerText : "<spring:message code='pay.head.requestDate'/>",width : 180 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
        {dataField : "ftStusId",headerText : "<spring:message code='pay.head.statusId'/>",width : 100 , editable : false, visible : false},
        {dataField : "ftStusNm",headerText : "<spring:message code='pay.head.status'/>",width : 150 , editable : false},
		{dataField : "payId",headerText : "<spring:message code='pay.head.PID'/>",width : 150 , editable : false, visible : false},
		{dataField : "groupSeq",headerText : "<spring:message code='pay.head.paymentGrpNo'/>",width : 150 , editable : false, visible : false}
	];


	$(document).ready(function(){
		doGetCombo('/common/selectCodeList.do', '396' , ''   , 'reason' , 'S', '');
		doDefCombo(statusData, '' ,'status', 'S', '');

		//그리드 생성
	    confirmFTGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

		// Master Grid 셀 클릭시 이벤트
	    AUIGrid.bind(confirmFTGridID, "cellClick", function( event ){
		    selectedGridValue = event.rowIndex;
	    });

	});

    // ajax list 조회.
    function searchList(){

		if(FormUtil.checkReqValue($("#reqNo"))){
			if(FormUtil.checkReqValue($("#reqDateFr")) ||
				FormUtil.checkReqValue($("#reqDateTo"))){
	            Common.alert("<spring:message code='pay.alert.inputReqDate'/>");
		        return;
			}
		}

    	Common.ajax("POST","/payment/selectRequestFTList.do",$("#searchForm").serializeJSON(), function(result){
    		AUIGrid.setGridData(confirmFTGridID, result);
    	});
    }

    // 화면 초기화
    function clear(){
    	//화면내 모든 form 객체 초기화
    	$("#searchForm")[0].reset();

    	//그리드 초기화
    	//AUIGrid.clearGridData(myGridID);
    }


	//Request DCF 팝업
	function fn_confirmFTPop(){
		var selectedItem = AUIGrid.getSelectedIndex(confirmFTGridID);

		if (selectedItem[0] > -1){

			var ftReqId = AUIGrid.getCellValue(confirmFTGridID, selectedGridValue, "ftReqId");
			var ftStusId = AUIGrid.getCellValue(confirmFTGridID, selectedGridValue, "ftStusId");
			var payId = AUIGrid.getCellValue(confirmFTGridID, selectedGridValue, "payId");
			var groupSeq = AUIGrid.getCellValue(confirmFTGridID, selectedGridValue, "groupSeq");

			Common.popupDiv('/payment/initConfirmFTPop.do', {"ftReqId" : ftReqId, "ftStusId" : ftStusId, "payId" : payId , "groupSeq" : groupSeq}, null , true ,'_confirmFTPop');

		}else{
             Common.alert("<spring:message code='pay.alert.transListSelected'/>");
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
        <h2>Confirm Fund Transfer</h2>
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
						<th scope="row">FT Request No</th>
                        <td>
                            <input type="text" id="reqNo" name="reqNo" class="w100p" />
                        </td>

					    <th scope="row">Request Date</th>
                        <td>
                            <!-- date_set start -->
                            <div class="date_set w100p">
                            <p><input type="text" id="reqDateFr" name="reqDateFr" title="Request Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text" id="reqDateTo" name="reqDateTo" title="Request End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                    </tr>
					<tr>
						<th scope="row">Reason</th>
                        <td>
							<select id="reason" name="reason" class="w100p"></select>
                        </td>

					    <th scope="row">Status</th>
                        <td>
							<select id="status" name="status" class="w100p"></select>
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
			<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
				<ul class="btns">
					<li><p class="link_btn"><a href="javascript:fn_confirmFTPop();"><spring:message code='pay.btn.link.approvalFT'/></a></p></li>
				</ul>
			</c:if>
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


