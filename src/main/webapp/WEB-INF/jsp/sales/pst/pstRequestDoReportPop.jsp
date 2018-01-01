<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
    
    //AUIGrid 생성 후 반환 ID
    var myGridID;
    
    $(document).ready(function(){
        
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        //Call Ajax
        fn_getStockListAjax();
      
    });
    
    function createAUIGrid() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [{
                dataField : "code",
                headerText : "PST Type",
                width : 80,
                editable : false
            }, {
                dataField : "pstRefNo",
                headerText : "PST Ref No",
                width : 110,
                editable : false
            }, {
                dataField : "stkCodeDesc",
                headerText : "Stock Description",
                width : 200,
                editable : false
            }, {
                dataField : "pstQty",
                headerText : "Quantity",
                width : 80,
                editable : false
            }, {
                dataField : "pstStockRem",
                headerText : "Remark",
                editable : false
            }, {
                dataField : "crtDt",
                headerText : "Create Date",
                dataType : "date",
                formatString : "mm/dd/yyyy" ,
                width : 100,
                editable : false
            }, {
                dataField : "userName",
                headerText : "Creator",
                width : 100,
                editable : false
            }];
       
        // 그리드 속성 설정
        var gridPros = {
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 10,
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
            showRowNumColumn : true,
            groupingMessage : "Here groupping"
        };
        
        myGridID = GridCommon.createAUIGrid("#stock_grid_wrap", columnLayout, gridPros);
    }
    
    function fn_getStockListAjax(){
        Common.ajax("GET", "/sales/pst/reportGrid.do",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }
    
    //resize func (tab click)
    function fn_resizefunc(gridName){ // 
        AUIGrid.resize(gridName, 900, 250);
   }
    
    function fn_report() {
    	//CURRENT DATE
        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }
        $("#reportDownFileName").val('PSTTransactionLoglisting_'+date+(new Date().getMonth()+1)+new Date().getFullYear()); //DOWNLOAD FILE NAME
        
    	var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
        };
    	
    	Common.report("dataForm", option);
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>PST REQUEST INFOMATION</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="autoClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<article class="tap_area"><!-- tap_area start -->
<form id="getParamForm" name="getParamForm" method="GET">
    <input type="hidden" id="pstSalesOrdId" name="pstSalesOrdId" value="${pstInfo.pstSalesOrdId}">
    <input type="hidden" id="pstStusIdParam" name="pstStusIdParam" value="${pstStusIdParam}">
    <input type="hidden" id="pstSalesOrdIdParam" name="pstSalesOrdIdParam" value="${pstSalesOrdIdParam}">
    <input type="hidden" id="pstDealerDelvryCntId" name="pstDealerDelvryCntId" value="${pstDealerDelvryCntId}">
    <input type="hidden" id="pstDealerMailCntId" name="pstDealerMailCntId" value="${pstDealerMailCntId}">
    <input type="hidden" id="pstDealerDelvryAddId" name="pstDealerDelvryAddId" value="${pstDealerDelvryAddId}">
    <input type="hidden" id="pstDealerMailAddId" name="pstDealerMailAddId" value="${pstDealerMailAddId}">
</form>
<form id="dataForm" name="dataForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/PSTTransactionLoglisting_PDF.rpt" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="V_PSOID" name="V_PSOID" value="${pstInfo.pstSalesOrdId}" />
</form>
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
    <th scope="row">PSO ID</th>
    <td><span>${pstInfo.pstSalesOrdId}</span></td>
    <th scope="row">PSO RefNo</th>
    <td><span>${pstInfo.pstRefNo}</span></td>
    <th scope="row">Customer PO</th>
    <td><span>${pstInfo.pstCustPo}</span></td>
</tr>
<tr>
    <th scope="row">Currency Type</th>
    <td><span>${pstInfo.pstCurTypeCode}</span></td>
    <th scope="row">Currency Rate</th>
    <td><span>${pstInfo.pstCurRate}</span></td>
    <th scope="row">Person In Charge</th>
    <td><span>${pstInfo.picName}</span></td>
</tr>
<tr>
    <th scope="row">PSO Status</th>
    <td><span>${pstInfo.pstStusCode}</span></td>
    <th scope="row">Create By</th>
    <td><span>${pstInfo.crtUserName}</span></td>
    <th scope="row">Create At</th>
    <td><span>${pstInfo.crtDt}</span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5"><span>${pstInfo.pstRem}</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="stock_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript: fn_report();">Generate</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->