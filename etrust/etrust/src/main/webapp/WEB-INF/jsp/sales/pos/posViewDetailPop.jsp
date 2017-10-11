<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
  
  //AUIGrid 생성 후 반환 ID  
  var posDetGridID;
  var paymentGridID;
  
  $(document).ready(function() {
    
      createPosGrid();
      createPaymentGrid();
      
      fn_getPosViewListAjax(); // Pos list
      fn_getPayMentAjax(); //Payment list
      
     /*  fn_resizefunc(posDetGridID);
      fn_resizefunc(paymentGridID); */
      
  });
  
  function fn_getPayMentAjax(){
     
      Common.ajax("GET", "/sales/pos/selectPosPaymentJsonList",$("#getParamForm").serialize(), function(result) {
          AUIGrid.setGridData(paymentGridID, result);
      });
      
  };
  
  function fn_getPosViewListAjax(){
      Common.ajax("GET", "/sales/pos/selectPosDetailJsonList",$("#getParamForm").serialize(), function(result) {
          AUIGrid.setGridData(posDetGridID, result);
      });
  };
  
  
  
  function createPosGrid(){
      // Pos Column
      var posColumnLayout = [ 
           {dataField : "stkCode", headerText : "Item Code", width : '10%'}, 
           {dataField : "stkDesc", headerText : "Item Description", width : '40%'},
           {dataField : "posItmQty", headerText : "Qty", width : '10%'},  
           {dataField : "posItmUnitPrc", headerText : "Unit Price", width : '10%'}, 
           {dataField : "posItmChrg", headerText : "Sub Total(Exclude GST)", width : '10%'}, 
           {dataField : "posItmTxs", headerText : "GST(6%)", width : '10%'},
           {dataField : "posItmTot", headerText : "Total", width : '10%'}
       ];
      
      //그리드 속성 설정
      var gridPros = {
              
              usePaging           : true,         //페이징 사용
              pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
              editable            : false,            
              fixedColumnCount    : 1,            
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
      
      posDetGridID = GridCommon.createAUIGrid("pos_detail_grid_wrap", posColumnLayout,'', gridPros);    // Pos list 
      
  }
  
  function createPaymentGrid(){
      
      var paymentColumnLayout = [ 
           {dataField : "codeDesc", headerText : "Mode", width : '10%'}, 
           {dataField : "payItmRefNo", headerText : "Ref No", width : '10%'},
           {dataField : "payItmAmt", headerText : "Amount", width : '10%'},  
           {dataField : "payItmOriCcNo", headerText : "C.Card", width : '10%'}, 
           {dataField : "payItmAppvNo", headerText : "Aproval No", width : '10%'}, 
           {dataField : "codeName", headerText : "CRC Mode", width : '10%'},
           {dataField : "name", headerText : "Issued Bank", width : '10%'},
           {dataField : "accDesc", headerText : "Bank Acc", width : '10%'},
           {dataField : "payItmRefDt", headerText : "Ref Date", width : '10%'},
           {dataField : "payItmRem", headerText : "Remark", width : '10%'}
       ];
                        
      //그리드 속성 설정
      var gridPros = {
              
              usePaging           : true,         //페이징 사용
              pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
              editable            : false,            
              fixedColumnCount    : 1,            
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
                        
      paymentGridID = GridCommon.createAUIGrid("payment_grid_wrap", paymentColumnLayout,'', gridPros);    // Payment list 
      
  }
  
  //resize func (tab click)
  function fn_resizefunc(gridName){
      AUIGrid.resize(gridName, 1600, 300);
 }
  
  function fn_resize(){
      
      fn_resizefunc(posDetGridID);
      fn_resizefunc(paymentGridID);
      
  }
</script>



<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Point Of Sales View</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close" >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on" onclick="javascript : fn_resize()">Purchase Info</a></li>
    <li><a href="#" onclick="javascript : fn_resize()">Payment Mode</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<div class="divine_auto"><!-- divine_auto start -->

<div style="width:60%;">

<aside class="title_line"><!-- title_line start -->
<h3>Particular Information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">POS Type</th>
    <td><span>${purchaseMap.codeName}</span></td>
</tr>
<tr>
    <th scope="row">Reference No</th> <!--    //purchaseMap  // detailMap // payMap  -->
    <td><span><b>${purchaseMap.posNo}</b></span></td>
</tr>
<tr>
    <th scope="row">Related No</th>
    <td><span>${purchaseMap.posNo1}</span></td>
</tr>
<tr>
    <th scope="row">Member Code</th>
    <td><span>${purchaseMap.memCode} <c:if test="${not empty purchaseMap.name}"> - ${purchaseMap.name}</c:if></span></td>
</tr>
<tr>
    <th scope="row">Sales Type</th>
    <td><span>${purchaseMap.codeName1}</span></td>
</tr>
<tr>
    <th scope="row">Sales Date</th>
    <td><span>${purchaseMap.posDt}</span></td>
</tr>
<tr>
    <th scope="row">Creator</th>
    <td><span>
        ${purchaseMap.userName}
    <c:if test="${not empty purchaseMap.userFullName}">
        - ${purchaseMap.userFullName}
    </c:if>
    </span></td>
</tr>
<tr>
    <th scope="row">Warehouse</th> 
    <td><span>${purchaseMap.whLocCode} <c:if test="${not empty purchaseMap.whLocDesc}"> - ${purchaseMap.whLocDesc}</c:if></span></td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td><span>${purchaseMap.posCustName}</span></td>
</tr>
<tr>
    <th scope="row">Address</th>
    <td><span>${purchaseMap.fullAddress}</span></td> 
</tr>
<tr>
    <th scope="row">POS Reason</th>
    <td><span>${purchaseMap.resnDesc}</span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td><span>${purchaseMap.posRem}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</div>
<div style="width:40%;">
<aside class="title_line"><!-- title_line start --> 
<h3>Charges Balance</h3>
<ul class="right_btns">
    <li><strong>RM ${purchaseMap.posTotAmt}</strong></li>
</ul>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Total</th>
    <td><span>${purchaseMap.posTotChrg}</span></td> 
</tr>
<tr>
    <th scope="row">GST (6%)</th>
    <td><span>${purchaseMap.posTotTxs}</span></td>
</tr>
<tr>
    <th scope="row">Discount</th>
    <td><span>${purchaseMap.posTotDscnt}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</div>
</div><!-- divine_auto end -->
<article class="grid_wrap"><!-- grid_wrap start -->
   <div id="pos_detail_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h3>Payment Information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Total Charges</th>
    <td><span>${purchaseMap.posTotAmt}</span></td>
    <th scope="row">Receipt No</th>
    <td><span><b>${purchaseMap.orNo}</b></span></td>
    <th scope="row">Debtor Acc</th>
    <td><span>${purchaseMap.accCode} <c:if test="${not empty purchaseMap.accDesc}"> - ${purchaseMap.accDesc}</c:if></span></td>
</tr>
<tr>
    <th scope="row">Branch Code</th>
    <td><span>${purchaseMap.branchCode} <c:if test="${not empty purchaseMap.branchName}"> - ${purchaseMap.branchName}</c:if></span></td>
    <th scope="row">TR Ref No</th>
    <td><span>${purchaseMap.trNo}</span></td>
    <th scope="row">TR Issued Date</th>
    <td><span>${purchaseMap.trIssuDt}</span></td> 
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns mt40">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
   <div id="payment_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</article><!-- tap_area end -->

</section> <!--tap_wrap end  -->
</section><!-- pop_body end -->
</div><!-- popup_wrap end -->