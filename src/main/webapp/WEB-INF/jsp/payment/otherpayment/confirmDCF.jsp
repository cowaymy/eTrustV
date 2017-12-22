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
	var confirmDCFGridID;

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
        {dataField : "dcfReqId",headerText : "<spring:message code='pay.head.dcfRequestNo'/>",width : 150 , editable : false},
        {dataField : "grpSeq",headerText : "<spring:message code='pay.head.paymentGroupSeq'/>",width : 200 , editable : false},
        {dataField : "dcfResnNm",headerText : "<spring:message code='pay.head.reason'/>",width : 240 , editable : false},
        {dataField : "dcfCrtUserNm",headerText : "<spring:message code='pay.head.requestor'/>",width : 180 , editable : false},
        {dataField : "dcfCrtDt",headerText : "<spring:message code='pay.head.requestDate'/>",width : 180 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
        {dataField : "dcfStusId",headerText : "<spring:message code='pay.head.statusId'/>",width : 100 , editable : false, visible : false},
        {dataField : "dcfStusNm",headerText : "<spring:message code='pay.head.status'/>",width : 150 , editable : false}
	];
	
    
	$(document).ready(function(){
		doGetCombo('/common/selectCodeList.do', '392' , ''   , 'reason' , 'S', '');
		doDefCombo(statusData, '' ,'status', 'S', '');

		//그리드 생성
	    confirmDCFGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
		
		// Master Grid 셀 클릭시 이벤트
	    AUIGrid.bind(confirmDCFGridID, "cellClick", function( event ){ 
		    selectedGridValue = event.rowIndex;
	    });
	    
	});

    // ajax list 조회.
    function searchList(){

		if(FormUtil.checkReqValue($("#reqNo"))){			
			if(FormUtil.checkReqValue($("#reqDateFr")) ||
				FormUtil.checkReqValue($("#reqDateTo"))){
	            Common.alert('* Please input Request Date <br />');
		        return;
			}	
		}        
    	
    	Common.ajax("POST","/payment/selectRequestDCFList.do",$("#searchForm").serializeJSON(), function(result){    		
    		AUIGrid.setGridData(confirmDCFGridID, result);
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
	function fn_confirmDCFPop(){
		var selectedItem = AUIGrid.getSelectedIndex(confirmDCFGridID);
		
		if (selectedItem[0] > -1){
			var groupSeq = AUIGrid.getCellValue(confirmDCFGridID, selectedGridValue, "grpSeq");
			var dcfReqId = AUIGrid.getCellValue(confirmDCFGridID, selectedGridValue, "dcfReqId");
			var dcfStusId = AUIGrid.getCellValue(confirmDCFGridID, selectedGridValue, "dcfStusId");
			
			Common.popupDiv('/payment/initConfirmDCFPop.do', {"groupSeq" : groupSeq, "reqNo" : dcfReqId, "dcfStusId" : dcfStusId}, null , true ,'_confirmDCFPop');
			
		}else{
             Common.alert('No DCF List selected.');
        }	
	}

</script>
<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Other Payment</li>        
        <li>Confirm DCF</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Confirm DCF</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:searchList();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>     
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
						<th scope="row">DCF Request No</th>
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
				<ul class="btns">
					<li><p class="link_btn"><a href="javascript:fn_confirmDCFPop();"><spring:message code='pay.btn.link.approvalDCF'/></a></p></li>
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


