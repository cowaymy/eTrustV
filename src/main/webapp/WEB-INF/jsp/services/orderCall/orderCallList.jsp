<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">

    var callStusCode;
    var callStusId;
    var salesOrdId;
    var callEntryId;
    var salesOrdNo;

//Start AUIGrid
$(document).ready(function() {
	
	
    // AUIGrid 그리드를 생성합니다.
    orderCallListGrid();
    
    AUIGrid.setSelectionMode(myGridID, "singleRow");
    
/*  // 셀 더블클릭 이벤트 바인딩
      AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
            //alert(event.rowIndex+ " - double clicked!! : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
            Common.popupDiv("/organization/selectMemberListDetailPop.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
        });
 */
 
		 AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
			 callStusCode =  AUIGrid.getCellValue(myGridID, event.rowIndex, "callStusCode");
		        callStusId = AUIGrid.getCellValue(myGridID, event.rowIndex, "callStusId");
		        salesOrdId = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
		        callEntryId = AUIGrid.getCellValue(myGridID, event.rowIndex, "callEntryId");
		        salesOrdNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdNo");
		     Common.popupDiv("/callCenter/viewCallResultPop.do?isPop=true&callStusCode=" + callStusCode+"&callStusId=" + callStusId+"&salesOrdId=" + salesOrdId+"&callEntryId=" + callEntryId+"&salesOrdNo=" + salesOrdNo+"&salesOrderId=" + salesOrdId);
		 }); 
     AUIGrid.bind(myGridID, "cellClick", function(event) {
        //alert(event.rowIndex+ " -cellClick : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
        callStusCode =  AUIGrid.getCellValue(myGridID, event.rowIndex, "callStusCode");
        callStusId = AUIGrid.getCellValue(myGridID, event.rowIndex, "callStusId");
        salesOrdId = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
        callEntryId = AUIGrid.getCellValue(myGridID, event.rowIndex, "callEntryId");
        salesOrdNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdNo");
        //Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
        console.log(callStusCode+ "     " + callStusId + "     " + salesOrdId+ "     "  + callEntryId)
        
        
    });  
     
 
 doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID',   '', 'listAppType',     'M', 'fn_multiCombo'); //Common Code
 doGetComboSepa('/common/selectBranchCodeList.do',  '5', ' - ', '',   'listDSCCode', 'M', 'fn_multiCombo'); //Branch Code
 doGetProductCombo('/common/selectProductCodeList.do', '', '', 'product', 'S'); //Product Code
 
 
  doGetCombo('/callCenter/getstateList.do', '', '','ordStatus', 'S' ,  '');
     
 
     $("#ordStatus").change(function() {
        alert(11111111);
        
        $("#ordArea").find('option').each(function() {
            $(this).remove();
        });

        
        if ($(this).val().trim() == "") {
            return;
        }       
        doGetCombo('/callCenter/getAreaList.do', $(this).val() , ''   , 'ordArea' , 'S', '');
    });
    
});

    function fn_multiCombo(){
    	 $('#listAppType').change(function() {
             //console.log($(this).val());
         }).multipleSelect({
             selectAll: true, // 전체선택 
             width: '100%'
         });
    	 $('#listDSCCode').change(function() {
             //console.log($(this).val());
         }).multipleSelect({
             selectAll: true, // 전체선택 
             width: '100%'
         });
    }
	function fn_orderCallList(){
		Common.ajax("GET", "/callCenter/searchOrderCallList.do", $("#orderCallSearchForm").serialize(), function(result) {
	        console.log("성공.");
	        console.log("data : " + result);
	        AUIGrid.setGridData(myGridID, result);
	    });
	}
	function fn_openAddCall(){
		if(callStusId == "1" || callStusId == "19" || callStusId == "30"  ){ //1 10 19 20 30)
		  //Common.popupDiv("/callCenter/addCallResultPop.do?isPop=true&callStusCode=" + callStusCode+"&callStusId=" + callStusId+"&salesOrdId=" + salesOrdId+"&callEntryId=" + callEntryId+"&salesOrdNo=" + salesOrdNo+"&salesOrderId=" + salesOrdId);
            Common.popupDiv("/callCenter/addCallResultPop.do", {
                callStusCode: callStusCode,
                callStusId: callStusId,
                salesOrdId: salesOrdId,
                callEntryId: callEntryId,
                salesOrdNo: salesOrdNo,
                salesOrderId: salesOrdId
            });
		}else if(callStusId == "10" ){
			Common.alert("<spring:message code='service.msg.callLogCan'/> ");
		}else if(callStusId == "20" ){
			Common.alert("<spring:message code='service.msg.callLogRDY'/> ");
        } 
	}
	var myGridID;
	function orderCallListGrid() {
        //AUIGrid 칼럼 설정
        var columnLayout = [ {
            dataField : "callTypeCode",
            headerText : "Type",
            headerText : '<spring:message code="service.grid.Type" />',
            editable : false,
            width : 100
        }, {
            dataField : "callStusCode",
            headerText : "Status",
            headerText : '<spring:message code="service.grid.Status" />',
            editable : false,
            width : 100
        }, {
            dataField : "callLogDt",
            headerText : "Date",
            headerText : '<spring:message code="service.grid.Date" />',
            editable : false,
            width : 130
        }, {
            dataField : "salesOrdNo",
            headerText : '<spring:message code="service.grid.OrderNo" />', 
            editable : false,
            width : 150
        }, {
            dataField : "appTypeName",
            headerText : '<spring:message code="service.grid.AppType" />',  
            editable : false,
            style : "my-column",
            width : 100
        }, {
            dataField : "productCode",
            headerText : '<spring:message code="service.grid.Product" />',
            editable : false,
            width : 180
        }, {
            dataField : "custName",
            headerText : '<spring:message code="service.grid.Customer" />',
            editable : false,
            width : 180
        }, {
            dataField : "isWaitCancl",
            headerText : '<spring:message code="service.grid.WaitCancel" />',		
            width : 180
        }, {
            dataField : "callStusId",
            
            headerText : "",
            width : 0
        }, {
            dataField : "salesOrdId",
            headerText : "",
            width : 0
        }, {
            dataField : "callEntryId",
            headerText : "",
            width : 0
        }];
         // 그리드 속성 설정
        var gridPros = {
            
            // 페이징 사용       
            usePaging : true,
            
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            
            editable : true,
            
            showStateColumn : false, 
            
            displayTreeOpen : true,
            
            
            headerHeight : 30,
            
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true

        };
        
        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        myGridID = AUIGrid.create("#grid_wrap_callList", columnLayout, gridPros);
    }

var gridPros = {
        
        // 페이징 사용       
        usePaging : true,
        
        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,
        
        editable : true,
        
        fixedColumnCount : 1,
        
        showStateColumn : true, 
        
        displayTreeOpen : true,
        
        selectionMode : "singleRow",
        
        headerHeight : 30,
        
        // 그룹핑 패널 사용
        useGroupingPanel : true,
        
        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,
        
        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,
        
        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : false,
        
    };
    
function fn_excelDown(){
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap_callList", "xlsx", "Order Call Log Search");
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code='service.title.OrderCallLogSearch'/></h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onClick="fn_openAddCall()"><spring:message code='service.btn.addCallLogResult'/></a></p></li>
    <li><p class="btn_blue"><a href="#" onClick="javascript:fn_orderCallList()"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="orderCallSearchForm">

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
    <th scope="row"><spring:message code='service.title.OrderNo'/></th>
    <td>
    <input type="text" title="" placeholder="Order Number" class="w100p" id="orderNo" name="orderNo" />
    </td> 
    <th scope="row"><spring:message code='service.title.ApplicationType'/></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="listAppType" name="appType">
    </select>
    </td>
    <th scope="row"><spring:message code='service.title.OrderDate'/></th>
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="createDate" name="createDate"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date"  id="endDate"  name="endDate"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.State'/></th>
    <td>
    <select class="w100p" id="ordStatus" name="ordStatus">
    </select>
    </td>
    <th scope="row"><spring:message code='service.title.Area'/></th>
    <td>
    <select class="w100p" id="ordArea" name="ordArea">
    </select>
    </td>
    <th scope="row"><spring:message code='service.title.Product'/></th>
    <td>
    <select class="w100p" id="product" name="product">
    </select>
    </td>
</tr>
<tr> 
    <th scope="row"><spring:message code='service.title.CallLogType'/></th>
    
    <td>
    <select class="multy_select w100p" multiple="multiple" id="callLogType" name="callLogType">
        <option value="257" selected>New Installation Order</option>
        <option value="258">Product Exchange</option>

    </select>
    </td>
    <th scope="row"><spring:message code='service.title.CallLogStatus'/></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="callLogStatus" name="callLogStatus">
     <option value="1" selected>Active</option>
     <option value="10">Cancelled</option>
     <option value="19" selected>Recall</option>
     <option value="20">Ready To Install</option>
     <option value="30">Waiting For Cancel</option>
    </select>
    </td>
    <th scope="row"><spring:message code='service.title.CallLogDate'/></th>    
    <td>

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="callStrDate" name="callStrDate"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date"  id="callEndDate" name="callEndDate"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.CustomerID'/></th>    
    <td>
    <input type="text" title="" placeholder="Customer ID" class="w100p" id="custId" name="custId"/>
    </td>
    <th scope="row"><spring:message code='service.title.CustomerName'/></th>  
    <td>
    <input type="text" title="" placeholder="Customer Name" class="w100p" id="custName" name="custName"/>
    </td>
    <th scope="row"><spring:message code='service.title.NRIC_CompanyNo'/></th>  
    <td>
    <input type="text" title="" placeholder="NRIC/Company Number" class="w100p" id="nricNo" name="nricNo"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.ContactNo'/></th>  
    <td>
    <input type="text" title="" placeholder="Contact Number" class="w100p" id="contactNo" name="contactNo"/>
    </td>
    <th scope="row"><spring:message code='service.title.DSCCode'/></th>  
    <td>
    <select class="multy_select w100p" multiple="multiple" id="listDSCCode" name="DSCCode">
    </select>
    </td>
    <th scope="row"><spring:message code='service.title.PONumber'/></th>      
    <td>
    <input type="text" title="" placeholder="PO Number" class="w100p" id="PONum" name="PONum"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.SortBy'/></th>
    <td colspan="5">
    <select class="w100p" id="sortBy" name="sortBy">
        <option value="0" selected>No Sorting</option>
        <option value="1">Order Number</option>
        <option value="2">Customer Name</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<%-- <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#" onClick="fn_openAddCall()">Add Call Log Result</a></p></li>
       <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li> 
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end --> --%>

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" onClick="fn_excelDown()"><spring:message code='sys.btn.excel.dw' /></a></p></li>
   <!-- <l  i><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li> -->
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_callList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
