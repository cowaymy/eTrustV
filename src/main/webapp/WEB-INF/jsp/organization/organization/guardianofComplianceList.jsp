<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function() {
    //doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : 1389, inputId : 1, separator : '-'}, '', 'caseCategory', 'S'); //Reason Code

	ComplianceListGrid();

    AUIGrid.bind(myGridID, "cellClick", function(event) {
	    requestid = AUIGrid.getCellValue(myGridID, event.rowIndex, "requestid");
	});

});
var myGridID;
function ComplianceListGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "requestid",
        headerText : "No",
        editable : false,
        visible : false,
        width : 100
    }, {
        dataField : "userName",
        headerText : "Requestor",
        editable : false,
        width : 150
    }, {
        dataField : "name1",
        headerText : "Request Status",
        editable : false,
        width : 150
    },

    {
        dataField : "requestcreateat",
        headerText : "Request Date",
        editable : false,
        width : 150,
        dataType : "date",
        formatString : "dd/mm/yyyy"
    },
    {
        dataField : "salesOrdNo",
        headerText : "Order No",
        editable : false,
        width : 200
    }, {
        dataField : "requestcategory",
        headerText : "Case Category",
        editable : false,
        width : 200
    }, {
        dataField : "requestrefdate",
        headerText : "Complaint Date",
        editable : false,
        width : 150,
        dataType : "date",
        formatString : "dd/mm/yyyy"
    }
    ];



    // 그리드 속성 설정
   var gridPros = {

	        // 페이징 사용
	        usePaging : true,

	        // 한 화면에 출력되는 행 개수 20(기본값:20)
	        pageRowCount : 20,

	        editable : true,

	        displayTreeOpen : true,

	        selectionMode : "singleRow",

	        headerHeight : 30,

	        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	        skipReadonlyColumns : true,

	        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	        wrapSelectionMove : true,

	        // 줄번호 칼럼 렌더러 출력
	        showRowNumColumn : true

   };


    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID = AUIGrid.create("#grid_wrap_complianceList", columnLayout, gridPros);
}

function fn_complianceSearch(){
	 if("${PAGE_AUTH.funcUserDefine1}" !='Y'){
	Common.ajax("GET", "/organization/compliance/selectGuardianofComplianceListCodyHP.do", $("#complianceSearch").serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + JSON.stringify(result));
        AUIGrid.setGridData(myGridID, result);
    });
}
	 else{
		 Common.ajax("GET", "/organization/compliance/selectGuardianofComplianceList.do", $("#complianceSearch").serialize(), function(result) {
		        console.log("성공.");
		        console.log("data : " + JSON.stringify(result));
		        AUIGrid.setGridData(myGridID, result);
		    });
		 }
	 }


$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = -1;
        }
        AUIGrid.clearGridData(myGridID);
    });
};

function fn_complianceNew(){
	Common.popupDiv("/organization/compliance/guardianofComplianceAddPop.do"  , null, null , true , '');
}

function fn_complianceView() {

    var selectedItems = AUIGrid.getSelectedItems(myGridID);
        if (selectedItems.length <= 0) {
            Common.alert("<b>No request selected.</b>");
            return;
        }

    Common.popupDiv("/organization/compliance/guardianofComplianceViewPop.do?reqstId=" + requestid, null, null, true, '_compensationEditPop');

}

function fn_complianceViewLimit() {

    var selectedItems = AUIGrid.getSelectedItems(myGridID);
        if (selectedItems.length <= 0) {
            Common.alert("<b>No request selected.</b>");
            return;
        }

    Common.popupDiv("/organization/compliance/guardianofComplianceViewLimitPop.do?reqstId=" + requestid, null, null, true, '_compensationEditPop');

}
</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Compliance Call Log</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Guardian of Compliance</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_complianceNew()"><span class="new"></span>New</a></p></li>
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="btn_blue"><a href="#" onclick="javascript:fn_complianceView()"><span class="view"></span>View</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine1 != 'Y'}">
        <li><p class="btn_blue"><a href="#" onclick="javascript:fn_complianceViewLimit()"><span class="view"></span>View</a></p></li>
    </c:if>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_complianceSearch()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#complianceSearch').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="complianceSearch">
<input type="hidden" name="memType" id="memType" value="${memType }"/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Case Category</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="caseCategory" name="caseCategory">
             <c:forEach var="list" items="${caseCategoryCodeList}" varStatus="status">
                 <option value="${list.codeId}">${list.codeName } </option>
            </c:forEach>
        </select>
    </td>
    <th scope="row">Pre-Register Date</th>
    <td colspan="3">
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="requestCreatStart" name="requestCreatStart"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="requestCreatEnd" name="requestCreatEnd"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
<th scope="row">Request Status  </th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="requestStatusId" name="requestStatusId">
	        <option value="1">Active</option>
	        <option value="44">Pending</option>
	        <option value="5">Approved</option>
	        <option value="6">Rejected</option>
	    </select>
    </td>
    <th scope="row">Order No</th>
    <td>
    <input type="text" title="" placeholder="Order No" class="" id="salesOrdNo" name="salesOrdNo"/>
    </td>
    <th scope="row">Customer Name</th>
    <td>
    <input type="text" title="" placeholder="Customer Name" class="" id="customerName" name="customerName"/>
    </td>
</tr>

<tr>
    <th scope="row">Complaint Date</th>
    <td>
    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="complaintDate" name="complaintDate"/>
    </td>
    <th scope="row">Involved Person Code</th>
    <td colspan="3">
    <input type="text" title="" placeholder="Involved Person Code" class="" id="involvedPersonCode" name="involvedPersonCode"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->


<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_complianceList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

