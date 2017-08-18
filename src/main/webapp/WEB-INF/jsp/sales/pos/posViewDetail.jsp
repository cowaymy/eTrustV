<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
  
  //AUIGrid 생성 후 반환 ID  
  var posGridID;
  var paymentGridID;
  
  $(document).ready(function() {
	
	  createPosGrid();
	  createPaymentGrid();
	  
	  fn_getPosListAjax(); // Pos list
	  fn_getPayMentAjax(); //Payment list
	  
	  fn_resizefunc(posGridID);
	  fn_resizefunc(paymentGridID);
	  
  });
  
  function fn_getPayMentAjax(){
	 
	  Common.ajax("GET", "/sales/pos/selectPosPaymentJsonList",$("#getParamForm").serialize(), function(result) {
          AUIGrid.setGridData(paymentGridID, result);
      });
	  
  };
  
  function fn_getPosListAjax(){
	  Common.ajax("GET", "/sales/pos/selectPosDetailJsonList",$("#getParamForm").serialize(), function(result) {
          AUIGrid.setGridData(posGridID, result);
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
      
      posGridID = GridCommon.createAUIGrid("pos_grid_wrap", posColumnLayout,'', gridPros);    // Pos list 
      
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
	  
	  fn_resizefunc(posGridID);
      fn_resizefunc(paymentGridID);
	  
  }
</script>
<div id="wrap"><!-- wrap start -->
<form id="getParamForm">
    <input type="hidden" name="posId" id="_posId"  value="${purchaseMap.posId}"> 
    <input type="hidden" name="payId" id="_payId" value="${purchaseMap.payId}">
</form>
<header id="header"><!-- header start -->
<ul class="left_opt">
    <li>Neo(Mega Deal): <span>2394</span></li> 
    <li>Sales(Key In): <span>9304</span></li> 
    <li>Net Qty: <span>310</span></li>
    <li>Outright : <span>138</span></li>
    <li>Installment: <span>4254</span></li>
    <li>Rental: <span>4702</span></li>
    <li>Total: <span>45080</span></li>
</ul>
<ul class="right_opt">
    <li>Login as <span>KRHQ9001-HQ</span></li>
    <li><a href="#" class="logout">Logout</a></li>
    <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_home.gif" alt="Home" /></a></li>
    <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_set.gif" alt="Setting" /></a></li>
</ul>
</header><!-- header end -->
<hr />
        
<section id="container"><!-- container start -->

<aside class="lnb_wrap"><!-- lnb_wrap start -->

<header class="lnb_header"><!-- lnb_header start -->
<form action="#" method="post">
<h1><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/logo.gif" alt="eTrust system" /></a></h1>
<p class="search">
<input type="text" title="검색어 입력" />
<input type="image" src="${pageContext.request.contextPath}/resources/images/common/icon_lnb_search.gif" alt="검색" />
</p>

</form>
</header><!-- lnb_header end -->

<section class="lnb_con"><!-- lnb_con start -->
<p class="click_add_on_solo on"><a href="#">All menu</a></p>
<ul class="inb_menu">
    <li class="active">
    <a href="#" class="on">menu 1depth</a>

    <ul>
        <li class="active">
        <a href="#" class="on">menu 2depth</a>

        <ul>
            <li class="active">
            <a href="#" class="on">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
        </ul>

        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
    </ul>

    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
</ul>
<p class="click_add_on_solo"><a href="#"><span></span>My menu</a></p>
<ul class="inb_menu">
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
</ul>
</section><!-- lnb_con end -->

</aside><!-- lnb_wrap end -->

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>POS View Details</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

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
    <th scope="row">Address 1</th>
    <td><span>${purchaseMap.posAddr1}</span></td>
</tr>
<tr>
    <th scope="row">Address 2</th>
    <td><span>${purchaseMap.posAddr2}</span></td>
</tr>
<tr>
    <th scope="row">Address 3</th>
    <td><span>${purchaseMap.posAddr3}</span></td>
</tr>
<tr>
    <th scope="row">Address 4</th>
    <td><span>${purchaseMap.posAddr4}</span></td>
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
   <div id="pos_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
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
</section><!-- tap_wrap end -->
</section><!-- content end -->
</section><!-- container end -->
<hr />
</div><!-- wrap end -->
