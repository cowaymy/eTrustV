<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">

/* gride 동적 버튼 */
.edit-column {
    visibility:hidden;
}
</style>

<script type="text/javascript">
	//AUIGrid 생성 후 반환 ID
	var viewHistGridID;
	
	$(document).ready(function() {
	    
		// AUIGrid 그리드를 생성합니다.
        createAUIGrid();
	        
        fn_paymentViewHistAjax();
	});
	
	function createAUIGrid() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "c6",
                headerText : "<spring:message code="sal.title.type" />",
                width : 80,
                editable : false
            }, {
                dataField : "code",
                headerText : "<spring:message code="sal.title.mode" />",
                width : 70,
                editable : false
            }, {
                dataField : "custCrcOwner",
                headerText : "<spring:message code="sal.title.crcAccOwner" />",
                width : 120,
                editable : false
            }, {
                dataField : "custAccNo",
                headerText : "<spring:message code="sal.title.crcAccNo" />",
                width : 120,
                editable : false
            }, {
                dataField : "custCrcExpr",
                headerText : "<spring:message code="sal.title.expiryDate" />",
                editable : false
            }, {
                dataField : "bankCodeId",
                headerText : "<spring:message code="sal.title.bank" />",
                width : 90,
                editable : false
            }, {
                dataField : "ddApplyDt",
                headerText : "<spring:message code="sal.title.applyDate" />",
                editable : false
            }, {
                dataField : "ddSubmitDt",
                headerText : "<spring:message code="sal.title.submitDate" />",
                editable : false
            }, {
                dataField : "-",
                headerText : "<spring:message code="sal.title.approveDate" />",
                editable : false
            },{
                dataField : "undefined",
                headerText : "<spring:message code="sal.title.reactivate" />",
                width : 110,
                styleFunction : cellStyleFunction,
                renderer : {
                      type : "ButtonRenderer",
                      labelText : "<spring:message code="sal.btn.confirm" />",
                      onclick : function(rowIndex, columnIndex, value, item) {
                           //pupupWin
                          $("#histRenPayId").val(item.histRenPayId);
                          fn_confirm(item.code, item.bankCodeId, item.ddApplyDt);
                      }
               }
           }, {
                dataField : "ddRejctDt",
                headerText : "<spring:message code="sal.title.rejectDate" />",
                editable : false
            }, {
                dataField : "resnCodeId",
                headerText : "<spring:message code="sal.title.rejectCode" />",
                editable : false
            }, {
                dataField : "issuNric",
                headerText : "<spring:message code="sal.title.issuedNric" />",
                editable : false
            }, {
                dataField : "custName",
                headerText : "<spring:message code="sal.title.thirdParty" />",
                editable : false
            }, {
                dataField : "userName",
                headerText : "<spring:message code="sal.title.updator" />",
                editable : false
            }, {
                dataField : "updDt",
                headerText : "<spring:message code="sal.title.updateDate" />",
                editable : false
            }];
        
     // 그리드 속성 설정
        var gridPros = {
            
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : false, 
            displayTreeOpen : true,
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : false,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : false
        };
        
        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        viewHistGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    }

	//Get address by Ajax
    function fn_paymentViewHistAjax(){
       Common.ajax("GET", "/sales/membershipRental/paymentViewHistoryAjax",$("#historyForm").serialize(), function(result) {
           AUIGrid.setGridData(viewHistGridID, result);
       });
   }
	
    //addcolum button hidden
    function cellStyleFunction(rowIndex, columnIndex, value, headerText, item, dataField){

       if(item.ddApplyDt != '-' && item.ddSubmitDt != '-' && item.ddStartDt != '-' && item.c6 != 'Current'){
           return '';  
       }else{
           return 'edit-column';
       }
    }
    
    function fn_confirm(mode, bank, applyDt){

    	var msg = "<spring:message code="sal.conf.requestSummary" /> </br>";
    	msg += "<spring:message code="sal.conf.payMode" />["+mode+"] </br> <spring:message code="sal.conf.bankCode" />: ["+bank+"] </br> <spring:message code="sal.conf.applyDate" />: ["+applyDt+"]";
    	
    	Common.confirm(msg, fn_confirmOk);
    	
    }
    
    function fn_confirmOk(){

        Common.ajax("GET", "/sales/membershipRental/paymentViewHistoryConfirm.do", $('#historyForm').serializeJSON(), function(result) {
            console.log(result);
            
            Common.alert('<spring:message code="sal.alert.msg.succPaySet" />');
            
            //$("#histClose").click();
            fn_paymentViewHistAjax();

        }, function(jqXHR, textStatus, errorThrown) {
            try {
                Common.alert("<spring:message code="sal.alert.msg.failPaySet" />");
            }
            catch(e) {
                console.log(e);
            }
        });
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.renPaySetHis" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="histClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<form id="historyForm" name="historyForm" method="POST">
    <input type="hidden" id="srvCntrctId" name="srvCntrctId" value="${srvCntrctId }">
    <input type="hidden" id="salesOrdId" name="salesOrdId" value="${salesOrdId }">
    <input type="hidden" id="histRenPayId" name="histRenPayId" >
    <input type="hidden" id="userId" name="userId" value="${userId }">
</form>
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- content end -->

<hr />

</div><!-- popup_wrap end -->
