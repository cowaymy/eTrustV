<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
    
    
    //생성 후 반환 Id
    var payGrid;
    var callGrid;
    
    $(document).ready(function() {
		
    	createPayGrid();
    	createCallGrid();
    	
    	//Selected Pay Tab Set Gird  and Resize
    	$("#_payTab").click(function() {
			 if(AUIGrid.getRowCount(payGrid) <= 0) {
				 fn_selectPayListAjax();
             }
			 AUIGrid.resize(payGrid, 950, 380);
		});
    	
    	//Selected Call Tab Set Gird
        $("#_callTab").click(function() {
        	if(AUIGrid.getRowCount(callGrid) <= 0) {
        		fn_selectCallListAjax();
            }
        	AUIGrid.resize(callGrid, 950, 380);
        });
    	
	});
    
    //Create Grid
    function createPayGrid(){
    	var  columnLayout = [
    	                     {dataField : "orNo", headerText : "Receipt No", width : "10%" , editable : false},
    	                     {dataField : "payOrNo", headerText : "Reverse For", width : "10%" , editable : false},
    	                     {dataField : "payData", headerText : "Payment Date", width : "10%" , editable : false},
    	                     {dataField : "codeName", headerText : "Payment Type", width : "10%" , editable : false},
    	                     {dataField : "accCode", headerText : "Debtor Acc", width : "10%" , editable : false},
    	                     {dataField : "code", headerText : "Key-In Branch (Code)", width : "15%" , editable : false},
    	                     {dataField : "name1", headerText : "Key-In Branch (Name)", width : "15%" , editable : false},
    	                     {dataField : "totAmt", headerText : "Total Amount", width : "10%" , editable : false},
    	                     {dataField : "userName", headerText : "Creator", width : "10%" , editable : false}
    	                     
    	               ]
    	               
    	               //그리드 속성 설정
    	               var gridPros = {
    	                       usePaging           : true,         //페이징 사용
    	                       pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
    	                       editable            : false,            
    	                       fixedColumnCount    : 0,            
    	                       showStateColumn     : false,             
    	                       displayTreeOpen     : true,            
    	//                       selectionMode       : "singleRow",  //"multipleCells",            
    	                       headerHeight        : 30,       
    	                       rowHeight           : 150,   
    	                       wordWrap            : true, 
    	                       useGroupingPanel    : false,        //그룹핑 패널 사용
    	                       skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    	                       wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    	                       showRowNumColumn    : false,         //줄번호 칼럼 렌더러 출력    
    	                       noDataMessage       : "No order found.",
    	                       groupingMessage     : "Here groupping"
    	                   };
    	               
    	payGrid = GridCommon.createAUIGrid("#pay_grid_wrap", columnLayout, gridPros);
    }
    
    function createCallGrid(){
    	
    	var  columnLayout = [
                             {dataField : "code", headerText : "Status", width : "10%" , editable : false},
                             {dataField : "cnfmLogMsg", headerText : "Call Message", width : "35%" , editable : false},
                             {dataField : "cnfmLogSmsMsg", headerText : "SMS Message", width : "35%" , editable : false},
                             {dataField : "userName", headerText : "Key By", width : "10%" , editable : false},
                             {dataField : "cnfmLogCrtDt", headerText : "Key At", width : "10%" , editable : false}
                       ]
                       
                       //그리드 속성 설정
                       var gridPros = {
                               usePaging           : true,         //페이징 사용
                               pageRowCount        : 5,           //한 화면에 출력되는 행 개수 20(기본값:20)            
                               editable            : false,            
                               fixedColumnCount    : 0,            
                               showStateColumn     : false,             
                               displayTreeOpen     : true,            
             //                  selectionMode       : "singleRow",  //"multipleCells",            
                               headerHeight        : 30,       
                               rowHeight           : 150,   
                               wordWrap            : true, 
                               useGroupingPanel    : false,        //그룹핑 패널 사용
                               skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                               wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                               showRowNumColumn    : false,         //줄번호 칼럼 렌더러 출력    
                               noDataMessage       : "No transaction found in this call.",
                               groupingMessage     : "Here groupping"
                           };
                       
    	callGrid = GridCommon.createAUIGrid("#call_grid_wrap", columnLayout, gridPros);
    }
    
    
    //Call Ajax
    function fn_selectPayListAjax(){
    	
    	Common.ajax("GET", "/sales/ccp/selectPaymentList",  $("#ajaxForm").serialize(), function(result) {
            AUIGrid.setGridData(payGrid, result);
            
       });
    }
    
    
    function fn_selectCallListAjax(){
    	Common.ajax("GET", "/sales/ccp/selectCallLogList",  $("#ajaxForm").serialize(), function(result) {
            AUIGrid.setGridData(callGrid, result);
            
       });
    }
    
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>CCP RentalMembership View</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Membership Info</a></li>
    <li><a href="#">Order Info</a></li>
    <li><a href="#">Rental Payment Info</a></li>
    <li><a href="#">Mailing Info</a></li> 
    <li><a href="#" id="_payTab">Payment List</a></li>  
    <li><a href="#" id="_callTab">Call Log List</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->
<form id="ajaxForm">
    <input type="hidden" name="cnfmCntrctId" value="${cnfmCntrctId}">
</form>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Membership No.</th>
    <td><span>${contractInfo.srvCntrctRefNo}</span></td>
    <th scope="row">Membership Type</th>
    <td><span>${contractInfo.codeName}</span></td>
    <th scope="row">Membership Key-In Date</th> 
    <td><span>${contractInfo.srvCntrctCrtDt}</span></td>
</tr>
<tr>
    <th scope="row">Membership Status</th>
    <td><span>${contractInfo.code}</span></td>
    <th scope="row">Rental Status</th> 
    <td><span>${contractInfo.cntrctRentalStus}</span></td>
    <th scope="row">PO Number</th>
    <td><span>${contractInfo.poRefNo}</span></td> 
</tr>
<tr>
    <th scope="row">Package</th>
    <td colspan="3"><span>${contractInfo.srvCntrctPacDesc}</span></td> 
    <th scope="row">Duration</th> 
    <td><span>
    <c:if test="${not empty contractInfo.qotatCntrctDur}">
        ${contractInfo.qotatCntrctDur} month(s)
    </c:if>
    </span></td>
</tr>
<tr>
    <th scope="row">Membership Fee</th> 
    <td><span> ${contractInfo.srvCntrctRental}</span></td>
    <th scope="row">Outstanding Amount</th>
    <td><span>${unbillMap.outstanding}</span></td>
    <th scope="row">Unbill Amount</th>
    <td><span>${unbillMap.unbillAmt}</span></td>
</tr>
<tr>
    <th scope="row">Package Promotion</th>
    <td colspan="5"><span> ${contractInfo.promoDesc}</span></td> 
</tr>
<tr>
    <th scope="row">Filter Promotion</th>
    <td colspan="3"><span>${contractInfo.promoDesc1}</span></td>
    <th scope="row">BS Frequency</th>
    <td><span>
    <c:if test="${not empty contractInfo.qotatCntrctFreq}">
        ${contractInfo.qotatCntrctFreq} month(s)
    </c:if>
    </span></td> 
</tr>
<tr>
    <th scope="row">Updator</th>
    <td><span>${contractInfo.username1}</span></td>
    <th scope="row">Updated</th>
    <td><span>${contractInfo.srvCntrctUpdDt}</span></td> 
    <th scope="row"></th>
    <th scope="row"></th>
</tr>
<tr>
    <th scope="row">Membership F/B Code</th>
    <td colspan="5"><span>${contractInfo.resnDesc}</span></td>  
</tr>
<tr>
    <th scope="row">Membership Remark</th>
    <td colspan="5"><span>${contractInfo.cnfmRem}</span></td> 
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Sales Person Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Sales Person</th>
    <td><span>
    ${contractInfo.memCode}
    <c:if test="${not empty contractInfo.name}">
        &nbsp;-&nbsp; ${contractInfo.name}
    </c:if>
    </span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No</th>
    <td><span>${orderInfoMap.ordNo}</span></td>
    <th scope="row">Order Date</th>
    <td><span>${orderInfoMap.ordDt}</span></td>
    <th scope="row">Order Status</th>
    <td><span>${orderInfoMap.ordStusName}</span></td> 
</tr>
<tr>
    <th scope="row">Product Category</th>
    <td colspan="3"><span>${orderInfoMap.stkCtgryName}</span></td> 
    <th scope="row">Application Type</th>
    <td><span>${orderInfoMap.appTypeCode}</span></td> 
</tr>
<tr>
    <th scope="row">Product Code</th>
    <td><span>${orderInfoMap.stockCode}</span></td> 
    <th scope="row">Product Name</th>
    <td colspan="3"><span>${orderInfoMap.stockDesc}</span></td> 
</tr>
<tr>
    <th scope="row">Customer ID</th>
    <td><span>${orderInfoMap.custId}</span></td> 
    <th scope="row">NRIC/Company No</th>
    <td colspan="3"><span>${orderInfoMap.custNric}</span></td> 
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="5"><span>${orderInfoMap.custName}</span></td>
</tr>
<tr>
    <th scope="row">Last Nembership</th>
    <td colspan="3"><span>${cofigMap.lastMembership}</span></td>
    <th scope="row">Expire Date</th>
    <td><span>${cofigMap.srvPrdExprDt}</span></td>
</tr>
<tr>
    <th scope="row">Install Address</th>
    <td colspan="5"><span>${installMap.fullAddress }</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Payment Mode</th>
    <td><span>${payMap.codeName }</span></td>
    <th scope="row">Name On Card</th>
    <td colspan="3"><span>
    <c:if test="${empty payMap.custCrcOwner}">
        -
    </c:if>
    <c:if test="${not empty payMap.custCrcOwner}">
        ${payMap.custCrcOwner}
    </c:if>
    </span></td>
</tr>
<tr>
    <th scope="row">Credit Card No.</th>
    <td>
        <c:if test="${empty payMap.custCrcNo }">
            -
        </c:if>
        <c:if test="${not empty payMap.custCrcNo }">
            ${payMap.custCrcNo}
        </c:if>
     </td>
    <th scope="row">Card Type</th>
    <td><span>
    <c:if test="${empty payMap.codeName1}">
        -
    </c:if>
    <c:if test="${not empty payMap.codeName1}">
        ${payMap.codeName1}
    </c:if>
    </span></td> 
    <th scope="row">Expiry Date</th>
    <td><span> 
    <c:if test="${not empty payMap.custCrcExpr}">
        ${payMap.custCrcExpr}
    </c:if>
    <c:if test="${empty payMap.custCrcExpr}">
        -
    </c:if>
    </span></td> 
</tr>
<tr>
    <th scope="row">Bank Acc No.</th>
    <td><span>
    <c:if test="${empty payMap.custAccNo}">
        -
    </c:if>
    <c:if test="${not empty payMap.custAccNo}">
        ${payMap.custAccNo}
    </c:if>
    </span></td>
    <th scope="row">Issue Bank</th>
    <td><span>
    <c:if test="${not empty payMap.bankCode}">
        ${payMap.bankCode}
    </c:if>
    <c:if test="${not empty payMap.bankName}">
        - ${payMap.bankName}
    </c:if>  
    </span></td>
    <th scope="row">Account Name</th>
    <td><span>
    <c:if test="${empty payMap.custAccOwner}">
        -
    </c:if>
    <c:if test="${not empty payMap.custAccOwner}">
        ${payMap.custAccOwner}
    </c:if>
    </span></td>
</tr>
<tr>
    <th scope="row">Pay By Third Party</th>
    <td><span>
    <c:if test="${payMap.is3rdParty eq 0}">
        No
    </c:if>
    <c:if test="${payMap.is3rdParty eq 1}">
        Yes
    </c:if>
    </span></td>
    <th scope="row">Third Party ID</th>
    <td><span>
        <c:if test="${not empty thirdMap}">
            ${thirdMap.custId}
        </c:if>
        <c:if test="${empty thirdMap}">
            -
        </c:if>
    </span></td>
    <th scope="row">Third Party Type</th>
    <td><span>
    <c:if test="${not empty thirdMap}">
            ${thirdMap.codeName1}
     </c:if>
     <c:if test="${empty thirdMap}">
            -
     </c:if>
    </span></td>
</tr>
<tr>
    <th scope="row">Third Party Name</th>
    <td colspan="3"><span>
     <c:if test="${not empty thirdMap}">
	       ${thirdMap.name}
	 </c:if>
	 <c:if test="${empty thirdMap}">
	       -
	 </c:if>
    </span></td>
    <th scope="row">Third Party NRIC</th>
    <td><span>
    <c:if test="${not empty thirdMap}">
           ${thirdMap.nric}
     </c:if>
     <c:if test="${empty thirdMap}">
           -
     </c:if>
    </span></td>
</tr>
<tr>
    <th scope="row">Apply Date</th>
    <td><span>${payMap.ddApplyDt}</span></td>
    <th scope="row">Submit Date</th>
    <td><span>${payMap.ddSubmitDt}</span></td>
    <th scope="row">Start Date</th>
    <td><span>${payMap.ddStartDt}</span></td> 
</tr>
<tr>
    <th scope="row">Reject Date</th>
    <td><span>${payMap.ddRejctDt}</span></td>
    <th scope="row">Reject Code</th>
    <td><span>${payMap.resnCode}</span></td>  
    <th scope="row">Payment Term</th>
    <td><span>
    <c:if test="${not empty payMap.payTrm}">
        ${payMap.payTrm} month(s)
    </c:if>
    </span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="3">Mailing Address</th>
    <td colspan="3"><span>${mailMap.mailAdd1}</span></td>
    <th scope="row">Country</th>
    <td><span>${mailMap.mailCnty}</span></td>
</tr>
<tr>
    <td colspan="3"><span>${mailMap.mailAdd2}</span></td>
    <th scope="row">State</th>
    <td><span>${mailMap.mailState}</span></td>
</tr>
<tr>
    <td colspan="3"><span>${mailMap.mailAdd3}</span></td>
    <th scope="row">Area</th>
    <td><span>${mailMap.mailArea}</span></td>
</tr>
<tr>
    <th scope="row">Billing Group</th>
    <td><span>${mailMap.billGrpNo}</span></td>
    <th scope="row">Billing Type</th>
    <td>
    <label>
  <c:choose>
    <c:when test="${mailMap.billSms != 0}">
       <input type="checkbox" onClick="return false" checked/>
       <span class="txt_box">SMS<i>${mailMap.mailCntTelM}</i></span>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span>SMS</span>
    </c:otherwise>
  </c:choose>
    </label>
    <label>
  <c:choose>
    <c:when test="${mailMap.billPost != 0}">
       <input type="checkbox" onClick="return false" checked/>
       <span class="txt_box">Post<i>${mailMap.fullAddress}</i></span>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span>Post</span>
    </c:otherwise>
  </c:choose>
    </label>
    <label>
  <c:choose>
    <c:when test="${mailMap.billState != 0}">
       <input type="checkbox" onClick="return false" checked/>
       <span class="txt_box">E-statement><i>${mailMap.billStateEmail}</i></span>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span>E-statement</span>
    </c:otherwise>
  </c:choose>
     </label>
    </td>
    <th scope="row">Postcode</th>
    <td><span>${mailMap.mailPostCode}</span></td>
</tr>
<tr>
    <th scope="row">Contact Name</th>
    <td colspan="3"><span>${mailMap.mailCntName}</span></td>
    <th scope="row">Gender</th>
    <td><span>${mailMap.mailCntGender}</span></td>
</tr>
<tr>
    <th scope="row">Contact NRIC</th>
    <td><span>${mailMap.mailCntNric}</span></td>
    <th scope="row">Email</th>
    <td><span>${mailMap.mailCntEmail}</span></td>
    <th scope="row">Fax No</th>
    <td><span>${mailMap.mailCntTelF}</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>${mailMap.mailCntTelM}</span></td>
    <th scope="row">Office No</th>
    <td><span>${mailMap.mailCntTelO}</span></td>
    <th scope="row">House No</th>
    <td><span>${mailMap.mailCntTelR}</span></td>
</tr>
<tr>
    <th scope="row">Post</th>
    <td><span>${mailMap.mailCntPost}</span></td>
    <th scope="row">Department</th>
    <td><span>${mailMap.mailCntDept}</span></td>
</tr>

</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="pay_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start --> 
<div id="call_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div>
