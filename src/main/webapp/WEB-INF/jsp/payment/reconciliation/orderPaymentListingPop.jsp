<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javaScript">


	//Grid Properties 설정 : 마스터 그리드용 
	var gridProsMaster = {
	        editable : false,                 // 편집 가능 여부 (기본값 : false)
	        showStateColumn : false,     // 상태 칼럼 사용
	        showRowNumColumn : false,
	        usePaging : false
	};
	
	var gridPros = {            
	        editable : false,                 // 편집 가능 여부 (기본값 : false)
	        showStateColumn : false     // 상태 칼럼 사용
	};
	
	var myGridID,subGridID;
   
    $(document).ready(function(){
        
    	// Order 정보 (Master Grid) 그리드 생성
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridProsMaster);
        
        fn_getOrderListAjax(1);
        
        // Master Grid 셀 클릭시 이벤트
        AUIGrid.bind(myGridID, "cellClick", function( event ){ 
            selectedGridValue = event.rowIndex;
            AUIGrid.destroy(subGridID); 
            // Payment (Slave Grid) 그리드 생성
            subGridID = GridCommon.createAUIGrid("grid_sub_wrap", slaveColumnLayout,null,gridPros);
            $("#payId").val(AUIGrid.getCellValue(myGridID , event.rowIndex , "payId"));
            $("#salesOrdId").val(AUIGrid.getCellValue(myGridID , event.rowIndex , "salesOrdId"));
            
            fn_getPaymentListAjax();
        });
    });
    
    // AUIGrid 칼럼 설정
    var columnLayout = [
        { dataField:"payDt" ,headerText:"TrxNo",editable : false  , visible:false, dataType : "date", formatString : "dd-mm-yyyy"},
        { dataField:"payTypeId" ,headerText:"TrxNo",editable : false ,visible:false},
        {dataField:"rnum", headerText:"No.", width : 80,editable : false },
        { dataField:"trxId" ,headerText:"TrxNo",editable : false },
        { dataField:"trxDt" ,headerText:"TrxDate",editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
        { dataField:"trxAmt" ,headerText:"TrxTotal" ,editable : false , dataType : "numeric", formatString : "#,##0.#"},
        { dataField:"payId" ,headerText:"PID" ,editable : false },
        { dataField:"orNo" ,headerText:"ORNo" ,editable : false },
        { dataField:"payTypeName" ,headerText:"PayType" ,editable : false },
        { dataField:"AdvMonth" ,headerText:"AdvMonth" ,editable : false },
        { dataField:"trNo" ,headerText:"TRNo" ,editable : false },
        { dataField:"orAmt" ,headerText:"ORTotal" ,editable : false , dataType : "numeric", formatString : "#,##0.#"},
        { dataField:"salesOrdNo" ,headerText:"OrderNo" ,editable : false },
        { dataField:"appTypeName" ,headerText:"AppType" ,editable : false },
        { dataField:"productDesc" ,headerText:"Product" ,editable : false },
        { dataField:"custName" ,headerText:"Customer" ,editable : false },
        { dataField:"custIc" ,headerText:"IC/CO No." ,editable : false },
        { dataField:"virtlAccNo" ,headerText:"VANo" ,editable : false },
        { dataField:"clctrBrnchName" ,headerText:"Branch" ,editable : false },
        { dataField:"keyinUserName" ,headerText:"UserName" ,editable : false },
        { dataField:"salesOrdId" ,headerText:"SalesOrdId" ,editable : false, visible : true}
        ];

    var slaveColumnLayout = [ 
        { dataField:"payId" ,headerText:"PayID",editable : false ,visible : false },
        { dataField:"payItmId" ,headerText:"ItemId",editable : false ,visible : false },
        { dataField:"codeName" ,headerText:"Mode",editable : false },
        { dataField:"payItmRefNo" ,headerText:"RefNo",editable : false },
        { dataField:"c7" ,headerText:"CardType" ,editable : false },
        { dataField:"codeName1" ,headerText:"CCType" ,editable : false },
        { dataField:"payItmCcHolderName" ,headerText:"CCHolder" ,editable : false },
        { dataField:"payItmCcExprDt" ,headerText:"CCExpiryDate" ,editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
        { dataField:"payItmChqNo" ,headerText:"ChequeNo" ,editable : false },
        { dataField:"name" ,headerText:"IssueBank" ,editable : false },
        { dataField:"payItmAmt" ,headerText:"Amount" ,editable : false , dataType : "numeric", formatString : "#,##0.#"},                   
        { dataField:"c8" ,headerText:"CRCMode" ,editable : false },
        { dataField:"accDesc" ,headerText:"Bank Account" ,editable : false },
        { dataField:"c3" ,headerText:"Account Code" ,editable : false },
        { dataField:"payItmRefDt" ,headerText:"RefDate" ,editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
        { dataField:"payItmAppvNo" ,headerText:"ApprNo." ,editable : false },
        { dataField:"c4" ,headerText:"EFT" ,editable : false },
        { dataField:"c5" ,headerText:"Running No" ,editable : false },
        { dataField:"payItmRem" ,headerText:"Remark" ,editable : false },
        { dataField:"payItmBankChrgAmt" ,headerText:"BankCharge" ,editable : false , dataType : "numeric", formatString : "#,##0.#"}
        ];
    
    function fn_getOrderListAjax(goPage) {
        
        //페이징 변수 세팅
        $("#pageNo").val(goPage);   
        AUIGrid.destroy(subGridID);//subGrid 초기화
        Common.ajax("GET", "/payment/selectOrderList", $("#masterForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result.resultList);
            
            //전체건수 세팅
            _totalRowCount = result.totalRowCount;
            
            //페이징 처리를 위한 옵션 설정
            var pagingPros = {
                    // 1페이지에서 보여줄 행의 수
                    rowCount : $("#rowCount").val()
            };
            
            GridCommon.createPagingNavigator(goPage, _totalRowCount , pagingPros);
        });
    }

    //마스터 그리드 페이지 이동
    function moveToPage(goPage){
      //페이징 변수 세팅
      $("#pageNo").val(goPage);
      
      Common.ajax("GET", "/payment/selectOrderListPaging.do", $("#masterForm").serialize(), function(result) {        
          AUIGrid.setGridData(myGridID, result.resultList);
          
          //페이징 처리를 위한 옵션 설정
          var pagingPros = {
                  // 1페이지에서 보여줄 행의 수
                  rowCount : $("#rowCount").val()
          };
          
          GridCommon.createPagingNavigator(goPage, _totalRowCount , pagingPros);        
      });    
    }

    //상세 그리드 (Payment) 리스트 조회.
    function fn_getPaymentListAjax() {        
        Common.ajax("GET", "/payment/selectPaymentList", $("#detailForm").serialize(), function(result) {
            AUIGrid.setGridData(subGridID, result);
        });
    }
</script>
<div id="popup_wrap" class="popup_wrap pop_win"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Order Payment Listing</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="window.close()">CLOSE</a></p></li>
        </ul>
    </header><!-- pop_header end -->
    <section class="pop_body"><!-- pop_body start -->
       <input id="callPrgm" name="callPrgm" value="${callPrgm}" type="hidden" />
        <!-- search_result start -->
	    <section class="search_result">
	        <!-- grid_wrap start -->
	        <article id="grid_wrap" class="grid_wrap"></article>
	        <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
	        <!-- grid_wrap end -->
	        
	        <!-- grid_wrap start -->
	        <article id="grid_sub_wrap" class="grid_wrap mt10"></article>
	        <!-- grid_wrap end -->
	    </section>
        <!-- search_result end -->
    </section><!-- content end -->
    <form name="masterForm" id="masterForm"  method="post">
        <input type="hidden" id="orderId" name="orderId" value="${orderId}">
        <input type="hidden" name="rowCount" id="rowCount" value="20" />
        <input type="hidden" name="pageNo" id="pageNo" />
    </form>
    <form name="detailForm" id="detailForm"  method="post">
	    <input type="hidden" name="payId" id="payId" />
	    <input type="hidden" name="salesOrdId" id="salesOrdId" />
    </form> 
</div>
        