<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var agmHistoryGridID; //AGM History Summary
    var billingGroupLatestSummaryGridID; //Billing Group Latest Summary
    var agreementGridID;
    
    //AgreementList
    var agreementList;
    
    var rentalGridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 5,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
            showStateColumn     : true,             
            displayTreeOpen     : false,            
  //          selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true
        };
    $(document).ready(function(){
    	
    	//Agreement List
    	if('${agreList}'=='' || '${agreList}' == null){
        }else{
            agreementList = JSON.parse('${agreList}');           
        }
    	
    	//AUIGrid 그리드를 생성합니다.
        billingGroupLatestSummaryGrid();
        createAUIGrid_agreement();
        
    });
    
    function billingGroupLatestSummaryGrid() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : '<spring:message code="sal.title.text.mainOrder" />',          dataField : "isMain",      width : '10%' , 
               renderer : 
		            {  type : "CheckBoxEditRenderer",
		                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
		                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
		                checkValue : 1, // true, false 인 경우가 기본
		                unCheckValue : 0
		            } 
            }
          , { headerText : '<spring:message code="sal.text.customerId" />',      dataField : "custId",        width : '15%' }
          , { headerText : '<spring:message code="sal.text.ordNo" />',  dataField : "salesOrdNo", width : '20%' }
          , { headerText : '<spring:message code="sal.text.ordDate" />', dataField : "salesDt",  width : '10%' }
          , { headerText : '<spring:message code="sal.title.status" />',   dataField : "code",    width : '10%' }
          , { headerText : '<spring:message code="sal.title.text.product" />',            dataField : "product", width : '20%' }
          , { headerText : '<spring:message code="sal.title.text.rentalFees" />',            dataField : "mthRentAmt", width : '15%' }
          ];

        billingGroupLatestSummaryGridID = GridCommon.createAUIGrid("grid_billing_summ_wrap", columnLayout, "", rentalGridPros);
        
        //Set Grid
        Common.ajax("GET","/payment/selectBillGroup.do", {orderNo:'${ordNo}'}, function(result){
            AUIGrid.setGridData(billingGroupLatestSummaryGridID, result.data.selectGroupList); 
        });
        
    }

    
    function createAUIGrid_agreement(){
        //AUIGrid 칼럼 설정
        var agreLayout = [
          {   dataField : "govAgBatchNo",  headerText : '<spring:message code="sal.title.text.agreementNo" />',         width : '20%' }
         ,{   dataField : "name",     headerText : '<spring:message code="sal.title.text.agrStatus" />',     width :'10%' }
         ,{   dataField : "govAgPrgrsName",  headerText : '<spring:message code="sal.title.text.agreementPrgs" />',         width : '30%' }
         ,{   dataField : "code",    headerText : '<spring:message code="sal.title.text.agreeType" />',        width : '20%' }
         ,{   dataField : "govAgStartDt", headerText : '<spring:message code="sal.text.startDate" />',   width : '10%' }
         ,{   dataField : "govAgEndDt",  headerText : '<spring:message code="sal.title.text.expiredDate" />',     width : '10%'  }
        ];
        agreementGridID = GridCommon.createAUIGrid("grid_amg_history_wrap", agreLayout, "", rentalGridPros);
     
	     //Set Grid
	     if(agreementList != '' ){
	         AUIGrid.setGridData(agreementGridID, agreementList);
	     } else{
	         $("#_agreDiv").hide();
	     }
     }
    
    // 리스트 조회.
//    function fn_selectRosSummList(){
    	/*  Common.ajax("GET", "/sales/order/selectDiscountJsonList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(discountGridID, result);
        }); */
  //  }
    
 //   function fn_selectBillingSummList(){
    	
 //   }
</script>
<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.rosLatestSummary" /></h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.totOutstanding" /></th>
    <td><span>${ordOutInfo.ordTotOtstnd}</span></td>
    <th scope="row"><spring:message code="sal.title.text.outstandingMonth" /></th>
    <td><span>${ordOutInfo.ordOtstndMth}</span></td>
    <th scope="row"><spring:message code="sal.title.text.unbillAmt" /></th>
    <td><span>${ordOutInfo.ordUnbillAmt}</span></td>
    <th scope="row"><spring:message code="sal.title.text.lastMonthPaid" /></th>
    <td><span>${sixMonthMap.prev1Month}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.penaltyCharges" /></th>
    <td><span>${ordOutInfo.totPnaltyChrg}</span></td>
    <th scope="row"><spring:message code="sal.title.text.penaltyPaid" /></th>
    <td><span>${ordOutInfo.totPnaltyPaid}</span></td>
    <th scope="row"><spring:message code="sal.title.text.penaltyAdjmt" /></th>
    <td><span>${ordOutInfo.totPnaltyAdj}</span></td>
    <th scope="row"><spring:message code="sal.title.text.thisMonthPaid" /></th>
    <td><span>${sixMonthMap.curMonth}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.rentalStatus" />
    </th>
    <td><span>${rentalMap.rentalStus}</span></td>
    <th scope="row"><spring:message code="sal.title.text.payMode" /></th>
    <td><span>${orderDetail.rentPaySetInf.rentPayModeDesc}</span></td>
    <th scope="row"><spring:message code="sal.text.payTerm" /></th>
    <td><span>${orderDetail.rentPaySetInf.payTrm} month(s)</span></td>
    <th scope="row"><spring:message code="sal.title.text.billedMonth" /></th>
    <td><span>${billMonthMap.rentInstNo}</span></td>
</tr>
</tbody>
</table>   

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.agmHistorySummary" /></h3>
</aside><!-- title_line end -->

<div id ="_agreDiv" >
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_amg_history_wrap" style="width:100%; height:180px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</div>

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.billingGrpLatestSummary" /></h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_billing_summ_wrap" style="width:100%; height:180px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->