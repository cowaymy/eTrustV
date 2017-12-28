<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
	//AUIGrid 생성 후 반환 ID
	var callLogGridID;
	
	var option = {
            winName : "popup",
            width : "950px",   // 창 가로 크기
            height : "700px",    // 창 세로 크기
            resizable : "yes", // 창 사이즈 변경. (yes/no)(default : yes)
            scrollbars : "yes" // 스크롤바. (yes/no)(default : yes)
    };
	
	$(document).ready(function(){
	    
	    // AUIGrid 그리드를 생성합니다.
	    createLogAUIGrid();
	    
	    AUIGrid.setSelectionMode(myGridID, "singleRow");
	    
	    orderInvestCallLogDetailGridAjax();

	    if(gridParam.stusParam.value == '1'){
	            $("#saveSuspendDiv").show();
	    }else{
	    	$("#saveSuspendDiv").hide();
	    }
	   
	});
	
	function createLogAUIGrid() {
	    // AUIGrid 칼럼 설정
	    
	    // 데이터 형태는 다음과 같은 형태임,
	    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
	    var logColumnLayout = [ {
	            dataField : "codeName",
	            headerText : "Type",
	            width : 190,
	            editable : false
	        }, {
	            dataField : "name",
	            headerText : "Status",
	            width : 130,
	            editable : false
	        }, {
	            dataField : "callRem",
	            headerText : "Message",
	            editable : false
	        }, {
	            dataField : "userName",
	            headerText : "Create By",
	            width : 130,
	            editable : false
	        }, {
	            dataField : "callCrtDt",
	            headerText : "Create At",
	            dataType : "date", 
                formatString : "mm-dd-yyyy hh:24MI:ss",
	            width : 130,
	            editable : false
	        }, {
	            dataField : "invId",
	            visible : false
	        }];
	   
	    // 그리드 속성 설정
	    var gridPros = {
	        // 페이징 사용       
	        usePaging : true,
	        // 한 화면에 출력되는 행 개수 20(기본값:20)
	        pageRowCount : 5,
	        editable : true,
	        fixedColumnCount : 1,
	        showStateColumn : true, 
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
	    
	    callLogGridID = AUIGrid.create("#callLog_grid_wrap", logColumnLayout, gridPros);
	}
	
	// Ajax
    function orderInvestCallLogDetailGridAjax() {        
        Common.ajax("GET", "/sales/order/ordInvestCallLogDtGridJsonList",$("#gridParam").serialize(), function(result) {
            AUIGrid.setGridData(callLogGridID, result);
        });
    }
	
    //resize func (tab click)
    function fn_resizefunc(gridName){ // 
        AUIGrid.resize(gridName, 900, 250);
    }
  
    function fn_callResultSaveOK(){
    	Common.ajax("GET", "/sales/order/saveCallResultOk.do", $("#saveForm").serializeJSON(), function(result) {
            if(result.resultStatus == 29){
            	Common.alert("INV success", fn_success);
            }else if(result.resultStatus == 28){
            	Common.alert("REG success", fn_success);
            }else {
            	Common.alert("SUS success", fn_success);
            }
    		Common.alert(result.msg);
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
    function fn_callResultSave(){

    	var invmsg = "";
        invmsg += "Order Number : " + ${investCallResultCust.salesOrdNo }+"<br>";
        invmsg += "Are you sure want to remain this order to Investigate status ?";
        
        var susmsg = "";
        susmsg += "Order number : " + ${investCallResultCust.salesOrdNo }+"<br>";
        susmsg += "This month is BS month for this order.</br>";
        susmsg += "Ticket of BS request will be send to cody divison automatically by system.</br>";
        susmsg += "Are you sure want to remain this order to status regular  ?";
        
    	if(saveForm.callResultRem.value == ""){
    		Common.alert("Please Enter callResultRem Remark !");
    		return false;
    	}
    	// REG 저장일때 BSMonth를 비교하여 ticket 라디오박스 confirm을 위한 체크 
        if(saveForm.callResultStus.value == "28"){
            Common.ajax("GET", "/sales/order/bsMonthCheck.do", $("#saveForm").serializeJSON(), function(result) {
            	if(result.regSaveMsg == "1"){
                	Common.popupDiv("/sales/order/bsMonthCheckOKPop.do", $("#saveForm").serializeJSON(), null, true, 'savePop');
                }else{
                	Common.popupDiv("/sales/order/bsMonthCheckNoPop.do", $("#saveForm").serializeJSON(), null, true, 'savePop');
                }
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
        }else{
        	if(saveForm.callResultStus.value == "29"){
        		Common.confirm(invmsg,fn_callResultSaveOK);
        	}else if(saveForm.callResultStus.value == "2"){
        		Common.confirm(susmsg,fn_callResultSaveOK);
        	}else{
        		Common.alert("Please try again");
        		return false;
        	}
        	
        }
    	
    }
    
    function fn_inCharge(obj , value , tag , selvalue){
    	var robj= '#'+obj;
        $(robj).attr("disabled",false);
        if(value == 3){
            getCmbChargeNm('/sales/order/inchargeJsonList.do', '60' , value , selvalue,obj, 'S', '');
        }else if(value == 4){
            getCmbChargeNm('/sales/order/inchargeJsonList.do', '133' , value , selvalue,obj, 'S', '');
        }else{
        	 $("#inchargeNm").find("option").remove();
        }
    }
    
    function getCmbChargeNm(url, groupCd ,codevalue ,  selCode, obj , type, callbackFn){
        $.ajax({
            type : "GET",
            url : url,
            data : { roleId : groupCd},
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
               var rData = data;
               doDefNmCombo(rData, selCode, obj , type,  callbackFn)
            },
            error: function(jqXHR, textStatus, errorThrown){
                alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
            },
            complete: function(){
            }
        });
    }
    
    function doDefNmCombo(data, selCode, obj , type, callbackFn){
        var targetObj = document.getElementById(obj);
        var custom = "";

        for(var i=targetObj.length-1; i>=0; i--) {
            targetObj.remove( i );
        }
        obj= '#'+obj;
//        if (type&&type!="M") {
//            custom = (type == "S") ? eTrusttext.option.choose : ((type == "A") ? eTrusttext.option.all : "");
//            $("<option />", {value: "", text: custom}).appendTo(obj);
//        }else{
//            $(obj).attr("multiple","multiple");
//        }

        $.each(data, function(index,value) {
            //CODEID , CODE , CODENAME ,,description
            if(selCode==data[index].userId){
                $('<option />', {value : data[index].userId, text:data[index].userFullNm}).appendTo(obj).attr("selected", "true");
            }else{
                $('<option />', {value : data[index].userId, text:data[index].userFullNm}).appendTo(obj);
            }
        });


        if(callbackFn){
            var strCallback = callbackFn+"()";
            eval(strCallback);
        }
    }
    
    function fn_stusChng(){
    	if(saveForm.callResultStus.value == "2"){
    		$(".inchargeDiv").show();
    	}else{
    		$(".inchargeDiv").hide();
    	}
    }
    
    function fn_success(){
    	fn_investCallResultListAjax();
    	$("#_saveClose").click();
    }
    
    function fn_goLedger1(){
        Common.popupWin('gridParam', "/sales/order/orderLedgerViewPop.do", option);
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order Investigation Request Details - Officer</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_saveClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Investigate Request Info</a></li>
    <li><a href="#">Customer Info</a></li>
    <li><a href="#" onclick="javascript: fn_resizefunc(callLogGridID)">Call Log</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0 mt0">Particular Information</h3>
<ul class="right_btns top0">
    <li><p class="btn_blue"><a href="#" onclick="javascript : fn_goLedger1()"><span class="search"></span>View Order Ledger(1)</a></p></li>
</ul>
</aside><!-- title_line end -->
<form id="gridParam" name="gridParam" method="GET">
    <input type="hidden" id="callLogInvId" name="callLogInvId" value="${investCallResultInfo.invId }">
    <input type="hidden" id="salesOrdId" name="salesOrdId" value="${investCallResultInfo.salesOrdId }">
    <input type="hidden" id="ordId" name="ordId" value="${investCallResultInfo.salesOrdId }">
    <input type="hidden" id="stusParam" name="stusParam" value="${investCallResultInfo.invStusId }">
    <input type="hidden" id="rentalStusParam" name="rentalStusParam" value="${investCallResultCust.stusCodeId }">
</form>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Investigation No.</th>
    <td>
    <span>${investCallResultInfo.invNo }</span>
    </td>
    <th scope="row">Investigate Status</th>
    <td>${investCallResultInfo.name }
    </td>
</tr>
<tr>
    <th scope="row">Investigated At</th>
    <td>
    <span>${investCallResultInfo.invCrtDt }</span>
    </td>
    <th scope="row">BS Cancelled</th>
    <td>-
    </td>
</tr>
<tr>
    <th scope="row">Product</th>
    <td>
    <span>${investCallResultCust.stkDesc }</span>
    </td>
    <th scope="row">Rental Status</th>
    <td>${investCallResultCust.stusCodeId }
    </td>
</tr>
<tr>
    <th scope="row">Order No</th>
    <td>
    <span>${investCallResultCust.salesOrdNo }</span>
    </td>
    <th scope="row">Order Date</th>
    <td>${investCallResultCust.salesDt }
    </td>
</tr>
<tr>
    <th scope="row">Application Type</th>
    <td>
    <span>${investCallResultCust.codeName }</span>
    </td>
    <th scope="row">Rental Fees</th>
    <td>RM ${investCallResultCust.mthRentAmt }
    </td>
</tr>
<tr>
    <th scope="row">Last Update At</th>
    <td>
    <span>${investCallResultInfo.invUpdDt }</span>
    </td>
    <th scope="row">Last Update By</th>
    <td>${investCallResultInfo.username1 }
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Customer  Information</h3>
</aside><!-- title_line end -->

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
    <th scope="row">Customer ID</th>
    <td>
    <span>${investCallResultCust.custId }</span>
    </td>
    <th scope="row">Customer Type</th>
    <td>
    <span>${investCallResultCust.codeDesc }</span>
    </td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td>
    <span>${investCallResultCust.name }</span>
    </td>
    <th scope="row">Customer NRIC</th>
    <td>
    <span>${investCallResultCust.nric }</span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Mailing Information  </h3>
</aside><!-- title_line end -->

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
    <th scope="row">Contact Person</th>
    <td colspan="3">
    <span>${investCallResultCust.name1 }</span>
    </td>
</tr>
<tr>
    <th scope="row">Office No.</th>
    <td>
    <span>${investCallResultCust.telO }</span>
    </td>
    <th scope="row">Residence No.</th>
    <td>
    <span>${investCallResultCust.telR }</span>
    </td>
</tr>
<tr>
    <th scope="row">Fax No.</th>
    <td>
    <span>${investCallResultCust.telF }</span>
    </td>
    <th scope="row">Mobile No.</th>
    <td>
    <span>${investCallResultCust.telM1 }</span>
    </td>
</tr>
<tr>
    <th scope="row">Address</th>
    <td colspan="3">
    <span>${investCallResultCust.maillingAddr }</span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Installation Information </h3>
</aside><!-- title_line end -->

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
    <th scope="row">Contact Person</th>
    <td colspan="3">
    <span>${investCallResultCust.name2 }</span>
    </td>
</tr>
<tr>
    <th scope="row">Office No.</th>
    <td>
    <span>${investCallResultCust.telO1 }</span>
    </td>
    <th scope="row">Residence No.</th>
    <td>
    <span>${investCallResultCust.telR1 }</span>
    </td>
</tr>
<tr>
    <th scope="row">Fax No.</th>
    <td>
    <span>${investCallResultCust.telF1 }</span>
    </td>
    <th scope="row">Mobile No.</th>
    <td>
    <span>${investCallResultCust.telM11 }</span>
    </td>
</tr>
<tr>
    <th scope="row">Address</th>
    <td colspan="3">
    <span>${investCallResultCust.installationAddr }</span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Call Log</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="callLog_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<div id="saveSuspendDiv" style="display:none;"><!-- Status = Suspend일 경우 start -->
<aside class="title_line"><!-- title_line start -->
<h3>Investigation Result Information</h3>
</aside><!-- title_line end -->

<form id="saveForm" name="saveForm" method="GET">
	<input type="hidden" id="callResultInvId" name="callResultInvId" value="${investCallResultInfo.invId }">
	<input type="hidden" id="invCallEntryId" name="invCallEntryId" value="${investCallResultInfo.invCallEntryId }">
	<input type="hidden" id="saveSalesOrdNo" name="saveSalesOrdNo" value="${investCallResultCust.salesOrdNo }">
	<input type="hidden" id="saveSalesOrdId" name="saveSalesOrdId" value="${investCallResultInfo.salesOrdId }">
<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Suspend No</th>
    <td>
    <span>-</span>
    </td>
</tr>
<tr>
    <th scope="row">Status</th>
    <td>
    <select id="callResultStus" name="callResultStus" onChange="fn_stusChng()">
        <option value="29">(INV) Pending For Investigate</option>
        <option value="28">(REG) Return To Regular</option>
        <option value="2">(SUS) Suspend This Sales Order</option>
    </select>
    <p class="ml10">
        <span class="blue_text">INV - Continue investigate | REG - Order return to regular | SUS - Suspend the order </span>
        <span class="red_text">*Unable to transfer ownership from 26 to 1 next month </span>
    </p>
    </td>
</tr>
<tr class="inchargeDiv" style="display:none">
    <th scope="row" rowspan="2">Inchage Person</th>
    <td>
    <select id="incharge" name="incharge" onchange="fn_inCharge('inchargeNm', this.value, '', '')">
        <option value="0">[Select One]</option>
        <option value="3">Internal Caller</option>
        <option value="4">Third Party</option>
    </select>
    </td>
</tr>
<tr class="inchargeDiv" style="display:none">
    <td>
	    <select  id="inchargeNm" name="inchargeNm">
	    </select>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td>
    <textarea cols="20" rows="5" id="callResultRem" name="callResultRem" placeholder=""></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<ul class="center_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue2"><a href="#" onclick="fn_callResultSave()">SAVE</a></p></li>
    </c:if>
</ul>
</div>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->