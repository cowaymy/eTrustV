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
            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
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
            { headerText : "Main Order",          dataField : "isMain",      width : '10%' , 
               renderer : 
		            {  type : "CheckBoxEditRenderer",
		                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
		                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
		                checkValue : 1, // true, false 인 경우가 기본
		                unCheckValue : 0
		            } 
            }
          , { headerText : "Customer ID",      dataField : "custId",        width : '15%' }
          , { headerText : "Order No",  dataField : "salesOrdNo", width : '20%' }
          , { headerText : "Order Date", dataField : "salesDt",  width : '10%' }
          , { headerText : "Status",   dataField : "code",    width : '10%' }
          , { headerText : "Product",            dataField : "product", width : '20%' }
          , { headerText : "Rental Fees",            dataField : "mthRentAmt", width : '15%' }
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
          {   dataField : "govAgBatchNo",  headerText : 'Agreement No.',         width : '20%' }
         ,{   dataField : "name",     headerText : 'Agreement Status',     width :'10%' }
         ,{   dataField : "govAgPrgrsName",  headerText : 'Agreement Progress',         width : '30%' }
         ,{   dataField : "code",    headerText : 'Agreement Type',        width : '20%' }
         ,{   dataField : "govAgStartDt", headerText : 'Start Date',   width : '10%' }
         ,{   dataField : "govAgEndDt",  headerText : 'Expired Date',     width : '10%'  }
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
<h3>ROS Latest Summary</h3>
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
    <th scope="row">Total Outstanding</th>
    <td><span>${ordOutInfo.ordTotOtstnd}</span></td>
    <th scope="row">Outstanding Month</th>
    <td><span>${ordOutInfo.ordOtstndMth}</span></td>
    <th scope="row">Unbill Amount</th>
    <td><span>${ordOutInfo.ordUnbillAmt}</span></td>
    <th scope="row">Last Month Paid</th>
    <td><span>${sixMonthMap.prev1Month}</span></td>
</tr>
<tr>
    <th scope="row">Penalty Charges</th>
    <td><span>${ordOutInfo.totPnaltyChrg}</span></td>
    <th scope="row">Penalty Paid</th>
    <td><span>${ordOutInfo.totPnaltyPaid}</span></td>
    <th scope="row">Penalty Adjustment</th>
    <td><span>${ordOutInfo.totPnaltyAdj}</span></td>
    <th scope="row">This Month Paid</th>
    <td><span>${sixMonthMap.curMonth}</span></td>
</tr>
<tr>
    <th scope="row">Rental Status</th>
    <td><span>${rentalMap.rentalStus}</span></td>
    <th scope="row">Pay Mode</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayModeDesc}</span></td>
    <th scope="row">Payment Term</th>
    <td><span>${orderDetail.rentPaySetInf.payTrm} month(s)</span></td>
    <th scope="row">Billed Month</th>
    <td><span>${billMonthMap.rentInstNo}</span></td>
</tr>
</tbody>
</table>   

<aside class="title_line"><!-- title_line start -->
<h3>AGM History Summary</h3>
</aside><!-- title_line end -->

<div id ="_agreDiv" >
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_amg_history_wrap" style="width:100%; height:180px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</div>

<aside class="title_line"><!-- title_line start -->
<h3>Billing Group Latest Summary</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_billing_summ_wrap" style="width:100%; height:180px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->