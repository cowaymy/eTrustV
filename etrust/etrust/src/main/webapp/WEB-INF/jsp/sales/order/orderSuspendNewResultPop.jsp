<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    //AUIGrid 생성 후 반환 ID
    var inchargeGridID; 
    var callResultGridID;
    var callLogGirdID;
    
    $(document).ready(function(){
        
 //       createInchargeGrid();
        createCallResultGrid();
        createcallLogGird();
        
        //Call Ajax
 //       fn_getInchargeAjax(); 
        fn_getCallResultAjax();
        fn_getCallLogAjax();
    });
    
    
    function createCallResultGrid() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var callResultColumnLayout = [{
                dataField : "stusCode",
                headerText : "Status",
                width : 110,
                editable : false
            }, {
                dataField : "recalldt",
                headerText : "Recall Date",
                width : 130,
                editable : false
            }, {
                dataField : "resnDesc",
                headerText : "Feedback",
                width : 160,
                editable : false
            }, {
                dataField : "callRem",
                headerText : "Remark",
                editable : false
            }, {
                dataField : "callCrtUserName",
                headerText : "Key By",
                width : 110,
                editable : false
            }, {
                dataField : "callCrtDt",
                headerText : "Key At",
                dataType : "date", 
                formatString : "dd/mm/yyyy",
                width : 120,
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
            showStateColumn : true, 
            displayTreeOpen : true,
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : true,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
            groupingMessage : "Here groupping"
        };
        
        callResultGridID = GridCommon.createAUIGrid("#callResult_grid_wrap", callResultColumnLayout, gridPros);
    }
    
    function createcallLogGird() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var callLogColumnLayout = [{
                dataField : "codeName",
                headerText : "Type",
                width : 130,
                editable : false
            }, {
                dataField : "'resnDesc",
                headerText : "Feedback",
                width : 160,
                editable : false
            }, {
                dataField : "stusCodeName",
                headerText : "Action",
                width : 120,
                editable : false
            }, {
                dataField : "callRosAmt",
                headerText : "Amount",
                width : 100,
                editable : false
            },{
                dataField : "callRem",
                headerText : "Remark",
                editable : false
            }, {
                dataField : "rosCallerUserName",
                headerText : "Caller",
                width : 110,
                editable : false
            }, {
                dataField : "callCrtUserName",
                headerText : "Creator",
                width : 110,
                editable : false
            },{
                dataField : "callCrtDt",
                headerText : "CreateDate",
                dataType : "date", 
                formatString : "dd/mm/yyyy",
                width : 120,
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
            showStateColumn : true, 
            displayTreeOpen : true,
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : true,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
            groupingMessage : "Here groupping"
        };
        
        callLogGirdID = GridCommon.createAUIGrid("#callLog_grid_wrap", callLogColumnLayout, gridPros);
    }
    
    // contact Ajax
//    function fn_getInchargeAjax(){
//        Common.ajax("GET", "/sales/order/inchargePersonList.do",$("#getParamForm").serialize(), function(result) {
//            AUIGrid.setGridData(inchargeGridID, result);
//        });
//    }
    
 // contact Ajax
    function fn_getCallResultAjax(){
        Common.ajax("GET", "/sales/order/suspendCallResultList.do",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(callResultGridID, result);
        });
    }
 
 // contact Ajax
    function fn_getCallLogAjax(){
        Common.ajax("GET", "/sales/order/callResultLogList.do",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(callLogGirdID, result);
        });
    }
 
  //resize func (tab click)
    function fn_resizefunc(gridName){ //
        if(gridName == '#callResult_grid_wrap'){
        	AUIGrid.resize(gridName, 900, 200);
        }else{
        	AUIGrid.resize(gridName, 900, 300);
        }
   }
  
  function fn_saveSuspendResult(){
	  var time = new Date();
	  var day = time.getDate();
	  
	  if( day >= 26 || day == 1){
		  Common.alert("This action is not allowed within 26 to 1 next month.");
		  return false;
	  }
	  
	  if(document.statusForm.newSuspResultStus.value == ""){
		  Common.alert("Please select the status");
		  return false;
	  }
	  
	  if(document.statusForm.newSuspResultRem.value == ""){
          Common.alert("Please key in the remark");
          return false;
      }
	  
	    Common.ajax("GET", "/sales/order/newSuspendResult.do", $("#statusForm").serializeJSON(), function(result) {
	    	Common.alert(result.msg, fn_reloadPage);
	    }, function(jqXHR, textStatus, errorThrown) {
	            try {
	                console.log("status : " + jqXHR.status);
	                console.log("code : " + jqXHR.responseJSON.code);
	                console.log("message : " + jqXHR.responseJSON.message);
	                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);

	                Common.alert("Failed to order invest reject.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
	                }
	            catch (e) {
	                console.log(e);
	                alert("Saving data prepration failed.");
	            }
	            alert("Fail : " + jqXHR.responseJSON.message);
	    }); 
	}

	function fn_reloadPage(){
	    //Parent Window Method Call
	    fn_searchListAjax();
	    Common.popupDiv('/sales/order/orderSuspendNewResultPop.do', $('#detailForm').serializeJSON(), null , true, '_editDiv2');
	    $("#_close").click();
	}
	
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>New Suspend Result</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close" >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="getParamForm" name="getParamForm" method="GET">
    <input type="hidden" id="susId" name="susId" value="${susId }">
    <input type="hidden" id="salesOrdId" name="salesOrdId" value="${salesOrdId }">
</form>

<aside class="title_line"><!-- title_line start -->
<h2>Suspend &amp; Call Log Information</h2>
</aside><!-- title_line end -->


<section class="tap_wrap mt0"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Suspend Info</a></li>
    <li><a href="#" onclick="javascript: fn_resizefunc(callResultGridID)">Suspend Call Result</a></li>
    <li><a href="#">Order Details</a></li>
    <li><a href="#" onclick="javascript: fn_resizefunc(callLogGirdID)">Full Call Log</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Suspend Number</th>
    <td><span>${suspensionInfo.susNo }</span></td>
    <th scope="row">Create Date</th>
    <td><span>${suspensionInfo.susCrtDt }</span></td>
    <th scope="row">Creator</th>
    <td><span>${suspensionInfo.susCrtUserName }</span></td>
</tr>
<tr>
    <th scope="row">Status</th>
    <td><span>${suspensionInfo.code }</span></td>
    <th scope="row">Update Date</th>
    <td><span>${suspensionInfo.susUpdDt }</span></td>
    <th scope="row">Updator</th>
    <td><span>${suspensionInfo.susUpdUserName }</span></td>
</tr>
<tr>
    <th scope="row">Order Number</th>
    <td><span>${suspensionInfo.salesOrdNo }</span></td>
    <th scope="row">Investigate Number</th>
    <td><span>${suspensionInfo.invNo }</span></td>
    <th scope="row"></th>
    <td><span></span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start 

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>
-->
<article class="grid_wrap"  style="height:200px"><!-- grid_wrap start -->
    <div id="callResult_grid_wrap" style="width:100%; height:200px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="tap_wrap mt10"><!-- tap_wrap start -->

<ul class="tap_type1 num4">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">HP / Cody</a></li>
    <li><a href="#">Customer Info</a></li>
    <li><a href="#">Installation Info</a></li>
    <li><a href="#">Mailling Info</a></li>
    <li><a href="#">Payment Channel</a></li>
    <li><a href="#">Membership Info</a></li>
    <li><a href="#">Document Submission</a></li>
    <li><a href="#">Call Log</a></li>
    <li><a href="#">Guarantee Info</a></li>
    <li><a href="#">Payment Listing</a></li>
    <li><a href="#">Last 6 Months Transaction</a></li>
    <li><a href="#">Order Configuration</a></li>
    <li><a href="#">Auto Debit Result</a></li>
    <li><a href="#">Relief Certificate</a></li>
    <li><a href="#">Discount</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Progress Status</th>
    <td><span>text</span></td>
    <th scope="row">Agreement No</th>
    <td><span>text</span></td>
    <th scope="row">Agreement Expiry</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Order No</th>
    <td></td>
    <th scope="row">Order Date</th>
    <td></td>
    <th scope="row">Status</th>
    <td></td>
</tr>
<tr>
    <th scope="row">Application Type</th>
    <td></td>
    <th scope="row">Reference No</th>
    <td></td>
    <th scope="row">Key At(By)</th>
    <td></td>
</tr>
<tr>
    <th scope="row">Product</th>
    <td></td>
    <th scope="row">PO Number</th>
    <td></td>
    <th scope="row">Key-inBranch</th>
    <td></td>
</tr>
<tr>
    <th scope="row">PV</th>
    <td></td>
    <th scope="row">Price/RPF</th>
    <td></td>
    <th scope="row">Rental Fees</th>
    <td></td>
</tr>
<tr>
    <th scope="row">Installment Duration</th>
    <td></td>
    <th scope="row">PV Month(Month/Year)</th>
    <td></td>
    <th scope="row">Rental Status</th>
    <td></td>
</tr>
<tr>
    <th scope="row">Promotion</th>
    <td colspan="3"></td>
    <th scope="row">Related No</th>
    <td></td>
</tr>
<tr>
    <th scope="row">Serial Number</th>
    <td></td>
    <th scope="row">Sirim Number</th>
    <td></td>
    <th scope="row">Update At(By)</th>
    <td></td>
</tr>
<tr>
    <th scope="row">Obligation Period</th>
    <td colspan="5"></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5"></td>
</tr>
<tr>
    <th scope="row">CCP Feedback Code</th>
    <td colspan="5"></td>
</tr>
<tr>
    <th scope="row">CCP Remark</th>
    <td colspan="5"></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="divine2"><!-- divine3 start -->

<article>
<h2>Salesman Info</h2>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th rowspan="3" scope="row">Order Made By</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td><span>text</span></td>
</tr>
<tr>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Salesman Code</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Salesman Name</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Salesman NRIC</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Office No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">House No</th>
    <td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article>

<article>
<h2>Cody Info</h2>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th rowspan="3" scope="row">Service By</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td><span>text</span></td>
</tr>
<tr>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Cody Code</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Cody Name</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Cody NRIC</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Office No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">House No</th>
    <td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article>

</section><!-- divine2 start -->


</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer ID</th>
    <td><span>text</span></td>
    <th scope="row">Customer Name</th>
    <td colspan="3"><span>text</span></td>
</tr>
<tr>
    <th scope="row">Customer Type</th>
    <td><span>text</span></td>
    <th scope="row">NRIC/Company No</th>
    <td><span>text</span></td>
    <th scope="row">JomPay Ref-1</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Nationality</th>
    <td><span>text</span></td>
    <th scope="row">Gender</th>
    <td><span>text</span></td>
    <th scope="row">Race</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">VA Number</th>
    <td><span>text</span></td>
    <th scope="row">Passport Exprire</th>
    <td><span>text</span></td>
    <th scope="row">Visa Exprire</th>
    <td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Same Rental Group Order(s)</h2>
</aside><!-- title_line end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th rowspan="3" scope="row">Installation Address</th>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Country</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td colspan="3"><span>text</span></td>
    <th scope="row">State</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Area</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Prefer Install Date</th>
    <td><span>text</span></td>
    <th scope="row">Prefer Install Time</th>
    <td><span>text</span></td>
    <th scope="row">Postcode</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Instruction</th>
    <td colspan="5"><span>text</span></td>
</tr>
<tr>
    <th scope="row">DSC Verification Remark</th>
    <td colspan="5"><span>text</span></td>
</tr>
<tr>
    <th scope="row">DSC Branch</th>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Installed Date</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">CT Code</th>
    <td><span>text</span></td>
    <th scope="row">CT Name</th>
    <td colspan="3"><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt40"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Contact Name</th>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Gender</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Contact NRIC</th>
    <td><span>text</span></td>
    <th scope="row">Email</th>
    <td><span>text</span></td>
    <th scope="row">Fax No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>text</span></td>
    <th scope="row">Office No</th>
    <td><span>text</span></td>
    <th scope="row">House No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Post</th>
    <td><span>text</span></td>
    <th scope="row">Department</th>
    <td><span>text</span></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th rowspan="3" scope="row">Mailing Address</th>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Country</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td colspan="3"><span>text</span></td>
    <th scope="row">State</th>
    <td><span>text</span></td>
</tr>
<tr>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Area</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Billing Group</th>
    <td><span>text</span></td>
    <th scope="row">Billing Type</th>
    <td>
    <label><input type="checkbox" /><span>SMS</span></label>
    <label><input type="checkbox" /><span>Post</span></label>
    <label><input type="checkbox" /><span>E-statement</span></label>
    </td>
    <th scope="row">Postcode</th>
    <td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt40"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Contact Name</th>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Gender</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Contact NRIC</th>
    <td><span>text</span></td>
    <th scope="row">Email</th>
    <td><span>text</span></td>
    <th scope="row">Fax No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>text</span></td>
    <th scope="row">Office No</th>
    <td><span>text</span></td>
    <th scope="row">House No</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Post</th>
    <td><span>text</span></td>
    <th scope="row">Departiment</th>
    <td><span>text</span></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Rental Paymode</th>
    <td><span>text</span></td>
    <th scope="row">Direct Debit Mode</th>
    <td><span>text</span></td>
    <th scope="row">Auto Debit Limit</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Issue Bank</th>
    <td><span>text</span></td>
    <th scope="row">Card Type</th>
    <td><span>text</span></td>
    <th scope="row">Claim Bill Date</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Credit Card No</th>
    <td><span>text</span></td>
    <th scope="row">Name On Card</th>
    <td><span>text</span></td>
    <th scope="row">Expiry Date</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Bank Account No</th>
    <td><span>text</span></td>
    <th scope="row">Account Name</th>
    <td><span>text</span></td>
    <th scope="row">Issure NRIC</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Apply Date</th>
    <td><span>text</span></td>
    <th scope="row">Submit Date</th>
    <td><span>text</span></td>
    <th scope="row">Start Date</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Reject Date</th>
    <td><span>text</span></td>
    <th scope="row">Reject Code</th>
    <td><span>text</span></td>
    <th scope="row">Payment Team</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Pay By Third Party</th>
    <td><span>text</span></td>
    <th scope="row">Third Party ID</th>
    <td><span>text</span></td>
    <th scope="row">Third Party Type</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">Third Party Name</th>
    <td colspan="3"><span>text</span></td>
    <th scope="row">Third Party NRIC</th>
    <td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Guarantee Status</th>
    <td colspan="3"><span>text</span></td>
</tr>
<tr>
    <th scope="row">HP Code</th>
    <td><span>text</span></td>
    <th scope="row">HP Name(NRIC)</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">HM Code</th>
    <td><span>text</span></td>
    <th scope="row">HM Name(NRIC)</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">SM Code</th>
    <td><span>text</span></td>
    <th scope="row">SM Name(NRIC)</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">GM Code</th>
    <td><span>text</span></td>
    <th scope="row">GM Name(NRIC)</th>
    <td><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">BS Availability</th>
    <td><span>text</span></td>
    <th scope="row">BS Frequency</th>
    <td><span>text</span></td>
    <th scope="row">Last BS Date</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">BS Cody Code</th>
    <td colspan="5"><span>text</span></td>
</tr>
<tr>
    <th scope="row">Config Remark</th>
    <td colspan="5"><span>text</span></td>
</tr>
<tr>
    <th scope="row">Happy Call Service</th>
    <td colspan="5">
    <label><input type="checkbox" /><span>Installation Type</span></label>
    <label><input type="checkbox" /><span>BS Type</span></label>
    <label><input type="checkbox" /><span>AS Type</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Prefer BS Week</th>
    <td colspan="5">
    <label><input type="radio" name="week" /><span>None</span></label>
    <label><input type="radio" name="week" /><span>Week1</span></label>
    <label><input type="radio" name="week" /><span>Week2</span></label>
    <label><input type="radio" name="week" /><span>Week3</span></label>
    <label><input type="radio" name="week" /><span>Week4</span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Reference No</th>
    <td><span>text</span></td>
    <th scope="row">Certificate Date</th>
    <td><span>text</span></td>
</tr>
<tr>
    <th scope="row">GST Registration No</th>
    <td colspan="3"><span>text</span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><span>text</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start 

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>
-->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="callLog_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<aside class="title_line mt20"><!-- title_line start -->
<h2>Suspend Result</h2>
</aside><!-- title_line end -->

<form id="statusForm" name="statusForm" method="GET">
    <input type="hidden" id="susId" name="susId" value="${suspensionInfo.susId }">
	<table class="type1"><!-- table start -->
	<caption>table</caption>
	<colgroup>
	    <col style="width:150px" />
	    <col style="width:*" />
	</colgroup>
		<tbody>
			<tr>
			    <th scope="row">Status</th>
			    <td>
			    <select id="newSuspResultStus" name="newSuspResultStus">
			        <option value="">Status</option>
			        <option value="2">Suspend</option>
			        <option value="28">Regular</option>
			    </select>
			    </td>
			</tr>
			<tr>
			    <th scope="row">Remark</th>
			    <td>
			    <textarea cols="20" rows="5" id="newSuspResultRem" name="newSuspResultRem" placeholder="Remark"></textarea>
			    </td>
			</tr>
		</tbody>
	</table><!-- table end -->
</form>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="fn_saveSuspendResult()">Save</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
