<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.my-right-style {
    text-align:right;
}
.my-left-style {
    text-align:left;
}
.aui-grid-drop-list-ul {
   text-align:left;
}
</style>
<script type="text/javaScript">
var assignGrid;
var excelGrid;

var companyList = [];
var agentList = [];
var suggestList = [];
var ynData = [{"codeId": "1","codeName": "YES"},{"codeId": "0","codeName": "NO"}];

var MEM_TYPE     = '${SESSION_INFO.userTypeId}';
var userName      = '${SESSION_INFO.userName}';
var agentId = null;

$(document).ready(function(){

    if(MEM_TYPE == '6' || MEM_TYPE == '4'){
        $("#rosCaller").multipleSelect("enable");
    }else{
        $("#rosCaller").multipleSelect("disable");

        Common.ajax("GET", "/sales/rcms/selectRosCaller", {userName:userName}, function(result) {
            if(result.length > 0){
              agentId =  "" +result[0].agentId + "|!|";
            }
        }, null, {async : false});
    }

	doDefCombo(ynData, '' ,'etrYn', 'S', '');
	doDefCombo(ynData, '' ,'sensitiveYn', 'S', '');
	doDefCombo(ynData, '' ,'assignYn', 'S', '');
    //Application Type
    CommonCombo.make("appType", "/common/selectCodeList.do", {groupCode : '10'}, '66',
    		{
		        id: "codeId",
		        name:"codeName",
		        isShowChoose: false
		      });
    //orderStatus
    CommonCombo.make('orderStatus', "/status/selectStatusCategoryCdList.do", {selCategoryId : 27} , '4',
    		{
		    	id: "stusCodeId",              // 콤보박스 value 에 지정할 필드명.
		        name: "codeName",  // 콤보박스 text 에 지정할 필드명.
		        isShowChoose: false
		    });
    //rentalStatus
    CommonCombo.make('rentalStatus', "/status/selectStatusCategoryCdList.do", {selCategoryId : 26} , 'INV|!|SUS',
    		{
	    	    id: "code",              // 콤보박스 value 에 지정할 필드명.
		        name: "codeName",  // 콤보박스 text 에 지정할 필드명.
		        isShowChoose: false,
		        isCheckAll : false,
		        type : 'M'
		        });
    //Customer Type
    CommonCombo.make("customerType", "/common/selectCodeList.do", {groupCode : '8'}, '964', {isShowChoose: false});
    //Company Type
    CommonCombo.make("companyType", "/common/selectCodeList.do", {groupCode : '95'}, null, {isShowChoose: false , isCheckAll : false, type: "M"});
    //Opening Aging Month
    CommonCombo.make("openMonth", "/common/selectCodeList.do", {groupCode : '330'}, '4|!|5|!|6',
    		{
                id: "code",
                name:"codeName",
                isShowChoose: false ,
                isCheckAll : false,
                type: "M"
             });
    //RosCaller
    CommonCombo.make("rosCaller", "/sales/rcms/selectRosCaller", {stus:'1'}, agentId,  {id:'agentId', name:"agentName", isShowChoose: false,isCheckAll : false , type: "M"});
    //doGetCombo('/common/selectCodeList.do', '2', '',    'cmbRaceId',    'S', ''); //Common Code
    CommonCombo.make('cmbRaceId', "/common/selectCodeList.do", {groupCode : '2'} , '',
            {
                id: "codeId",              // 콤보박스 value 에 지정할 필드명.
                name: "codeName",  // 콤보박스 text 에 지정할 필드명.
                isShowChoose: false,
                isCheckAll : false,
                type : 'M'
                });
    $("#companyType").multipleSelect("disable");
    fn_companyList();
    fn_agentList();
    fn_suggestList();

    createGrid();

    //엑셀 다운
    $('#excelDown').click(function() {
       GridCommon.exportTo("excelGrid", 'xlsx', "RCMS Assign List");
    });

   // fn_selectListAjax();
});


function fn_companyList(){

    Common.ajax("GET", "/common/selectCodeList.do", {groupCode : '95'}, function(result) {
    	companyList = result;
        console.log(companyList);
    }, null, {async : false});
}


//Ros caller
function fn_agentList(){

    Common.ajax("GET", "/sales/rcms/selectRosCaller", {stus:'1'}, function(result) {
    	agentList = result;
        console.log(agentList);
    }, null, {async : false});
}

//suggest Caller
function fn_suggestList(){

    Common.ajax("GET", "/sales/rcms/selectRosCaller", '', function(result) {
    	suggestList = result;
        console.log(suggestList);
    }, null, {async : false});
}



function createGrid(){

        var assignColLayout = [
              {dataField : "salesOrdId", headerText : "", width : 90  , visible:false   },
              {dataField : "typeId", headerText : "", width : 90  , visible:false   },
              {dataField : "salesOrdNo", headerText : '<spring:message code="sal.title.text.ordNop" />', width : '7%' , editable       : false   },
              {dataField : "custId", headerText : '<spring:message code="sal.title.text.customerBrId" />', width : '7%' , editable       : false       },
              {dataField : "name", headerText : '<spring:message code="sal.text.custName" />', width : '15%' , editable       : false        },
              {dataField : "corpTypeId", headerText : '<spring:message code="sal.title.text.companyBrType" />', width : '10%', 	  editable       : false},
              /* {dataField : "race", headerText : '<spring:message code="sal.text.race" />', width : '7%',       editable       : false}, */
              /* {dataField : "colctTrget", headerText : '<spring:message code="sal.title.text.openOsBrTarget" />', width : '7%'  , editable       : false,   dataType : "numeric", formatString : "#,##0.00", }, */
              {dataField : "rentAmt", headerText : '<spring:message code="sal.title.text.currBrOs" />', width : '7%'  , editable       : false ,   dataType : "numeric", formatString : "#,##0.00", },
              /* {dataField : "openMthAging", headerText : '<spring:message code="sal.title.text.openAgingBrMonth" />', width : '7%'  , editable       : false      } , */
              {dataField : "unBillAmt", headerText : '<spring:message code="sal.text.unbillAmount" />', width : '10%'  , editable       : false      } ,
              /* {dataField : "currRentalStus", headerText : '<spring:message code="sal.title.text.currRentStatus" />', width : '10%'  , editable       : false      } , */
	          {dataField : "prevAgentId", headerText : "", width : 90    ,   visible:false ,   editable       : false},
	          //{dataField : "oriPrevAgentId", headerText : '<spring:message code="sal.title.text.prevCaller" />', width : '14%'    ,    editable       : false } ,
              {dataField : "agentId", headerText : '<spring:message code="sal.title.text.rosCaller" />', width : '14%'    ,     editable       : false },
              {dataField : "assigned", headerText : '<spring:message code="sal.title.text.assigned" />', width : '7%'  , editable       : false, visible : false     } ,
              {dataField : "sensitiveFg", headerText : '<spring:message code="sal.title.text.sensitive" />', width : '5%'   ,editable       : false    },
              {dataField : "rem", headerText : '<spring:message code="sal.title.text.sensitiveRem" />', width : '10%'   ,editable       : false    },
              {dataField : "etrFg", headerText : '<spring:message code="sal.title.text.etr" />', width : '5%'   ,editable       : false    },
              {dataField : "etrRem", headerText : '<spring:message code="sal.title.text.otrRem" />', width : '10%'   ,editable       : false    }
              ];

        var excelColLayout = [
              {dataField : "salesOrdNo", headerText : '<spring:message code="sal.title.text.ordNop" />', width : 80 },
              {dataField : "custId", headerText : '<spring:message code="sal.title.text.customerBrId" />', width : 100 },
              {dataField : "name", headerText : '<spring:message code="sal.text.custName" />', width : 250 },
              {dataField : "corpTypeId", headerText : '<spring:message code="sal.title.text.companyBrType" />', width : 100 },
              /* {dataField : "race", headerText : '<spring:message code="sal.text.race" />', width : 75}, */
              {dataField : "mthRentAmt", headerText : '<spring:message code="sal.text.rentalAmount" />', width : 75, dataType : "numeric", formatString : "#,##0.00"},
              {dataField : "colctTrget", headerText : '<spring:message code="sal.title.text.openOsBrTarget" />', width : 100 , dataType : "numeric", formatString : "#,##0.00" },
              {dataField : "rentAmt", headerText : '<spring:message code="sal.title.text.currBrOs" />', width : 100 , dataType : "numeric", formatString : "#,##0.00" },
              {dataField : "openMthAging", headerText : '<spring:message code="sal.title.text.openAgingBrMonth" />', width : 95 } ,
              {dataField : "unBillAmt", headerText : '<spring:message code="sal.text.unbillAmount" />', width : 100 , dataType : "numeric", formatString : "#,##0.00" } ,
              {dataField : "oriPrevAgentId", headerText : '<spring:message code="sal.title.text.prevCaller" />', width : 250 } ,
              {dataField : "agentId", headerText : '<spring:message code="sal.title.text.rosCaller" />', width : 250 },
              {dataField : "updAgentDt", headerText : '<spring:message code="sal.title.text.assignedDt" />', width : 100 } ,
              {dataField : "sensitiveFg", headerText : '<spring:message code="sal.title.text.sensitive" />', width : 70 },
              {dataField : "rem", headerText : '<spring:message code="sal.title.text.sensitiveRem" />', width : 200 },
              {dataField : "etrFg", headerText : '<spring:message code="sal.title.text.etr" />', width : 70 },
              {dataField : "etrRem", headerText : '<spring:message code="sal.title.text.otrRem" />', width : 300 }
              ];


        var assignOptions = {
                   showStateColumn:false,
                   showRowNumColumn    : true,
                   usePaging : true,
                   editable : true,
                   headerHeight : 30
             };

        assignGrid = GridCommon.createAUIGrid("#assignGrid", assignColLayout, "", assignOptions);
        excelGrid = GridCommon.createAUIGrid("#excelGrid", excelColLayout, "", assignOptions);

         AUIGrid.bind(assignGrid, "cellDoubleClick", function(event){
        	 viewRentalLedger();
         });

         //셀 클릭 이벤트 바인딩
         AUIGrid.bind(assignGrid, "cellClick", function(event){
              $("#orderNo").val(AUIGrid.getCellValue(assignGrid , event.rowIndex , "salesOrdNo"));
              $("#salesOrdId").val(AUIGrid.getCellValue(assignGrid , event.rowIndex , "salesOrdId"));
         });


        // 에디팅 시작 이벤트 바인딩
        AUIGrid.bind(assignGrid, "cellEditBegin", auiCellEditignHandler);
        AUIGrid.setFixedColumnCount(assignGrid, 4);
}

//AUIGrid 메소드
function auiCellEditignHandler(event)
{
    if(event.type == "cellEditBegin")
    {
        console.log("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
        //var menuSeq = AUIGrid.getCellValue(myGridID, event.rowIndex, 9);

        if(event.dataField == "corpTypeId")
        {
            // 추가된 행 아이템인지 조사하여 추가된 행인 경우만 에디팅 진입 허용
            if(AUIGrid.getCellValue(assignGrid, event.rowIndex, "typeId")=='965'){  //추가된 Row
                return true;
            } else {
                return false; // false 반환하면 기본 행위 안함(즉, cellEditBegin 의 기본행위는 에디팅 진입임)
            }
        }
    }
}

 //리스트 조회.
function fn_selectListAjax() {

    // 버튼 클릭시 cellEditCancel  이벤트 발생 제거. => 편집모드(editable=true)인 경우 해당 input 의 값을 강제적으로 편집 완료로 변경.
    AUIGrid.forceEditingComplete(assignGrid, null, false);

	 if($("#rentalStatus").val() == ""){
	        Common.alert('<spring:message code="sal.alert.msg.plzSelRentalStus" />');
	        return ;
	 }


	 if(!(MEM_TYPE == '4' || MEM_TYPE == '6')){
		 if($("#rosCaller").val() == null){
			 Common.alert('<spring:message code="sal.alert.msg.rosCaller" />');
	         return ;
		 }
	 }

	 console.log($("#rosCaller").val());
	if($("#customerType").val() == "964"){
          $("#companyType").val("");
    }

	$("#appType").prop("disabled", false);
    Common.ajax("GET", "/sales/rcms/selectAssignAgentList", $("#searchForm").serialize(), function(result) {

       console.log("성공.");
       console.log( result);

      AUIGrid.setGridData(assignGrid, result);
      AUIGrid.setGridData(excelGrid, result);

      $("#orderNo").val("");
      $("#salesOrdId").val("");
      $("#appType").prop("disabled", true);

  });
}

function fn_clear(){
    $("#searchForm")[0].reset();
}

//리스트 조회.
function fn_save() {

    var editedRowItems = AUIGrid.getEditedRowItems(assignGrid);

    if(editedRowItems.length <= 0) {
        Common.alert('<spring:message code="sal.alert.msg.noUpdateItem" />');
        return ;
    }
    console.log(editedRowItems);
    var param = GridCommon.getEditData(assignGrid);

    Common.ajax("POST", "/sales/rcms/saveAssignAgent", param, function(result) {

    	fn_selectListAjax();

  });
}

function fn_customerChng(){

	if($("#customerType").val() == "964"){
        $("#companyType").multipleSelect("disable");
	}else{
        $("#companyType").multipleSelect("enable");
	}

}

function fn_uploadPop(){
	Common.popupDiv("/sales/rcms/uploadAssignAgentPop.do",null, fn_selectListAjax, true, "uploadAssignAgentPop");
}

function fn_edit(){

	if($("#salesOrdId").val() == ""){
		Common.alert("Please select data to edit. ");
		return;
	}
	//Common.popupDiv("/sales/rcms/updateRemarkPop.do",null, fn_selectListAjax, true, "updateRemarkPop");
	Common.popupDiv("/sales/rcms/updateRemarkPop.do",null, '', true, "updateRemarkPop");
}

/* Report Start*/
function fn_badAccReport(){
	Common.popupDiv("/sales/rcms/badAccReportPop.do",null, null , true, "badReportPop");
}

function fn_assignListReport(){
    Common.popupDiv("/sales/rcms/assignListReportPop.do",null, null , true, "assignListReportPop");
}

function fn_eTRSummaryListReport(){
    Common.popupDiv("/sales/rcms/eTRSummaryListReportPop.do",null, null , true, "eTRSummaryListReportPop");
}

function fn_assignSummaryListReport(){
    Common.popupDiv("/sales/rcms/assignSummaryListReportPop.do",null, null , true, "assignSummaryListReportPop");
}

/* Report End*/



function viewRentalLedger(){
    var gridObj = AUIGrid.getSelectedItems(assignGrid);
    if(gridObj.length > 0 ){
    	console.log(gridObj);
    	console.log(gridObj[0].item.salesOrdId);
        var orderid = gridObj[0].item.salesOrdId;
        $("#ledgerForm #ordId").val(orderid);
        Common.popupWin("ledgerForm", "/sales/order/orderLedger2ViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
    }else{
        Common.alert("<spring:message code='pay.alert.selectTheOrderFirst'/>");
        return;
    }

}

function fn_invoicePop() {
    Common.popupDiv("/payment/initTaxInvoiceRentalPop.do", '', null, true);
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Customer</li>
    <li>Customer</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.title.text.rcmsAssignAgent" /></h2>

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <li><p class="btn_blue"><a href="#" onClick="fn_invoicePop()"><spring:message code="sal.btn.taxInvoice" /></a></p></li>
        <li><p class="btn_blue"><a href="#" id="btnSearch" onclick="javascript:fn_selectListAjax();"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
        <li><p class="btn_blue"><a href="#" id="btnClear" onclick="javascript:fn_clear();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="ledgerForm" action="#" method="post">
        <input type="hidden" id="ordId" name="ordId" />
</form>
<form id="editForm" name="editForm" action="#" method="post">
    <input type="hidden" id="orderNo" name="orderNo" />
    <input type="hidden" id="salesOrdId" name="salesOrdId" />
</form>
    <form id="searchForm" name="searchForm" action="#" method="post">
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:170px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.rcmsAppType" /><span class="must">*</span></th>
        <td>
        <select id="appType" name="appType" class="w100p disabled" disabled="disabled" >
        </select>
        </td>
        <th scope="row"><spring:message code="sal.title.text.ordStus" /><span class="must">*</span></th>
        <td>
          <select  id="orderStatus" name="orderStatus" class="w100p"></select>
        </td>
        <th scope="row"><spring:message code="sal.text.rentalStatus" /><span class="must">*</span></th>
        <td>
        <select id="rentalStatus" name="rentalStatus" class="multy_select w100p" multiple="multiple">
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.custType" /><span class="must">*</span></th>
        <td>
          <select  id="customerType" name="customerType" class="w100p" onchange="javascript:fn_customerChng();"></select>
        </td>
        <th scope="row"><spring:message code="sal.title.text.companyType" /></th>
        <td>
        <select id="companyType" name="companyType" class="multy_select w100p" multiple="multiple">
        </select>
        </td>
        <th scope="row"><spring:message code="sal.title.text.openAgingBrMth" /></th>
        <td>
        <select id="openMonth" name="openMonth" class="multy_select w100p" multiple="multiple">
        </select>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.rosCaller" /></th>
        <td>
        <select id="rosCaller" name="rosCaller" class="multy_select w100p" multiple="multiple">
        </select>
        </td>
        <th scope="row"><spring:message code="sal.title.text.ordNop" /></th>
        <td>
        <input type="text" title="" placeholder="" class="w100p" id="orderNo" name="orderNo"/>
        </td>
        <th scope="row">Over 60 months</th>
        <td>
        <input type="checkbox" id="over60" name="over60"  value="Y"/>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.customerId" /></th>
        <td>
        <input type="text" title="" placeholder="" class="w100p" id="customerId" name="customerId" />
        </td>
        <th scope="row"><spring:message code="sal.text.race"/></th>
        <td>
            <select id="cmbRaceId" name="raceId" class="multy_select w100p"  multiple="multiple" ></select>
        </td>
        <th scope="row"><spring:message code="sal.text.nricCompanyNo" /></th>
        <td>
        <input type="text" title="" placeholder="" class="w100p" id="nric" name="nric" />
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.assigned" /></th>
        <td>
        <p><select id="assignYn" name="assignYn" class="w100p"></select></p>
        </td>
        <th scope="row"><spring:message code="sal.title.text.sensitive" /></th>
        <td>
        <p><select id="sensitiveYn" name="sensitiveYn" class="w100p"></select></p>
        </td>
        <th scope="row"><spring:message code="sal.title.text.etr" /></th>
        <td>
        <p><select id="etrYn" name="etrYn" class="w100p"></select></p>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.custName" /></th>
        <td>
            <input type="text" title="" placeholder="" class="w100p" id="custName" name="custName" />
        </td>
        <th scope="row"><spring:message code="sales.vaNum" /></th>
        <td>
            <input type="text" title="" placeholder="" class="w100p" id="vaNo" name="vaNo" />
        </td>
        <th scope="row"></th>
        <td></td>
    </tr>

    </tbody>
    </table><!-- table end -->


    <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
        <dt><spring:message code="sal.title.text.link" /></dt>
        <dd>
        <ul class="btns">
        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
            <li><p class="link_btn type2"><a onclick="javascript: fn_assignListReport()"><spring:message code="sal.title.text.assignListRaw" /></a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="link_btn type2"><a onclick="javascript: fn_badAccReport()"><spring:message code="sal.title.text.badaccRaw" /></a></p></li>
            <li><p class="link_btn type2"><a onclick="javascript: fn_eTRSummaryListReport()"><spring:message code="sal.title.text.etrSummaryListRaw" /></a></p></li>
            <li><p class="link_btn type2"><a onclick="javascript: fn_assignSummaryListReport()"><spring:message code="sal.title.text.assignSummaryListRaw" /></a></p></li>
        </c:if>
        </ul>
        <ul class="btns">
        </ul>
        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end -->


    </form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<ul class="right_btns mt10">
    <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
        <li><p class="btn_grid"><a href="#" id="excelDown"><spring:message code="sal.title.text.download" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
        <li><p class="btn_grid"><a href="#" onclick="javascript:fn_edit();"><spring:message code="sal.title.text.edit" /></a></p></li>
    </c:if>
    <%-- <li><p class="btn_grid"><a href="#" onclick="javascript:fn_save();"><spring:message code="sal.btn.save" /></a></p></li> --%>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="assignGrid" style="width:100%; height:300px; margin:0 auto;"></div>
    <div id="excelGrid" style="width:100%; height:300px; margin:0 auto; display: none" ></div>
</article><!-- grid_wrap end -->
</section><!-- search_result end -->
</section><!-- content end -->
