<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function() {

    if("${PAGE_AUTH.funcUserDefine1}" != 'Y') {
        $("#caseNoLbl").remove();
        $("#caseNoCol").remove();
    }

	ComplianceListGrid();
	ExcelListGrid();

	doGetComboAndGroup2('/organization/compliance/getPicList.do', {}, '', 'cmdchangePerson', 'S', 'fn_setOptGrpClass');//product 생성

    AUIGrid.bind(myGridID, "cellClick", function(event) {
	    requestid = AUIGrid.getCellValue(myGridID, event.rowIndex, "requestid");
	    isMod = "${PAGE_AUTH.funcUserDefine4}";
	});

});
var myGridID,excelGridID;
function ComplianceListGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [{
        dataField : "requestid",
        headerText : "No",
        editable : false,
        visible : false,
        width : 100
    }, {
        dataField : "userName",
        headerText : "Requestor",
        editable : false,
        visible : true,
        width : 150
    }, {
        dataField : "name1",
        headerText : "Request Status",
        editable : false,
        width : 150
    },{
        dataField : "requestcreateat",
        headerText : "Request Date",
        editable : false,
        width : 150,
        dataType : "date",
        formatString : "dd/mm/yyyy"
    },{
        dataField : "approvalName",
        headerText : "Approval by",
        editable : false,
        width : 180
    },{
        dataField : "approvalStatus",
        headerText : "Approval Status",
        editable : false,
        width : 150
    },{
        dataField : "approvalDatetime",
        headerText : "Approval Date",
        editable : false,
        width : 150,
        dataType : "date",
        formatString : "dd/mm/yyyy"
    },{
        dataField : "salesOrdNo",
        headerText : "Order No",
        editable : false,
        width : 200
    },
    /*{
        dataField : "comboOrdNo",
        headerText : "Order No2",
        editable : false,
        width : 200
    },*/
    {
        dataField : "memCode",
        headerText : "Person Involved",
        editable : false,
        width : 150,
        visible : true
    },{
        dataField : "picName",
        headerText : "PIC",
        editable : false,
        width : 150
    },{
        dataField : "state",
        headerText : "Installation State",
        editable : false,
        width : 200
    },{
        dataField : "requestcategory",
        headerText : "Case Category",
        editable : false,
        width : 200
    },{
        dataField : "resnDescSub",
        headerText : "Sub Category",
        editable : false,
        width : 200
    },
    {
        dataField : "requestrefdate",
        headerText : "Complaint Date",
        editable : false,
        width : 150,
        dataType : "date",
        formatString : "dd/mm/yyyy",
        visible : false
    },
    /////////////////////////// ADDITIONAL FIELD ////////////////////////////// ALEX-21072020
   /*  {
        dataField : "memCode",
        headerText : "Person Involved",
        editable : false,
        width : 150,
        visible : true
    },  */{
        dataField : "requestcontent",
        headerText : "Feedback Content",
        editable : false,
        width : 150,
        visible : false
    }, /* {
        dataField : "userName",
        headerText : "Responded by",
        editable : false,
        width : 150,
        visible : false
    }, */ {
        dataField : "respnsUpdated",
        headerText : "Responded Date",
        editable : false,
        width : 150,
        dataType : "date",
        formatString : "dd/mm/yyyy",
    },{
        dataField : "respnsMsg",
        headerText : "Remark",
        editable : false,
        width : 150,
        visible : false
    },{
        dataField : "caseNo",
        headerText : "Case No",
        editable : false,
        width : 150,
    }
    /////////////////////////// ADDITIONAL FIELD //////////////////////////////
    ];


    // 그리드 속성 설정
   var gridPros = {
       usePaging : true, // 페이징 사용
       pageRowCount : 20, // 한 화면에 출력되는 행 개수 20(기본값:20)
       editable : true,
       displayTreeOpen : true,
       selectionMode : "singleRow",
       headerHeight : 30,
       skipReadonlyColumns : true, // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
       wrapSelectionMove : true, // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
       showRowNumColumn : true, // 줄번호 칼럼 렌더러 출력
       exportURL : "/common/exportGrid.do"
   };

    myGridID = AUIGrid.create("#grid_wrap_complianceList", columnLayout, gridPros);
}

function ExcelListGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [
    /*
    {
        dataField : "requestid",
        headerText : "No",
        editable : false,
        visible : false,
        width : 100
    },
    */
    {
        dataField : "userName",
        headerText : "Requestor",
        editable : false,
        visible : true,
        width : 150
    }, {
        dataField : "name1",
        headerText : "Request Status",
        editable : false,
        width : 150
    },{
        dataField : "requestcreateat",
        headerText : "Request Date",
        editable : false,
        width : 150,
        dataType : "date",
        formatString : "dd/mm/yyyy"
    },{
        dataField : "approvalName",
        headerText : "Approval by",
        editable : false,
    },{
        dataField : "approvalStatus",
        headerText : "Approval Status",
        editable : false,
        width : 150
    },{
        dataField : "approvalDatetime",
        headerText : "Approval Date",
        editable : false,
        width : 150,
        dataType : "date",
        formatString : "dd/mm/yyyy"
    },{
        dataField : "salesOrdNo",
        headerText : "Order No",
        editable : false,
        width : 200
    },
    /* {
        dataField : "comboOrdNo",
        headerText : "Order No2",
        editable : false,
        width : 200
    }, */
    {
        dataField : "memCode",
        headerText : "Person Involved",
        editable : false,
        width : 150
    },{
        dataField : "picName",
        headerText : "PIC",
        editable : false,
        width : 150
    },{
        dataField : "state",
        headerText : "Installation State",
        editable : false,
        width : 200
    }, {
        dataField : "requestcategory",
        headerText : "Case Category",
        editable : false,
        width : 200
    },{
        dataField : "resnDescSub",
        headerText : "Sub Category",
        editable : false,
        width : 200
    },
    /*
    {
        dataField : "requestrefdate",
        headerText : "Complaint Date",
        editable : false,
        width : 150,
        dataType : "date",
        formatString : "dd/mm/yyyy"
    },
    */
    /////////////////////////// ADDITIONAL FIELD ////////////////////////////// ALEX-21072020
    /*
    {
        dataField : "memCode",
        headerText : "Person Involved",
        editable : false,
        width : 150
    },
    */
    {
        dataField : "requestcontent",
        headerText : "Feedback Content",
        editable : false,
        width : 350
    }, {
        dataField : "userName",
        headerText : "Responded by",
        editable : false,
        width : 150
    }, {
        dataField : "respnsUpdated",
        headerText : "Responded Date",
        editable : false,
        width : 150,
        dataType : "date",
        formatString : "dd/mm/yyyy"
    }, {
        dataField : "respnsMsg",
        headerText : "Remark",
        editable : false,
        width : 350,
        style : "aui-grid-user-custom-left"
    },
    /////////////////////////// ADDITIONAL FIELD //////////////////////////////
    {
        dataField : "caseNo",
        headerText : "Case No",
        editable : false,
        width : 150
    }/* ,
    {
        dataField : "picName",
        headerText : "PIC",
        editable : false,
        width : 250
    } */
    ];

    // 그리드 속성 설정
    var gridPros = {
        usePaging : true, // 페이징 사용
        pageRowCount : 20, // 한 화면에 출력되는 행 개수 20(기본값:20)
        editable : true,
        displayTreeOpen : true,
        selectionMode : "singleRow",
        headerHeight : 30,
        skipReadonlyColumns : true, // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove : true, // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn : true, // 줄번호 칼럼 렌더러 출력
        exportURL : "/common/exportGrid.do",
    };

    excelGridID = AUIGrid.create("#grid_wrap_excelList", columnLayout, gridPros);
}

function fn_complianceSearch(){
    if("${PAGE_AUTH.funcUserDefine1}" != 'Y'){
        Common.ajax("GET", "/organization/compliance/selectGuardianofComplianceListCodyHP.do", $("#complianceSearch").serialize(), function(result) {
            console.log("성공.");
            AUIGrid.setGridData(myGridID, result);
        });
    } else {
    	Common.ajax("GET", "/organization/compliance/selectGuardianofComplianceListSearch.do", $("#complianceSearch").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
            AUIGrid.setGridData(excelGridID, result);
        });
       /*  Common.ajax("GET", "/organization/compliance/selectGuardianofComplianceList.do", $("#complianceSearch").serialize(), function(result) {
        	AUIGrid.setGridData(excelGridID, result);
        }); */

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
        } else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        } else if (tag === 'select'){
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

    Common.popupDiv("/organization/compliance/guardianofComplianceViewPop.do?reqstId=" + requestid  + "&isMod=" + isMod, null, null, true, '_compensationEditPop');

}

function fn_complianceViewLimit() {

    var selectedItems = AUIGrid.getSelectedItems(myGridID);
        if (selectedItems.length <= 0) {
            Common.alert("<b>No request selected.</b>");
            return;
        }

    Common.popupDiv("/organization/compliance/guardianofComplianceViewLimitPop.do?reqstId=" + requestid + "&isMod=" + isMod, null, null, true, '_compensationEditPop');

}

function fn_Approve(event, rowIndex) {

    var selectedItems = AUIGrid.getSelectedItems(myGridID);
    if (selectedItems.length <= 0) {
        Common.alert("<b>No request selected.</b>");
        return;
    }

	 var USER_ID     = '${SESSION_INFO.userId}';
	 var approvalUserId = selectedItems[0].item.approvalUserId

	if(USER_ID == approvalUserId){
		 Common.popupDiv("/organization/compliance/guardianofComplianceApprovalPop.do?reqstId=" + requestid + "&isMod=" + isMod, null, null, true, '_compensationEditPop');
    }else{
        Common.alert("Approval User not match");
        return false;
    }
}

$(function() {
$("#download").click(function() {
    //GridCommon.exportTo("grid_wrap_complianceList", 'xlsx', "Guardian of Coway List")
	 var excelProps = {
                fileName     : "Guardian of Coway List",

                columnSizeOfDataField : {
                    "requestrefdate" : 2000,
                    "memCode" : 2000
                },
            };

	AUIGrid.exportToXlsx(excelGridID, excelProps);
});
});

function fn_setOptGrpClass() {
    $("optgroup").attr("class" , "optgroup_text")
}

function getSelectedRowIndex() {
    return AUIGrid.getSelectedIndex(myGridID); // This should return the row index of the selected row
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
<h2>Guardian of Coway</h2>
<ul class="right_btns">
     <li><p class="btn_blue"><a href="#" onclick="javascript:fn_complianceNew()"><span class="new"></span>New</a></p></li>
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
        <li><p class="btn_blue"><a href="#" onclick="javascript:fn_complianceView()"><span class="view"></span>Compliance View</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <li><p class="btn_blue"><a href="#" onclick="javascript:fn_complianceViewLimit()"><span class="view"></span>Requester View</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
        <li><p class="btn_blue"><a href="#" onclick="javascript:fn_Approve(event, getSelectedRowIndex())"><span class="view"></span>Approval</a></p></li>
    </c:if>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_complianceSearch()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#complianceSearch').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="complianceSearch">
<input type="hidden" name="memType" id="memType" value="${memType }"/>
<%-- <input type="text" name="funcUserDefine1" id="funcUserDefine1" value="${PAGE_AUTH.funcUserDefine1}"/>
<input type="text" name="funcUserDefine2" id="funcUserDefine2" value="${PAGE_AUTH.funcUserDefine2}"/>
<input type="text" name="funcUserDefine3" id="funcUserDefine3" value="${PAGE_AUTH.funcUserDefine3}"/> --%>

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
    <td>
        <div class="date_set"><!-- date_set start -->
            <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="requestCreatStart" name="requestCreatStart"/></p>
            <span>To</span>
            <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="requestCreatEnd" name="requestCreatEnd"/></p>
        </div><!-- date_set end -->
    </td>
    <th scope="row" id="caseNoLbl">Case No</th>
    <td id="caseNoCol">
        <input type="text" title="" placeholder="Case No" class="w100p" id="caseNo" name="caseNo"/>
    </td>
</tr>
<tr>
<th scope="row">Request Status  </th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="requestStatusId" name="requestStatusId">
	        <option value="1">Active</option>
	        <option value="60">In Progress</option>
	        <option value="36">Closed</option>
	        <option value="10">Cancelled</option>
	    </select>
    </td>
    <th scope="row">Order No</th>
    <td>
    <input type="text" title="" placeholder="Order No" class="w100p" id="salesOrdNo" name="salesOrdNo"/>
    </td>
    <th scope="row">Customer Name</th>
    <td>
    <input type="text" title="" placeholder="Customer Name" class="w100p" id="customerName" name="customerName"/>
    </td>
</tr>

<tr>
    <th scope="row">Complaint Date</th>
    <td>
        <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date w100p" id="complaintDate" name="complaintDate"/>
    </td>
    <th scope="row">Involved Person Code</th>
    <td>
        <input type="text" title="" placeholder="Involved Person Code" class="w100p" id="involvedPersonCode" name="involvedPersonCode"/>
    </td>
    <th scope="row">Person In Charge</th>
    <td>
        <select id="cmdchangePerson" name="changePerson" class="w100p"></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
         <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
</c:if>
<!--          <li><p class="btn_grid"><a id="insert">INS</a></p></li>             -->
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_complianceList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
<div id="grid_wrap_excelList" style="width: 100%; height: 500px; margin: 0 auto;display:none;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

